#### Homework Due 1/19/2022####
#GGPLOT Components
#### Nick Alioto #####

rm(list=ls());                         # clear the Environment tab
options(show.error.locations = TRUE);  # show line numbers on error
library(package=ggplot2);              # include all GGPlot2 functions

## Use front Slash to tell R to search through folders in a specific order
## header = True will show column names



WeatherData = read.csv(file="Data/LansingNOAA.csv", header = TRUE)

########################    10 Application ####################################

# 1.) What component (function) would be used to create a text plot?
                     #### - geom_label(), or geom_text() ######

#2.) What component would you use to change the breaks on the x-axis if the values were in date format?
  
               ####### You would use the scale_x_date component #########

scale_x
# -----------Plotting Time -----  Pressure vs. Wind Speed Plot ----------------#

weather_plot = ggplot(data = WeatherData) + 
       geom_point (mapping = aes(x = windSpeed, y = stnPressure)) +
       labs(title = "Pressure vs. Wind Speed", subtitle = "Lansing MI, 2016",
       x = " Wind Speed (mph)", y = "Standard Pressure") +
       theme_classic() +
       theme( axis.text.x=element_text(angle=45) ) +
       scale_y_continuous( breaks = seq(from=28, to=30, by=0.1), 
                           limits = c(28.5,29.5)) +
       scale_x_continuous(breaks = c(3,12,21), 
                           limits = c(0,21))
plot(weather_plot)      

?scale_y_continuous
       
###############################################################################

######################## 10.1 Questions ######################################

#1.) Pretty comfortable, It was good to practice with some of the theme components, I haven't ever really 
#    used them before.

#2.) No confusing parts, it is just good to practice with all these various components and to see how they 
#   they edit the graph and making it cleaner.

#3.) Making Maps with GGPLOT, perhaps maps that show topographical features


