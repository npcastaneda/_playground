# Non-priorities processes
# Sept - Oct 2013


cd /curie_data2/ncastaneda/code/gap-analysis-cwr/gap-analysis/gap-code
# cp * /curie_data2/ncastaneda/gap-analysis/gap_groundnut/_scripts
cp * /curie_data2/ncastaneda/gap-analysis/gap_beet/_scripts
# cp * /curie_data2/ncastaneda/gap-analysis/gap_cucumber/_scripts
cp * /curie_data2/ncastaneda/gap-analysis/gap_cotton/_scripts
cp * /curie_data2/ncastaneda/gap-analysis/gap_tomato/_scripts
cp * /curie_data2/ncastaneda/gap-analysis/gap_grape/_scripts
cp * /curie_data2/ncastaneda/gap-analysis/gap_maize/_scripts
cp * /curie_data2/ncastaneda/gap-analysis/gap_lettuce/_scripts
cp * /curie_data2/ncastaneda/gap-analysis/gap_adzuki_bean/_scripts
cp * /curie_data2/ncastaneda/gap-analysis/gap_apricot/_scripts
cp * /curie_data2/ncastaneda/gap-analysis/gap_cassava/_scripts
cp * /curie_data2/ncastaneda/gap-analysis/gap_cherry/_scripts



data <- read.csv("clipboard", sep="")
require(maptools); data(wrld_simpl)
plot(wrld_simpl)
points(data$lon, data$lat, col="red")


require(sp)
require(maptools)

narea <- "D:/Playground/narea.shp"
narea <- readShapeSpatial(narea)
plot(narea)

x <- over(narea, data)

spList <- read.csv("D:/Playground/gap_capsicum/summary-files/taxaForRichness.csv")
allOcc <- read.csv("D:/Playground/gap_capsicum/occurrences/capsicum.csv")
bdir <- "D:/Playground/gap_capsicum"
ddir <- paste(bdir, "/samples_calculations", sep="")

sample1 <- zipRead("D:/Playground/gap_capsicum/samples_calculations/3887", "samples-buffer-na.asc.gz")
sample0 <- zipRead("D:/Playground/gap_capsicum/samples_calculations/3887", "samples-buffer.asc.gz")
plot(sample1)
plot(sample0)



# grape
require(raster)
bdir <- "D:/Playground/gap_grape"
mask <- raster(paste(bdir,"/masks/mask.asc", sep=""))
cellArea <- raster(paste(bdir,"/masks/cellArea.asc", sep=""))
plot(mask)
plot(cellArea)

mask
cellArea
min(mask[])

hsamples <- zipRead(paste(bdir,"/samples_calculations/2317", sep=""), "hsamples-buffer.asc.gz")
chull <- zipRead(paste(bdir,"/samples_calculations/2317", sep=""), "convex-hull.asc.gz")

hsamples
chull

hsamples <- raster(paste(bdir,"/samples_calculations/2317/hsamples-buffer.asc", sep=""))
chull <- raster(paste(bdir,"/samples_calculations/2317/convex-hull.asc", sep=""))
plot(hsamples)

require(maptools)
shpName <- paste(bdir,"/masks/polyshps/mask.shp", sep="")
pol <- readShapePoly(shpName)

plot(pol)
#--------------------------------
spp <- zipRead("D:/Playground/gap_grape", "2317_worldclim2_5_EMN_PA.asc.gz")
pc1 <- raster("D:/Playground/gap_grape/pc_r_1.asc")
par(mfrow=c(1,2))
plot(spp)
plot(pc1)

# sugarcane
data <- read.csv("D:/Playground/gap_sugarcane/sugar_cane_all.csv")
gOcc <- data[which(data$Taxon == "1995"),]
gOcc <- gOcc[which(gOcc$H == "1"),]
require(maptools); data(wrld_simpl)
shp <- readShapePoly("D:/CWR/_inputs/_non-PriorityCrops/_revision/2013-09-23/SHP/sugar_cane/1995/narea.shp")
plot(shp)
points(gOcc$lon, gOcc$lat, col="red")

plot(wrld_simpl, col="azure")
points(gOcc$lon, gOcc$lat, col="red")
#--------------------------------
#maize richness
require(maptools); data(wrld_simpl)
dir <- "D:/Playground/gap_maize"
list <- list.dirs(dir)
list <- list[-1]
par(mfrow=c(5,2))
for(ls in list){
  results_0[[i]] <- zipRead(ls,"samples-buffer-na.asc.gz")
  plot(rs)
}

par(mfrow=c(1,1))
mask <- raster(paste(dir,"/mask.asc",sep=""))
plot(mask)

par(mfrow=c(1,2))
rs <- raster("D:/Playground/gap_grape/pc_r_1.asc")
plot(rs)
rs <- raster("D:/Playground/gap_grape/pc_r_2.asc")
plot(rs)