##############################################
# Summarize priorities table
# N. Castaneda - 2013
##############################################



##############################################
# Adding up all priorities tables
##############################################

# Project priority crops
cropList= c("avena", "bambara", "bean", "cajanus", "cicer", "cowpea", "daucus", "eggplant", "eleusine", "faba_bean", "helianthus", "hordeum", 
            "ipomoea", "lathyrus", "lens", "lima_bean", "malus","medicago","musa","pennisetum", "pisum", "potato", "rice", "secale", "sorghum", 
            "triticum", "vetch")

idir = "/curie_data2/ncastaneda/gap-analysis"
odir <- paste(idir, "/_results", sep="")

sppC <- 1
for (crop in cropList) {
  
  cat("Reading data for", crop, "\n")
  cropDir <- paste(idir, "/gap_", crop,sep="")
  priFile <- paste(cropDir,"/priorities/priorities.csv",sep="")
  priorit <- read.csv(priFile)
  
  if(sppC ==1){
    allPri <- priorit
  }else{
    allPri <- rbind(allPri, priorit)
  }
  sppC <- sppC + 1
}
  
outFile <- paste(odir, "/allCropPriorities_2013_08_26.csv", sep="")
write.csv(allPri, outFile, quote=F, row.names=F)


##############################################
# Comparing all taxa vs. gap-analyzed taxa
##############################################
dir <- "/curie_data2/ncastaneda/gap-analysis/_summaries"

#----- Priority taxa
alltaxa = read.csv(paste(dir,"/2_priority/PtaxaofPcrops_all - names_codes_newest(450).csv",sep=""))
gistaxa = read.csv(paste(dir,"/2_priority/priorities2013-08-26.csv",sep=""))

#----- Non-priority taxa
alltaxa = read.csv(paste(dir,"/3_non-priority/CWR_non-priority_crops_processing - non_priority_taxa-2013-09-13.csv",sep=""))
gistaxa = read.csv(paste(dir,"/3_non-priority/priorities2013-10-22.csv",sep=""))

# alltaxa = alltaxa[,c("Taxa", "TOTAL_RP", "TOTAL", "HS", "HS_RP", "GS", "GS_RP", "SRS", "ATAUC", "STAUC", "ASD15", "IS_VALID", "GRS", "ERS", "FPS", "FPCAT")]
names(alltaxa)[1] = "TAXON"


# # Erasing var. from text
# tNames <- alltaxa$TAXON
# tNames <- as.vector(tNames)
# fout <- tNames[grep("var._",tNames,fixed=T)]
# alltaxa$TAXON <- as.vector(alltaxa$TAXON)
# for (f in fout) {
#   true_name <- strsplit(paste(f),"var._")[[1]]
#   true_name3 <- paste(true_name[1],true_name[2],sep="")
#   alltaxa$TAXON[which(alltaxa$TAXON==f)] <- array(true_name3,dim=length(which(alltaxa$TAXON==f)))  
# }
# 
# # Erasing subsp. from text
# tNames <- alltaxa$TAXON
# tNames <- as.vector(tNames)
# fout <- tNames[grep("subsp._",tNames,fixed=T)]
# alltaxa$TAXON <- as.vector(alltaxa$TAXON)
# for (f in fout) {
#   true_name <- strsplit(paste(f),"subsp._")[[1]]
#   true_name3 <- paste(true_name[1],true_name[2],sep="")
#   alltaxa$TAXON[which(alltaxa$TAXON==f)] <- array(true_name3,dim=length(which(alltaxa$TAXON==f)))  
# }

# write.csv(alltaxa, "D:/CWR/ResultsGapAnalysis2013/_summary/_analysis/alltaxa_2013_08_23.csv")

taxalist <- alltaxa[,c("Crop_code","TAXON")]

# taxalist <- data.frame(alltaxa$TAXON)
# names(taxalist)[1] <- "TAXON"
all = merge(taxalist,gistaxa, by="TAXON", all.x=T) # YEAHHHH

# write.csv(taxalist, "D:/CWR/ResultsGapAnalysis2013/_summary/_analysis/taxalist.csv")
# write.csv(a, "D:/CWR/ResultsGapAnalysis2013/_summary/_analysis/a.csv")

NASpList = all[is.na(all$FPS),] 
for(spp in NASpList$TAXON){
  cat("Processing", spp, "\n")
  fpcat <- "HPS"
  all$FPCAT[which(all$TAXON==paste(spp))] <- fpcat
  all$MAP_AVAILABLE[which(all$TAXON==paste(spp))] <- 0
}

write.csv(all, "D:/CWR/ResultsGapAnalysis2013/_summary/_analysis/alltaxapriorities_2013_08_26.csv")
