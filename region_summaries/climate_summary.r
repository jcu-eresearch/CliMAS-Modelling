library(SDMTools)

#load climate layers
climate.dir = '/home/jc165798/Climate/CIAS/Australia/5km/bioclim_asc/'; setwd(climate.dir)
#get YEARs, ESs, GCMs 
#for now, just trial it on one layer

#load clip/summary layers

out.dir='/home/jc148322/AP02/climate.summaries/';dir.create(out.dir)

#for now, just trial it on one climate layer
tfiles=list.files(pattern='RCP')
tt = strsplit(tfiles,'_') #string split the file names
ESs = GCMs = YEARs = NULL #set all to null
for (tval in tt) { vois=c(vois,tval[1]);ESs = c(ESs,tval[1]); GCMs = c(GCMs,tval[2]); YEARs = c(YEARs, tval[3])} #extract all possible values
ESs = unique(ESs); GCMs = unique(GCMs); YEARs=unique(YEARs) #keep only unique
clim.vars=c('bioclim_01','bioclim_12')
vois=c('state','ibra')
###need to make a special table for current


#read in pos and attach data from both layers to it.
pos = read.csv('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.positions.csv',as.is=TRUE)

state.asc=read.asc("/home/jc148322/AP02/vetting_clips/state.asc")
pos$state=extract.data(cbind(pos$lon,pos$lat), state.asc)

ibra.asc=read.asc("/home/jc148322/AP02/vetting_clips/ibra.asc")
pos$ibra=extract.data(cbind(pos$lon,pos$lat), ibra.asc)

pos=na.omit(pos)

for (clim.var in clim.vars){
	for (es in ESs){ cat(es,'\n')
		for (yr in YEARs) { cat(yr,'\n')
			for (voi in vois) { cat (voi,'\n')	
				regions=unique(pos[,voi]);regions=sort(regions)
				region.mean=matrix(NA, nc=length(GCMs),nr=length(regions))
				region.min=matrix(NA, nc=length(GCMs),nr=length(regions))
				region.max=matrix(NA, nc=length(GCMs),nr=length(regions))
				
				colnames(region.mean)=GCMs; colnames(region.min)=GCMs; colnames(region.max)=GCMs;
				
				for (gcm in GCMs) { cat(gcm,'\n')
					tasc=read.asc.gz(paste(climate.dir,es,'_',gcm,'_',yr,'/',clim.var,'.asc.gz',sep=''))
					pos[,clim.var]=extract.data(cbind(pos$lon,pos$lat),tasc)
					i=1
					for (region in regions) {cat(region,'\n')
						
						tdata=pos[which(pos[,voi]==region),]
						region.mean[i,gcm]=round(mean(tdata[,clim.var]),2)
						region.min[i,gcm]=round(min(tdata[,clim.var]),2)
						region.max[i,gcm]=round(max(tdata[,clim.var]),2)
						i=i+1
					}
					
				}
				dir.create(paste(out.dir, voi,'/',es,'/',yr,sep=''),recursive=TRUE)
				rownames(region.mean)=regions; rownames(region.min)=regions; rownames(region.max)=regions;
				write.csv(region.mean, paste(out.dir, voi,'/',es,'/',yr,'/mean.absolute.',clim.var,'.csv',sep=''))
				write.csv(region.min, paste(out.dir,voi,'/',es,'/',yr,'/max.absolute.',clim.var,'.csv',sep=''))
				write.csv(region.max, paste(out.dir,voi,'/',es,'/',yr,'/min.absolute.',clim.var,'.csv',sep=''))
			}
		}
	}
}
