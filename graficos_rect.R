
# Graphics

# Option 1

x <- 1:10
par(mar=c(5,4,4,5.5),xpd=NA)

plot(x,type="n",
     xlim=c(0,10),ylim=c(0,10),
     xlab="FPS North America", ylab="FPS US")
for(i in 1:3){
  rect(0,0,3,3,angle=45,col="#ff000035",border=NA) # red
  rect(3,3,5,5,angle=45,col="#FFA50035",border=NA) # orange
  rect(5,5,7.5,7.5,angle=45,col="#FFFF0040",border=NA) # yellow
  rect(7.5,7.5,10,10,angle=45,col="#00800030",border=NA) # green
}
legend(10.5,8.5,c('HPS', 'MPS', 'LPS', 'NFCR'),
       fill=c('#ff000035','#FFA50035','#FFFF0040','#00800030'),
       border="white",box.col=NA)

#add points
#points(data.na$FPS,data.us$FPS,pch=20,cex=0.8)
#points(data.na$SRS,data.us$SRS,pch=20,cex=0.8,col=2)
#points(data.na$GRS,data.us$GRS,pch=20,cex=0.8,col=4)
#points(data.na$ERS,data.us$ERS,pch=20,cex=0.8,col=5)

# Option 2

fpsScore <- data.frame(data.na$FPS, data.us$FPS) # read data x and y
names(fpsScore) <- c("fps_na","fps_us") # data in data.frame

p <- ggplot(fpsScore, aes(x=fps_na,y=fps_us))
p +
  geom_rect(xmin=0, xmax=3, ymin=0, ymax=3, linetype=0, fill='red', alpha=0.008) +
  geom_rect(xmin=3, xmax=5, ymin=3, ymax=5, linetype=0, fill='orange3', alpha=0.008) +
  geom_rect(xmin=5, xmax=7.5, ymin=5, ymax=7.5, linetype=0, fill='yellow', alpha=0.008) +
  geom_rect(xmin=7.5, xmax=10, ymin=7.5, ymax=10, linetype=0, fill='forestgreen', alpha=0.008) +
  geom_point() +
  xlab('Final priority score North America') +
  ylab('Final priority score United States') +
  opts(axis.line = theme_segment(colour = "black"),
       panel.grid.major = theme_blank(),
       panel.grid.minor = theme_blank(),
       panel.border = theme_blank(),
       panel.background = theme_blank()) +
  theme(axis.title.x = element_text(size = 15, vjust=-.2)) +
  theme(axis.title.y = element_text(size = 15, vjust=0.3))
