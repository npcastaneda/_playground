#//////////////////////CLIMATE GAPS///////////////////Author Maarten van Zonneveld 

library(raster)
library(maptools)
library(graphics)

# DATA IMPORTATION

#wd on desktop
mywd <- "C:/Documents and Settings/mvanzonneveld.IS/My Documents/Dropbox/SAP - Spatial analyses/"
#wd on laptop
mywd <- "C:/Documents and Settings/user/My Documents/Dropbox/SAP - Spatial analyses/"

#read shapefile centralAm
setwd("//172.22.50.6/Public/Shared data/SAP Mesoamerica Baseline/SAP - Spatial analyses/input/countries")
centralAm<-readShapePoly(fn="Central America",proj4string=CRS("+proj=longlat +datum=WGS84"), force_ring=T)

#read climate rasters
setwd(paste(mywd,"input/envlayersMaxent 2.5min",sep=""))
efiles<-list.files(pattern="asc", full.names=T)
elayers<-stack(efiles)
projection(elayers)<-"+proj=longlat +datum=WGS84"
elayers<-crop(elayers, centralAm)

#re-ordening and re-scaling 19 bioclimate rasters
elayers <- stack(elayers[[1]]/10,elayers[[12:19]]/10,elayers[[2:3]]/10,elayers[[4:11]])

#read data points
setwd(paste(mywd,"input/clean dataset/", sep=""))
points <- read.csv("cleandata_nodups_no_outl.csv",header=TRUE)

# identification cultivated species
species <- c(as.vector(unique(subset(points,management=="C")[,"sp"])))
species <- c("Zea mays","Phaseolus vulgaris","Ipomoea batatas","Carica papaya","Manihot esculenta")

#select subset cultivated species points
ALL.points <- list()
for (i in species){
  nm<-which(species==i)
  ALL.points[[nm]]<-subset(points, sp==i)}
names(ALL.points)<-species

#extract values by subset cultivated species points
CLIM.ALL.points<-list()
for (i in species){
  df<-ALL.points[[i]]
  nm<-which(species==i)
  CLIM.ALL.points[[nm]]<-extract(elayers[[c(1,12)]], df[,c('x','y')],na.rm=TRUE)
  colnames(CLIM.ALL.points[[nm]])<-c("ameant","ap")
} 
names(CLIM.ALL.points)<-species

# GENEBANK POINTS

#select subset genebank points
G.points<-list()
for (i in species){
  nm<-which(species==i)
  G.points[[nm]]<-(subset(points, sp==i & Rec_Type=="G"))}
names(G.points)<-species

#extract values by subset genebank points
CLIM.G.points<-list()
for (i in species){
  df<-G.points[[i]]
  nm<-which(species==i)
  CLIM.G.points[[nm]]<-extract(elayers[[c(1,12)]], df[,c('x','y')],na.rm=TRUE)
  colnames(CLIM.G.points[[nm]])<-c("ameant","ap")
  }
names(CLIM.G.points)<-species

# SAMPLING REPRESENTATIVENESS SCORES (Ramierez et al. 2010) 
SRS<-vector()
for (i in species){
  nm<-which(species==i)
  SRS[[nm]] <- nrow(G.points[[i]])/(nrow(ALL.points[[i]]))*10
}
names(SRS)<-species
write.table(SRS, file = paste(mywd,"output/Histograms climate gaps/sampling representativeness scores.txt", sep=""),col.names=TRUE)

#HISTOGRAMS CLIMATE GAPS

# Distribution histograms mean annual temperature
for (i in species) {
  CLIM.ALL <- hist((CLIM.ALL.points[[i]][,1]), xlim=c(0,32), breaks=seq(0,32,2)) 
  if (length(CLIM.G.points[[i]][,1])>0){
    CLIM.G <- hist((CLIM.G.points[[i]][,1]),xlim=c(0,32), breaks=seq(0,32,2))   
    k="output/Histograms climate gaps/TEMP/Distribution histograms/"
    png(paste(mywd,k,i,".png",sep=""))
    plot(CLIM.ALL, col=rgb(0,0,1,1), xlim=c(0,32), 
         axes=FALSE,
         xlab="Temperatura promedia anual(°C)", 
         ylab="Numero de muestras", 
         main= i)
    plot(CLIM.G, col=rgb(1,0,0,1), xlim=c(0,32), 
          add=T)
    leg <- c("Azul: herbaria + germoplasma", "Rojo: germoplasma")
    legend("topleft",leg,cex=0.9)
    axis(1,at=seq(0,32,4),labels=TRUE, tick = TRUE, pos=0)
    axis(2,at=NULL,labels=TRUE, tick = TRUE)
    dev.off()
      }
  if (length(CLIM.G.points[[i]][,1])<1){
    k="output/Histograms climate gaps/TEMP/Distribution histograms/"
    png(paste(mywd,k,i,".png",sep=""))
    plot(CLIM.ALL, col=rgb(0,0,1,1), xlim=c(0,32), 
         axes=FALSE,
         xlab="Temperatura promedia anual(°C)", 
         ylab="Número de muestras",
         main= i )
    leg <- c("Azul: herbaria")
    legend("topleft",leg,cex=0.9)
    axis(1,at=seq(0,32,4),labels=TRUE, tick = TRUE, pos=0)
    axis(2,at=NULL,labels=TRUE, tick = TRUE)
    dev.off()  
  }
}

# Density histograms mean annual temperature
for (i in species) {
  CLIM.ALL <- hist((CLIM.ALL.points[[i]][,1]),freq=FALSE,xlim=c(0,32),breaks=seq(0,32,2)) 
  if (length(CLIM.G.points[[i]][,1])>0){
    CLIM.G <- hist((CLIM.G.points[[i]][,1]),freq=FALSE,xlim=c(0,32),breaks=seq(0,32,2))   
    k="output/Histograms climate gaps/TEMP/Density histograms/"
    png(paste(mywd,k,i,".png",sep=""))
    plot(CLIM.ALL, freq=FALSE, col=rgb(0,0,1,1), 
         axes=FALSE,
         ylim=c(0,0.5),
         xlab="Temperatura promedia anual(°C)", 
         ylab="Densidad de muestras",
         main= i)
    plot( CLIM.G, freq=FALSE, col=rgb(1,0,0,1), 
          add=TRUE)
    leg <- c("Azul: herbaria + germoplasma", "Rojo: germoplasma")
    legend("topleft",leg,cex=0.9)
    axis(1,at=seq(0,32,4),labels=TRUE, tick = TRUE, pos=0)
    axis(2,at=seq(0,0.5,0.1),labels=TRUE, tick = TRUE)
    dev.off()
  }
  if (length(CLIM.G.points[[i]][,]) < 1){
    k="output/Histograms climate gaps/TEMP/Density histograms/"
    png(paste(mywd,k,i,".png",sep=""))
    plot(CLIM.ALL, freq=FALSE, col=rgb(0,0,1,1),
         axes=FALSE,
         ylim=c(0,0.5),
         xlab="Temperatura promedia anual(°C)", 
         ylab="Densidad de muestras",
         main= i)
    leg <- c("Azul: herbaria")
    legend("topleft",leg,cex=0.9)
    axis(1,at=seq(0,32,4),labels=T, tick = TRUE, pos=0)
    axis(2,at=seq(0,0.5,0.1),labels=T, tick = TRUE)
    dev.off()  
  }
}

# Distribution histograms annual precipitation
for (i in species) {
  CLIM.ALL <- hist((CLIM.ALL.points[[i]][,2]),freq=FALSE,breaks=seq(0,5500,500)) 
  if (length(CLIM.G.points[[i]][,2])>0){
    CLIM.G <- hist((CLIM.G.points[[i]][,2]),freq=FALSE,breaks=seq(0,5500,500))   
    k="output/Histograms climate gaps/PREC/Distribution histograms/"
    png(paste(mywd,k,i,".png",sep=""))
    plot(CLIM.ALL, col=rgb(0,0,1,1),  
         axes=FALSE,
         xlab="Precipitación annual (mm)", 
         ylab="Numero de muestras", main= i)
    plot( CLIM.G, col=rgb(1,0,0,1), 
          add=TRUE)
    leg <- c("Azul: herbaria + germoplasma", "Rojo: germoplasma")
    legend("topright",leg,cex=0.9)
    axis(1,at=NULL,labels=T, tick = TRUE, pos=0)
    axis(2,at=NULL,labels=T, tick = TRUE)
    dev.off()
  }
  if (length(CLIM.G.points[[i]][,2])<1){
    k="output/Histograms climate gaps/PREC/Distribution histograms/"
    png(paste(mywd,k,i,".png",sep=""))
    plot(CLIM.ALL, col=rgb(0,0,1,1),
         axes=FALSE,
         xlab="Precipitación annual (mm)", 
         ylab="Número de muestras",main= i )
    leg <- c("Azul: herbaria")
    legend("topright",leg,cex=0.9)
    axis(1,at=NULL,labels=T, tick = TRUE, pos=0)
    axis(2,at=NULL,labels=T, tick = TRUE)
    dev.off()
   }
}

# Density histograms annual precipitation
  for (i in species) {
    CLIM.ALL <- hist((CLIM.ALL.points[[i]][,2]),breaks=seq(0,5500,500)) 
    if (length(CLIM.G.points[[i]][,2])>0){
      CLIM.G <- hist((CLIM.G.points[[i]][,2]),breaks=seq(0,5500,500))   
      k="output/Histograms climate gaps/PREC/Density histograms/"
      png(paste(mywd,k,i,".png",sep=""))
      plot(CLIM.ALL, freq=FALSE, col=rgb(0,0,1,1),  
           axes=FALSE,
           xlab="Precipitación annual (mm)", 
           ylab="Densidad de muestras", main= i)
      plot( CLIM.G, freq=FALSE, col=rgb(1,0,0,1), 
            add=TRUE)
      leg <- c("Azul: herbaria + germoplasma", "Rojo: germoplasma")
      legend("topright",leg,cex=0.9)
      axis(1,at=NULL,labels=T, tick = TRUE, pos=0)
      axis(2,at=seq(0,0.002,0.0002),labels=T, tick = TRUE)
      dev.off()
    }
    if (length(CLIM.G.points[[i]][,2])<1){
      k="output/Histograms climate gaps/PREC/Density histograms/"
      png(paste(mywd,k,i,".png",sep=""))
      plot(CLIM.ALL, freq=FALSE, col=rgb(0,0,1,1),
           axes=FALSE,
           xlab="Precipitación annual (mm)", 
           ylab="Densidad de muestras",main= i )
      leg <- c("Azul: herbaria")
      legend("topright",leg,cex=0.9)
      axis(1,at=NULL,labels=T, tick = TRUE, pos=0)
      axis(2,at=seq(0,0.002,0.0001),labels=T, tick = TRUE)
      dev.off()
    }
  }
