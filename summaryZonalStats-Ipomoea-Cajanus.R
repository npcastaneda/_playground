# Purpose: Prepare zonal stats files
# Author: N. Castaneda (2014)
#########################################################

# Preparing data for zonal stats

# cajanus
dir <- "D:/CWR-collaborations/cajanus/_ZonalAnalysis/gap_spp"

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

#########################################################
# RUN ZONAL STATS IN ARCGIS 
#########################################################
# Code for merging all zonal stats files

dir = "D:/CWR-collaborations/cajanus/_ZonalAnalysis/gap_spp"
setwd(dir)

filenames <- list.files(path=dir,recursive=T,pattern =".csv", full.names=T)	
summary <- do.call(rbind,lapply(filenames,read.csv,header=F))
names(summary) <- c("ISOCODE", "CROP", "TAXON")
attach(summary)
summary = summary[order(CROP),]
summary = subset(summary, ISOCODE != "ISOCODE") # cleans up repeated headers
summary$SOURCE <- "gap-analysis"

# zonaltaxa <- as.data.frame(unique(summary$TAXON))
# names(zonaltaxa) <- "TAXON"

# Open priorities table (all taxa)
# prior <- read.csv("D:/CWR/ResultsGapAnalysis2013/_summary/_analysis/alltaxapriorities_2013_08_26.csv")
prior <- read.csv("D:/CWR/ResultsGapAnalysis2013/_allCrops/alltaxapriorities_2013_10_22.csv")
HPSprior <- prior[prior$FPCAT=="HPS",]
nomapHPS <- HPSprior[which(HPSprior$MAP_AVAILABLE==0),]

# nomapHPS <- nomapHPS[,2:3]
nomapHPS <- nomapHPS[,1:2]
names(nomapHPS) <- c("TAXON","CROP")
# nomapHPS <- as.data.frame(nomapHPS$TAXON)

# Open native-areas file
# nareas <- read.csv("D:/CWR/ResultsGapAnalysis2013/_zonalStats/native-areas-for-zonalStats.csv") # For priority crops
# nareas <- nareas[,c(1,3,2)] # For priority crops
nareas <- read.csv("D:/CWR/ResultsGapAnalysis2013/_zonalStats/native-areas-for-zonalStats-nonprior2.csv") # For non-priority crops
nareas <- nareas[,c(1,3)] # For non-priority crops
nareas <- unique(nareas)
nareas$SOURCE <- NA
# names(nareas) <- c("ISOCODE", "CROP", "TAXON") # For priority crops
names(nareas) <- c("ISOCODE","TAXON", "SOURCE") # For priority crops
nareas$SOURCE <- "grinNA-database"

# Combining zonal stats results and native areas data
nomapHPSna <- merge(nareas, nomapHPS, by="TAXON", all.y=T)
nomapHPSna <- nomapHPSna[,c("ISOCODE", "crop_code", "TAXON", "SOURCE")]
names(nomapHPSna)[2] <- "CROP"

summary2 <- rbind(summary,nomapHPSna)
write.csv(summary2,"D:/CWR/ResultsGapAnalysis2013/_zonalStats/2013-10-24_all_gap_rich_Spss-nonPrior/_zonalstatsallcrops.csv", row.names=F)


# Adding country level data (area and countries names)
require(foreign)
cntrs <- read.dbf("D:/CWR/ResultsGapAnalysis2013/_zonalStats/2013-08-20_all_gap_rich_Spss/gadm2_cntry.dbf")
# summary <- read.csv("D:/CWR/ResultsGapAnalysis2013/_zonalStats/2013-08-20_all_gap_rich_Spss/_zonalstatsallcrops.csv") #priority crops
summary <- read.csv("D:/CWR/ResultsGapAnalysis2013/_zonalStats/2013-10-24_all_gap_rich_Spss-nonPrior/_zonalstatsallcrops.csv") #Non-priority crops
names(summary) <- c("ISO", "CROP", "TAXON", "SOURCE")

# summary2 <- merge(cntrs, summary, by.x="ISO", by.y="ISOCODE", all.y=T)
summary2 <- merge(cntrs, summary, by.y="ISO", all.y=T)

# write.csv(summary,"_zonalstatsallcrops.csv", row.names=F, col.names=F) # priority-crops
write.csv(summary2,"D:/CWR/ResultsGapAnalysis2013/_zonalStats/2013-10-24_all_gap_rich_Spss-nonPrior/_zonalstatsallcrops.csv", row.names=F) #non-priority crops

#########################################################
# Code for merging All priorities + gp concepts
# By: Nora Castaneda - Aug 2013

alllists <- read.csv("D:/CWR/ResultsGapAnalysis2013/_summary/prioritiesLists/_AllLists.csv")
gpconcepts <- read.csv("D:/PhD/writing/GapResults/GP-relations.csv")

test <- merge(x = alllists, y = gpconcepts, by.x="Taxon_final", by.y="Scientific_Name")
names(test)
test <- test[,c("ID","Taxon_final_short","Taxon_final",
                "Crop_code","Coded.name","relative_of","JUL2013_FPS",
                "JUL2013_FPCAT","Concept_Type","Concept_Level",
                "ConceptKey","to.remove","comments")]
write.csv(test, "D:/PhD/writing/GapResults/finaldata.csv", row.names=F)
