
comparison <- read.csv("F:/fps_comp.csv",header=T)
head(comparison)

plot(comparison$FPS_before,comparison$FPS_after,
     xlim=c(0,10),ylim=c(0,10),ylab=)

abline(lm(comparison[,3]~comparison[,2]))

#### opción 1
scatterhist <- function(x, y, xlab = "", ylab = "", ...){
  zones <- matrix(c(2,0,1,3), ncol = 2, byrow = TRUE)
  layout(zones, widths=c(4/5,1/5), heights = c(1/5,4/5))
  xhist <- hist(x, plot = FALSE)
  yhist <- hist(y, plot = FALSE)
  top <- max(c(xhist$counts, yhist$counts))
  par(mar = c(3,3,1,1))
  plot(x, y , ...)
  par(mar = c(0,3,1,1))
  barplot(xhist$counts, axes = FALSE, ylim = c(0, top), space = 0)
  par(mar = c(3,0,1,1))
  barplot(yhist$counts, axes = FALSE, xlim = c(0, top),
          space = 0, horiz = TRUE)
  par(oma = c(3,3,0,0))
  mtext(xlab, side = 1, line = 1, outer = TRUE, adj = 0,
        at = (.8 * (mean(x) - min(x))/(max(x)-min(x))))
  mtext(ylab, side = 2, line = 1, outer = TRUE, adj = 0,
        at = (.8 * (mean(y) - min(y))/(max(y) - min(y))))
}
scatterhist(comparison$FPS_before,comparison$FPS_after)

#### opción 2, ggplot2

geom_lm <- function(formula = y ~ x) {
  geom_smooth(formula = formula, se = FALSE, method = "lm")
}

library(ggplot2)
hist_top <- ggplot() + geom_density(aes(comparison$FPS_before), colour="forestgreen", fill="forestgreen", alpha=0.3) + 
  xlab("") + ylab("Density") + xlim(0,10); hist_top

empty <- ggplot()+geom_point(aes(1,1), colour="white")+
  opts(axis.ticks=theme_blank(), 
       panel.background=theme_blank(), 
       axis.text.x=theme_blank(), axis.text.y=theme_blank(),           
       axis.title.x=theme_blank(), axis.title.y=theme_blank())

scatter <- ggplot()+geom_point(aes(comparison$FPS_before,comparison$FPS_after)) + 
  xlab("Before ...") + ylab("After ...") + xlim(0,10) + ylim(0,10) + geom_lm() +

  
hist_right <- ggplot() + geom_density(aes(comparison$FPS_after), colour="steelblue3", fill="steelblue3", alpha=0.3) + 
  xlab("") + ylab("Density") + xlim(0,10) + coord_flip(); hist_right

grid.arrange(hist_top, empty, scatter, hist_right, ncol=2, nrow=2, widths=c(4, 1), heights=c(1, 4))




+ theme(legend.position = "none",          
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(), 
        plot.margin = unit(c(3,-5.5,4,3), "mm")) +
  +scale_x_continuous(breaks = 0:10,
                      limits = c(0,10),
                      expand = c(.05,.05))

#### opción 3, ggplot2
scatter <- qplot(x=comparison$FPS_before,y=comparison$FPS_after, data=comparison)  + 
  scale_x_continuous(limits=c(0,10)) + 
  scale_y_continuous(limits=c(0,10)) + 
  geom_rug(col=rgb(.5,0,0,alpha=.2)) +
  xlab("Before ...") + ylab("After ...")
scatter

scatter + theme(legend.position = "none",          
               axis.title.x = element_blank(),
               axis.title.y = element_blank(),
               axis.text.x = element_blank(),
               axis.text.y = element_blank(), 
               plot.margin = unit(c(3,-5.5,4,3), "mm")) +
  +scale_x_continuous(breaks = 0:6,
                      limits = c(0,10),
                      expand = c(.05,.05))













