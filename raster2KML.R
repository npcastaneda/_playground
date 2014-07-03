# Purpose: produce Google Earth compatible files from Rasters
# N. Castaneda - 2013
#################################################
require(raster)
require(sp)

wd <- "D:/Playground"
setwd(wd)
src.dir <- "D:/_code/R/gap-analysis-maxent"

source(paste(src.dir,"/000.zipRead.R",sep=""))

#rs <- raster("./Musa_textilis.asc")
rs <- zipRead(wd,"gap-richness.asc.gz")

plot(rs)

rs[which(rs[]==0)] <- NA

brks <- unique(rs)
cols <- colorRampPalette(c("dark green","yellow","orange","red"))(length(brks)-1)
cols <- colorRampPalette(c("dark green","yellow","orange","red"))(length(brks))
cols <- rainbow(length(brks))

KMLname = "gaprichness.kml"
KML(rs, file=KMLname,col=cols,zip="",overwrite=TRUE)


#################################################
require(plotKML)

brks <- unique(rs)
cols <- colorRampPalette(c("dark green","yellow","orange","red"))(length(brks)-1)

kml(rs,folder.name=wd,file.name=paste(folder.name,".kml",sep=""), colour=cols,raster_name="gatsu")

plotKML(obj, 
        folder.name = normalizeFilename(deparse(substitute(obj, env = parent.frame()))), 
        file.name = paste(folder.name, ".kml", sep=""), 
        colour, raster_name, metadata = NULL, kmz = FALSE, ...)



data(eberg_grid)
gridded(eberg_grid) <- ~x+y
proj4string(eberg_grid) <- CRS("+init=epsg:31467")
data(SAGA_pal)
plotKML(eberg_grid["TWISRT6"], colour_scale = cols)




data(worldgrids_pal)
pal = as.character(worldgrids_pal["corine2k"][[1]][c(1,11,13,14,16,17,18)])
plotKML(eberg_grid["LNCCOR6"], colour_scale=pal)


install.packages(c("XML", "RSAGA", "rgdal", "raster", "plyr", "colorspace", "colorRamps", "spacetime", "aqp", "spatstat", "scales", "stringr", "plotrix", "pixmap", "dismo"))

#################### COLORS ####################
cols <- colors()[grep("sky",colors())]


require(graphics)
# A Color Wheel
pie(rep(1, 12), col = rainbow(12))

brks <- unique(quantile(c(h_ras[],g_ras[]),na.rm=T,probs=c(seq(0,1,by=0.05))))
cols <- colorRampPalette(c("dark green","yellow","orange","red"))(length(brks)-1)
brks.lab <- round(brks,0)


brks <- unique(rs)
cols <- colorRampPalette(c("dark green","yellow","orange","red"))(length(brks)-1)



brks <- unique(quantile(c(h_ras[],g_ras[]),na.rm=T,probs=c(seq(0,1,by=0.05))))
cols <- colorRampPalette(c("dark green","yellow","orange","red"))(length(brks)-1)
brks.lab <- round(brks,0)


plot(rs,col=cols)

################################################################################################
if (!file.exists("./figures")) {dir.create("./figures")}

#h_ras <- trim(h_ras) # Test!
#g_ras <- trim(g_ras)
z <- extent(h_ras)
aspect <- (z@ymax-z@ymin)*1.4/(z@xmax-z@xmin)

#herbarium map
tiff("./figures/h_samples_count.tif",
     res=300,pointsize=5,width=1500,height=1500*aspect,units="px",compression="lzw")
par(mar=c(2.5,2.5,1,1),cex=0.8,lwd=0.8)
plot(h_ras,col=cols,zlim=c(min(brks),max(brks)),
     breaks=brks,lab.breaks=brks.lab,useRaster=F,
     horizontal=T,
     legend.width=1,
     legend.shrink=0.99)
plot(wrld_simpl,add=T,lwd=0.5, border="azure4")
grid()
dev.off()