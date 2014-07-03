# Create line graphs including standard deviation
# N. Castaneda - 2014


# -------------------------------------
# All data (1998-2014)
dir <- "D:/Solicitudes/frodriguez/variacion-precios-cafe"

coffee <- read.csv("D:/Solicitudes/frodriguez/variacion-precios-cafe/tablas mercado robusta_ICO-2014.csv")
head(coffee)

names(coffee) <- c("year", "group", "mean", "sd")


ggplot(coffee, aes(x=year, y=mean)) + geom_line(aes(colour=group)) + 
  geom_ribbon(aes(ymax=mean+sd, ymin=mean-sd, fill=group), alpha = 0.2) +
  scale_x_continuous(breaks = 1998:2014) +
#   scale_fill_brewer(palette="Dark2") # Other color palette
#   scale_fill_manual(values=c("red", "blue", "green", "purple", "yellow", "black")) # Use user-defined colors
  ylab("Precio promedio") + 
  xlab ("Año")

ggsave(filename="precios1998-2014.png",path=dir,dpi=300)

# Only data with SD
coffee <- read.csv("D:/Solicitudes/frodriguez/variacion-precios-cafe/tablas mercado robusta_ICO-2010-2014.csv")
head(coffee)
names(coffee) <- c("year", "group", "mean", "sd")

ggplot(coffee, aes(x=year, y=mean)) + geom_line(aes(colour=group)) + 
  geom_ribbon(aes(ymax=mean+sd, ymin=mean-sd, fill=group), alpha = 0.2) +
  scale_x_continuous(breaks = 2010:2013) +
  ylab("Precio promedio") + 
  xlab ("Año")

ggsave(filename="precios2010-2013.png",path=dir,dpi=300)

