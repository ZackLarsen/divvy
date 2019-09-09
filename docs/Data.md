---
layout: default
---

# Here is a page about data.

### Go back [home](https://zacklarsen.github.io/divvy/)

The main webpage for Divvy [system data](https://www.divvybikes.com/system-data) is hosted by the Divvy bikeshare company itself and contains trip data from the 3rd quarter of 2013 to the second quarter of 2019 (as of September 6, 2019). The data corresponding to these trips can be downloaded 2 quarters at a time in the form of csv files. 

In addition to these trip files, Divvy provides a live json feed that contains information (in Spanish and French in addition to English) on the [station information](https://gbfs.divvybikes.com/gbfs/en/station_information.json) as well as [station status](https://gbfs.divvybikes.com/gbfs/en/station_status.json).

In 2019, Divvy reached an agreement with the City of Chicago to expand its program by building out a large number of new stations in various neighborhoods, and at some point in 2019 there will be electric-assist bikes available for rental. Because of the additional stations and the ability to rent electric bikes, Divvy changed their data schema to offer information on which stations have electric-assist bikes. 
> Below is a description of the schema for the various downloadable files and JSON feeds:

## Station Schema


## Trips Schema
1. Most files:
   * "trip_id"
   * "starttime"
   * "stoptime"         
   * "bikeid"
   * "tripduration"
   * "from_station_id"  
   * "from_station_name"
   * "to_station_id"
   * "to_station_name"
   * "usertype"
   * "gender"
   * "birthyear" 
1. 2018_Q1 and 2019_Q2:
   * "01 - Rental Details Rental ID"                   
   * "01 - Rental Details Local Start Time"            
   * "01 - Rental Details Local End Time"              
   * "01 - Rental Details Bike ID"                     
   * "01 - Rental Details Duration In Seconds Uncapped"
   * "03 - Rental Start Station ID"                    
   * "03 - Rental Start Station Name"                  
   * "02 - Rental End Station ID"                      
   * "02 - Rental End Station Name"                    
   * "User Type"                                       
   * "Member Gender"                                   
   * "05 - Member Details Member Birthday Year"
