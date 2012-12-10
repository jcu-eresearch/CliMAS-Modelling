


plot.climate=function(variable, cols, ylim, yseq, ny, legend.pos) {
#variable is text (ie.'rainfall)
#yseq is sequence between ylims
#ny is ny in grid
#legend pos is percent down from top
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


#rainfall
plot.climate('rainfall',cols[2], ylim, 100, ny=7, legend.pos=2)

#temperature
plot.climate('temperature',cols[1],ylim, 1, ny=ylim[2]-ylim[1])


#ylim possibilities
limits=c(min(climdata[,3:ncol(climdata)]),max(climdata[,3:ncol(climdata)]))

padded.limits=function(limits, floor.lim=-Inf, ceiling.lim=Inf) {

	ldiff=limits[2]-limits[1]
	
	lmin=limits[1]
	lmax=limits[2]
	
	if (ldiff<=2){
		lims=c(round(lmin-0.05,1),round(lmax+0.05,1)) } #round to 0.1
	if (ldiff>2 & ldiff<=10){
		lims=c(round(lmin-0.5),round(lmax+0.5)) }#round to 1
	if (ldiff>10 & ldiff<=50){
		lims=c(round((lmin-2.5)*2,-1)/2,round((lmax+2.5)*2,-1)/2) }#round to 5
	if (ldiff>50 & ldiff<=100){
		lims=c(round(lmin-5,-1),round(lmax+5,-1))} #round to 10
	if (ldiff>100 & ldiff<=200){
		lims=c(round((lmin-10)*5,-2)/5,round((lmax+10)*5,-2)/5) }#round to 20
	if (ldiff>200 & ldiff<=500) {
		lims=c(round((lmin-25)*2,-2)/2,round((lmax+25)*2,-2)/2) }#round to 50
	if (ldiff>500) {
		lims=c(round(lmin-50,-2)/2,round(lmax+50,-2)/2) }#round to 100
			
	if (lims[1]<floor.lim) { lims[1]=floor.lim }
	if (lims[2]>ceiling.lim) { lims[2]=ceiling.lim }
	
return(lims)}

ylim=padded.limits(limits,floor.lim=0)





























