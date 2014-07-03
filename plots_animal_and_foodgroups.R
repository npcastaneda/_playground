#Julian Ramirez-Villegas and Colin Khoury
#How many crops feed the world?
#March 2012
stop("DO NOT RUN!")
#make a nice figure using these data
#relative change on plant to animal rate

rm(list=ls()); g=gc(); rm(g)
wd <- "D:/_hmcfw/Analysis/data/FBS_1961-2009" #"D:/SkyDrive/How-many-crops/CK_2013_4_15"
setwd(wd)

iDataDir <- paste(wd,"/all_1961_2009_final_analysis_data",sep="")     # paste(wd,"/input_data",sep="")

figDir <- paste(iDataDir,"/figures_jrv",sep="")
if (!file.exists(figDir)) {dir.create(figDir)}


#read in the dataset
all_data <- read.csv(paste(iDataDir,"/all_1961_2009_final_analysis_data_v2.csv",sep=""))

#read in categories
cat_data <- read.csv(paste(iDataDir,"/FBS_commodities_2013_11_30.dat",sep=""),header=T,sep="\t")
names(cat_data)[1] <- "Item"

#merge both
wk_data <- merge(all_data,cat_data,by="Item",sort=F)
wk_data <- wk_data[which(wk_data$food_group != "DO NOT INCLUDE"),]

#subselect only the two totals
#wk_data <- all_data[which(all_data$Item == "Animal Products (Total)" | all_data$Item == "Vegetal Products (Total)" | all_data$Item == "Grand Total"),]

#subselect one commodity for testing
umeas <- unique(wk_data$Element)
ufgrp <- unique(wk_data$food_group)
ucoun <- unique(wk_data$Country)

#first: compress commodities into food groups for every country and every measurement
out_all <- data.frame()
for (meas in umeas) {
  #meas <- umeas[1]
  cat("Measurement:",paste(meas),"\n")
  mdata <- wk_data[which(wk_data$Element == meas),]
  for (fg in ufgrp) {
    #fg <- ufgrp[1]
    cat("Food group:",paste(fg),"\n")
    fdata <- mdata[which(mdata$food_group == fg),]
    for (coun in ucoun) {
      #coun <- ucoun[1]
      #cat("Country:",paste(coun),"\n")
      cdata <- fdata[which(fdata$Country == coun),]
      calData <- cdata[,fields]
      ttl <- colSums(calData,na.rm=T)
      out_row <- data.frame(Food_group=paste(fg),Country=paste(coun),Element=paste(meas),Unit=paste(cdata$Unit[1]))
      out_row <- cbind(out_row,t(ttl))
      out_all <- rbind(out_all,out_row)
    }
  }
}


#second: create mean across all countries for each of the food groups and measurements
out_final <- data.frame()
for (meas in umeas) {
  #meas <- umeas[1]
  cat("Measurement:",paste(meas),"\n")
  mdata <- out_all[which(out_all$Element == meas),]
  for (fg in ufgrp) {
    #fg <- ufgrp[1]
    fdata <- mdata[which(mdata$Food_group == paste(fg)),]
    calData <- fdata[,fields]
    ttl <- colMeans(calData,na.rm=T)
    out_row <- data.frame(Food_group=paste(fg),Element=paste(meas),Unit=paste(fdata$Unit[1]))
    out_row <- cbind(out_row,t(ttl))
    out_final <- rbind(out_final,out_row)
  }
}

write.csv(out_final,paste(iDataDir,"/data_for_stacked_lineplot.csv",sep=""),quote=T,row.names=F)


#####################
out_final <- read.csv(paste(iDataDir,"/data_for_stacked_lineplot.csv",sep=""))


################################################################
################################################################
###### Fat (g/capita/day)
################################################################
################################################################
library(ggplot2); library(plyr); library(reshape2); library(RColorBrewer); library(grid)

meas <- paste(umeas[3])
mdata <- out_final[which(out_final$Element == meas),]

mdata$Element <- NULL; mdata$Unit <- NULL
#names(mdata)[1] <- "Food group"
ddf <- melt(mdata)
ddf$variable <- as.numeric(gsub("Y","",ddf$variable))
ddf$Food_group <- factor(ddf$Food_group, levels = rev(c('Animal products', 'Cereals', 'Oilcrops',  'Starchy roots', 'Sugarcrops',
                                          'Pulses', 'Vegetables', 'Fruits', 'Spices', 'Stimulants', 'Alcoholic beverages')), ordered=T)
ddf <- ddply(ddf, .(Food_group), transform, Food_group_or = order(Food_group))

p <- ggplot(ddf, aes(variable, value, order = -as.numeric(Food_group)))
p <- p + geom_area(aes(colour = Food_group, fill= Food_group), position = 'stack')
p <- p + scale_colour_discrete(h=c(0,360)+15,c=100,l=65,h.start=0,direction=-1)
p <- p + scale_fill_discrete(h=c(0,360)+15,c=100,l=65,h.start=0,direction=-1)
p <- p + theme(legend.key.height=unit(1.2,"cm"),legend.key.width=unit(1.1,"cm"), panel.background=element_rect(fill="white",colour="black"),
               axis.text=element_text(size=35,colour="black"),legend.title=element_text(size=30),legend.text=element_text(size=30),
               axis.title=element_text(size=35,face="bold"),axis.ticks=element_line(colour="black"))
p <- p + labs(x="Year",y="Fat supply quantity (g/capita/day)",fill="Food group", colour="Food group")


pdf(paste(figDir,"/1_fat_stacked.pdf",sep=""),width=21.5,height=15,pointsize=15)
print(p)
dev.off()



################################################################
################################################################
###### Protein (g/capita/day)
################################################################
################################################################
meas <- paste(umeas[1])
mdata <- out_final[which(out_final$Element == meas),]

mdata$Element <- NULL; mdata$Unit <- NULL
#names(mdata)[1] <- "Food group"
ddf <- melt(mdata)
ddf$variable <- as.numeric(gsub("Y","",ddf$variable))
ddf$Food_group <- factor(ddf$Food_group, levels = rev(c('Animal products', 'Cereals', 'Oilcrops',  'Starchy roots', 'Sugarcrops',
                                                    'Pulses', 'Vegetables', 'Fruits', 'Spices', 'Stimulants', 'Alcoholic beverages')), ordered=F)
ddf <- ddply(ddf, .(Food_group), transform, Food_group_or = order(Food_group))

p <- ggplot(ddf, aes(variable, value, order=-as.numeric(Food_group)))
p <- p + geom_area(aes(colour = Food_group, fill= Food_group), position = 'stack')
p <- p + scale_colour_discrete(h=c(0,360)+15,c=100,l=65,h.start=0,direction=-1)
p <- p + scale_fill_discrete(h=c(0,360)+15,c=100,l=65,h.start=0,direction=-1)
p <- p + theme(legend.key.height=unit(1.2,"cm"),legend.key.width=unit(1.1,"cm"), panel.background=element_rect(fill="white",colour="black"),
               axis.text=element_text(size=35,colour="black"),legend.title=element_text(size=30),legend.text=element_text(size=30),
               axis.title=element_text(size=35,face="bold"),axis.ticks=element_line(colour="black"))
p <- p + labs(x="Year",y="Protein supply quantity (g/capita/day)",fill="Food group", colour="Food group")


pdf(paste(figDir,"/1_protein_stacked.pdf",sep=""),width=21.5,height=15,pointsize=15)
print(p)
dev.off()



################################################################
################################################################
###### Calories (kcal/capita/day)
################################################################
################################################################
meas <- paste(umeas[2])
mdata <- out_final[which(out_final$Element == meas),]

mdata$Element <- NULL; mdata$Unit <- NULL
#names(mdata)[1] <- "Food group"
ddf <- melt(mdata)
ddf$variable <- as.numeric(gsub("Y","",ddf$variable))
ddf$Food_group <- factor(ddf$Food_group, levels = rev(c('Animal products', 'Cereals', 'Oilcrops', 'Starchy roots', 'Sugarcrops',
                                                    'Pulses', 'Vegetables', 'Fruits', 'Spices', 'Stimulants', 'Alcoholic beverages')), ordered=F)
ddf <- ddply(ddf, .(Food_group), transform, Food_group_or = order(Food_group))

p <- ggplot(ddf, aes(variable, value, order=-as.numeric(Food_group)))
p <- p + geom_area(aes(colour = Food_group, fill= Food_group), position = 'stack')
p <- p + scale_colour_discrete(h=c(0,360)+15,c=100,l=65,h.start=0,direction=-1)
p <- p + scale_fill_discrete(h=c(0,360)+15,c=100,l=65,h.start=0,direction=-1)
p <- p + theme(legend.key.height=unit(1.2,"cm"),legend.key.width=unit(1.1,"cm"), panel.background=element_rect(fill="white",colour="black"),
               axis.text=element_text(size=35,colour="black"),legend.title=element_text(size=30),legend.text=element_text(size=30),
               axis.title=element_text(size=35,face="bold"),axis.ticks=element_line(colour="black"))
p <- p + labs(x="Year",y="Calories (kcal/capita/day)",fill="Food group", colour="Food group")
p <- p + scale_y_continuous(breaks=c(seq(0,4000,by=500)),limits=c(0,3000))


pdf(paste(figDir,"/1_calories_stacked.pdf",sep=""),width=21.5,height=15,pointsize=15)
print(p)
dev.off()




################################################################
################################################################
###### Weight (g/capita/day)
################################################################
################################################################
meas <- paste(umeas[4])
mdata <- out_final[which(out_final$Element == meas),]

mdata$Element <- NULL; mdata$Unit <- NULL
#names(mdata)[1] <- "Food group"
ddf <- melt(mdata)
ddf$variable <- as.numeric(gsub("Y","",ddf$variable))
ddf$Food_group <- factor(ddf$Food_group, levels = rev(c('Animal products', 'Cereals', 'Oilcrops', 'Starchy roots', 'Sugarcrops',
                                                    'Pulses', 'Vegetables', 'Fruits', 'Spices', 'Stimulants', 'Alcoholic beverages')), ordered=F)
ddf <- ddply(ddf, .(Food_group), transform, Food_group_or = order(Food_group))

p <- ggplot(ddf, aes(variable, value, order=-as.numeric(Food_group)))
p <- p + geom_area(aes(colour = Food_group, fill= Food_group), position = 'stack')
p <- p + scale_colour_discrete(h=c(0,360)+15,c=100,l=65,h.start=0,direction=-1)
p <- p + scale_fill_discrete(h=c(0,360)+15,c=100,l=65,h.start=0,direction=-1)
p <- p + theme(legend.key.height=unit(1.2,"cm"),legend.key.width=unit(1.1,"cm"), panel.background=element_rect(fill="white",colour="black"),
               axis.text=element_text(size=35,colour="black"),legend.title=element_text(size=30),legend.text=element_text(size=30),
               axis.title=element_text(size=35,face="bold"),axis.ticks=element_line(colour="black"))
p <- p + labs(x="Year",y="Weight (g/capita/day)",fill="Food group", colour="Food group")
p <- p + scale_y_continuous(breaks=c(seq(0,4000,by=500)),limits=c(0,2000))


pdf(paste(figDir,"/1_weight_stacked.pdf",sep=""),width=21.5,height=15,pointsize=15)
print(p)
dev.off()



