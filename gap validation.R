##Gap Validation##

data=read.table("clipboard",header=T)
data_sub=data[data$Genepool=="avena",]
data_sub=data.frame(data_sub,apply(data_sub[,4:7],1,mean,na.rm=T))
names(data_sub)[8]="Ave_Expert"
boxplot(data_sub[,c(3,8)])


data=data.frame(data,apply(data[,4:7],1,mean,na.rm=T))
names(data)[8]="Mean_expert"

##Grafico Boxplot Diferencias##
bymedian <- with(data,reorder(Genepool,FPS-Mean_expert,median,na.rm=T))
boxplot(FPS-Mean_expert ~ bymedian, data=data, cex.axis=0.6,col="lightgray",main="Difference between FPS and Comparable EPS")
abline(h=0,col="red")
grid()

##RMCE
x=data.frame(data$Genepool,(data$FPS-data$Mean_expert)^2)
RSME=tapply((data$FPS-data$Mean_expert)^2,data$Genepool,sum,na.rm=T)/tapply((data$FPS-data$Mean_expert)^2,data$Genepool,length)
RSME=RSME[-19]
barplot(sort(sqrt(RSME)),horiz=F, cex.names=0.6, main="Root Mean Square Error")
abline(h=2,col="red")

##############################################################
require(graphics)

bymedian <- with(InsectSprays, reorder(spray, count, mean))
boxplot(count ~ bymedian, data = InsectSprays,
        xlab = "Type of spray", ylab = "Insect count",
        main = "InsectSprays data", varwidth = TRUE,
        col = "lightgray")
##############################################################

