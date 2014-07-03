crop <- "vetch" #change according to the coded name
#basic stuff - where is the code
src.dir <- paste("/curie_data2/ncastaneda/gap-analysis/gap_",crop,"/_scripts",sep="") # !!! change accordingly !!!
gap.dir <-"/curie_data2/ncastaneda/gap-analysis" # !!! change accordingly !!!



#########################################################
# ERASING GAP ANOMALUOUS FILES

eraser <- function(bdir,crop){
  
  spList <- read.csv(paste(bdir, "/priorities/priorities.csv", sep=""))
  allOcc <- read.csv(paste(bdir, "/occurrences/",crop,".csv", sep=""))
  names(spList)[1]="TAXON"
  
  priorityLevel <- c("HPS","MPS","LPS","NFCR")
  
  for(p in priorityLevel){
    spList <- spList[which(spList$FPCAT == p),]
    gapdir <- paste(bdir, "/gap_spp/", p, sep="")
    
    for(spp in spList$TAXON){
      gap_spp <- paste(gapdir, "/", spp, ".asc.gz", sep="")
      tallOcc <- allOcc[which(allOcc$Taxon == paste(spp)),]
      nrow = nrow(tallOcc)
      if(nrow == 0){
        cat(spp, "doesn't have records with coordinates \n")
        if(file.exists(gap_spp)){
          cat("Erasing", spp, "gap map \n")
          unlink(gap_spp)
        }
      }
      #cat(spp, "has", nrow, "records with coordinates \n")
    }
  }  
}

for (crop in cropList){
  bdir = paste("/curie_data2/ncastaneda/gap-analysis/gap_", crop, sep="")
  eraser(bdir,crop)
}
