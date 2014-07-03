
outBackName="./maxent_modeling/background/4824.csv" # change accord taxon
msk=paste(gap.dir,"/_backgroundFiles/backselection.asc",sep="")
backFilesDir=paste(gap.dir,"/_backgroundFiles/",sep="")

zones <- c(1:6)
countries <- c("nam","sam","eur","asi","afr","aus")

zonM <- data.frame(Zones=zones,Countries=countries)

zone <- 4 ###CHANGE ACCORD ZONE
ctry <- zonM$Countries[which(zonM$Zones == zone)]

backFile <- paste(backFilesDir, "/backsamples_z", zone, "_swd.csv", sep="")
backPts <- read.csv(backFile)
finalBackPts <- backPts
out <- write.csv(finalBackPts, outBackName, quote=F, row.names=F)

rm(uniqueOccZones)
rm(occZones)
rm(globZones)
rm(spData)
rm(backPts)