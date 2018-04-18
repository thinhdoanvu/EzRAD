#SETUP
install.packages("devtools")
install_github("thibautjombart/adegenet")
install.packages("DBI")
install.packages("assertthat")
install.packages("tibble")
install.packages("scales")"
install.packages("httpuv")
install.packages("xtable")
install.packages("deldir")
install.packages("LearnBayes")
install.packages("gmodels")
install.packages("expm")
install.packages("sp")
install.packages("permute")
install.packages("diveRsity")

library(devtools)
library(adegenet)
library(plyr)
adegenetServer()

#Bat buoc phai la file.gen nen binh thuong khi convert la file .txt nen gio day can doi lai ten .gen
#File can phai duoc convert truc tipe tu GENALEX, su dung tinh nang Export to Genepop (file name = .GEN)
#Chu y: Phai doi ten du lieu cua cot dau tien trong GENALEX (AG1, AG2, AG3,...) thanh (1,2,3,...)
#Cot Pop (cot 2) can duoc dat thanh cac con so (1<->AG, 2 <->DT)...
#Khi convert sang Genepop cot dau tien se chua ten cua cac quan the se la: (    1,    ) do vay can phai chuyen doi lai thanh (1_1, 1_2, 1_3,..2_1, 2_2,...)
#Buoc 1. Copy tung pop de lam, lan luot kiem tra tung pop chu dung lam 1 lan co the bao loi..."Error in read.genepop(file.choose(new = FALSE)) : "
#Hoac loi: Error in `rownames<-`(`*tmp*`, value = c("1_1", "1_2", "1_3", "1_4", "1_5",  : length of 'dimnames' [1] not equal to array extent
#Buoc 2: thay the cac ky tu trang o dau 1 pop bat ky thanh khong con khoang trang -> sau do thay the ten pop = \t1_ (hoac \t2_....)
#Vi du: "     DL" -> "DL" -> "	1_"
#Buoc 3: Them vao dang sau dau _ la cac so thu tu tuong ung voi lan luot so cac the
#Vi du: 1_1, 1_2, 1_3.....
#Buoc 4...thuc hien cau lenh ben duoi

data.loci=read.genepop(file.choose(new=FALSE)) #Import Data

levels(data.loci@pop) <-c("DL","DN","HA","KG","A1","NT","TH","CD") #Set Population Names
#levels(data.loci@pop) <-c("AG","BT","CT","DT","ST","TG","TV","VL")
#levels(data.loci@pop) <-c("AG","DT","CT","VL","TG","BT","TV","ST")

#Dat lai cac ten quan the tuong ung no la: 1,2,3,4 thanh AG, DT, BT, TV

data.loci.mean <- tab(data.loci, NA.method="mean") #Replace Zeros with mean

test<-levels(data.loci@pop) #Create Vector of Pop Names

test1<-revalue(test, c("DL"="grey","DN"="deeppink3","HA"="black","KG"="purple","A1"="green","NT"="Blue","TH"="cyan","CD"="red")) #Code colors for populations
#test1<-revalue(test, c("AG"="grey","BT"="deeppink3","CT"="black","DT"="purple","ST"="green","TG"="Blue","TV"="cyan","VL"="red")) #Code colors for populations
#test1<-revalue(test, c("AG"="grey","DT"="deeppink3","CT"="black","VL"="purple","TG"="green","BT"="Blue","TV"="cyan","ST"="red")) #Code colors for populations

pca.loci.mean <- dudi.pca(data.loci.mean); #Create PCA

s.class(pca.loci.mean$li, pop(data.loci), xax=1,yax=2, col=test1); #Plot PCA

title("Centered PCA of Loci Dataset"); #Title Graph

grp <- find.clusters(data.loci.mean, max.n.clust=8); #Use K-means clustering to infer groups

table.value(table(pop(data.loci), grp$grp), col.lab=paste("Inferred", 1:8), row.lab=paste(levels(data.loci@pop))) #print frequency table

table(pop(data.loci), grp$grp) #print numbered table



dapc1 <- dapc(data.loci.mean, grp$grp) #create DAPC

scatter(dapc1, posi.da="bottomright",  bg="white", pch=17:22, cstar=0, col=test1, scree.pca=FALSE, posi.pca="NULL") #Plot DAPC
title("DAPC with Inferred Groups") #Title Graph

#CAN VE MOI CHO NAY LA DUOC
dapc2<- dapc(data.loci.mean, pop(data.loci)) #Create DAPC with location as a group

scatter(dapc2, posi.da="bottomright",  bg="white", pch=17:22, cstar=0, col=test1, scree.pca=TRUE, posi.pca="bottomleft"); #Plot DAPC
title("DAPC with Localities as Groups") #Set Title



#DiveRsity

library(diveRsity)
data <- readGenepop(infile="Shark_Outlier.gen") #Convert Genepop file to DiveRsity file
results <- diffCalc(infile="Shark_Outlier.gen", outfile="text", fst = TRUE, pairwise = T, para = T, bs_pairwise = T,boots = 1000) #calculate divergence statistcs with 1000 bootstraps


#Ve 3D GENALEX
install.packages("scatterplot3d")
require("scatterplot3d")
require("RColorBrewer")

x=read.csv("/home/thinhdv/SUU_Pub/data.csv")
scatterplot3d(x[2:4])
s3d=scatterplot3d(x[2:4],pch=16,highlight.3d=TRUE,type="h/p/s",main="Title for 3D scatter")
plane=lm(x$cot1 ~ x$cot2 + x$cot3)
#ve mat phang
s3d$plane3d(plane)

install.pakages("rgl")
require("rgl")
plot3d(x$coor1,x$coor2,x$coor3,xlab="Coordinate 1",ylab="Coordinate 2",zlab="Coordinate 3",col=brewer.pal(3,"Dark2")[unclass(x$population)],size=3)

#Ve line
#plot3d(x$coor1,x$coor2,x$coor3,type="h",xlab="Coordinate 1",ylab="Coordinate 2",zlab="Coordinate 3",col=brewer.pal(3,"Dark2")[unclass(x$population)],size=1)

#Ve shape
#plot3d(x$coor1,x$coor2,x$coor3,type="h",xlab="Coordinate 1",ylab="Coordinate 2",zlab="Coordinate 3",col=brewer.pal(3,"Dark2")[unclass(x$population)],size=1)

#Chinh mau sac
#plot3d(x$coor1,x$coor2,x$coor3,type="h",xlab="Coordinate 1",ylab="Coordinate 2",zlab="Coordinate 3",c("NC"="Dark Blue","PC"="Green", "LK"="Dark Red", "AK"="Orange")[unclass(x$population)],size=1)

#clean
detach("package:rgl",unload=TRUE)
detach("pakage:RColorBrewer",unload=TRUE)
rm(list=ls())

#Warning message:
In par3d(userMatrix = c(1, 0, 0, 0, 0, 0.342020143325668,-0.939692620785909,  :
  font family "sans" not found, using "bitmap"


#GIAI PHAP
1. Download FreeType from: https://sourceforge.net/projects/freetype/files/ e.g. latest version.
2. Extract the downloaded file, enter in the directory where it is saved and type in:

./configure

make

sudo make install

3. Still need to rebuild rgl in R: download its source code from the link appearing in the first link above; without extracting the file, type in:

R CMD INSTALL name_of_archive.tar.gz

4. Enjoy any text size (that R supports) in plot3d objects.



library(adegenet)
new <- read.genepop("Anthyllis_new.gen")
old <- read.genepop("Anthyllis_old.gen")
nInd(old) #check number of individuals in dataset
nInd(new)

mat2 <- as.matrix(na.replace(old, method="mean"))
grp2 <- pop(old)
xval2 <- xvalDapc(mat2, grp2, n.pca.max = 300, training.set = 0.9,result = "groupMean", center = TRUE, scale = FALSE,n.pca = NULL, n.rep = 30, xval.plot = TRUE) #cross validation
xval2[2:6]

dapc_old <- dapc(old)
pred.sup <- predict.dapc(dapc_old, newdata=new) #predict results new individuals based on old dapc results
library(xlsx)
write.xlsx(pred.sup, "assignment DAPC.xlsx") 

table.value(table(pred.sup$assign, pop(new)), col.lab=levels(pop(new)), clegend = 0)
table <- table(pred.sup$assign, pop(new))          
write.xlsx(table, "assignment2 DAPC.xlsx") 
