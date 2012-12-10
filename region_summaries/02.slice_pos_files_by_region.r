#make climate pos
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
	for (es in ESs) { cat(es, '\n')
		#load pos file
		es.pos=read.csv(paste(es,'.',clim.var,'.csv',sep=''),as.is=TRUE)
		for (voi in vois) {cat (voi, '\n')
			#create state/nrm/ibra dir
			voi.dir=paste(out.dir, voi,'/',sep=''); dir.create(voi.dir)
			#will use voi column to subset data
			
			#identify regions
			regions=sort(unique(es.pos[,voi],na.rm=T))
			for (region in regions) {cat (region, '\n')
				#create region dir
				region.dir=paste(voi.dir, region,'/',sep=''); dir.create(region.dir)
				#subset pos by region
				tpos=es.pos[which(es.pos[,voi]==region),]
				#write subset to new directory
				write.csv(tpos, paste(region.dir, es,'.',clim.var,'.csv', sep=''),row.names=FALSE)
			}
		}
	}
}
