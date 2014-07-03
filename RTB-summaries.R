##############################################
# RTB summaries
# N. Castaneda - 2014
##############################################

#--------------------------------------------
# Crops to be included
# - Musa (this includes banana and plantain)
# - Potato
# - Cassava
# - Sweetpotato
# - Yam (Dioscorea alata - water yam; D. cayennensis - lagos yam; D. rotundata - whiteguinea yam)
# - Cocoyam (Xanthosoma saggitifolium)
#--------------------------------------------


#--------------------------------------------
# Initial settings
#--------------------------------------------
require(raster)
src.dir <- "/curie_data2/ncastaneda/code/gap-analysis-cwr/gap-analysis/gap-code"
source(paste(src.dir,"/000.zipRead.R",sep=""))
source(paste(src.dir,"/000.zipWrite.R",sep=""))

date <- "2014-06-22"#"2014-03-06"#"2013-10-29"#"2013-10-22" #"2013-08-26"
idir <- "/curie_data2/ncastaneda/gap-analysis"
odir <- paste(idir, "/_summaries/RTB", sep=""); if(!file.exists(odir)){dir.create(odir)}

# oadir <- paste(odir, "/1_all", sep=""); if(!file.exists(oadir)){dir.create(oadir)}
# opdir <- paste(odir, "/2_priority", sep=""); if(!file.exists(opdir)){dir.create(opdir)}
# ondir <- paste(odir, "/3_non-priority", sep=""); if(!file.exists(ondir)){dir.create(ondir)}

template <- raster("/curie_data2/ncastaneda/geodata/bio_2_5m/bio_1.asc")

# ::::: Crops list ::::::

cropPriorList= c("musa", "potato", "cassava", "ipomoea", "yam_lagos","yam_water","yam_whiteguinea", "cocoyam")


#--------------------------------------------
# Species richness
#--------------------------------------------

sppRich <- function (cropList, idir, template, outdir) {
  
  data_crops=list()
  
  # Remove crops without species-richness.asc.gz file
  for(crop in cropList){
    path=paste(idir,"/gap_",crop,"/species_richness",sep="")
    fname="species-richness.asc.gz"
    if(!file.exists(paste(path,"/",fname, sep=""))){
      cropList = cropList[-which(cropList==crop)]
    }
  }
  
  # Listing files
  crop = cropList
  for(i in 1:length(crop)){
    path=paste(idir,"/gap_",crop,"/species_richness",sep="")
    fname="species-richness.asc.gz"
    data_crops[[i]]=zipRead(path[i],fname)
  }
  
  for(i in 1:length(data_crops)){
    data_crops[[i]]=extend(data_crops[[i]],template)}
  
  data=stack(data_crops)
  data_sum=sum(data,na.rm=T)
  
  zipWrite(data_sum, outdir, paste("spp-taxa-rich",date,".asc.gz",sep=""))
}

# Priority crops
cropList <- cropPriorList
outdir <- opdir
sppRich(cropList, idir, template, outdir)

#--------------------------------------------
# Gap richness (per taxon)
#--------------------------------------------

gapTaxaRich <- function (cropList, idir, template, outdir) {
  
  data_crops=list()
  
  # Remove crops without gap-richness.asc.gz file
  for(crop in cropList){
    path=paste(idir,"/gap_",crop,"/gap_richness/HPS",sep="")
    fname="gap-richness.asc.gz"
    if(!file.exists(paste(path,"/",fname, sep=""))){
      cropList = cropList[-which(cropList==crop)]
    }
  }
  
  # Listing files
  crop = cropList
  for(i in 1:length(crop)){
    path=paste(idir,"/gap_",crop,"/gap_richness/HPS",sep="")
    fname="gap-richness.asc.gz"
    data_crops[[i]]=zipRead(path[i],fname)
  }
  
  for(i in 1:length(data_crops)){
    data_crops[[i]]=extend(data_crops[[i]],template)}
  
  data=stack(data_crops)
  data_sum=sum(data,na.rm=T)
  
  zipWrite(data_sum, outdir, paste("gap-taxa-rich",date,".asc.gz",sep=""))
}

# Priority crops
cropList <- cropPriorList
outdir <- opdir
gapTaxaRich(cropList, idir, template, outdir)

# Non-priority crops
cropList <- cropNonPriorList
outdir <- ondir
gapTaxaRich(cropList, idir, template, outdir)

# All crops
if(file.exists(paste(opdir,"/gap-taxa-rich", date, ".asc.gz", sep="")) & file.exists(paste(ondir,"/gap-taxa-rich", date, "_all.asc.gz", sep=""))){
  nPrior <- zipRead(ondir, paste("gap-taxa-rich", date, "_all.asc.gz", sep=""))
  Prior <- zipRead(opdir, paste("gap-taxa-rich", date, ".asc.gz", sep=""))
  data_sum <- sum(nPrior,Prior,na.rm=T)
  zipWrite(data_sum, oadir, paste("gap-taxa-rich",date,".asc.gz",sep=""))
}

#--------------------------------------------
# Gap richness (per genepool)
#--------------------------------------------

gapCropRich <- function (cropList, idir, template, outdir) {
  
  data_crops=list()
  
  # Remove crops without gap-richness.asc.gz file
  for(crop in cropList){
    path=paste(idir,"/gap_",crop,"/gap_richness/HPS",sep="")
    fname="gap-richness.asc.gz"
    if(!file.exists(paste(path,"/",fname, sep=""))){
      cropList = cropList[-which(cropList==crop)]
    }
  }
  
  # Listing files
  crop = cropList
  for(i in 1:length(crop)){
    path=paste(idir,"/gap_",crop,"/gap_richness/HPS",sep="")
    fname="gap-richness.asc.gz"
    data_crops[[i]]=zipRead(path[i],fname)
  }
  
  for(i in 1:length(data_crops)){
    data_crops[[i]]=extend(data_crops[[i]],template)
    data_crops2 <- lapply(data_crops,function(x){x[which(x[]!=0)] <- 1; return(x)})
  }
  
  data=stack(data_crops2)
  data_sum=sum(data,na.rm=T)
  
  zipWrite(data_sum, outdir, paste("gap-gp-rich",date,".asc.gz",sep=""))
}

# Priority crops
cropList <- cropPriorList
outdir <- opdir
gapCropRich(cropList, idir, template, outdir)

# Non-priority crops
cropNonPriorList <- c("groundnut","beet","capsicum","watermelon","cucumber","strawberry","soybean","cotton","lettuce","cassava")
cropNonPriorList <- c("sugar_cane","tomato","cacao","grape","maize","garlic","leek","onion","pineapple","cabbage")
cropNonPriorList <- c("mustard","mustard_black","rape","turnip","papaya","safflower","grapefruit","lemon","orange","melon")
cropNonPriorList <- c("squash_maxima","squash_pepo","mango","almond","apricot","cherry","peach","plum","pear","spinach")
cropNonPriorList <- c("adzuki_bean","mung_bean","urd_bean","breadfruit","asparagus","quinoa","yam_lagos","yam_water","yam_whiteguinea",
                      "millet_panicum","millet_setaria","cocoyam")

cropList <- cropNonPriorList
outdir <- ondir
gapCropRich(cropList, idir, template, outdir)

rs1 <- zipRead(ondir, paste("gap-gp-rich",date,"a.asc.gz",sep=""))
rs2 <- zipRead(ondir, paste("gap-gp-rich",date,"b.asc.gz",sep=""))
rs3 <- zipRead(ondir, paste("gap-gp-rich",date,"c.asc.gz",sep=""))
rs4 <- zipRead(ondir, paste("gap-gp-rich",date,"d.asc.gz",sep=""))
rs5 <- zipRead(ondir, paste("gap-gp-rich",date,"e.asc.gz",sep=""))

data_sum <- sum(rs1,rs2,rs3,rs4,rs5,na.rm=T)
zipWrite(data_sum, ondir, paste("gap-gp-rich",date,"all.asc.gz",sep=""))

# All crops
if(file.exists(paste(opdir,"gap-gp-rich", date, "asc.gz", sep="")) & file.exists(paste(ondir,"gap-gp-rich", date, "asc.gz", sep=""))){
  #   nPrior <- zipRead(ondir, paste("gap-gp-rich", date, "asc.gz", sep=""))
  nPrior <- zipRead(ondir,"gap-gp-rich2013-10-28.asc.gz")
  #   Prior <- zipRead(opdir, paste("gap-gp-rich", date, "asc.gz", sep=""))
  Prior <- zipRead(opdir,"gap-gp-rich2013-08-26.asc.gz")
  data_sum <- sum(nPrior,Prior,na.rm=T)
  zipWrite(data_sum, oadir, paste("gap-gp-rich",date,".asc.gz",sep=""))
}

#--------------------------------------------
#--------------------------------------------
#--------------------------------------------
# Creating maps
#--------------------------------------------

library(raster); library(maptools); data(wrld_simpl)

title <- "Species richness"

fileDir <- paste(crop_dir,"/species_richness",sep="")
file <- zipRead(fileDir, "species-richness.asc.gz")


cols = colorRampPalette(c("gray87", "dark green","yellow","orange","red"))(255) # LOVE IT!!!
z <- extent(file)
aspect <- (z@ymax-z@ymin)*1.4/(z@xmax-z@xmin)

tiff("./figures/spp_richness.tif",
     res=300,pointsize=5,width=1500,height=1500*aspect,units="px",compression="lzw")
plot(file, col=cols, useRaster=T, 
     main="Species richness",
     horizontal=T,
     legend.width=1,
     legend.shrink=0.99)
plot(wrld_simpl,add=T,lwd=0.5, border="azure4")
grid()
dev.off()
