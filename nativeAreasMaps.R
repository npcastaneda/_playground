require(maptools); data(wrld_simpl)
require(sp)

cropList= c("avena", "bambara", "bean", "cajanus", "cicer", "cowpea", "daucus", "eggplant", "eleusine", "faba_bean", "helianthus", "hordeum", 
            "ipomoea", "lathyrus", "lens", "lima_bean", "malus","medicago","musa","pennisetum", "pisum", "potato", "rice", "secale", "sorghum", 
            "triticum", "vetch")

for(crop in cropList){
  dir <- paste("/curie_data2/ncastaneda/gap-analysis/gap_", crop, "/biomod_modeling/native-areas/polyshps", sep="")
  out <- "/curie_data2/ncastaneda/gap-analysis/_native-areas"
  outdir <- paste(out,"/", crop, sep=""); if(!file.exists(outdir)){dir.create(outdir)}
  spList <- read.csv("/curie_data2/ncastaneda/gap-analysis/_results/PtaxaofPcrops_all - names_codes_newest(450).csv")
#   spList <- read.csv("D:/CWR/ResultsGapAnalysis2013/_summary/_analysis/PtaxaofPcrops_all - names_codes_newest(450).csv") # TEMPORAL
  spList <- spList[which(spList$Crop_code == paste(crop)),]
  spList <- spList$Taxon_final_short
  for(sp in spList){
    narea <- paste(dir, "/", sp, "/narea.shp", sep="")
    if(file.exists(narea)){
      spname <- gsub("_", " ", sp)
      narea <- readShapePoly(narea)
    
      tiff(paste(outdir, "/", sp, ".tif", sep=""),
           res=300,pointsize=5,width=1500,height=800,units="px",compression="lzw")
      # par(mar=c(0.5,0.5,0.5,0.5),cex=0.8,lwd=0.8, oma=c(1,1,2,1))
      # par(mar=c(1,1,1,1),cex=0.8,lwd=0.8, oma=c(1,1,2,1))
      par(mar=c(0.2,0.2,0.2,0.2),cex=0.8,lwd=0.8, oma=c(1,1,2,1))
      
      plot(wrld_simpl,lwd=0.5, border="azure4", useRaster=F)
      plot(narea, lwd=0.5, add=T, col="darkolivegreen1", border="darkolivegreen")
      title(main=spname, outer=T, font.main=3)
      grid()
      box(lty = 'solid', lwd=0.8)
      
      dev.off()  
    }
  }
}

out <- "D:/CWR-collaborations/potatoCIP/_process/nareas-spooner/_figures"
dir <- "D:/CWR-collaborations/potatoCIP/_process/nareas-spooner"
setwd(dir)
spList <- list.dirs(dir)[-1]
for(sp in spList){
  unlist(strsplit())
}
