#make climate pos
library(SDMTools)

#set directories
clim.dir = '/home/jc165798/Climate/CIAS/Australia/5km/bioclim_asc/'; setwd(clim.dir)
out.dir='/home/jc1es8322/AP02/climate.summaries/pos.data/';dir.create(out.dir)

#get YEARs, ESs, GCMs 

files=list.files(pattern='RCP')
tt = strsplit(files,'_') #string split the file names
ESs = GCMs = YEARs = vois = NULL #set all to null
for (tval in tt) { vois=c(vois,tval[1]);ESs = c(ESs,tval[1]); GCMs = c(GCMs,tval[2]); YEARs = c(YEARs, tval[3])} #extract all possible values
ESs = unique(ESs); GCMs = unique(GCMs); YEARs=unique(YEARs) #keep only unique
clim.vars=c('bioclim_01','bioclim_12')

###read in pos
pos = read.csv('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.positions.csv',as.is=TRUE)
region.pos=pos
###read in region asciis
setwd('/home/jc148322/AP02/climate.summaries/region_layers/')
vois=c('state','nrm','ibra')
for (voi in vois) { cat(voi,'\n')
	region.pos[,voi]=extract.data(cbind(pos$lon,pos$lat),read.asc(paste(voi,'.asc',sep='')))
}

#make a pos file of percentile and yr combinations for each RCP, for each bioclim
for (clim.var in clim.vars){ cat(clim.var, '\n')
	for (es in ESs) { cat(es, '\n')
		es.pos=region.pos
		#read in current data
		es.pos$current=extract.data(cbind(pos$lon,pos$lat),read.asc.gz(paste(clim.dir,'current.76to05/',clim.var,'.asc.gz', sep='')))

		tfiles=grep(es,files,value=T)
		for (yr in YEARs) {cat (es,'\n')
			yr.pos=pos
			asc.dirs=grep(yr,tfiles,value=T)
			
			for (gcm in GCMs) {cat(gcm, '\n')
				wd=grep(gcm,asc.dirs,value=T); setwd(paste(clim.dir,wd, '/',sep=""))				
				yr.pos[,gcm]=extract.data(cbind(pos$lon, pos$lat),read.asc.gz(paste(clim.var,'.asc.gz',sep='')))
			}
			out.quant=t(apply(yr.pos[,6:ncol(yr.pos)],1,function(x) { return(quantile(x,c(0.1,0.5,0.9),na.rm=TRUE,type=8)) }))
			colnames(out.quant)=c(paste('tenth.percentile.',yr,sep=''),paste('fiftieth.percentile.',yr,sep=''),paste('ninetieth.percentile.',yr,sep=''))
			es.pos=cbind(es.pos,out.quant)
		}
		
		write.csv(es.pos,paste(out.dir, es,'.',clim.var,'.csv',sep=''),row.names=F)
	}
	}
		