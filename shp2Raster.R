# Purpose: converts shp polygons into raster files
# N. Castaneda 2013

require(raster); require(maptools)

src.dir <- "D:/_code/R/gap-analysis-maxent"
source(paste(src.dir,"/000.zipWrite.R",sep=""))
source(paste(src.dir,"/000.zipRead.R",sep=""))


dir <- "D:/CWR/ResultsGapAnalysis2013/Borrar/musa/nareas/Musa_acuminata"
shp <- readShapePoly(paste(dir,"/narea",sep=""))
msk <- raster("D:/CWR/ResultsGapAnalysis2013/Borrar/musa/mask.asc")
################# RASTERIZE #################

rs <- rasterize(shp,msk) # convert from shp to raster
rs[!is.na(rs)] <- 1 # reclass all to 1
writeRaster(rs,paste(dir,"/Musa_acuminata.asc",sep=""))

plot(msk)
plot(rs)

##################### 
plot(rs)

# TEST 1 ==> GUSTA!
test1 <- rs
test1[!is.na(test1)] <- 1
plot(test1)

# TEST 2
test2 <- rs
test2[which(!is.na(test2[]))] <- 1
plot(test2)
test2[which(is.na(test2[]) & msk[] == 1)] <- 0
plot(test2)