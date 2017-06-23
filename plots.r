#!/usr/bin/env Rscript
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
	data <- read.csv('20050306/output_34_-117_1000.txt', skip=7, sep='', header=F)

	# Set up the PDF file for output
	pdf(paste("plots/",path,"_",elev[f],'_specific_humidity.pdf',sep=""), width=17, height=9)
	par(mar=c(3,3,3,3))

	# create the plot for the column 19 and only the first 72 rows.  Label plot and set extents of the plot.
	plot(data$V19[1:72], type='n', ylim=range(0,15), xlab="Hours (Backwards from 0)", ylab="Specific Humidity", main=paste("Specific Humidity: ",elev[f],"m"))
	grid()

	# Loop through all the files for the specified atmospheric river at the specified (earlier loop) elevation
	for (i in temp) {

		# read in the data, skip the first 7 lines
		data <- read.csv(paste(path,"/",i,sep=""), skip=7, sep='', header=F)
		# add lines to the plot (again only first 72 rows of the 19th column)
		lines(data$V19[1:72], lwd=2, col=cols[f])
	}

	# save the PDF
	dev.off()

	# ELEVATION
	pdf(paste("plots/",path,"_",elev[f],'_elevation.pdf',sep=""), width=17, height=9)
	par(mar=c(3,3,3,3))
	plot(data$V12[1:72], type='n', ylim=range(0,10000), xlab="Hours (Backwards from 0)", ylab="Elevation", main=paste("Parcel Elevation: ",elev[f],"m"))
	grid()
	for (i in temp) {
		data <- read.csv(paste(path,"/",i,sep=""), skip=7, sep='', header=F)
		lines(data$V12[1:72], lwd=2, col=cols[f])
	}
	dev.off()


	# MIX RATIO
	pdf(paste("plots/",path,"_",elev[f],'_mixratio.pdf',sep=""), width=17, height=9)
	par(mar=c(3,3,3,3))
	plot(data$V20[1:72], type='n', ylim=range(0,16), xlab="Hours (Backwards from 0)", ylab="Mix Ratio", main=paste("H20 Mix Ratio: ",elev[f],"m"))
	grid()
	for (i in temp) {
		data <- read.csv(paste(path,"/",i,sep=""), skip=7, sep='', header=F)
		lines(data$V20[1:72], lwd=2, col=cols[f])
	}
	dev.off()

	# LAT / LNG MAPS
	pdf(paste("plots/",path,"_",elev[f],'_map.pdf',sep=""), width=17, height=13)
	map('world2', xlim = c(120, 250), ylim=c(10,70), fill=TRUE, col='#eeeeeeee')
	grid()
	map.axes()
	for (i in temp) {
		data <- read.csv(paste(path,"/",i,sep=""), skip=7, sep='', header=F)
		data$V11[data$V11 >= 0] <- data$V11[data$V11 >= 0] - 360
		data$V11 <- data$V11 + 360
		lines(data$V11[1:72], data$V10[1:72], lwd=1.5, col=cols[f])
		#cnt <- cnt+1
	}
	dev.off()
	#map("world", projection="rectangular", parameter=0, orientation=c(90,0,180), wrap=TRUE, fill=T, resolution=0,col=0, xlim=c(180,-120))
}