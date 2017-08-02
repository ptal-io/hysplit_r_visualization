#!/usr/bin/env Rscript
setwd('~/Downloads/output/')

nca <- read.csv('NCA.csv', header=F)
sca <- read.csv('SCA.csv', header=F)
pnw <- read.csv('PNW.csv', header=F)

a <- sca
title="SCA"

mmax <- vector(mode='numeric', length=500)
mland <- vector(mode='numeric', length=500)
mdelta <- vector(mode='numeric', length=500)
cnt <- 1
for(i in 1:length(a[,1])) {
	path = toString(a[i,1])
	temp = list.files(path=path, pattern="2000.txt")

	for (i in temp) {
		# read in the data, skip the first 7 lines
		data <- read.csv(paste(path,"/",i,sep=""), skip=7, sep='', header=F)
		# add lines to the plot (again only first 72 rows of the 19th column)
		#lines(data$V19[1:72], lwd=2, col="#333333")
		mmax[cnt]<-max(data$V19[1:72])
		mland[cnt]<-data$V19[1]
		mdelta[cnt] <- mmax[cnt] - mland[cnt]
		cnt<-cnt+1
	}
}

pdf(paste("plots/ALL_max_sp_density.pdf",sep=""), width=10, height=7)
par(mar=c(6,6,3,3))
#density(asdf, breaks=40, col='lightblue', main=paste(title," SH",sep=""), xlab="Specific Humdity")
plot(density(mmax, bw=0.3), type='n', main=paste("Specific Humdity MAX",sep=""), ylim=range(0,0.35), xlim=range(0,20))
grid()
lines(density(mmax, bw=0.3), col='#1b9e77', lwd=2)

a <- nca

mmax <- vector(mode='numeric', length=500)
mland <- vector(mode='numeric', length=500)
mdelta <- vector(mode='numeric', length=500)
cnt <- 1
for(i in 1:length(a[,1])) {
	path = toString(a[i,1])
	temp = list.files(path=path, pattern="2000.txt")

	for (i in temp) {
		# read in the data, skip the first 7 lines
		data <- read.csv(paste(path,"/",i,sep=""), skip=7, sep='', header=F)
		# add lines to the plot (again only first 72 rows of the 19th column)
		#lines(data$V19[1:72], lwd=2, col="#333333")
		mmax[cnt]<-max(data$V19[1:72])
		mland[cnt]<-data$V19[1]
		mdelta[cnt] <- mmax[cnt] - mland[cnt]
		cnt<-cnt+1
	}
}

lines(density(mmax, bw=0.3), col='#7570b3', lwd=2)

a <- pnw

mmax <- vector(mode='numeric', length=500)
mland <- vector(mode='numeric', length=500)
mdelta <- vector(mode='numeric', length=500)
cnt <- 1
for(i in 1:length(a[,1])) {
	path = toString(a[i,1])
	temp = list.files(path=path, pattern="2000.txt")

	for (i in temp) {
		# read in the data, skip the first 7 lines
		data <- read.csv(paste(path,"/",i,sep=""), skip=7, sep='', header=F)
		# add lines to the plot (again only first 72 rows of the 19th column)
		#lines(data$V19[1:72], lwd=2, col="#333333")
		mmax[cnt]<-max(data$V19[1:72])
		mland[cnt]<-data$V19[1]
		mdelta[cnt] <- mmax[cnt] - mland[cnt]
		cnt<-cnt+1
	}
}

lines(density(mmax, bw=0.3), col='#d95f02', lwd=2)
legend("topright", c("SCA","NCA","PNW"), fill=c("#1b9e77","#7570b3","#d95f02"))
dev.off()


############# LANDFALL ############################

pdf(paste("plots/",title,"_landfall_sp_density.pdf",sep=""), width=10, height=7)
par(mar=c(6,6,3,3))
#density(asdf, breaks=40, col='lightblue', main=paste(title," SH",sep=""), xlab="Specific Humdity")
plot(density(mland, bw=0.3), type='n', main=paste(title," SH LANDFALL",sep=""), ylim=range(0,0.35), xlim=range(0,20))
grid()
polygon(density(mland, bw=0.3), col='lightblue')
dev.off()

pdf(paste("plots/",title,"_delta_sp_density.pdf",sep=""), width=10, height=7)
par(mar=c(6,6,3,3))
plot(density(mland, bw=0.3), type='n', main=paste(title," SH DELTA",sep=""), xlab="Max SH - Landfall SH", ylim=range(0,0.35), xlim=range(0,20))
grid()
polygon(density(mland, bw=0.3), col='pink')
dev.off()
