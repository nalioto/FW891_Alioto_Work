####### Annotations Homework FW891 #########
#### Nick Alioto
### February 19, 2022

###############################################################################
rm(list=ls());                         # clear Environment tab
options(show.error.locations = TRUE);  # show line numbers on error
library(package=ggplot2)               # get the GGPlot package
library(ggforce)

# read in CSV file and save the content to weatherData
weatherData = read.csv(file="Data/LansingNOAA.csv")

##############################   Question  1    ################################

### Re-order the directions on the x-axis using factor(s)
windDirOrdered = factor(weatherData$windDir,
                        levels=c("North", "East", "South", "West"))


plot1 = ggplot(data=weatherData) +
  geom_boxplot(mapping=aes(x=windDirOrdered, y=changeMaxTemp),
               na.rm = TRUE) +
  theme_bw() +
  labs(title = "Change in Temperature vs. Wind Direction",
       subtitle = "Lansing, Michigan: 2016",
       x = "Wind Direction",
       y = "Change in Temperature (\u00B0F)");
plot(plot1)

#########
# Need Vectors for points to add and for colors and fill of those points
xvec <- c(2,2,2)
yvec <- c(-23,20,25)
point.size <- c(4,3,3)
point.fill <- c("pink","salmon","darkorchid3")

# Now let's add our created points
Plot2 <- plot1 +
  annotate(geom= "point",
           x = xvec,
           y = yvec,
           size = point.size,
           color = "black",
           fill = point.fill,
           shape = c(21,22,23))
plot(Plot2)

## Now let's add lines with there values to the plot
plot3 <- Plot2 +
  annotate(geom= "text",
           x= c(1.5, 1.5, 1.5),        
           y= c(-23,20,25),  
           label= c("-23","20","25"),     
           color="orange") +
  annotate(geom= "segment",
           x= c(1.6,1.6,1.6),          # starts after first box
           xend= c(1.9,1.9,1.9),      # ends just before the second box
           y= c(25,20,-23),           
           yend= c(25,20,-23))      
plot(plot3)

### Finally let's add boxes behind all of the outlier values we added
plot4 <- plot3 +
  annotate(geom= "rect",
           xmin = c(1.35,1.35,1.35),    # starting x
           xmax = c(1.6,1.6,1.6),    # ending x point
           ymin = c(23,18,-25),   # starting y point
           ymax = c(27,22,-21),   # ending y point
           alpha = 0.2,
           linetype=1,
           fill = "black")
           
plot(plot4)
#------------------------------------------------------------------------------

########################   Question 2  ########################################

plot5 <- ggplot() + # creating a canvas without a data frame
  theme_bw() +
  annotate(geom="point",
           x = weatherData$avgTemp[1:101], # use [] to subset out data you want
           y = weatherData$relHum[1:101],  # in this case the first 100 values
           size = 3,
           color = "blue",
           fill = "red",
           shape = 21) + 
  labs(title="Scatterplot using annotate",
       x = "Average Temperature",
       y = "Relative Humidity")
plot(plot5)

# Adding horizontal and vertical lines for the median of the above 100 values
# for avgTemp and relHum
Temp.median <- median(weatherData$avgTemp[1:101]) # = 32
Humidity.median <- median(weatherData$relHum[1:101]) # = 73

#Noe let's add using vline for (x) and hline for (y)
plot6 <- plot5 +
  geom_vline(mapping=aes(xintercept = Temp.median),
             color = "yellow3",
             size= 1) +
  geom_hline(mapping=aes(yintercept = Humidity.median),
             color="darkorchid2",
             size=1)
plot(plot6)

# Finally let's add circle and elipse to the values we want to highlight
# Need to install the ggforce package to use geom_ellipse

plot7 <- plot6 +
  annotate(geom="polygon",  # connects all the points
           x = c(21.5,22,11,3,18),
           y = c(80,56,60,70,90),
           color = "black",
           fill = "salmon",
           linetype = 1,
           alpha = 0.2) +
  geom_ellipse(mapping=aes(x0 = 44, y0 = 91, a = 14.2, b= 7.8, angle=150),
               alpha=0.2,   
               color = "blue",
               fill = "green",
               size=1,
               linetype=1)
plot(plot7)

############################# Question 3  #####################################

# Create our values for the plot using seq() function
x.vals <- seq(from=1, to=1000, by=1)
y.vals <- seq(from= sqrt(1), to= sqrt(1000), length.out=1000)


#Now time to make our plots
plot8 <- ggplot()+
  theme_bw() +
  annotate(geom= "point",
           x= x.vals,
           y= y.vals,
           size=2,
           color="black",
           fill="salmon",
           shape=5) +
  labs(title = "Square Root of X",
       x = "values of x from 1 - 1000",
       y = "Square root values of X from 1 - 1000")
plot(plot8)

#Now we add an arrow to the end using geom = "segment"

plot9 <- plot8 +
  annotate(geom = "segment",
           x= 950,              #Start the segment near the end of the x-values
           xend= 1000,
           y= 30.09011,         #Start the y segment near the end of the y-values
           yend= sqrt(1000),
           color= "red",
           linetype= 1,
           size= 1,
           arrow = arrow())
plot(plot9)



#------------------------------------------------------------------------------
# 10.1 - Questions
# Answer the following in comments inside your application script:
  
#  What was your level of comfort with the lesson/application?
#9/1o, figuring out question 3 was the most difficult to me

#  Approximately how long did you work on this lesson?
# 2 Hours

#  What areas of the lesson/application confused or still confuses you?
# Nothing is confusing remembering how to do this all will just take continual
# practice

#  What are some things you would like to know more about that is related to, but not covered in, this lesson?
# Adding actual images or logos onto your plot, without having to export the plot
# and edit in say powerpoint.