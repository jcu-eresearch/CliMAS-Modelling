library(SDMTools)
source('/home/jc148322/scripts/libraries/cool_functions.r')
out.dir='/home/jc148322/AP02/climate.summaries/downloadable.data/';dir.create(out.dir)

plot.climate=function(variable, cols, ylim, legend.pos) {
#variable is text (ie.'rainfall)
#yseq is sequence between ylims
#ny is ny in grid
#legend pos is percent down from top
ny=ylim[2]-ylim[1]
for(i in c(0.1,1,5,10,20,50,100)){
	tt=ny
	tt=tt/i
	if (tt<=10) break
	}
ny=tt	

yseq=(ylim[2]-ylim[1])/ny

tlegend=ylim[2]-legend.pos*((ylim[2]-ylim[1])/100)
blegend=ylim[2]-(legend.pos+5)*((ylim[2]-ylim[1])/100)

png(paste('absolute.climate.',clim.var,'.png',sep=''),width=16, height=6, units='cm', res=300, pointsize=5, bg='white')
par(mfrow=c(1,2),mar=c(5,5,2,1), oma=c(0,0,0,0))
	#RCP45
	plot(YEARs,RCP45.data[,2],xlab='', ylab=paste('Mean annual ',variable,sep=''), font.sub=2, font.lab=3, xlim=c(2015,2085),ylim=ylim, type='n', cex.lab=1.2, cex.axis=1, axes=F,xaxs='i',yaxs='i', col.axis='grey20')
	
	assign.list(l,r,b,t) %=% par("usr")
	rect(l, b, r, t, col = "grey90",lty=0)
	grid(nx=7,ny=ny,col='white', lty=1,lwd=0.5)
	polygon(c(YEARs, rev(YEARs)), c(RCP45.data[,1], rev(RCP45.data[,3])), col=adjustcolor(cols,alpha.f=0.5),lty=0)
	lines(YEARs,RCP45.data[,2], col='grey20')

	axis(1,YEARs,labels=YEARs,lwd=0.5,lwd.ticks=0.5,cex=1.5,col='grey20')
	axis(2,seq(ylim[1],ylim[2],yseq),labels=round(seq(ylim[1],ylim[2],yseq)),lwd=0.5,lwd.ticks=0.5,cex=1.5,col='grey20')
	
	legend(2016,tlegend, 'Best estimate (50th percentile)',lwd=1, bty='n',xjust=0)
	legend(2018,blegend, 'Variation between GCMs (10th-90th)', fill=adjustcolor(cols,alpha.f=0.5),border=adjustcolor(cols,alpha.f=0.5),bty='n')
	mtext('Low (RCP4.5)', line=3,  side=1, cex=1.5,font=2)

	#RPC85
	par(mar=c(5,3,2,3))
	plot(YEARs,RCP85.data[,2],xlab='', ylab='',  font.sub=2,xlim=c(2015,2085),ylim=ylim, type='n', cex.lab=1.5, cex.axis=1, font.lab='1',axes=F,xaxs='i',yaxs='i',col.axis='grey20')
	
	assign.list(l,r,b,t) %=% par("usr")
	rect(l, b, r, t, col = "grey90", lty=0)
	grid(nx=7,ny=ny,col='white', lty=1,lwd=0.5)
	polygon(c(YEARs, rev(YEARs)), c(RCP85.data[,1], rev(RCP85.data[,3])), col=adjustcolor(cols,alpha.f=0.5),lty=0)
	lines(YEARs,RCP85.data[,2], col='grey20')

	axis(1,YEARs,labels=YEARs,lwd=0.5,lwd.ticks=0.5,cex=1.5,col='grey20')
	axis(2,seq(ylim[1],ylim[2],yseq),labels=round(seq(ylim[1],ylim[2],yseq)),lwd=0.5,lwd.ticks=0.5,cex=1.5, col='grey20')
	mtext('High (RCP8.5)', line=3,  side=1, cex=1.5, font=2)
dev.off()

}

vois=c('state','nrm','ibra')
ESs=c('RCP45','RCP85')
YEARs=seq(2015,2085,10)
clim.vars=c('bioclim_01','bioclim_12')
cols=c('orange','dodgerblue')

for (clim.var in clim.vars){ cat(clim.var, '\n')
	
	for (voi in vois) {cat (voi, '\n')
		#set state/nrm/ibra dir
		voi.dir=paste(out.dir, voi,'/',sep=''); setwd(voi.dir)
		#identify regions
		regions=list.files()
		for (region in regions) {cat (region, '\n')
			region.dir=paste(voi.dir, region,'/',sep='');setwd(region.dir)
			climdata=read.csv(paste('regional.summary.',clim.var,'.csv',sep=''),as.is=TRUE)
			climdata=climdata[which(climdata$RCP=='RCP45' | climdata$RCP=='RCP85'),]
			climdata=climdata[,c('RCP','percentile.yr','mean')]
			
			for (es in ESs) {
				tdata=climdata[which(climdata$RCP==es),]
				for (quant in c('tenth','fiftieth','ninetieth')) {
				rois=grep(quant,tdata$percentile.yr)
				assign(paste(es,'.',quant, sep=''),tdata[rois,'mean'])
				
				}
			}
			RCP45.data=cbind(RCP45.tenth,RCP45.fiftieth,RCP45.ninetieth);colnames(RCP45.data)=c('tenth','fiftieth','ninetieth');rownames(RCP45.data)=NULL
			RCP85.data=cbind(RCP85.tenth,RCP85.fiftieth,RCP85.ninetieth);colnames(RCP85.data)=c('tenth','fiftieth','ninetieth');rownames(RCP85.data)=NULL
			
			if (clim.var==clim.vars[1]) {
				#ylim=c(round(min(climdata[,'mean'])-0.5),round(max(climdata[,'mean'])+0.5))
				plot.climate('temperature',cols[1],ylim, 1, ny=ylim[2]-ylim[1])
			}
			if (clim.var==clim.vars[2]) {
				ylim=c(round(min(climdata[,'mean'])),round(max(climdata[,'mean'])))
				ylim=padded.limits(ylim,floor.lim=0)
				
				plot.climate('rainfall',cols[2], ylim,  legend.pos=2)
			}

		}
	}
}
			

			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
