
library(SDMTools); library(maptools)

#set directories
wd='/home/jc148322/AP02/climate.summaries/downloadable.data/';setwd(wd)
layer.dir='/home/jc148322/AP02/climate.summaries/region_layers/'


vois=c('state','nrm','ibra')
region.types=c('State','NRM','IBRA')
i=0
for (voi in vois) {
i=i+1
	#setstate/nrm/ibra dir
	voi.dir=paste(wd, voi,'/',sep=''); setwd(voi.dir)
	
	if (voi=='state') { tdata=read.dbf(paste(layer.dir,'Shapefile/STE11aAust.dbf',sep=''))}
	if (voi=='nrm') {   tdata=read.dbf(paste(layer.dir,'Shapefile/NRM_Regions_2010.dbf',sep=''))
						tdata$nrm=seq(0,63,1)
						}
	if (voi=='ibra') {  tdata=read.dbf(paste(layer.dir,'Shapefile/IBRA7_regions.dbf',sep=''))}

	regions=list.files()
	for (region in regions) {
		if (voi=='state') { region.name=tdata$STATE_NAME[which(tdata$STATE_CODE==region)]    }
		if (voi=='nrm')   { region.name=tdata$NRM_REGION[which(tdata$nrm==region)]    }
		if (voi=='ibra')  { region.name=tdata$REG_NAME_7[which(tdata$OBJECTID==region)]    }

		id=paste(region.types[i],' ',region.name,sep='')
		id=gsub(' ','_',id)
		
		region.dir=paste(voi.dir, region,'/',sep='') #name region dir
		system(paste('mv ', region.dir,' ', wd, id, sep=''))
		#cat(paste('mv ', region.dir,' ', wd, id, sep=''),'\n')
		#cat(id,'\n')
	}
}


#### renaming files

setwd(wd)
dirs=list.files()


for (d in dirs) {
	region.dir=paste(wd, d, '/', sep=''); setwd(region.dir)
	
	files=list.files()
	file.names=gsub('bioclim_01','temperature',files)
	file.names=gsub('bioclim_12','rainfall',file.names)
	
	for (i in 1:length(files)){
		# system(paste('mv ', wd, files[i],' ', wd, file.names[i], sep=''))
		system(paste('mv ', region.dir, files[i],' ', region.dir, file.names[i], sep=''))
	
	}

}
