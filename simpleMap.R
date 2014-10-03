# Installing the packages needed for the exercice
install.packages("maptools") 
install.packages("raster")

# Calling required packaes
require(maptools)
require(raster)

# Opening Brazil shapefile
bra.map <- "D:/_geodata/admin/BRA_adm0.shp" #Change this path, to the path and filename where you are saving your shapefile of Brazil
bra.map <- readShapeSpatial(bra.map) # This is the function that calls the file

# Opening the elevation raster
ele.rs <- "D:/_geodata/elevation/alt.asc" #Change this path and filename accordingly. Use the ascii file!
ele.rs <- "D:/_geodata/clim/bio_2-5m/bio_1.asc"
ele.rs <- raster(ele.rs) # This is the function that calls the file
ele.rs <- crop(ele.rs,bra.map) #This function lets you extract the elevation data according to your shapefile

# Opening the species data
arachis <- "D:/CWR_collaborations/potatoCIP/_process/occurrence/potatoSpooner_all.csv" #Change this path and filename accordingly. Use the csv file
arachis <- read.csv(arachis)

# Preparing the map
plot(ele.rs)
plot(bra.map,add=T)
points(arachis$lon, arachis$lat, pch=16) # Change lon and lat according to the fieldnames in your file storing the latitude and longitude

