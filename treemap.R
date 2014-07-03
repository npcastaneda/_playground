priorities <- read.csv("clipboard", sep="")
head(priorities)
require(treemap)
install.packages("treemap")

treemap <- (dtf=priorities,index="count", vSize="count")

data(GNI2010)
treemap(GNI2010,
        index=c("continent", "iso3"),
        vSize="population",
        vColor="GNI",
        type="value")

treemap(priorities, vSize="Count", index="Country", vColor="Country")

crops <- read.csv("clipboard", sep="\t")
head(crops)
names(crops)
treemap(crops, vSize="X1_HPS", index="Row_Labels", vColor="Grand_Total", type="value")
treemap(crops, vSize="Grand_Total", index="Row_Labels", vColor="X1_HPS", type="dens", palette="RdBu",
        title.legend="Proportion of CWR categorized as High priorities for collection",
        title="Number of CWR per gene pool")