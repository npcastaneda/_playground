# Describing the quality of datasets
# N. Castaneda - 2014

require(ggplot2)
require(raster)
require(ggmap)
require(maptools)

# Test coordinates prepared by H. Achicanoy
# X <- data.frame(Lon=rnorm(100,100,100), Lat=rnorm(100,100,100))

# ======= Real data =======
dir <- "D:/CWR/_inputs/occurrences/20131025"
prior <- read.csv(paste(dir,"/allocc_cropPrior.csv",sep=""))
prior <- prior[,c("lon","lat")]
nprior <- read.csv(paste(dir,"/allocc_cropNonPrior.csv",sep=""))
nprior <- nprior[,c("lon","lat")]
X <- rbind(prior,nprior)

# Dispersion graph
absCoords <- abs(X%%1*sign(X))
head(absCoords)

d <- ggplot(absCoords, aes(lon, lat))
d + geom_point(alpha = 1/10)

ggsave(file=paste(dir,"/figures/dispersion-coords.pdf",sep=""))


# ======= Density map using ggplot2

m <- ggplot(X, aes(x = lon, y = lat)) +
  geom_point(color='chartreuse4', alpha=0.5)
# m + geom_density2d()
m + stat_density2d(aes(fill = ..level.., alpha = ..level..), geom="polygon")

# ======= Density map with maptools
data(wrld_simpl)
r <- raster()
res(r) <- 1

dens <- rasterize(X,r,fun="count")

dens[which(dens[]==0)] <- NA

brks <- unique(quantile(c(dens[],dens[]),na.rm=T,probs=c(seq(0,1,by=0.0005))))
# cols <- colorRampPalette(c("dark green","yellow","orange","red"))(length(brks)-1)
cols <- colorRampPalette(c("blueviolet","dodgerblue1","cadetblue3","lightgreen","greenyellow",
                           "yellow1","goldenrod1","red1"))(length(brks)-1)
brks.lab <- round(brks,0)

z <- extent(dens)
aspect <- (z@ymax-z@ymin)*1.4/(z@xmax-z@xmin)

#herbarium map
tiff(paste(dir,"/figures/density-all-points3.tif",sep=""),
     res=300,pointsize=5,width=1500,height=1500*aspect,units="px",compression="lzw")
par(mar=c(2.5,2.5,1,1),cex=0.8,lwd=0.8)
plot(dens,col=cols,zlim=c(min(brks),max(brks)), main = "All CWR samples",
     breaks=brks,lab.breaks=brks.lab,useRaster=F,
     horizontal=T,
     legend.width=1,
     legend.shrink=0.99)
plot(wrld_simpl,add=T,lwd=0.5, border="azure4")
grid()
dev.off()

# ======== Tree map (number of records per family)
dir <- "D:/CWR/_inputs/occurrences/20131025"
prior <- read.csv(paste(dir,"/allocc_cropPrior.csv",sep=""))
prior <- prior[,c("Taxon","lon","lat")]
nprior <- read.csv(paste(dir,"/allocc_cropNonPrior.csv",sep=""))
nprior <- nprior[,c("taxon_final","lon","lat")]
names(nprior) <- c("Taxon", "lon","lat")
X <- rbind(prior,nprior)

require(treemap)
