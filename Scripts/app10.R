### FW891 Homework 10: 03/27/2022 ###
#### Nick Alioto ####

library(package = "sp");       # old Simple Features (but still needed)
library(package = "rgeos");    # getting/converting crs
library(package = "rgdal");    # getting/converting crs
library(package = "ggplot2");
library(package = "sf");       # Simple Features
library(package = "rnaturalearth");     # for getting coord data
library(package = "rnaturalearthdata"); # for getting coord data

devtools::install_github("ropensci/rnaturalearthhires")

#################################  1. ##########################################
# False easting represents all the x coordinates on a mapping. To avoid having a 
# negative number that is usually associated with your x-coordinate. You would set the point of origin to be the intersection of the equator and central meridian. To avoid a negative number the standard the central 
# region of each time zone is set to 500,000 m East.


################################   2. ##########################################
# False Northing, is when you add values to your y-coordinate, once again to stop you from having 
# negative values. To achieve this the northing value is set 10,000 m North of the equator to prevent these negative values.



###############################   3.  ##########################################
### How I downloaded the lakes

lakes110 = ne_download(scale = 110, type = 'lakes', category = 'physical')

################################## 3. #########################################
# read in data from a csv file with spatial data
city_data <- st_read("Data/cities.csv", header = TRUE)

# Adding abbreviated city names as a new column in our CSV
city_data$abbr_names <- c(tor= 'tor', chi= 'chi', det= 'det')


## When you convert a CSV to a simple feature, you need to
#   supply the longitude and latitude columns (in that order)
cities_SF1 = st_as_sf(city_data, 
                       coords = c("Lat", "Lon"))

#### look for Geodetic CRS in simple feature
## The above SF has no crs -- will cause error when plotting
#   error: cannot transform sfc object with missing crs

# add the crs so it can be plotted
cities_SF2 = st_as_sf(city_data, 
                      coords = c("Lat", "Lon"),
                      crs = 4326)


############################### 4. & 5. ########################################


## KML files are google map files (similar to HTML files)
#  KMZ files are also google map files that have been zipped
lakeMichigan = st_read(dsn="Data/Lake_Michigan_shoreline.kml");
# KML files have the lat, long, and crs built in  -- you (usually) do not need to declare it
lakeMI_SF = st_as_sf(lakeMichigan); 

## SHP file are shapefiles (probably the most popular -- ArcGIS)
#  They are not standalone files!
# Get the lake borders from downloaded file
lakes = st_read(dsn="Data/lakes/ne_10m_lakes.shp");  
lakes_SF = st_as_sf(lakes); 

### Getting data from a database (in this case, from naturalearth.com)
#    The database sends a data file -- which types depends on the database
# get the state borders from naturalearth


states = ne_states(country = "United States of America");
states_SF = st_as_sf(states)

#### https://www.naturalearthdata.com/  (can get shapefiles from here)
#### https://rdrr.io/cran/rnaturalearth/api/ (R interface to naturalearth website)
#### https://gis-michigan.opendata.arcgis.com (Michigan shapefiles)


#Let's add Canada and the Lake Erie

canada <- ne_states(country = "Canada")
canada_SF <- st_as_sf(canada);

lakeErie <- st_read(dsn="Data/Lake_Erie_shoreline.kml");
lakeErie_SF <- st_as_sf(lakeErie);


plot1 = ggplot() +
  geom_sf(data = canada_SF,  #Adding Canada 
          mapping = aes(geometry = geometry),
          color = "black",
          fill = "grey") +
  geom_sf(data = states_SF,  #Adding states
          mapping = aes(geometry = geometry),
          color = "black",
          fill = "grey") +
  geom_sf(data = lakes_SF,  
          mapping = aes(geometry = geometry),
          color = "lightblue",
          fill = "lightblue") +
  geom_sf(data = cities_SF2,   # City simple feature with Tor, Chi, Det
          mapping = aes(geometry = geometry),      
          color = "red", 
          fill = "red") +
  geom_sf(data = lakeMI_SF,  #Adding Lake Michigan
          mapping = aes(geometry = geometry),
          color = "blue",
          fill = "blue") +
  geom_sf(data = lakeErie_SF,
          mapping = aes(geometry = geometry),  #Adding lake Erie
          color = "darkorchid3",
          fill = "darkorchid3") +
  coord_sf(crs = 26914,   # UTM 17N
           xlim = c(-500000, 2500000),  # note the negative number (false easting)
           ylim = c(4500000, 6000000),
           expand = TRUE) +
  geom_sf_label(data = cities_SF2,  #Couldn't get this to work.. everything before does run though
                mapping = aes(geometry=geometry, label=City_Name),
                color="purple",
                fill = "yellow")
plot(plot1)


############################# 6. ###############################################

#Read in the data
RTHA_data <- st_read("Data/rowan.csv", header = TRUE)

# Turn my data into a simple feature to plot points
RTHA_SF1 = st_as_sf(RTHA_data, 
                      coords = c("location.long", "location.lat"),
                      crs = 4326)

# Lets add all the simole features we will need to see the data
RTHA_plot <- ggplot() +
  geom_sf(data = canada_SF,
          mapping = aes(geometry = geometry),
          color = "black",
          fill = "grey") +
  geom_sf(data = states_SF,
          mapping = aes(geometry = geometry),
          color = "black",
          fill = "grey") +
  geom_sf(data = lakes_SF,
          mapping = aes(geometry = geometry),
          color = "lightblue",
          fill = "lightblue") +
  geom_path(data = RTHA_data,
          (aes(x=location.long,
                          y=location.lat,
                          size=0.8,
                          color = "black"))) +
  coord_sf(crs = 26914,   # UTM 17N
           xlim = c(-500000, 2500000),  # note the negative number (false easting)
           ylim = c(4500000, 6000000),
           expand = TRUE)
plot(RTHA_plot)
  
  
?geom_path

############################  7. ##############################################

#What was your level of comfort with the lesson/application? 
# This homework was quite hard overall, It took a lot longer then expected
# and some things still won't plot for me after I spent considerable time on them.
# I've used other code to plot maps before for my research, but this lesson really 
# challenged me.
  
#Approximately how long did you work on this lesson? 

# 5 hours, I spent a lot of time on this.
  
#What areas of the lesson/application confused or still confuses you? 

# I just need to keep practicing the same things we did above. For me most 
# challenging was trying to plot the city names, which I couldn't manage also
# plotting my data which is a migration trajectory didn't work either.
  
#What are some things you would like to know more about that is related to, but not covered in, this lesson? 

# Just need more practice with all the above, honestly.
  

