library(SDMTools);library(plotrix);library(maptools)

source('/home/jc148322/scripts/libraries/cool_functions.r')

delta.dir='/home/jc148322/AP02/climate.summaries/asciis/';setwd(delta.dir)
image.dir='/home/jc148322/AP02/climate.summaries/images/';dir.create(image.dir)
base.asc = read.asc.gz('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.asc.gz') #read in the base asc file
#read in asciis
pos=make.pos(base.asc)

asciis=list.files()
files=gsub('.asc.gz','',asciis)
tfiles1=grep('RCP45',files,value=T);tfiles2=grep('RCP85',files,value=T)
files=c(tfiles1,tfiles2)

for (i in 1:length(files)) {cat(files[i],'\n')
	tasc=read.asc.gz(paste(files[i],'.asc.gz',sep=''))
	assign(files[i],tasc) #saves ascii in memory as name of file. ie. RCP3PD.10th
	pos[,files[i]]=extract.data(cbind(pos$lon,pos$lat),get(files[i]))
}

setwd(image.dir)
nrm.asc=read.asc('nrm.asc')
blank.asc=base.asc; blank.asc[which(is.na(blank.asc))]=0

pos$nrm=extract.data(cbind(pos$lon,pos$lat),nrm.asc)


region.dir=paste(image.dir, 'nrm','/',sep='');dir.create(region.dir)
regions=sort(unique(pos$nrm))
regions=regions[1:10]
polys=readShapePoly('Shapefile/NRM_Regions_2010.shp')
polys@data$nrmID=c(0:63)

cols=colorRampPalette(c("#A50026","#D73027","#F46D43","#FDAE61","#FEE090","#FFFFBF","#E0F3F8","#ABD9E9","#74ADD1","#4575B4","#313695"))(100)
cols=cols[100:1]
dim.col=adjustcolor('grey50',alpha.f=0.4)
zlim=c(-7,7)
for (r in regions[2:10]) { cat(r, '\n')
	tpoly=polys[which(polys@data$nrmID==r),]
	region.name=polys$NRM_REGION[which(polys@data$nrmID==r)]
	pos$region=NA
	pos$region[which(pos$nrm==r)]=1
	#region.asc=make.asc(pos$region)
	
	pos$mask=1
	pos$mask[which(pos$nrm==r)]=NA
	region.mask=make.asc(pos$mask)
	
	assign.list(min.lon,max.lon,min.lat,max.lat) %=% fixed.zoom(pos$region, 1, 2)
	
	if (max.lat>=-18 & min.lat<=-34 |
		max.lon>=148 & min.lon<=120 ) { 
		xlim=c(min(pos$lon),max(pos$lon)); 
		ylim=c(min(pos$lat),max(pos$lat))

	}else{ 
		xlim=c(min.lon,max.lon); 
		ylim=c(min.lat,max.lat)
	}

	
	png(paste(region.dir,'mask.',r, '.png',sep=''),width=dim(base.asc)[1]*2+30, height=dim(base.asc)[2]*3+100, units='px', pointsize=20, bg='white')
		par(mar=c(4,2,0,2),mfrow=c(2,3),cex=1,oma=c(0,3,5,1))
				mat = matrix(c (1,1,1,1,4,4,4,4,
								1,1,1,1,4,4,4,4,
								1,1,1,1,4,4,4,4,
								2,2,2,2,5,5,5,5,
								2,2,2,2,5,5,5,5,
								2,2,2,2,5,5,5,5,
								3,3,3,3,6,6,6,6,
								3,3,3,3,6,6,6,6,
								3,3,3,3,6,6,6,6,
								7,8,8,8,8,8,8,8),nr=10,nc=8,byrow=TRUE) #create a layout matrix for images
			layout(mat) #call layout as defined above

		for (i in 1:6) {

			image(blank.asc, ann=FALSE,axes=FALSE,col='grey90',xlim=xlim,ylim=ylim) 			
			image(get(files[i]), ann=FALSE,axes=FALSE,col=cols, zlim=zlim, xlim=xlim,ylim=ylim,add=TRUE)
			image(region.mask, ann=FALSE,axes=FALSE,col=dim.col, zlim=zlim,xlim=xlim,ylim=ylim,add=TRUE)
			plot(tpoly,add=TRUE,border='grey20',lwd=2)
			
			if (i==1) { mtext('Low (RCP4.5)', line=1,side=3,cex=2,font=2)
							mtext('10th percentile', line=1,side=2, cex=1.5, font=3)}
			if (i==2) { mtext('50th percentile', line=1,side=2, cex=1.5, font=3)}
			if (i==3) { mtext('90th percentile', line=1,side=2, cex=1.5, font=3)
						margin.legend(x=0,y=-5,w=50,h=5,cols=cols,text.limits=round(zlim),cex=1)} 
						
			if (i==4) { mtext('High (RCP8.5)', line=1,side=3,cex=2,font=2)}
		
		}
		par(mar=c(1,1,0,2))
		image(base.asc, ann=FALSE,axes=FALSE,col='grey70')
		plot(tpoly,add=TRUE,col="#D73027",border="#D73027")
		
		plot(1:20,axes=FALSE, ann=FALSE,type = "n")
		text(0.2, 17, 'Figure 1: Change in annual mean temperature for a low and high emissions scenario in 2085.', cex=2,pos=4)
		text(0.2, 13, 'The 10th, 50th and 90th percentiles show variation between 18 GCMs.', cex=2,pos=4)
		text(0.2, 9, 'The middle model (50th percentile) of the high emissions scenario is our best estimate of the current trajectory.', cex=2,pos=4)
		
		text(0.2, 3, paste('NRM region: ',region.name,sep=''), cex=2,pos=4)
		
	dev.off()
	
}
	

			# mat = matrix(c( 1,1,1,1,2,
						# 1,1,1,1,1,
						# 1,1,1,1,1,
						# 1,1,1,1,1),nr=4,nc=5,byrow=TRUE) #create a layout matrix for images
			# layout(mat) #call layout as defined above

	
			# par(mar=c(0,0,1,1))
			# image(base.asc, ann=FALSE,axes=FALSE,col='grey20')
			# plot(tpoly,add=TRUE,col='grey95',border='grey95')