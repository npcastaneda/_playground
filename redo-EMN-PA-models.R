# Re-doing *_EMN_PA files
# October - 2013 N. Castaneda

crop <- "capsicum"
src.dir <- paste("/curie_data2/ncastaneda/gap-analysis/gap_",crop,"/_scripts",sep="") # !!! change accordingly !!!
gap.dir <-"/curie_data2/ncastaneda/gap-analysis" 
crop_dir <- paste(gap.dir,"/gap_",crop,sep="")

source(paste(src.dir,"/000.zipRead.R",sep=""))
source(paste(src.dir,"/000.zipWrite.R",sep=""))

maxentDir <- paste(crop_dir, "/maxent_modeling/models", sep="")
NADir <- paste(crop_dir, "/biomod_modeling/native-areas/asciigrids", sep="")

ls <- list.dirs(maxentDir, recursive=F)

for(spp in ls){
  spname <- unlist(strsplit(spp, "/"))[8]
  file <- paste(spp, "/projections/", spname, "_worldclim2_5_EMN_PA.asc.gz", sep="")
#   cat("Erasing", file, "\n")
#   unlink(file)
  cat("Re-creating PA file for", spname, "\n")
  NAGrid <- zipRead(paste(NADir, "/", spname ,sep=""),"narea.asc.gz")
  distMean <- zipRead(paste(spp,"/projections/", sep=""), paste(spname,"_worldclim2_5_EMN.asc.gz",sep=""))
  
  outFolder <- spp
  threshFile <- paste(outFolder, "/metrics/thresholds.csv", sep="")
  threshData <- read.csv(threshFile)
  
  thslds <- c("UpperLeftROC")
  
  thrNames <- names(threshData)
  thePos <- which(thrNames == thslds)
  theVal <- threshData[1,thePos]
  
  distMeanPA <- distMean
  distMeanPA[which(distMeanPA[] < theVal)] <- 0
  distMeanPA[which(distMeanPA[] != 0)] <- 1
  
  distMeanPA <- distMeanPA * NAGrid
  zipWrite(distMeanPA, paste(spp,"/projections", sep=""), paste(spname,"_worldclim2_5_EMN_PA.asc.gz",sep=""))
}

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::
rs <- raster("D:/Playground/gap_capsicum/3887_worldclim2_5_EMN_PA.asc")
plot(rs)

