# Compare the FPS obtained in different analysis

Rdata <- "D:/CWR-collaborations/solanumPBI/_results2014/eggplant/_figures/fps-comparison.RData"
load(Rdata)

require(ggplot2)

g <- ggplot(comp, aes(FPS2014, FPS2013))
g <- g + geom_rect(xmin=0,xmax=3,ymin=0,ymax=3, fill="red")
g <- g + geom_rect(xmin=3,xmax=5,ymin=3,ymax=5, fill="orange")
g <- g + geom_rect(xmin=5,xmax=7.5,ymin=5,ymax=7.5, fill="yellow")
g <- g + geom_rect(xmin=7.5,xmax=10,ymin=7.5,ymax=10, fill="green")
g <- g + geom_vline(xintercept = 3)
g <- g + geom_vline(xintercept = 5)
g <- g + geom_vline(xintercept = 7.5)
g <- g + geom_vline(xintercept = 10)
g <- g + geom_hline(yintercept = 3)
g <- g + geom_hline(yintercept = 5)
g <- g + geom_hline(yintercept = 7.5)
g <- g + geom_hline(yintercept = 10)

g <- g + geom_point()
g

tiff("D:/CWR-collaborations/solanumPBI/_results2014/eggplant/_figures/test.tiff", width=10, height=10,
     units="cm", res=600, compression="lzw")
print(g)
dev.off()