# Decompressing files for zonal stats in ArcGIS
# Castaneda Jul 2013

dir <- "D:/CWR/ResultsGapAnalysis2014/_zonalstats"
# dir = "D:/CWR/ResultsGapAnalysis2013/_zonalStats/2013-08-20_all_gap_rich_Spss"
# dir <- "D:/CWR/ResultsGapAnalysis2013/_non_priorities/_all_gap_rich20131024"
src.dir <- "D:/_code/R/gap-analysis-maxent"

source(paste(src.dir,"/000.zipRead.R", sep= ""))
  
crops = list.dirs(dir, recursive=T)
crops = crops[-1]

for(cropdir in crops){
  spps = list.files(cropdir, pattern=".gz")
  cropname = unlist(strsplit(cropdir, "/"))[[5]]
  if(length(spps)==0){
    cat("No compressed files available for",cropname, "\n")
  }else{
    for(spp in spps){
      cat("Decompressing files for",cropname, "\n")
      rs = zipRead(cropdir, spp)
      spname  = strsplit(spp, ".asc.gz")[[1]]
      writeRaster(rs, paste(cropdir, "/", spname,".asc", sep=""), overwrite=T) 
      unlink(paste(cropdir,"/",spp,sep=""))
    }
  }  
}
