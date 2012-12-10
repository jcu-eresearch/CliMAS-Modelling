library(rjson)
wd='/home/jc148322/AP02/climate.summaries/downloadable.data/';setwd(wd)
regions=list.files()
clim.vars=c('temperature','rainfall')
YEARs=c('current',seq(2015,2085,10))
#climate_json
for (r in regions){ cat(r,'\n')
	region.dir=paste(wd,r,'/',sep=''); setwd(region.dir)
	json.data=c('(Region long name)','(Region short name)','Region URL','Report Year')
	json.data=t(as.data.frame(json.data))
	colnames(json.data)=c('rg_long_name','rg_short_name','rg_url','year')
	
	#climate summary as json
	for (clim.var in clim.vars) {
		d=read.csv(paste('regional.summary.',clim.var,'.csv',sep=''))
		tdata=d[which(d$RCP=='RCP45' | d$RCP=='RCP85' | d$RCP=='current'),]
		tdata$d_up=tdata$mean-tdata$mean[1]
		tdata$d_down=-tdata$d_up; tdata$d_down[which(tdata$d_down<0)]=0
		tdata$d_up[which(tdata$d_up<0)]=0
		
		tdata$RCP=gsub('RCP45','low',tdata$RCP)
		tdata$RCP=gsub('RCP85','high',tdata$RCP)
		tdata$percentile.yr=as.character(tdata$percentile.yr)
		tt=strsplit(tdata$percentile.yr, '\\.')
		tdata$percentile=sapply(tt,'[',1)
		tdata$yr=sapply(tt,'[', 3)
		tdata=tdata[,c(1,9,8,3,4,5,6,7)]
		dmin=tdata[,c(1:4)]; dmin$stat='min'; colnames(dmin)[4]='value'
		dmean=tdata[,c(1:3,5)]; dmean$stat='mean'; colnames(dmean)[4]='value'
		dmax=tdata[,c(1:3,6)]; dmax$stat='max'; colnames(dmax)[4]='value'
		d_up=tdata[,c(1:3,7)];d_up$stat='d_up'; colnames(d_up)[4]='value'
		d_down=tdata[,c(1:3,8)];d_down$stat='d_down'; colnames(d_down)[4]='value'
		d=rbind(dmin,dmean,dmax,d_up,d_down); d=d[,c(1,2,3,5,4)]
		d$label=sapply(c(1:nrow(d)),function(x) {return(paste(clim.var,d[x,1],d[x,2],d[x,3],d[x,4],sep='_'))})
		d$label=gsub('current_NA_current','current',d$label)
		d=d[,c(6,round(5,digits=2))]
		tt=data.frame(t(d[,2]))
		colnames(tt)=d[,1]
		
		json.data=cbind(json.data,tt)
		
		
	}
	
	#species summary as json
	spdata=read.csv('biodiversity.summary.csv',as.is=T)
	spdata$RCP=gsub('RCP45','low',spdata$RCP)
	spdata$RCP=gsub('RCP85','high',spdata$RCP)
	d=NULL
	for (yr in YEARs){
		coi=grep(yr,colnames(spdata))
		coi=c(1,2,3,coi)
		yrdata=spdata[,coi]
		yrdata$yr=yr
		yrdata=yrdata[,c(1,2,3,5,4)]
		colnames(yrdata)[5]='count'
		if(yr=='current') {yrdata=yrdata[which(yrdata$outcome=='total'),] 
		} else {
			delta.low=yrdata[14,5]-yrdata[15,5]
			if (delta.low<0) {
				low_d_up=0; low_d_down=-delta.low
				} else {
				low_d_up=delta.low; low_d_down=0}

			delta.high=yrdata[30,5]-yrdata[31,5]
			if (delta.high<0) {
				high_d_up=0; high_d_down=-delta.high
				} else {
				high_d_up=delta.high; high_d_down=0}
		
		yrdata=rbind(yrdata,c('low','delta','up',yr,low_d_up))
		yrdata=rbind(yrdata,c('low','delta','down',yr,low_d_down))
		yrdata=rbind(yrdata,c('high','delta','up',yr,high_d_up))
		yrdata=rbind(yrdata,c('high','delta','down',yr,high_d_down))
		}
		d=rbind(d,yrdata)
	}
	d$label=sapply(c(1:nrow(d)),function(x) {return(paste(d[x,1],d[x,2],d[x,3],d[x,4],sep='_'))})
	d=d[,c(6,5)]
	tt=data.frame(t(d[,2]))
	colnames(tt)=d[,1]
	json.data=cbind(json.data,tt)
	
	json.data=as.list(json.data)
	json.data=lapply(json.data,function(x) {format(x)})
	json.data=lapply(json.data,as.character)
	json.data=toJSON(json.data)	
	
	
	zz = file('data.json','w')
		cat(json.data,file=zz)
	close(zz)
}

