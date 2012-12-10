library(SDMTools)

pos = read.csv('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.positions.csv',as.is=TRUE) 

taxa=c('amphibians','reptiles','mammals')
sh.dir='/home/jc148322/scripts/AP02/pot.mat.sh/';dir.create(sh.dir) #dir to write sh scripts to

for (tax in taxa) { cat(tax, '\n')
work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species

#cycle through each of the species
for (spp in species[3:length(species)]) {
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	
	setwd(sh.dir)
	##create the sh file
	 zz = file(paste('03.',spp,'.pot.mat.sh',sep=''),'w')
		 cat('#!/bin/bash\n',file=zz)
		 cat('cd $PBS_O_WORKDIR\n',file=zz)
		 cat("R CMD BATCH --no-save --no-restore '--args spp=\"",spp,"\" spp.dir=\"",spp.dir,"\" ' ~/scripts/AP02/SDM/03.run.pot.mat.r 03.",spp,'.pot.mat.Rout \n',sep='',file=zz) #run the R script in the background
		 
	close(zz) 

	##submit the script
	system(paste('qsub -l nodes=2 -l pmem=5gb 03.',spp,'.pot.mat.sh',sep=''))
	
}
}
