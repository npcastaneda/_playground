##############################################
# Global summaries - PREPARING NON-PRIORITIES
# N. Castaneda - 2013
##############################################

#--------------------------------------------
# Initial settings
#--------------------------------------------
require(raster)
src.dir <- "/curie_data2/ncastaneda/code/gap-analysis-cwr/gap-analysis/gap-code"
source(paste(src.dir,"/000.zipRead.R",sep=""))
source(paste(src.dir,"/000.zipWrite.R",sep=""))

date <- "2014-03-06"#"2013-10-29"#"2013-10-22" #"2013-08-26"
idir <- "/curie_data2/ncastaneda/gap-analysis"
odir <- paste(idir, "/_summaries", sep=""); if(!file.exists(odir)){dir.create(odir)}

ondir <- paste(odir, "/3_non-priority", sep=""); if(!file.exists(ondir)){dir.create(ondir)}

template <- raster("/curie_data2/ncastaneda/geodata/bio_2_5m/bio_1.asc")

# ::::: Non-priority crops ::::::
cropNonPriorList <- c("groundnut","beet","capsicum","watermelon","cucumber","strawberry","soybean","cotton","lettuce","cassava")
cropNonPriorList <- c("sugar_cane","tomato","cacao","grape","maize","garlic","leek","onion","pineapple","cabbage")
cropNonPriorList <- c("mustard","mustard_black","rape","turnip","papaya","safflower","grapefruit","lemon","orange","melon")
cropNonPriorList <- c("squash_maxima","squash_pepo","mango","almond","apricot","cherry","peach","plum","pear","spinach")
cropNonPriorList <- c("adzuki_bean","mung_bean","urd_bean","breadfruit","asparagus","quinoa","yam_lagos","yam_water","yam_whiteguinea",
                      "millet_panicum","millet_setaria","cocoyam")

#--------------------------------------------
# Species richness
#--------------------------------------------

sppRich <- function (cropList, idir, template, outdir) {
  
  data_crops=list()
  
  # Remove crops without gap-richness.asc.gz file
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

# Non-priority crops
cropList <- cropNonPriorList
outdir <- ondir
sppRich(cropList, idir, template, outdir)

rs1 <- zipRead(ondir, paste("spp-taxa-rich_a",date,".asc.gz",sep=""))
rs2 <- zipRead(ondir, paste("spp-taxa-rich_b",date,".asc.gz",sep=""))
rs3 <- zipRead(ondir, paste("spp-taxa-rich_c",date,".asc.gz",sep=""))
rs4 <- zipRead(ondir, paste("spp-taxa-rich_d",date,".asc.gz",sep=""))
rs5 <- zipRead(ondir, paste("spp-taxa-rich_e",date,".asc.gz",sep=""))

data_sum <- sum(rs1,rs2,rs3,rs4,rs5,na.rm=T)
zipWrite(data_sum, ondir, paste("spp-taxa-rich",date,"all.asc.gz",sep=""))

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

# Non-priority crops
cropList <- cropNonPriorList
outdir <- ondir
gapTaxaRich(cropList, idir, template, outdir)


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
