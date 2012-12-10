library(SDMTools)

#set directories
wd='/home/jc148322/AP02/climate.summaries/pos.data/';setwd(wd)
out.dir='/home/jc148322/AP02/climate.summaries/downloadable.data/';dir.create(out.dir)

#get YEARs, ESs, GCMs 

files=list.files(pattern='RCP')
ESs=c('RCP3PD','RCP45','RCP6','RCP85')
clim.vars=c('bioclim_01','bioclim_12')
vois=c('state','nrm','ibra')

###read in es pos files and split them
for (clim.var in clim.vars){ cat(clim.var, '\n')
	
	for (voi in vois) {cat (voi, '\n')
		#set state/nrm/ibra dir
		voi.dir=paste(out.dir, voi,'/',sep=''); setwd(voi.dir)
		#identify regions
		regions=list.files()
		for (region in regions) {cat (region, '\n')
			region.dir=paste(voi.dir, region,'/',sep='');setwd(region.dir)
			tfiles=list.files(pattern=clim.var)
			climsummary=NULL
			for (es in ESs) {cat (es, '\n')
				tfile=grep(es,tfiles,value=TRUE)
				climdata=read.csv(tfile);
				
				####need to deal with current data
				if (es==ESs[1]){
				current=climdata$current
				climsummary=c('current','current',round(min(current),2),round(mean(current),2),round(max(current),2))}
				
				climdata=climdata[,-c(1:8)]
				tdata=matrix(NA,nrow=ncol(climdata),ncol=5)
				tdata[,1]=es
				tdata[,2]=colnames(climdata)
				tdata[,3]=round(apply(climdata,2,min),2)
				tdata[,4]=round(apply(climdata,2,mean),2)
				tdata[,5]=round(apply(climdata,2,max),2)
				climsummary=rbind(climsummary,tdata)					
			}
			colnames(climsummary)=c('RCP','percentile.yr','min','mean','max')
			write.csv(climsummary,paste('regional.summary.',clim.var,'.csv',sep=''),row.names=FALSE)
		}
	}
}
