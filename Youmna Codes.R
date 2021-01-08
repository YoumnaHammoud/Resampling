install.packages("raster")
install.packages("rgdal")
library(raster)
library(rgdal)


aa<-list.files(path ="C:/Thesis MY Data/Data and Points/Predictors ready - new flow",pattern = "*.tif$",full.names = TRUE)
setwd("C:/Thesis MY Data/Data and Points/R Studio Results 2")
aa
#create raster
All_rast<-list()


for(i in 1:length(aa))
{
  All_rast[[i]]<- raster(aa[i],progress='text')
}
All_rast

Cat<-All_rast[8:9]
Cont<-All_rast[-c(8:9)]

#borders
bb<-lapply(All_rast,bbox)

bb

plot(extent(bb[[1]]))
plot(extent(bb[[2]]),add=TRUE,col='red')
plot(extent(bb[[3]]),add=TRUE,col='blue')
plot(extent(bb[[4]]),add=TRUE,col='green')
plot(extent(bb[[5]]),add=TRUE,col='yellow')
plot(extent(bb[[6]]),add=TRUE,col='orange')
plot(extent(bb[[7]]),add=TRUE,col='white')
plot(extent(bb[[8]]),add=TRUE,col='purple')
plot(extent(bb[[9]]),add=TRUE,col='pink')
plot(extent(bb[[10]]),add=TRUE,col='deeppink')
plot(extent(bb[[11]]),add=TRUE,col='blue2')
plot(extent(bb[[12]]),add=TRUE,col='darkgreen')
plot(extent(bb[[13]]),add=TRUE,col='darkviolet')
plot(extent(bb[[14]]),add=TRUE,col='darkblue')
plot(extent(bb[[15]]),add=TRUE,col='darkred')

XMI<-NULL
XMA<-NULL
YMI<-NULL
YMA<-NULL
for (i in 1 : length (All_rast))
{
  XMI[i]<-bb[[i]][1,1]
  XMA[i]<-bb[[i]][1,2]
  YMI[i]<-bb[[i]][2,1]
  YMA[i]<-bb[[i]][2,2]
  Xminimum<-max(XMI)
  Xmaximum<-min(XMA)
  Yminimum<-max(YMI)
  Ymaximum<-min(YMA)
}


XMI
XMA
YMI
YMA

Xminimum
Xmaximum
Yminimum
Ymaximum

Ref_ext<-extent(c(Xminimum,Xmaximum,Yminimum,Ymaximum))
Ref_ext

plot(Ref_ext,add=TRUE,col='green',lwd=5)



#crop
All_crp<-list()
for(i in 1:length(All_rast))
{
  All_crp[[i]]<- crop(All_rast[[i]],Ref_ext, progress='text')
}

All_crp



bb<-lapply(All_rast, bbox)
bb


#resample
Cat_resample<-list()
for(i in 1:length(Cat)) 
{
  Cat_resample[[i]]<- resample(Cat[[i]],Cont[[4]],method='ngb', progress='text')
}

Cont_resample<-list()
for(i in 1:length(Cont)) 
{
  
  Cont_resample[[i]]<- resample(Cont[[i]],Cont[[4]],method='bilinear', progress='text')
}


Catcont<-c(Cont_resample,Cat_resample)

#stack all the rasters cropped
st<-stack(Catcont)

st

#write rasters in the set directory
ww<-writeRaster(st,names(st),bylayer=TRUE,format='ascii', progress='text')
ww<-writeRaster(st,names(st),bylayer=TRUE,format='GTiff', progress='text')
