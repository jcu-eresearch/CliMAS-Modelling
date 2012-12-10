library(SDMTools);library(plotrix)

delta.dir='/home/jc148322/AP02/climate.summaries/asciis/';setwd(delta.dir)
image.dir='/home/jc148322/AP02/climate.summaries/images/';dir.create(image.dir)
base.asc = read.asc.gz('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.asc.gz') #read in the base asc file
#read in asciis


files=gsub('.asc.gz','',asciis)
tfiles1=grep('RCP45',files,value=T);tfiles2=grep('RCP85',files,value=T)
files=c(tfiles1,tfiles2)

for (i in 1:length(files)) {cat(files[i],'\n')
	tasc=read.asc.gz(paste(files[i],'.asc.gz',sep=''))
	assign(files[i],tasc) #saves ascii in memory as name of file. ie. RCP3PD.10th
}

#create image for australia
cols=colorRampPalette(c("#A50026","#D73027","#F46D43","#FDAE61","#FEE090","#FFFFBF","#E0F3F8","#ABD9E9","#74ADD1","#4575B4","#313695"))(100)
cols=cols[100:1]
zlim=c(-7,7)

	
dev.off()

#trial it on a subregion	
# state=read.asc("/home/jc148322/AP02/vetting_clips/state.asc")
# ibra=read.asc("/home/jc148322/AP02/vetting_clips/ibra.asc")
# vois=c('state', 'ibra')
# for (voi in vois) { cat(voi,'\n')
	# regions=unique(get(voi));regions=sort(regions)
	# for (region in regions) { cat(region,'\n')
		
		png(paste(image.dir,'test2.png',sep=''),width=dim(base.asc)[1]*2+30, height=dim(base.asc)[2]*3+100, units='px', pointsize=20, bg='white')
			par(mar=c(6,1,0,1),mfrow=c(2,3),cex=1,oma=c(0,3,5,0),xpd=T)
				mat = matrix(c (1,4,
								2,5,
								3,6),nr=3,nc=2,byrow=TRUE) #create a layout matrix for images
			layout(mat) #call layout as defined above

			for (i in 1:6) {cat(files[i],'\n')
				
				image(get(files[i]),ann=FALSE,axes=FALSE, zlim=zlim, col=cols)
				if (i==1) { mtext('Medium (RCP4.5)', line=1,side=3,cex=2,font=2)
							mtext('10th percentile', line=1,side=2, cex=1.5, font=3)}
				if (i==2) { mtext('50th percentile', line=1,side=2, cex=1.5, font=3)}
				if (i==3) { mtext('90th percentile', line=1,side=2, cex=1.5, font=3)
							color.legend(par("usr")[1]+2,par("usr")[3]-4,par("usr")[1]+20,par("usr")[3]-2,c('-7','+7'),cols,cex=1.5)} 
							
				if (i==4) { mtext('High (RCP8.5)', line=1,side=3,cex=2,font=2)}
			}		
		dev.off()
	
	# }
# }
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	