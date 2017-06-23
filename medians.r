#!/usr/bin/env Rscript
# @author Grant McKenzie
# Visualize median and mean of trajectories

args = commandArgs(trailingOnly=TRUE)

#load library need for 2d map
library(maps)

#set 3 basic colors
cols = c("#339999","#993399","#999933")
#set 3 elevations
elev = c(1000,2000,3000)
#set the path to the folder.  args[1] means it takes the first argument.
path = args[1] #"20101220"

#for loop going from 1 to 3
for (f in 1:3) {

	# SPECIFIC HUMIDITY
	# Get the correct text files based on the elevation and folder to correct AR
	patt = paste(elev[f],".txt", sep="")
	temp = list.files(path=path, pattern=patt)

	# Read in some dummy data used to set up the empty plot.
	data <- read.csv('20141223/output_2014_12_23_41_-123_3000.txt', skip=7, sep='', header=F)

	# LAT / LNG MAPS
	pdf(paste("plots/",path,"_",elev[f],'_map.pdf',sep=""), width=17, height=13)
	map('world2', xlim = c(150, 250), ylim=c(10,60), fill=TRUE, col='#eeeeeeee')
	grid()
	map.axes()
	medlat <- vector(mode="numeric", length=72)
	medlng <- vector(mode="numeric", length=72)
	meanlat <- vector(mode="numeric", length=72)
	meanlng <- vector(mode="numeric", length=72)
	sdlat <- vector(mode="numeric", length=72)
	sdlng <- vector(mode="numeric", length=72)
	for(j in 1:72) {
		a <- vector(mode="numeric", length=25)
		b <- vector(mode="numeric", length=25)
		cnt <-1
		for (i in temp) {
			data <- read.csv(paste(path,"/",i,sep=""), skip=7, sep='', header=F)
			data$V11[data$V11 >= 0] <- data$V11[data$V11 >= 0] - 360
			data$V11 <- data$V11 + 360
			a[cnt] <- data$V11[j]
			b[cnt] <- data$V10[j]
			cnt <- cnt+1
			
		#cnt <- cnt+1
		}
		medlng[j] <- median(a)
		medlat[j] <- median(b)
		meanlng[j] <- mean(a)
		meanlat[j] <- mean(b)
		sdlng[j] <- sd(a)
		sdlat[j] <- sd(b)
	}
	#print(medlat)
	for (i in temp) {
		data <- read.csv(paste(path,"/",i,sep=""), skip=7, sep='', header=F)
		data$V11[data$V11 >= 0] <- data$V11[data$V11 >= 0] - 360
		data$V11 <- data$V11 + 360
		lines(data$V11[1:72], data$V10[1:72], lwd=1.0, col=cols[f])
	}
	lines(medlng[1:72], medlat[1:72], lwd=2.0, col="black")
	lines(meanlng[1:72], meanlat[1:72], lty=2, lwd=2.0, col="#333333")
	lines((meanlng[1:72]+sdlng[1:72]), (meanlat[1:72]+sdlat[1:72]), lty=1, lwd=6.0, col="#66666666")
	lines((meanlng[1:72]-sdlng[1:72]), (meanlat[1:72]-sdlat[1:72]), lty=1, lwd=6.0, col="#66666666")

	legend('topleft', c("Individual Trajectories","Median","Mean","1 std dev from mean"), col=c(cols[f],'black','black',"#666666"), lty=c(1,1,2,1), lwd=c(1,2,2,6), bg="white")
	dev.off()

}