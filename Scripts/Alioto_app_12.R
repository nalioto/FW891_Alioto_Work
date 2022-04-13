# Homework 12 FW891
# Nick Alioto 04/13/2022

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
library(package = "gridExtra");
library(package = "png");
library(package = "jpeg");
library(package = "grid");
library(package = "ggspatial")

#### Application A
#    1) Make these changes to plot2:
#    - position the compass on the right side and centered vertically
#    - position scale at the top-center 
#        - you need to one of the padding subcomponents
#    - make the scale width about 30% of the plot
#    - increase the height of the scale bar (note: you can use cm or in)
#    - (approximately) double the size of the compass without 
#       changing the aspect ratio (i.e., the shape stays the same)
#    - Add two latitude lines at 40 and 50 degrees
#       - color the lines red
#       - use annotation_spatial_hline 

#   2) Add the compass and scale to a plot with your spatial data
#    - include at least three subcomponent changes for both scale and compass
#    - Add two green longitude lines 

# Get spatial data for all Lakes (downloaded from naturalearth) -- save to a SF
lakes = st_read(dsn="data/lakes/ne_10m_lakes.shp"); # can (usually) use this as an SF
lakes_SF = st_as_sf(lakes); # on the safe side -- explicitly make into an SF

# Get spatial data for the US using rnaturalearth package -- save to an SF
states = ne_states(country = "United States of America");
states_SF = st_as_sf(states);

plot3 = ggplot() +
  geom_sf(data = states_SF,
          mapping = aes(geometry = geometry),
          color = "black",
          fill = "grey") +
  geom_sf(data = lakes_SF,
          mapping = aes(geometry = geometry),
          color = "lightblue",
          fill = "lightblue") +
  annotation_scale(location = "tl",  # options: tr, br, tl, bl
                   #  plot_unit ="m",  # needs to match CRS
                   width_hint = 0.4,         #change width
                   height = unit(0.3, "in"), #change height
                   pad_x = unit(1.0, "in"),   #shift center
                   bar_cols = c("red", "orange"),
                   line_col = "gray20",   
                   text_col = "blue") +
  annotation_north_arrow(location = "br",          
                         height = unit(0.75, "in"), #change height
                         width  = unit(0.75, "in"), #change width
                         which_north = "true", 
                         pad_x = unit(0, "in"), 
                         pad_y = unit(0.65, "in"),  #shift center
                         style = north_arrow_fancy_orienteering(
                           text_col = 'red',
                           line_col = 'blue',
                           fill = 'yellow')) +
  annotation_spatial_hline(color = "red",           #Add latitude lines
                           intercept = c(40, 50),
                           crs = 4326) +            #use WGS84 so we can degrees 
  coord_sf(crs = 26917,                           #for intercept values
           xlim = c(-3000000, 2000000),  
           ylim = c(3000000, 7000000),
           expand = TRUE)
plot(plot3)

# create a plot with my own spatial data:
# Was not able to get started on this.



# Application B
# 1) Redo multi1 so that the picture of the llama and the Lake Michigan plot 
#    are to the right of the main plot.
#    Make sure nothing overlaps (i.e., you can see everything)
# 2) Create a SF of Lake Michigan that has only the outline of the lake
#     - make the background color of Lake Michigan transparent 
# 3) Create a rasterGrob of your own image
# 4) Create a second multipaneling that uses the US map
#   - put the transparent Lake Michigan in the bottom-right corner  
#   - set up the paneling so that your four image corners touches these four states:
#       Idaho, Minnesota, Arizona, and Arkansas 
#   - note: you will need to change the nrow/ncol of the matrixLayout

### Read in plot saved in last lesson -- puts the plot in the Environment
plotInfo = readRDS(file="FW891-main (3)/FW891-main/data/plot.RData");
plot(plotInfo);  # same info but name has changed

imgJPG = readJPEG("FW891-main (3)/FW891-main/images/alpaca.jpg");   # from the jpeg package
imgGrobJPG = rasterGrob(imgJPG);

# Get Lake Michigan spatial data and save to an SF
lakeMichigan = st_read(dsn="data/Lake_Michigan_shoreline.kml");
lakeMI_SF = st_as_sf(lakeMichigan); 

# A quick plot of Lake Michigan 
plot_LakeMI = ggplot() +
  geom_sf(data = lakeMI_SF,
          mapping = aes(geometry = geometry),
          color = "blue",
          fill = "lightgreen") +
  theme_void() +   # remove all plot features
  theme(panel.background=element_rect(color = "black", fill="transparent", 
                                      size=3));
plot(plot_LakeMI)

#move insets to right of map
newmatrixLayout = matrix(nrow=5, ncol=3, 
                         byrow=TRUE,   # how the matrix is laid out
                         # this should visually match nrow and ncol!
                         data = c(1,  NA, 3, 
                                  NA, NA, NA,
                                  NA, NA, NA,
                                  NA, NA, 2,
                                  NA, NA, 1));

#### Grobs and Multipaneling (mention ... argument)
multi2=arrangeGrob(plotInfo, plot_LakeMI, imgGrobJPG,  # 1, 2, 3
                   top = textGrob(label = "Llamas",
                                  gp=gpar(fontsize=25,# (G)raphical (P)arameters
                                          col="blue")), 
                   right="Alpaca",
                   layout_matrix = newmatrixLayout);
plot(multi2)


#add my own image and lake michigan to the map
USJPG = readJPEG("images/US.jpg");   # from the jpeg package
USGrobJPG = rasterGrob(USJPG)

myplot_LakeMI = ggplot() +
  geom_sf(data = lakeMI_SF,
          mapping = aes(geometry = geometry),
          color = "blue",
          fill = "lightgreen") +
  theme_void() +   # remove all plot features
  theme(panel.background=element_rect(color = "transparent", fill="transparent", 
                                      size=3))

newmatrixLayout = matrix(nrow=10, ncol=8, 
                         byrow=TRUE,   # how the matrix is laid out
                         # this should visually match nrow and ncol!
                         data = c(1,  NA, NA, NA, NA, NA, NA, NA,
                                  NA, NA, NA, NA, NA, NA, NA, NA,
                                  NA, NA,  3, NA, 3,  NA, NA, NA,
                                  NA, NA, NA, NA, NA, NA, NA, NA,
                                  NA, NA, NA, NA, NA, NA, NA, NA,
                                  NA, NA, NA, NA, NA, NA, NA, NA,
                                  NA, NA, NA, NA, NA, NA, NA, NA,
                                  NA, NA,  3, NA,  3, NA,  NA, 2,
                                  NA, NA, NA, NA, NA, NA, NA, NA,
                                  NA, NA, NA, NA, NA, NA,  NA, 1));

#### Grobs and Multipaneling (mention ... argument)
multi3=arrangeGrob(plotInfo, myplot_LakeMI, USGrobJPG,  # 1, 2, 3
                   top = textGrob(label = "Llamas",
                                  gp=gpar(fontsize=25,# (G)raphical (P)arameters
                                          col="blue")), 
                   right="Alpaca",
                   layout_matrix = newmatrixLayout);
plot(multi3)


# Application C
# Redo the newPlot plot so that the picture of the llama and the Lake Michigan 
# plot are to the right of the main plot with the US and the lakes. 

LakeMI_PNG = readPNG("FW891-main (3)/FW891-main/images/LakeMI.png");   

mynewPlot = plotInfo +
  annotation_raster(imgJPG,     # does not matter JPG vs PNG
                    xmin=2000000, xmax=1400000, 
                    ymin=6200000, ymax=7000000) +
  annotation_raster(LakeMI_PNG, # does matter -- image has transparency
                    xmin=1000000, xmax=2000000, 
                    ymin=2800000, ymax=3800000) +
  coord_sf(crs = 26917,  
           xlim = c(-3000000, 2000000),  
           ylim = c(3000000, 7000000),
           expand = TRUE);
plot(mynewPlot);

#Create a second plot that uses the US map: 
#    add the transparent Lake Michigan (from part B) to the bottom-right corner   
#    add your image (from part B) so that the four corners touch these four 
#           states: Idaho, Minnesota, Arizona, and Arkansas.  

# Was not able to get to this..

