######################################################################################################################
# RTF Playground - creating text documents straight from R
# From: http://cran.r-project.org/web/packages/rtf/vignettes/rtf.pdf
######################################################################################################################
library(rtf)
install.packages("R.methodsS3")
output<-"C:/Users/npcastaneda/Desktop/rtf_vignette.doc"
rtf<-RTF(output,width=8.5,height=11,font.size=10,omi=c(1,1,1,1))

addHeader(rtf,title="Section Header",
          + subtitle="This is the subheading or section text.")

addParagraph(rtf,"This is a new self-contained paragraph.\n")


startParagraph(rtf)
addText(rtf,"This text was added with the addText command. ")
addText(rtf,"You can add styled text too. ",bold=TRUE,italic=TRUE)
addText(rtf,"You must end the paragraph manually.")
endParagraph(rtf)

addPlot(rtf,plot.fun=plot,width=6,height=6,res=300, iris[,1],iris[,2])

# Add external files
graph <- "D:/CWR/_inputs/_priorityCrops/_revision/allNative/avena/Avena_abyssinica.tif"
addPng(rtf, graph, width=7, height=3.74)
# addPng(rtf, graph, width=5, height=5)

done(rtf)