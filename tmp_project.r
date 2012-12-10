mxe.dir = '/home/jc165798/Climate/CIAS/Australia/5km/bioclim_mxe/'
maxent.jar = "/home/jc165798/working/NARP_birds/maxent.jar"

################################################################################
#list the projections, cycle thorugh them and project the models onto them
proj.list = list.files(mxe.dir) #list the projections
current = grep('1990',proj.list,value=TRUE)
proj.list = c(current,grep('RCP',proj.list, value=TRUE)) #subset it to simply current and 2080 data
species.data=read.csv('/home/jc148322/AP02/vetting_clips/clipaction.csv',as.is=TRUE)
species.data=species.data[which(species.data$clipaction=='state_mask'),]#get the unique species numbers

taxa=c('amphibians','reptiles','mammals')
for (tax in taxa[2:3]) { cat(tax, '\n')
work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
#species = list.files(work.dir) #get a list of species
species=species.data$Species[which(species.data$Class==tax)]
#cycle through each of the species
for (spp in species) {
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	sppcode=list.files('output/',pattern='.lambdas');sppcode=strsplit(sppcode,'\\.')[[length(sppcode)]][1]
	zz = file('02.project.models.sh','w') ##create the sh file
		cat('#!/bin/bash\n',file=zz)
		cat('cd $PBS_O_WORKDIR\n',file=zz)
		cat('source /etc/profile.d/modules.sh\n',file=zz)
		cat('module load java\n',file=zz)
		dir.create('output/ascii/',recursive=TRUE) #create the output directory for all maps
		#cycle through the projections
		for (tproj in proj.list) cat('java -mx1024m -cp ',maxent.jar,' density.Project ',spp.dir,'output/',sppcode,'.lambdas ',mxe.dir,tproj,' ',spp.dir,'output/ascii/',tproj,'.asc fadebyclamping nowriteclampgrid\n',sep="",file=zz)
		cat('gzip ',spp.dir,'output/ascii/*asc\n',sep='',file=zz)
	close(zz) 

	#submit the script
	system('qsub -m n 02.project.models.sh')
}
}