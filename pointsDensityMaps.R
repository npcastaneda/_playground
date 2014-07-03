#:::::::::::::::::::::::::::::::::::::::::::
# Producing density maps with all data used in the analyses
# N. Castaneda - 2014
#:::::::::::::::::::::::::::::::::::::::::::

library(raster); library(maptools); data(wrld_simpl)

dir <- "D:/CWR/_inputs/occurrences/20131025"
setwd(dir)

# -- Non priority records
nonprior <- read.csv("D:/CWR/_inputs/occurrences/20131025/allocc_cropNonPrior.csv")
names(nonprior)
head(nonprior)

nonprior <- nonprior[,c("taxon_final","lat","lon","Type", "H", "G")]
names(nonprior) <- c("Taxon","lat","lon","Type", "H", "G")
head(nonprior)

# -- Priority records
prior <- read.csv("D:/CWR/_inputs/occurrences/20131025/allocc_cropPrior.csv")
names(prior)
prior <- prior[,c("Taxon", "lat", "lon","Type", "H", "G")]
head(prior)

# -- Binding all records
alldata <- rbind(prior,nonprior)

# -- Subsetting by H and G

h <- alldata[which(alldata$H==1),]
g <- alldata[which(alldata$G==1),]

# -- Producing maps
r <- raster()
res(r) <- 1

all_ras <- alldata
all_ras <- all_ras[,c("lon","lat")]
all_ras <- rasterize(all_ras,r,fun="count")

h_ras <- h
h_ras <- h_ras[,c("lon","lat")]
h_ras <- rasterize(h_ras,r,fun="count")

g_ras <- g
g_ras <- g_ras[,c("lon","lat")]
g_ras <- rasterize(g_ras,r,fun="count")

h_ras[which(h_ras[]==0)] <- NA; g_ras[which(g_ras[]==0)] <- NA; all_ras[which(all_ras[]==0)] <- NA

brks <- unique(quantile(c(all_ras[],all_ras[]),na.rm=T,probs=c(seq(0,1,by=0.05))))
cols <- colorRampPalette(c("dark green","yellow","orange","red"))(length(brks)-1)
brks.lab <- round(brks,0)

if (!file.exists("./figures")) {dir.create("./figures")}

z <- extent(h_ras)
aspect <- (z@ymax-z@ymin)*1.4/(z@xmax-z@xmin)

#herbarium map
tiff("./figures/h_samples_count.tif",
     res=300,pointsize=5,width=1500,height=1500*aspect,units="px",compression="lzw")
par(mar=c(2.5,2.5,1,1),cex=0.8,lwd=0.8)
plot(h_ras,col=cols,zlim=c(min(brks),max(brks)), main = "Herbarium samples",
     breaks=brks,lab.breaks=brks.lab,useRaster=F,
     horizontal=T,
     legend.width=1,
     legend.shrink=0.99)
plot(wrld_simpl,add=T,lwd=0.5, border="azure4")
grid()
dev.off()

#germplasm map
tiff("./figures/g_samples_count.tif",
     res=300,pointsize=5,width=1500,height=1500*aspect,units="px",compression="lzw")
par(mar=c(2.5,2.5,1,1),cex=0.8, lwd=0.8)
plot(g_ras,col=cols,zlim=c(min(brks),max(brks)),useRaster=F, main="Genebank accessions",
     breaks=brks,lab.breaks=brks.lab,
     horizontal=T,
     legend.width=1,
     legend.shrink=0.99)
plot(wrld_simpl,add=T,lwd=0.5, border="azure4")
grid()
dev.off()

#all records map
tiff("./figures/all_samples_count.tif",
     res=300,pointsize=5,width=1500,height=1500*aspect,units="px",compression="lzw")
par(mar=c(2.5,2.5,1,1),cex=0.8, lwd=0.8)
plot(all_ras,col=cols,zlim=c(min(brks),max(brks)),useRaster=F, main="All records densities",
     breaks=brks,lab.breaks=brks.lab,
     horizontal=T,
     legend.width=1,
     legend.shrink=0.99)
plot(wrld_simpl,add=T,lwd=0.5, border="azure4")
grid()
dev.off()
