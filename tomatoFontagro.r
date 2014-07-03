# Code created to manipulate climate change data provided by the University of Chile
# N. Castaneda
# Sept. 2013

require(raster)
dir <- "D:/Fontagro-tomato/uchile_inputs/bolivia"

# -------------------- Initial attempts --------------------
map3 <- read.csv(paste(dir,"/map-Bolivia_LB_sur.txt", sep=""),header=F)

lon <- as.numeric(substring(text=map3$V1, first=2, last=10))
lat <- as.numeric(substring(text=map3$V1, first=16, last=25))

coords <- cbind(lon,lat)
head(coords)
require(maptools); data(wrld_simpl)
plot(wrld_simpl,lwd=0.5, border="azure4", useRaster=F)

points(coords[,1], coords[,2], col="red", pch=19, cex=0.5)
require(raster)
?rasterize
coords <- as.data.frame(coords)
rs <- rasterize(coords, raster("D:/_geodata/clim/alt_30s/alt"))

# -------------------- After modifying files using Excel --------------------
# - BOLIVIA -
boln <- read.csv(paste(dir, "/map-BOLIVIAnorte_LB.csv", sep=""))
bols <- read.csv(paste(dir, "/map-Bolivia_LB_sur.csv", sep=""))
bol <- rbind(boln,bols)
write.csv(bol, paste(dir,"/bol_LB.csv", sep=""))
head(bol)
bol.rie <- subset(bol, select=c("lon", "lat", "ren.rie"))
write.csv(bol, paste(dir,"/bol_LB-ren-rie.csv", sep=""))
# rm(bol.rie)
bol.sec <- subset(bol, select=c("lon", "lat", "ren.sec"))
write.csv(bol, paste(dir,"/bol_LB-ren-sec.csv", sep=""))
# rm(bol.sec)

boln <- read.csv(paste(dir, "/map-BOLIVIAnorte50.csv", sep=""))
bols <- read.csv(paste(dir, "/map-BOLIVIAsur50.csv", sep=""))
bol <- rbind(boln,bols)
write.csv(bol, paste(dir,"/bol_50.csv", sep=""))
head(bol)
bol.rie <- subset(bol, select=c("lon", "lat", "ren.rie"))
write.csv(bol.rie, paste(dir,"/bol_50-ren-rie.csv", sep=""))
# rm(bol.rie)
bol.sec <- subset(bol, select=c("lon", "lat", "ren.sec"))
write.csv(bol.sec, paste(dir,"/bol_50-ren-sec.csv", sep=""))

# - PERU -
dir <- "D:/Fontagro-tomato/uchile_inputs/peru"
pern <- read.csv(paste(dir, "/map-norteLB_peru.csv", sep=""))
pers <- read.csv(paste(dir, "/map-surLB_peru.csv", sep=""))
perc <- read.csv(paste(dir, "/map-centroLB_peru.csv", sep=""))
per <- rbind(pern,pers, perc)
write.csv(per, paste(dir,"/per_LB.csv", sep=""))
head(per)

pern <- read.csv(paste(dir, "/map-norte50_peru.csv", sep=""))
pers <- read.csv(paste(dir, "/map-sur50_peru.csv", sep=""))
perc <- read.csv(paste(dir, "/map-centro50_peru.csv", sep=""))
per <- rbind(pern,pers, perc)
write.csv(per, paste(dir,"/per_50.csv", sep=""))
head(per)

# Revision ren.sec Peru
per50ren.sec <- read.csv("D:/Fontagro-tomato/uchile_inputs/peru/per_50.csv")
perLBren.sec <- read.csv("D:/Fontagro-tomato/uchile_inputs/peru/per_LB.csv")

require(raster)
alt <- raster("D:/_geodata/clim/alt_30s/alt")

per50ren.sec <- per50ren.sec[,c("lon", "lat", "ren.sec")]
table(per50ren.sec$ren.rie)

xy <- per50ren.sec[,c("lon", "lat", "ren.sec")]
rs <- rasterize(per50ren.sec,alt, field="ren.rie")
rs <- rasterFromXYZ(per50ren.sec)









