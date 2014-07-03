# Purpose: Map gap_richness.asc.gz files
# Author: N. Castaneda (2013)
##############################################################################

library(raster); library(maptools); data(wrld_simpl)

#Julian Ramirez
#Opens a connection over a zip or gzfile and reads the data

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

##############################################
##############################################
path <- "D:/CWR/ResultsGapAnalysis2013/_summary"
setdir(path)

cropList <- c("avena","bambara","bean","cajanus","cowpea","daucus","eggplant",
              "eleusine","helianthus","ipomoea","malus","medicago","musa",
              "pennisetum","rice","secale","sorghum","vetch")

for(crop in cropList){
  indir <- paste(path,"/",crop,sep="")
  h_ras <- zipRead(indir,"gap-richness.asc.gz")
  
  h_ras[which(h_ras[]==0)] <- NA
  
  z <- extent(h_ras)
  aspect <- (z@ymax-z@ymin)*1.4/(z@xmax-z@xmin)
  #gap richness map
  tiff(paste("D:/CWR/ResultsGapAnalysis2013/_figures/",crop,".tif",sep=""),
       res=300,pointsize=5,width=1500,height=1500*aspect,units="px",compression="lzw")
  par(mar=c(2.5,2.5,1,1),cex=0.8,lwd=0.8)
  plot(h_ras,useRaster=F,
       horizontal=T,
       legend.width=1,
       legend.shrink=0.99)
  plot(wrld_simpl,add=T,lwd=0.5, border="azure4")
  grid()
  dev.off()
  
}




