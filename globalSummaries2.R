##############################################
# Global summaries
# N. Castaneda - 2014
##############################################

#--------------------------------------------
# Initial settings
#--------------------------------------------
require(raster)
# src.dir <- "/curie_data/ncastaneda/code/gap-analysis-cwr/gap-analysis/gap-code"
src.dir <- "D:/_code/R/gap-analysis-maxent"
source(paste(src.dir,"/000.zipRead.R",sep=""))
source(paste(src.dir,"/000.zipWrite.R",sep=""))

date <- "2014-09-30"#"2014-03-06"#"2013-10-29"#"2013-10-22" #"2013-08-26"
# idir <- "/curie_data/ncastaneda/gap-analysis"
idir <- "D:/CWR/ResultsGapAnalysis2014/_zonalstats/2014-08-27"

odir <- paste(idir, "/_summaries", sep=""); if(!file.exists(odir)){dir.create(odir)}

oadir <- paste(odir, "/0_final", sep=""); if(!file.exists(oadir)){dir.create(oadir)}

template <- raster("/curie_data/ncastaneda/geodata/bio_2_5m/bio_1.asc")

#============================================
#============================================
# Processing crops without duplicates
#============================================
#============================================

# List of crops without duplicates

A <- c("asparagus",
"avena",
"bambara",
"bean",
"beet",
"breadfruit",
"cacao",
"cajanusPaper",
"capsicum",
"cassava",
"cicer",
"cocoyam",
"cowpea",
"daucus",
"eggplantNHM",
"eleusine",
"faba_bean")

B <- c("grape",
"groundnut",
"helianthusUS", # Be careful with this - data is ready in cure
"hordeum",
"ipomoea", # Be careful with this - data is ready in curie
"lathyrus",
"lens",
"lettuce",
"lima_bean",
"maize",
"malus",
"mango",
"millet_panicum",
"millet_setaria",
"musa",
"onion",
"papaya")

C <- c("pear",
"pennisetum",
"pineapple",
"pisum",
"potatoCIP", # be careful - data is ready in curie
"quinoa",
"rice",
"safflower",
"secale",
"sorghum",
"soybean",
"spinach",
"strawberry",
"sugar_cane",
"tomato",
"vetch",
"watermelon")

#--------------------------------------------
# Species richness
#--------------------------------------------
cat("Producing species richness map")

sppRich <- function (cropList, list, idir, template, outdir) {
  
  data_crops=list()
  
  # Remove crops without spp-richness.asc.gz file
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
  
  zipWrite(data_sum, outdir, paste("spp-taxa-rich-",list,date,".asc.gz",sep=""))
}


cropList <- A
list <- "A"
outdir <- oadir
sppRich(cropList, list, idir, template, outdir)

rs1 <- zipRead(oadir, paste("spp-taxa-rich-A",date,".asc.gz",sep=""))
rs2 <- zipRead(oadir, paste("spp-taxa-rich-B",date,".asc.gz",sep=""))
rs3 <- zipRead(oadir, paste("spp-taxa-rich-C",date,".asc.gz",sep=""))

data_sum <- sum(rs1,rs2,rs3,na.rm=T)
zipWrite(data_sum, oadir, paste("spp-taxa-rich",date,"nondups.asc.gz",sep=""))

#--------------------------------------------
# Gap richness (per taxon)
#--------------------------------------------

gapTaxaRich <- function (cropList, list, idir, template, outdir) {
  
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
  
  zipWrite(data_sum, outdir, paste("gap-taxa-rich-",list,date,".asc.gz",sep=""))
}

# Making the function work
cropList <- A
list <- "A"
outdir <- oadir
gapTaxaRich(cropList, list,idir, template, outdir)

rs1 <- zipRead(oadir, paste("gap-taxa-rich-A",date,".asc.gz",sep=""))
rs2 <- zipRead(oadir, paste("gap-taxa-rich-B",date,".asc.gz",sep=""))
rs3 <- zipRead(oadir, paste("gap-taxa-rich-C",date,".asc.gz",sep=""))

data_sum <- sum(rs1,rs2,rs3,na.rm=T)
zipWrite(data_sum, oadir, paste("gap-taxa-rich",date,"nondups.asc.gz",sep=""))

#--------------------------------------------
# Gap richness (per genepool)
#--------------------------------------------

gapCropRich <- function (cropList, list, idir, template, outdir) {
  
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
  
  zipWrite(data_sum, outdir, paste("gap-gp-rich-",list,date,".asc.gz",sep=""))
}

# Making the function work
cropList <- A
list <- "A"
outdir <- oadir
gapCropRich(cropList, list,idir, template, outdir)

rs1 <- zipRead(oadir, paste("gap-gp-rich-A",date,".asc.gz",sep=""))
rs2 <- zipRead(oadir, paste("gap-gp-rich-B",date,".asc.gz",sep=""))
rs3 <- zipRead(oadir, paste("gap-gp-rich-C",date,".asc.gz",sep=""))

data_sum <- sum(rs1,rs2,rs3,na.rm=T)
zipWrite(data_sum, oadir, paste("gap-gp-rich",date,"nondups.asc.gz",sep=""))

#============================================
#============================================
# Processing crops with duplicated taxa
#============================================
#============================================

D <- c("adzuki_bean",
       "almond",
       "cabbage",
       "cotton",
       "cucumber",
       "garlic",
       "leek",
       "melon",
       "mung_bean",
       "mustard",
       "mustard_black",
       "squash_maxima",
       "squash_pepo",
       "turnip",
       "urd_bean",
       "yam_lagos",
       "yam_water",
       "yam_whiteguinea"
)

E <- c("apricot", #These crops need to be revised before being processed!
       "cherry",
       "grapefruit",
       "lemon",
       "medicago",
       "orange",
       "peach",
       "plum",
       "rape",
       "triticum"
       )

prioritiesTable <- function (idir, list, outdir) {
  sppC <- 1
  for (crop in list) {
    
    cat("Reading data for", crop, "\n")
    cropDir <- paste(idir, "/", crop,sep="")
    priFile <- paste(cropDir,"/priorities.csv",sep="")
    priorit <- read.csv(priFile)
    priorit["crop_code"] <- crop
    
    if(sppC ==1){
      allPri <- priorit
    }else{
      allPri <- rbind(allPri, priorit)
    }
    sppC <- sppC + 1
  }
  
  outFile <- paste(outdir, "/priorities-dups",date,".csv",sep="")
  write.csv(allPri, outFile, quote=F, row.names=F)
  
}

# Priority crops
list <- c(D,E)
idir <-"D:/CWR/ResultsGapAnalysis2014/_zonalstats/2014-08-27"
outdir <- "D:/CWR/ResultsGapAnalysis2014/_zonalstats/2014-08-27/_priorities" ; if(!file.exists(outdir)){dir.create(outdir)}
prioritiesTable(idir,list, outdir)
