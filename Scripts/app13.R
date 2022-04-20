#FW891 Homeworkd
# 04/19/2022
# Nick Alioto


### Application:
# 1) Create a script file in your script folder named app13.r
# 2) Create a properly formatted Date object from the pseudoData 
#    columns date2 and date3
# 3) Create a properly formatted POSIXct object from the 
#    pseudoData columns dateTime2 and dateTime3         #d  #B       #Y
# 4) Create a vector that has the dates in this format: 15-April, 2022
#    - add this vector to a column named date_formatted in pseudoData
# 5) Create a vector that has the date-times in this format: 09:36 on Fri 04/15/22 
#    - add this vector to a column named dateTime_formatted in pseudoData
# 6) Create a vector that has the number of seconds since the epoch 
#    - this is since Jan 1, 1970 at midnight GMT (but you do not need this info)
#    - add this vector to a column named epoch in pseudoData

rm(list=ls());  options(show.error.locations = TRUE);
library(package = "sp");       #old Simple Features (but still needed)
library(package = "rgeos");    # getting/converting crs
library(package = "rgdal");    # getting/converting crs
library(package = "ggplot2");
library(package = "dplyr");
library(package = "sf");       # Simple Features
library(package = "rnaturalearth");     # for getting coord data
library(package = "rnaturalearthdata"); # for getting coord data
library(package = "gridExtra");
library(package = "png");
library(package = "jpeg");
library(package = "grid");
library(package = "ggspatial");
library(package = "gganimate");  # for animations
library(transformr)


pseudoData = read.csv("FW891-main (4)/FW891-main/data/pseudoData.csv");

stnDate2 = as.Date(pseudoData$date2,      # date1 is a chr (string) column
                  format="%Y-%m-%d");   # give the format of date1

stnDate3 = as.Date(pseudoData$date3,      # date1 is a chr (string) column
                   format="%m/%d/%y");   # give the format of date1

stnDateTime2 = as.POSIXct(pseudoData$dateTime2,
                         format="%Y-%m-%d %H:%M:%S");   

stnDateTime3 = as.POSIXct(pseudoData$dateTime3,
                         format="%Y-%m-%d %Hh%Mm");   
#Reformat
pseudoData$date_formatted = format(stnDate2, format="%d-%B, %Y");  # a chr vector
# 09:36 on Fri 04/15/22
pseudoData$datetime_formatted = format(stnDateTime2, format="%H:%M on %a %m/%d/%y");  # a chr vector


### Application
# 1) Add the following to the script file app13.r
# 2) Save the GLATOS fish movement data (CRS 4326) in the file 
#    data/Two_Interpolated_Fish_Tracks.csv to a Simple Feature
# 3) The fish are in Lake Erie 
#    - Create a spatial plot of the fish locations over a map of Lake Erie
# 4) Create an animation of the fish movement 
#    - map the record_type to color (use the colors blue and orange)
#    - map the animal_id to shape (use a star and a triangle)
#    - In the title put the time in this format: 15-May @ 4:57AM
# 5) Save the animation as FishTracks.gif to a folder called images 
#    in your Project Folder
#    - Use 300 frames in the animation (this will take time to render)
#    - have to animation run at 10 frames per second
# 6) Answer the following questions in comments:
#    Why are there many frames without any movement?
#    Why are there so many points in each of the frames?

fishData = read.csv("FW891-main (4)/FW891-main/data/Two_Interpolated_Fish_Tracks.csv")

### Convert into a Simple Feature with the standard 4326 CRS
fishData_SF = st_as_sf(fishData, 
                         coords=c("longitude","latitude"), 
                         crs=4326)

LakeErie <- st_read(dsn = 'data/Lake_Erie_Shoreline.kml')
LakeErie_SF <- st_as_sf(LakeErie)

plot_LakeER = ggplot() +
  geom_sf(data = LakeErie_SF,
          mapping = aes(geometry = geometry),
          color = "blue",
          fill = "lightblue") +
  theme_void() +   # remove all plot features
  theme(panel.background=element_rect(color = "black", fill="transparent", 
                                      size=3))
plot(plot_LakeER)


plot1 = ggplot() +
  geom_sf(data = LakeErie_SF,
          mapping = aes(geometry = geometry),
          color = "blue",
          fill = "lightblue") +
  geom_sf(data = fishData_SF,
          mapping = aes(geometry = geometry, color = record_type))+
#                        shape = animal_id)) +
  scale_color_manual(values=c("blue", "orange")) +
#  scale_shape_manual(values=c(2, 8)) + #star #triange     #throws error
  theme_void() +   # remove all plot features
  theme(panel.background=element_rect(color = "black", fill="transparent", 
                                      size=3)) +
  coord_sf(crs = 4326,  
           expand = TRUE)

plot(plot1)

#Create Animation
#Format date
stnTime = as.POSIXct(fishData_SF$bin_timestamp,    
                     format="%m/%d/%Y %H:%M")  

fishData_SF$time_formated <- format(stnTime, format="%d-%B @ %I:%M%p")
stnfish = as.POSIXct(fishData_SF$time_formated,    
                     format="%d-%B @ %I:%M%p")  #15-May @ 4:57AM

plot2 = plot1 +
  labs(title = "Timestamp: {frame_time}") +  # puts the time in the title
  transition_time(time=stnfish);

## animate() instead of plot() -- the animation goes to the Viewer tab
animate(plot=plot2, 
        nframes = 10,    # 10 frames (very low -- keeps the rendering time short)
        fps=1)          # 1 per second (so, this will be 10 seconds long)

### More useful to save as gif (again, nframes is small to keep rendering times manageable)
anim_save(filename = "Images/FishTracks.gif",   
          animation = plot2,# plot to animate
          nframes = 10,      # number of frames in animation 300
          fps = 1)          # frames per second



# 6) Answer the following questions in comments:
#    Why are there many frames without any movement?

#ANSWER: There are more frames than days with data, therefore some frames
#        display the same data

#    Why are there so many points in each of the frames?

# ANSWER: 
# This is due to the structure of the data. 
# Many points were collected at each time interval.

  
  


