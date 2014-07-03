require(rgdal)
require(raster)

source(paste(src.dir,"/000.zipRead.R",sep=""))
source(paste(src.dir,"/000.zipWrite.R",sep=""))
source(paste(src.dir,"/000.bufferPoints.R",sep=""))

#For taxa with invalid models use the Hsamples buffer, if hsamples do not exist 

gapRaster <- function(bdir) {
  idir <- paste(bdir, "/maxent_modeling", sep="")
  ddir <- paste(bdir, "/samples_calculations", sep="")
  
  outFolder <- paste(bdir, "/gap_spp", sep="")
  if (!file.exists(outFolder)) {
    dir.create(outFolder)
  }
  
  spList <- read.csv(paste(bdir, "/priorities/hps.csv", sep=""))
  names(spList)[1]="TAXON"
  #spList <- spList[which(spList$Class == "HPS"),]
  
  cat("\n")
  cat("Processing", nrow(spList), "HP Taxa \n")
  
  allOcc <- read.csv(paste(bdir, "/occurrences/",crop,".csv", sep=""))
  
  sppC <- 1
  rcount <- 1
  scount <- 1
  for (spp in spList$TAXON) {
    
    cat("Processing taxon", paste(spp), "\n")
    
    names(spList)[1]="TAXON"
    isValid <- spList$IS_VALID[which(spList$TAXON == paste(spp))]
    
    sppFolder <- paste(idir, "/models/", spp, sep="")
    projFolder <- paste(sppFolder, "/projections", sep="")
    
    if(file.exists(paste(outFolder,"/",spp,".asc",sep=""))){
      cat("The file already exists",spp,"\n")
    }else{
      
    #Size of the herbarium samples CA50
    cat("Calculating h-samples buffer \n")
    tallOcc <- allOcc[which(allOcc$Taxon == paste(spp)),]
    hOcc <- tallOcc[which(tallOcc$H == 1),]
    if (nrow(hOcc) != 0) {
      spOutFolder <- paste(ddir, "/", spp, sep="")
      
      if (!file.exists(paste(spOutFolder, "/hsamples-buffer.asc.gz", sep=""))) {
        if (!file.exists(spOutFolder)) {
          dir.create(spOutFolder)
        }
        hOcc <- as.data.frame(cbind(as.character(hOcc$Taxon), hOcc$lon, hOcc$lat))
        names(hOcc) <- c("taxon", "lon", "lat")
        
        write.csv(hOcc, paste(spOutFolder, "/hsamples.csv", sep=""), quote=F, row.names=F)
        rm(hOcc)
        grd <- createBuffers(paste(spOutFolder, "/hsamples.csv", sep=""), spOutFolder, "hsamples-buffer.asc", 50000, paste(bdir, "/masks/mask.asc", sep=""))
      } else {
        grd <- zipRead(spOutFolder, "hsamples-buffer.asc.gz")
      }
    }
    
    hbuffFile <- paste(spOutFolder, "/hsamples-buffer.asc.gz", sep="")
    
    #Size of the genebank accessions CA50
    cat("Calculating g-samples buffer \n")
    gOcc <- tallOcc[which(tallOcc$G == 1),]
    if (nrow(gOcc) != 0) {
      spOutFolder <- paste(ddir, "/", spp, sep="")
      
      if (!file.exists(paste(spOutFolder, "/gsamples-buffer.asc.gz", sep=""))) {
        if (!file.exists(spOutFolder)) {
          dir.create(spOutFolder)
        }
        gOcc <- as.data.frame(cbind(as.character(gOcc$Taxon), gOcc$Longitude, gOcc$Latitude))
        names(gOcc) <- c("taxon", "lon", "lat")
        
        write.csv(gOcc, paste(spOutFolder, "/gsamples.csv", sep=""), quote=F, row.names=F)
        rm(hOcc)
        grd.ga <- createBuffers(paste(spOutFolder, "/gsamples.csv", sep=""), spOutFolder, "gsamples-buffer.asc", 50000, paste(bdir, "/masks/mask.asc", sep=""))
      } else {
        grd.ga <- zipRead(spOutFolder, "gsamples-buffer.asc.gz")
      }
    }
    
    gbuffFile <- paste(spOutFolder, "/gsamples-buffer.asc.gz", sep="")
    
    #Presence absence surfaces
    
    if (isValid == 1) {
      cat("Presence/absence surf. exists, using it \n")
      pagrid <- paste(spp, "_worldclim2_5_EMN_PA.asc.gz", sep="")
      pagrid <- zipRead(projFolder, pagrid)
      
      if (file.exists(gbuffFile)) {
        pagrid[which(grd.ga[] == 1)] <- 0
      }
            
      assign(paste("dpgrid",sppC,sep=""), zipRead(spOutFolder, "pop-dist.asc.gz"))
      assign(paste("dpgrid",sppC,sep=""), get(paste("dpgrid",sppC,sep="")) * pagrid)

    } else if (file.exists(hbuffFile)) {
      cat("Presence/absence surf. does not exist or is not reliable, using hsamples instead \n")
      pagrid <- grd
      
      if (file.exists(gbuffFile)) {
        pagrid[which(grd.ga[] == 1)] <- 0
      }
      
      assign(paste("dpgrid",sppC,sep=""), zipRead(spOutFolder, "pop-dist.asc.gz"))
      assign(paste("dpgrid",sppC,sep=""), get(paste("dpgrid",sppC,sep="")) * pagrid)
      
    } else {
      cat("No PA surface, no HSamples, cannot map it out \n")
    }
    
    cat("Writing", spp, "raster gap \n")
    #writeRaster(pagrid, paste(outFolder,"/",spp,".asc",sep=""), overwrite=TRUE)
    zipWrite(pagrid, outFolder, paste(spp,"asc.gz",sep=""))
    
    sppC <- sppC + 1
  }
  }  
}

gapRichness <- function(bdir){
  gapdir <- paste(bdir, "/gap_spp", sep="")
  odir <- paste(bdir, "/gap_richness", sep="")
  
  #Creating the directories
  if (!file.exists(odir)) {
    dir.create(odir)
  }
  
  #Creating individual gap raster files
  res <- gapRaster(bdir)
  
  #Creating the gap richness file
  gapList <- list.files(gapdir,pattern="asc.gz")
  
  gap_spp <- gapList[[1]]
  gap_rich <- zipRead(gapdir,gap_spp)
    
  for(i in 2:length(gapList)){
    gap_spp <- gapList[[i]]
    gap_spp <- zipRead(gapdir,gap_spp)
    gap_rich <- gap_rich + gap_spp
  }
  cat("Writing the gap richness raster")
  zipWrite(gap_rich, odir, "gap-richness.asc.gz")
  
}

