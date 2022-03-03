####### Faceting & Boxplots Homework FW891 #########
#### Nick Alioto
### February 12, 2022

###############################################################################
rm(list=ls());                         # clear Environment tab
options(show.error.locations = TRUE);  # show line numbers on error
library(package=ggplot2);              # get the GGPlot package

# read in CSV file and save the content to weatherData
weatherData = read.csv(file="Data/LansingNOAA.csv")

##############################   Question  1    ################################

#view the data
View(weatherData)

#Order our wind from High to low using factor and creating a new vector
wind_order <- factor(weatherData$windSpeedLevel,
                     levels = c("High","Medium","Low"))

#Lets add to our data frame so we can use with function facet(),
#(make sure new column name is set the same to vector you created!)
weatherData$wind_order = wind_order

# Order our Wind Direction
wind_dir_order <- factor(weatherData$windDir,
                     levels = c("North","South","East","West"))

#Add this new vector to our data frame as well 
weatherData$wind_dir_order = wind_dir_order

# Temperature vs. Humidity Scatter plot (Facet by Row)
plot1 <- ggplot(data = weatherData) +
  geom_point(mapping = aes(x= relHum, y= avgTemp)) +
  theme_bw()+
  facet_grid( rows = vars(wind_order),
              cols = vars(wind_dir_order))+
  labs(title = "Temperature vs. Humidity",
       subtitle = "in relation to level of wind speed",
       x = "Humidity (%)",
       y = "Temperature (F)")
plot(plot1)


############################## Question 2 #####################################
#### Part 3: Reordering the seasons ####

#vector of Ordered seasons
seasonOrdered = factor(weatherData$season,
                       levels=c("Spring", "Summer", "Fall", "Winter"))
#Add to data frame
weatherData$seasonOrdered = seasonOrdered


# Let's edit the plot from figure 3 shall we

plot2 = ggplot( data=weatherData ) +
  geom_histogram( mapping=aes(x= avgTemp, fill= seasonOrdered),
                  binwidth = 8,
                  color="black") + 
  theme_bw() +
  scale_fill_manual(values = c("green","red","orange","purple")) +
  theme(strip.background = element_rect(fill = "darkorchid3"),
        strip.text = element_text(size = 14,
                                  color = 'white',
                                  family = "serif")) + 
  scale_x_continuous(breaks = seq(from = 5, to = 85, by= 10),
                     limits = c(0,100)) +
  facet_grid(rows = vars(seasonOrdered)) +
  labs(title = "Temperature (\u00B0F)",
       subtitle = "Lansing, Michigan: 2016",
       x = "Temperature (\u00B0F)")
plot(plot2)

??scale_x_continuous

                           
### Need to add the breaks on this plot......                     
# scale_x_continuous(breaks = seq(from=5, to=85, by=10),
#limits = c(5,90))) +

############################  Question 3   ####################################

#Reorder the wind speed
low_high <- factor(weatherData$windSpeedLevel,
                   levels = c("Low","Medium","High"))

#Add to Data Frame
weatherData$low_high = low_high

# Vector of box colors to use for fill
boxcolors <- c("blue","yellow2","blue","yellow2",
               "blue","yellow2","blue","yellow2",
               "blue","yellow2","blue","yellow2")

# Vector of colors to outline first 3 boxes only in blue
outline.colors <- c("black","black","black","black",
                    "black","black","black","black",
                    "blue","blue","blue","black")
                    


plot3 = ggplot(data=weatherData) +
  geom_boxplot(mapping=aes(x=wind_dir_order, y=changeMaxTemp),
               na.rm = TRUE,
               color = outline.colors,
               fill = boxcolors,
               outlier.colour = rgb(red= 1, green= 0.647, blue= 0), 
               outlier.shape = "\uff06",
               outlier.size = 3) +
  theme_bw() +
  facet_grid( cols=vars(low_high)) +
  labs(title = "Change in Temperature vs. Wind Direction",
       subtitle = "Lansing, Michigan: 2016",
       x = "Wind Direction",
       y = "Degrees (Fahrenheit)");
plot(plot3)


####################### Question 4 ############################################

# Set outlier.shape = NA
# Use oulier alpha and set that to 1 to make the points completely transparent
# You could also just set outlier = NA to not have it plotted even if there were
# any outliers present in yout data


######################   10.1 Questions  #####################################
#What was your level of comfort with the lesson/application?
# Probably a 9/10
  
#Approximately how long did you work on this lesson?
# about 3 hours

#What areas of the lesson/application confused or still confuses you?
# how to ripple and outlier? also how to edit x and y scales when it is a faceted plot

#What are some things you would like to know more about that is related to, but not covered in, this lesson?
# More information on plotting the error bars on boxplots