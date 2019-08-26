##################################################
## Project: Divvy
## Script purpose: Extract, Transform, Load Divvy station and trip data
## Date: August 25, 2019
## Author: Zack Larsen
##################################################

library(pacman)
library(tidyverse)
p_load(data.table, dtplyr, lubridate,
       flexdashboard,
       here, conflicted,
       jsonlite, geojson)

conflict_prefer("filter", "dplyr")
conflict_prefer("year", "lubridate")




# General Info ------------------------------------------------------------

"


Some stations have valet service
valet_info available at: https://www.divvybikes.com/valet
Some stations are in Evanston, so they have a 'region' of 35


"

# JSON feed ---------------------------------------------------------------

# Data source:
#https://gbfs.divvybikes.com/gbfs/gbfs.json
#https://gbfs.divvybikes.com/gbfs/en/system_alerts.json

station_status <- fromJSON("https://gbfs.divvybikes.com/gbfs/en/station_status.json")
station_status


station_information <- fromJSON("https://gbfs.divvybikes.com/gbfs/en/station_information.json")
station_information
as_datetime(station_information$last_updated)


stations <- station_information$data$stations
stations

colnames(stations)






# Stations with valet service:
# stations %>% 
#   filter(eightd_station_services != 'NULL') %>% 
#   select(station_id, eightd_station_services) %>% 
#   View()

valet_stations <- stations %>% 
  filter(eightd_station_services != 'NULL') %>% 
  select(station_id, eightd_station_services) %>% 
  unnest(eightd_station_services)

valet_stations %>% 
  View("valet")


fwrite(valet_stations, 'data/valet_stations.csv')






# Removing unnecessary fields:
colnames(stations)


stations <- transform(stations, station_id = as.integer(station_id))


stations <- stations %>% 
  select(-external_id, -short_name, -rental_methods, -electric_bike_surcharge_waiver,
         -eightd_has_key_dispenser, -eightd_station_services,
         -has_kiosk) %>% 
  mutate(region = if_else(region_id == '35', 'Evanston', 'Chicago')) %>% 
  select(-region_id) %>% 
  replace_na(list(region = 'Chicago'))

fwrite(stations, 'data/stations.csv')











# Trips -------------------------------------------------------------------

# 2019 Trips

q1_2019_trips <- fread("/Users/zacklarsen/Zack_Master/Datasets/Chicago/Divvy_Trips_2019_Q1")
q2_2019_trips <- fread("/Users/zacklarsen/Zack_Master/Datasets/Chicago/Divvy_Trips_2019_Q2")

#glimpse(q1_2019_trips)
# colnames(q1_2019_trips)
# colnames(q2_2019_trips)

# Reassign colnames of q2_2019_trips to match q1_2019_trips:
colnames(q2_2019_trips) <- colnames(q1_2019_trips)

# Stack on top of each other:
trips <- rbind(q1_2019_trips, q2_2019_trips)

# Remove unnecessary columns:
trips <- trips %>% 
  select(-from_station_name, -to_station_name)

# Faster, keeping date only and discarding time:
#trips <- transform(trips, start_time = as.Date.POSIXct(start_time))
#trips <- transform(trips, end_time = as.Date.POSIXct(end_time))

trips <- trips %>%
  mutate(
    start_time = as_datetime(start_time),
    end_time = as_datetime(end_time)
  )

# Change tripduration to integer
trips <- transform(trips, tripduration = as.integer(tripduration))




# Save finished file
#fwrite(trips, 'data/trips.csv')
#saveRDS(trips, 'data/trips.Rds', compress = FALSE)




# Garbage collection:
rm(q1_2019_trips)
rm(q2_2019_trips)







# Trips merged with stations ----------------------------------------------

trips

stations

glimpse(trips)

glimpse(stations)


merge(trips, stations, by.x = 'from_station_id', by.y = 'station_id')




# dtplyr ------------------------------------------------------------------


age <- function(dob, age.day = today(), units = "years", floor = TRUE) {
  calc.age = interval(dob, age.day) / duration(num = 1, units = units)
  if (floor) return(as.integer(floor(calc.age)))
  return(calc.age)
}



trips <- readRDS('data/trips.Rds')







trips_lazy <- lazy_dt(trips)

trips_lazy %>% 
  filter(tripduration > 10 * 60) %>% 
  mutate(age = year(start_time) - birthyear) %>% 
  na.omit() %>% 
  group_by(age) %>% 
  summarise(avg_duration = mean(tripduration)) %>% 
  as_tibble()



trips_lazy %>% 
  filter(tripduration > 10 * 60) %>% 
  group_by(birthyear) %>% 
  summarise(avg_duration = mean(tripduration)) %>% 
  as_tibble()






