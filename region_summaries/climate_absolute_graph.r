library(SDMTools)
source('/home/jc148322/scripts/libraries/cool_functions.r')
image.dir='/home/jc148322/AP02/climate.summaries/images/'
region='state';
ESs=c('RCP45','RCP85')
YEARs=seq(2015,2085,10)

for (es in ESs) {cat (es,'\n')
	wd=paste('/home/jc148322/AP02/climate.summaries/',region,'/',es,'/',sep='')
	
	tdata=matrix(NA,nc=4,nr=length(YEARs))
	colnames(tdata)=c('yr','ten','fifty','ninety')
	tdata[,1]=YEARs

	i=1
	for (yr in YEARs) { cat(yr,'\n')
		setwd(paste(wd,'/',yr,sep=''))
		temp.data=read.csv('mean.absolute.bioclim_01.csv',as.is=T)
		tdata[i,2:4]=t(apply(temp.data[1,],1,function(x) { return(quantile(x,c(0.1,0.5,0.9),na.rm=TRUE,type=8)) }))
		
		i=i+1
	}
	assign(paste(es,'.data',sep=''),tdata)
}


ylim=c(round(min(tdata[,2:4])-0.5),round(max(tdata[,2:4])+0.5))

png(paste(image.dir,'graph.test.png',sep=''),width=16, height=6, units='cm', res=300, pointsize=5, bg='white')
par(mfrow=c(1,2),mar=c(5,5,2,1), oma=c(0,0,0,0))
	#RCP45
	plot(RCP45.data[,1],RCP45.data[,3],xlab='', ylab='Mean annual temperature', font.sub=2, font.lab=3, xlim=c(2015,2085),ylim=ylim, type='n', cex.lab=1.2, cex.axis=1, axes=F,xaxs='i',yaxs='i', col.axis='grey20')
	
	assign.list(l,r,b,t) %=% par("usr")
	rect(l, b, r, t, col = "grey90",lty=0)
	grid(nx=7,ny=ylim[2]-ylim[1],col='white', lty=1,lwd=0.5)
	polygon(c(RCP45.data[,1], rev(RCP45.data[,1])), c(RCP45.data[,2], rev(RCP45.data[,4])), col=adjustcolor('orange',alpha.f=0.5),lty=0)
	lines(RCP45.data[,1],RCP45.data[,3], col='grey20')

	axis(1,YEARs,labels=YEARs,lwd=0.5,lwd.ticks=0.5,cex=1.5,col='grey20')
	axis(2,seq(ylim[1],ylim[2],1),labels=round(seq(ylim[1],ylim[2],1)),lwd=0.5,lwd.ticks=0.5,cex=1.5,col='grey20')
	
	legend(2016,ylim[2]-0.05, 'Best estimate (50th percentile)',lwd=1, bty='n',xjust=0)
	legend(2018,ylim[2]-0.45, 'Variation between GCMs (10th-90th)', fill=adjustcolor('orange',alpha.f=0.5),border=adjustcolor('orange',alpha.f=0.5),bty='n')
	mtext('Low (RCP4.5)', line=3,  side=1, cex=1.5,font=2)

	#RPC85
	par(mar=c(5,3,2,3))
	plot(RCP85.data[,1],RCP85.data[,3],xlab='', ylab='',  font.sub=2,xlim=c(2015,2085),ylim=ylim, type='n', cex.lab=1.5, cex.axis=1, font.lab='1',axes=F,xaxs='i',yaxs='i',col.axis='grey20')
	
	assign.list(l,r,b,t) %=% par("usr")
	rect(l, b, r, t, col = "grey90", lty=0)
	grid(nx=7,ny=ylim[2]-ylim[1],col='white', lty=1,lwd=0.5)
	polygon(c(RCP85.data[,1], rev(RCP85.data[,1])), c(RCP85.data[,2], rev(RCP85.data[,4])), col=adjustcolor('orange',alpha.f=0.5),lty=0)
	lines(RCP85.data[,1],RCP85.data[,3], col='grey20')

	axis(1,YEARs,labels=YEARs,lwd=0.5,lwd.ticks=0.5,cex=1.5,col='grey20')
	axis(2,seq(ylim[1],ylim[2],1),labels=round(seq(ylim[1],ylim[2],1)),lwd=0.5,lwd.ticks=0.5,cex=1.5, col='grey20')
	mtext('High (RCP8.5)', line=3,  side=1, cex=1.5, font=2)
dev.off()




RCP45.data=as.data.frame(RCP45.data)
RCP85.data=as.data.frame(RCP85.data)

png(paste(image.dir,'graph.test2.png',sep=''),width=18, height=7, units='cm', res=300, pointsize=10, bg='white')

	tplot <- ggplot(RCP45.data, aes(x=yr, ymin=ylim[1],ymax=ylim[2]))
	plot45 <- tplot + geom_ribbon(ymin=RCP45.data$ten, ymax=RCP45.data$ninety,fill='orange',alpha='0.5') + geom_line(aes(y=fifty)) + xlab('Year') + ylab('Mean annual temperature')
	
	tplot <- ggplot(RCP85.data, aes(x=yr,ymin=ylim[1],ymax=ylim[2]))
	plot85 <- tplot + geom_ribbon(ymin=RCP85.data$ten, ymax=RCP85.data$ninety,fill='orange',alpha='0.5') + geom_line(aes(y=fifty)) + xlab('Year') + ylab('Mean annual temperature')
	
	arrange_ggplot2(plot45,plot85,ncol=2)
	dev.off()
	
	
	tplot <- ggplot(tt, aes(x=yr))
	tplot + geom_ribbon(aes(ymin=ten, ymax=ninety)) + geom_line(aes(y=fifty)) + xlab('new xlab')
	