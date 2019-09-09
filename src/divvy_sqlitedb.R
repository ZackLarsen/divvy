##################################################
## Project: Divvy
## Script purpose: Ingest Divvy data into SQLite db
## Date: September 8, 2019
## Author: Zack Larsen
##################################################


library(pacman)
library(tidyverse)

p_load(RSQLite, conflicted, here, glue, DBI, arrow, fst, data.table)



# Fread data --------------------------------------------------------------

data_dir <- '/Users/zacklarsen/Zack_Master/Datasets/Chicago/Divvy/'




Divvy_Trips_2013 <- fread(glue(data_dir, 'Divvy_Trips_2013.csv'))

Divvy_Trips_2014_Q1Q2 <- fread(glue(data_dir, 'Divvy_Trips_2014_Q1Q2.csv'))
Divvy_Trips_2014_Q3 <- fread(glue(data_dir, 'Divvy_Trips_2014-Q3-0809.csv'))
Divvy_Trips_2014_Q4 <- fread(glue(data_dir, 'Divvy_Trips_2014-Q4.csv'))

Divvy_Trips_2015_Q1 <- fread(glue(data_dir, 'Divvy_Trips_2015-Q1.csv'))
Divvy_Trips_2015_Q2 <- fread(glue(data_dir, 'Divvy_Trips_2015-Q2.csv'))
Divvy_Trips_2015_07 <- fread(glue(data_dir, 'Divvy_Trips_2015_07.csv'))
Divvy_Trips_2015_08 <- fread(glue(data_dir, 'Divvy_Trips_2015_08.csv'))
Divvy_Trips_2015_09 <- fread(glue(data_dir, 'Divvy_Trips_2015_09.csv'))
Divvy_Trips_2015_Q4 <- fread(glue(data_dir, 'Divvy_Trips_2015_Q4.csv'))

Divvy_Trips_2016_Q1 <- fread(glue(data_dir, 'Divvy_Trips_2016_Q1.csv'))
Divvy_Trips_2016_4 <- fread(glue(data_dir, 'Divvy_Trips_2016_04.csv'))
Divvy_Trips_2016_5 <- fread(glue(data_dir, 'Divvy_Trips_2016_05.csv'))
Divvy_Trips_2016_6 <- fread(glue(data_dir, 'Divvy_Trips_2016_06.csv'))
Divvy_Trips_2016_Q3 <- fread(glue(data_dir, 'Divvy_Trips_2016_Q3.csv'))
Divvy_Trips_2016_Q4 <- fread(glue(data_dir, 'Divvy_Trips_2016_Q4.csv'))

Divvy_Trips_2017_Q1 <- fread(glue(data_dir, 'Divvy_Trips_2017_Q1.csv'))
Divvy_Trips_2017_Q2 <- fread(glue(data_dir, 'Divvy_Trips_2017_Q2.csv'))
Divvy_Trips_2017_Q3 <- fread(glue(data_dir, 'Divvy_Trips_2017_Q3.csv'))
Divvy_Trips_2017_Q4 <- fread(glue(data_dir, 'Divvy_Trips_2017_Q4.csv'))

Divvy_Trips_2018_Q1 <- fread(glue(data_dir, 'Divvy_Trips_2018_Q1.csv'))
Divvy_Trips_2018_Q2 <- fread(glue(data_dir, 'Divvy_Trips_2018_Q2.csv'))
Divvy_Trips_2018_Q3 <- fread(glue(data_dir, 'Divvy_Trips_2018_Q3.csv'))
Divvy_Trips_2018_Q4 <- fread(glue(data_dir, 'Divvy_Trips_2018_Q4.csv'))

Divvy_Trips_2019_Q1 <- fread(glue(data_dir, 'Divvy_Trips_2019_Q1'))
Divvy_Trips_2019_Q2 <- fread(glue(data_dir, 'Divvy_Trips_2019_Q2'))

colnames(Divvy_Trips_2013)
colnames(Divvy_Trips_2014_Q3)
colnames(Divvy_Trips_2014_Q4)
colnames(Divvy_Trips_2015_Q1)
colnames(Divvy_Trips_2015_Q2)
colnames(Divvy_Trips_2015_07)
colnames(Divvy_Trips_2015_08)
colnames(Divvy_Trips_2015_09)
colnames(Divvy_Trips_2015_Q4)
colnames(Divvy_Trips_2016_Q1)
colnames(Divvy_Trips_2016_4)
colnames(Divvy_Trips_2016_5)
colnames(Divvy_Trips_2016_6)
colnames(Divvy_Trips_2016_Q3)
colnames(Divvy_Trips_2016_Q4)
colnames(Divvy_Trips_2017_Q1)
colnames(Divvy_Trips_2017_Q2)
colnames(Divvy_Trips_2017_Q3)
colnames(Divvy_Trips_2017_Q4)
colnames(Divvy_Trips_2018_Q1)
colnames(Divvy_Trips_2018_Q2)
colnames(Divvy_Trips_2018_Q3)
colnames(Divvy_Trips_2018_Q4)
colnames(Divvy_Trips_2019_Q1)
colnames(Divvy_Trips_2019_Q2)

# Fix the discrepancy between the column names:
colnames(Divvy_Trips_2018_Q1) <- colnames(Divvy_Trips_2013)
colnames(Divvy_Trips_2019_Q2) <- colnames(Divvy_Trips_2013)




Divvy_Trips_2014_Q1Q2 %>% 
  head()



# Row-bind all trips dataframes together:
trips <- do.call("rbind",mget(ls(pattern = "Divvy_Trips.*")))











Divvy_Stations_2016_Q1Q2 <- fread(glue(data_dir, 'Divvy_Stations_2016_Q1Q2.csv'))
Divvy_Stations_2016_Q3 <- fread(glue(data_dir, 'Divvy_Stations_2016_Q3.csv'))
Divvy_Stations_2016_Q4 <- fread(glue(data_dir, 'Divvy_Stations_2016_Q4.csv'))

Divvy_Stations_2017_Q1Q2 <- fread(glue(data_dir, 'Divvy_Stations_2017_Q1Q2.csv'))
Divvy_Stations_2017_Q3Q4 <- fread(glue(data_dir, 'Divvy_Stations_2017_Q3Q4.csv'))





# Schema ------------------------------------------------------------------

db <- RSQLite::datasetsDb()

dbListTables(db)

dbReadTable(db, "CO2")

dbGetQuery(db, "SELECT*FROM CO2 WHERE conc < 100")

dbDisconnect(db)








con <- dbConnect(SQLite())

dbWriteTable(con, "mtcars", mtcars)

dbReadTable(con, "mtcars")





write.parquet(x, path)






# fst ---------------------------------------------------------------------

# Store the data frame to disk (with compression)
write.fst(divvy_trips, "divvy_trips", 100)

# Retrieve the data frame again
divvy_trips <- read.fst("divvy_trips")

# Reading subsets without having to read entire file first:
df_subset <- read.fst("divvy_trips", c("Date", "FromStationId"), 
                      from = 2000, to = 5000)










