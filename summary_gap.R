# Purpose: Add all gap richness files
# Author: D. Arango (2013)
########################################################

require(raster)

zipRead <- function(path, fname) {
  infile <- paste(path, "/", fname, sep="")
  
  #automatically detect the file type (zip or gzip)
  
  splt <- unlist(strsplit(fname, ".", fixed=T))
  ext <- splt[length(splt)]
  
  infname <- substring(fname, 1, nchar(fname)-nchar(ext)-1)
  
  if (tolower(ext) == "zip") {
    zz <- unz(infile, infname, "r")
  } else if (ext == "gz") {
    zz <- gzfile(infile, "r")
  } else {
    stop("Not supported file type")
  }
  
  #Reading the data from the ascii, and then closing the connection
  nc <- as.numeric(scan(zz, what="character", nlines=1, quiet=T)[2])
  nr <- as.numeric(scan(zz, what="character", nlines=1, quiet=T)[2])
  xll <- as.numeric(scan(zz, what="character", nlines=1, quiet=T)[2])
  yll <- as.numeric(scan(zz, what="character", nlines=1, quiet=T)[2])
  cz <- as.numeric(scan(zz, what="character", nlines=1, quiet=T)[2])
  nas <- as.numeric(scan(zz, what="character", nlines=1, quiet=T)[2])
  
  dta <- scan(zz, na.string=paste(nas), quiet=T)
  close(zz)
  
  #Drawing the extent 
  xur <- xll + cz*nc
  yur <- yll + cz*nr
  
  #Creating the raster and filling it with data
  rs <- raster(ncol=nc, nrow=nr, xmn=xll, xmx=xur, ymn=yll, ymx=yur)
  rs[] <- dta
  
  return(rs)
}


##

cropList= c("avena", "bambara", "bean", "cajanus", "cicer", "cowpea", "daucus", "eggplant", "eleusine", "faba_bean", "helianthus", "hordeum", 
            "ipomoea", "lathyrus", "lens", "lima_bean", "malus","medicago","musa","pennisetum", "pisum", "potato", "rice", "secale", "sorghum", 
            "triticum", "vetch")

data_crops=list()

# Remove crops without gap-richness.asx.gz file
for(crop in cropList){
  path=paste("/curie_data2/ncastaneda/gap-analysis","/gap_",crop,"/gap_richness/HPS",sep="")
  fname="gap-richness.asc.gz"
  if(!file.exists(paste(path,"/gap-richness.asc.gz", sep=""))){
    cropList = cropList[-which(cropList==crop)]
  }
}

# Listing files
crop = cropList
for(i in 1:length(crop)){
  path=paste("/curie_data2/ncastaneda/gap-analysis","/gap_",crop,"/gap_richness/HPS",sep="")
#   path = paste("D:/CWR/ResultsGapAnalysis2013/_summary/",crop,sep="")
  fname="gap-richness.asc.gz"
  data_crops[[i]]=zipRead(path[i],fname)
}


###

#paths=list.files("C:/Users/darango/Desktop",pattern=".tif",full.names=T)
#data=lapply(paths,FUN=raster)

# template=raster("D:/_geodata/clim/bio_2_5m/bio_1.asc")
template = raster("/curie_data2/ncastaneda/geodata/bio_2_5m/bio_1.asc")

for(i in 1:length(data_crops)){
data_crops[[i]]=extend(data_crops[[i]],template)}

data=stack(data_crops)
data_sum=sum(data,na.rm=T)

writeRaster(data_sum, "/curie_data2/ncastaneda/gap-analysis/_results/all_gap_rich.asc")
# writeRaster(data_sum,"D:/CWR/ResultsGapAnalysis2013/_summary/summary_w_potato.asc")
# rs <- raster("D:/CWR/ResultsGapAnalysis2013/_summary/summary_w_potato.asc")
# plot(rs)