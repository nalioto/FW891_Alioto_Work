### Mapping and Aesthetics Homework FW891 ###
### January 21 2022 ###
### Nick Alioto ###

rm(list=ls());                         # clear Environment tab
options(show.error.locations = TRUE);  # show line numbers on error
library(package=ggplot2);              # get the GGPlot package


# read in CSV file and save the content to weatherData
weatherData = read.csv(file="Data/weather/Lansing2016NOAA (1).csv")

##### APPLICATION 10 #####
# A.) Adding the mapping component color=season within Geom_smooth function,
#     assigns a line of best fit to the model for each set of data points associated
#     with a particular season. You can essentially see how well the model fits the data for
#     each season and the associated data, as opposed to a general fit comparing all the data points.

# B.)
Plot1 <- ggplot(data = weatherData) +
  geom_jitter(mapping= aes(x= tempDept, y = windSpeed, size= precip2, color= windDir)) +
  labs(title ="Wind Speed vs.Temperature",
       subtitle= "Precipitation amounts in relation to wind direction",
       x = "Temperature (degrees farenheight)",
       Y = "Wind Speed",
       size = "Precipitation",
       color = "Wind Directions") +
  theme_bw()                 +
  theme(legend.position = c(.99, .99),       ## Got this code from help page
        legend.justification = c("right", "top"), ##  Need Practice with adjustments
        legend.box.just = "right",               ##   of Legends
        legend.margin = margin(5, 5, 5, 5))
       
plot(Plot1)

####################### Comments on the plot  #######################

# Looking at this data it appears that the general trend is that winds from the
# West have the highest chance of bringing precipitation with them regardless of
# temperature. On the other hand it appears that winds originating from the South bring the highest amounts
# of total precipitation. One last observation is that between the temperature range of
# 0 - 10 degrees F is when you can most likely expect a weather event that will produce
# some kind of precipitation

# C.)
plot2 <- ggplot(data = weatherData) +
  geom_jitter(mapping= aes(x= relHum, y = avgTemp, size= stnPressure, color= windDir,
                           shape = season)) +
  labs(title ="Humidity vs.Temperature",
       subtitle= "pressure variation seasonally with varying wind directions",
       x = "Relative Humidity",
       Y = "Wind Speed",
       size = "Pressure (mb)",
       color = "Wind Directions",
       shape = "Season") +
  theme_gray()   
plot(plot2)

#### 10.1 #### Questions to Answer ########
#1.) My comfort with this lesson was probably a 9/10.

#2.) Totally with reading the lesson 2 hours.

#3.) Knowing the appropriated mapping components to assign to particular variables.

#4.) Just to get familiar with other Geoms and when some should and shouldn't be used.


                       