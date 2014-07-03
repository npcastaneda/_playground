# Split dataframe into several files
# Author: H. Achicanoy - 2013

#-------------------------------------------------------
nareas <- read.csv("D:/CWR/_inputs/_non-PriorityCrops/NativeAreasList-2013-09-13-processing.csv")
names(nareas)
head(nareas)

nareas <- nareas[,c(1,3,4,5)]

names(nareas) <- c("id","taxon", "crop_code", "countries")
nareas$countries <- gsub("TMP","TLS", nareas$countries)

nareas <- nareas[,c("id","countries", "crop_code")]
division <- split(nareas, nareas$crop_code)

dir <- "D:/CWR/_inputs/_non-PriorityCrops/_revision/2013-09-13/_revision-2013-09-13"

for(i in 1:length(division)){
  
  taxalist <- as.data.frame(division[i])
  taxalist <- taxalist[,c(1,2)]
  write.csv(taxalist,file=paste(dir,"/",names(division[i]),'.csv',sep=''), row.names=F)
  
}