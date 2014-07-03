
inDir <- "D:/Zonal_python_USstates/results"

listZone <- list.files(inDir)

sppC <- 1
for (sp in listZone) {
  
  cat("Reading data for", sp, "\n")
  priorit <- read.csv(paste(inDir,"/",sp,sep=""))
  
  if(sppC==1){
    allPri <- priorit
  }else{
    allPri <- rbind(allPri, priorit)
  }
  sppC <- sppC + 1
  
}

outFile <- paste(inDir, "/Zonal_USP1Aall.csv", sep="")
write.csv(allPri, outFile, quote=F, row.names=F)
