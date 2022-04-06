# Mapping my Own Data Homework #
# Nick Alioto
# 04/04/2022
# FW891

#Clear Console and the Environment 
rm(list=ls());  options(show.error.locations = TRUE);

# sp needs to be installed before sf package but you will still
# get an error about sp not being installed -- this can be ignored
library(package = "sp");       #old Simple Features (but still needed)
library(package = "rgeos");    # getting/converting crs
library(package = "rgdal");    # getting/converting crs
library(package = "ggplot2");
library(package = "dplyr");
library(package = "sf");       # Simple Features
library(package = "rnaturalearth");     # for getting coord data
library(package = "rnaturalearthdata"); # for getting coord data

# Read in the Data
hawk_data = st_read(dsn="Data/rowan.csv");
hawk_data_SF = st_as_sf(hawk_data, 
                      coords = c("location.long", "location.lat"),
                      crs = 4326);

hawk_plot = ggplot() +
  geom_sf(data = hawk_data_SF,
          mapping = aes(geometry = geometry),
          color = "turquoise2");
plot(hawk_plot);

# Save the data into a different format

st_write(hawk_data_SF, dsn = "hawk_data.kml", # Converted to a KML
         driver = "kml");

st_write(hawk_data_SF, dsn = "hawk_data.geojson", #Converted to a Geojson 
         driver = "GeoJSON");

hawk_data_KML = st_read(dsn="hawk_data.kml");
hawk_data_GEO = st_read(dsn="hawk_data.geojson");

hawk_data_KML_SF = st_as_sf(hawk_data_KML);
hawk_data_GEO_SF = st_as_sf(hawk_data_GEO);

plot2 = ggplot() +
  geom_sf(data = hawk_data_KML_SF,
          mapping = aes(geometry = geometry),
          color = "navy");
plot(plot2)

# Let's plot it using the GEOJson

plot3 = ggplot() +
  geom_sf(data = hawk_data_GEO_SF,
          mapping = aes(geometry = geometry),
          color = "magenta1");
plot(plot3)
