#drafted by Jeremy VanDerWal ( jjvanderwal@gmail.com ... www.jjvanderwal.com )
#GNU General Public License .. feel free to use / distribute ... no warranties

################################################################################
library(SDMTools) #load the necessary libraries

wd = '/home/jc148322/AP02/working.data/'; setwd(wd) #define and set theworking directory
climate.dir = '/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/bioclim/' #define the climate directory
species.data=read.csv('/home/jc148322/AP02/vetting_clips/clipaction_final.csv',as.is=TRUE)
taxa=c('amphibians','reptiles','mammals')


clim.vars = paste('bioclim_',sprintf('%02i',c(1,4,5,6,12,15,16,17)),sep='') #define the climate variables of interest
bioclim_01=read.asc.gz(paste(climate.dir,clim.vars[1],'.asc.gz',sep=''))
bioclim_04=read.asc.gz(paste(climate.dir,clim.vars[2],'.asc.gz',sep=''))
bioclim_05=read.asc.gz(paste(climate.dir,clim.vars[3],'.asc.gz',sep=''))
bioclim_06=read.asc.gz(paste(climate.dir,clim.vars[4],'.asc.gz',sep=''))
bioclim_12=read.asc.gz(paste(climate.dir,clim.vars[5],'.asc.gz',sep=''))
bioclim_15=read.asc.gz(paste(climate.dir,clim.vars[6],'.asc.gz',sep=''))
bioclim_16=read.asc.gz(paste(climate.dir,clim.vars[7],'.asc.gz',sep=''))
bioclim_17=read.asc.gz(paste(climate.dir,clim.vars[8],'.asc.gz',sep=''))

for (tax in taxa) { cat (tax, '\n')
species=species.data$species[which(species.data$class==tax)]
#make the background points file
bkgd = read.csv(paste('/home/jc148322/AP02/',tax,'.bkgd.csv',sep=''),as.is=TRUE) #read in the background data

bkgd$LATDEC = round(bkgd$LATDEC/0.05)*0.05 #round latitude to 0.05 degrees
bkgd$LONGDEC = round(bkgd$LONGDEC/0.05)*0.05 #round Longitude to 0.05 degrees

bkgd = bkgd[,c('SPPCODE','LATDEC','LONGDEC')] #keep only columns of interest
nrow(bkgd); bkgd = unique(bkgd); nrow(bkgd) #keep only unique info

for (clim.var in clim.vars) { cat(clim.var,'\n') #cycle through each of hte climate variables
	bkgd[,clim.var] = extract.data(cbind(bkgd$LONGDEC,bkgd$LATDEC), get(clim.var)) #append the climate data
}
bkgd = na.omit(bkgd); #remove missing data
#write.csv(bkgd,paste('/scratch/jc148322/AP02/',tax,'/target_group_bkgd.csv',sep=''),row.names=FALSE); rm(bkgd) #write out the file and remove it from memory

tax.dir=paste('/scratch/jc148322/AP02/',tax, '/',sep="");setwd(tax.dir)
for (spp in species) {  cat(spp,'\n')#cycle through each of the species numbers
	toccur = read.csv(paste(wd,spp,'.csv',sep=''),as.is=TRUE) #get the observations for the species
	toccur = toccur[which(toccur$UNCERTAINTY<=25000 | is.na(toccur$UNCERTAINTY)),] #keep only things with <20km accuracy
	tdata=species.data[which(species.data$species==spp),]
	if (tdata$clipaction=='rm_pre1950') {
		d = format(toccur$DATE)
		d = as.numeric(substr(d,1,4))
		pre1950 = d<=1950
		toccur = subset(toccur[c('SPPCODE','LONGDEC','LATDEC')], pre1950 == FALSE)
		}else{toccur=toccur}		

	toccur$LATDEC = round(toccur$LATDEC/0.05)*0.05; 
	toccur$LONGDEC = round(toccur$LONGDEC/0.05)*0.05; 

	toccur = toccur[,c('SPPCODE','LATDEC','LONGDEC')] #keep only columns of interest
	nrow(toccur); toccur = unique(toccur); nrow(toccur) #keep only unique info
	
	if (tdata$clipaction=='ibra') {
		clipasc=read.asc.gz(paste('/home/jc148322/AP02/vetting_clips/ibra/',spp,'.bioregion.clip.asc.gz',sep=''))
		toccur$clip=extract.data(cbind(toccur$LONGDEC,toccur$LATDEC),clipasc)
		toccur=toccur[which(toccur$clip==1),] #wonder if na.omit does the same job
		}else {toccur=toccur}
	if (tdata$clipaction=='state_then_ibra') {
		clipasc=read.asc.gz(paste('/home/jc148322/AP02/vetting_clips/ibra/',spp,'.bioregion.clip.asc.gz',sep=''))
		toccur$clip=extract.data(cbind(toccur$LONGDEC,toccur$LATDEC),clipasc)
		toccur=toccur[which(toccur$clip==1),] #wonder if na.omit does the same job
		}else {toccur=toccur}
	if (tdata$clipaction=='state_mask') {
		clipasc=read.asc.gz(paste('/home/jc148322/AP02/vetting_clips/state/',spp,'.bioregion.clip.asc.gz',sep=''))
		toccur$clip=extract.data(cbind(toccur$LONGDEC,toccur$LATDEC),clipasc)
		toccur=toccur[which(toccur$clip==1),] #wonder if na.omit does the same job
		}else {toccur=toccur}
	
		
	toccur=toccur[,c(1:3)]
	if (nrow(toccur)<10){ 
	} else  {
		for (clim.var in clim.vars) { cat(clim.var,'\n') #cycle through each of hte climate variables
		toccur[,clim.var] = extract.data(cbind(toccur$LONGDEC,toccur$LATDEC), get(clim.var)) #append the climate data
		}
		toccur=na.omit(toccur)
		
		spp.dir = paste(tax.dir,'models/',spp,'/',sep='') #define the species directory
		dir.create(paste(spp.dir,'output',sep=''),recursive=TRUE) #create the species directory
		write.csv(toccur,paste(spp.dir,'occur.csv',sep=''),row.names=FALSE) #write out the file and remove it from memory
		zz = file(paste(spp.dir,'01.create.model.sh',sep=''),'w') #create the shell script to run the maxent model
			cat('#!/bin/bash\n',file=zz)
			cat('cd $PBS_O_WORKDIR\n',file=zz)
			cat('source /etc/profile.d/modules.sh\n',file=zz)
			cat('module load java\n',file=zz)
			cat('java -mx1024m -jar ',tax.dir,'maxent.jar -e ',tax.dir,'target_group_bkgd.csv -s occur.csv -o output nothreshold nowarnings novisible replicates=10 nooutputgrids -r -a \n',sep="",file=zz)
			cat('cp -af output/maxentResults.csv output/maxentResults.crossvalide.csv\n',file=zz)
			cat('java -mx1024m -jar ',tax.dir,'maxent.jar -e ',tax.dir,'target_group_bkgd.csv -s occur.csv -o output nothreshold nowarnings novisible nowriteclampgrid nowritemess writeplotdata -P -J -r -a \n',sep="",file=zz)
		close(zz) 
		setwd(spp.dir); system(paste('qsub -m n -N ',spp,' 01.create.model.sh',sep='')); setwd(tax.dir) #submit the script	
	}
}
}
