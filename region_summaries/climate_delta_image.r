library(SDMTools)

delta.dir='/home/jc148322/AP02/climate.summaries/asciis/';setwd(delta.dir)
image.dir='/home/jc148322/AP02/climate.summaries/images/';dir.create(image.dir)

#read in asciis

asciis=list.files()
files=gsub('.asc.gz','',asciis)

for (i in 1:length(files)) {cat(files[i],'\n')
	tasc=read.asc.gz(asciis[i])
	assign(files[i],tasc) #saves ascii in memory as name of file. ie. RCP3PD.10th
}

#create image for australia
cols=colorRampPalette(c("#A50026","#D73027","#F46D43","#FDAE61","#FEE090","#FFFFBF","#E0F3F8","#ABD9E9","#74ADD1","#4575B4","#313695"))(100)
cols=cols[100:1]
zlim=c(-7,7)


png(paste(image.dir,'test.png',sep=''),width=dim(base.asc)[1]*4+30, height=dim(base.asc)[2]*3+100, units='px', pointsize=20, bg='white')
	par(mar=c(6,1,0,1),mfrow=c(3,4),cex=1,oma=c(0,3,5,0),xpd=T)
	
	for (i in 1:12) {cat(files[i],'\n')
		image(get(files[i]),ann=FALSE,axes=FALSE, zlim=zlim, col=cols)
		if (i==1) { mtext('Extremely low', line=1,side=3,cex=2)
					mtext('10th percentile', line=1,side=2, cex=2)}
		if (i==2) { mtext('50th percentile', line=1,side=2, cex=2)}
		if (i==3) { mtext('90th percentile', line=1,side=2, cex=2)
					color.legend(par("usr")[1]+2,par("usr")[3]-4,par("usr")[1]+20,par("usr")[3]-2,c('-7','+7'),cols,cex=1.5)} 
		if (i==4) { mtext('Low', line=1,side=3,cex=2)}
		if (i==7) { mtext('Medium', line=1,side=3,cex=2)}
		if (i==10) { mtext('High', line=1,side=3,cex=2)}
	}

		
dev.off()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	