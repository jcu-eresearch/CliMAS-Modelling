library(SDMTools)

sh.dir='/home/jc148322/scripts/AP02/species_summary.sh/';dir.create(sh.dir) #dir to write sh scripts to

taxa=c('amphibians','reptiles','mammals')

for (tax in taxa[2:3]) {
	
	work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
	species = list.files(work.dir) #get a list of species
		
	for (spp in species) {
		
		setwd(sh.dir)
			##create the sh file
			 zz = file(paste('05.',spp,'.summary.sh',sep=''),'w')
				 cat('#!/bin/bash\n',file=zz)
				 cat('cd $PBS_O_WORKDIR\n',file=zz)
				 cat("R CMD BATCH --no-save --no-restore '--args spp=\"",spp,"\" work.dir=\"",work.dir,"\" ' ~/scripts/AP02/SDM/05.run.speciesdata.r 05.",spp,'.summary.Rout \n',sep='',file=zz) #run the R script in the background
				 
			close(zz) 

			##submit the script
			system(paste('qsub -m n 05.',spp,'.summary.sh',sep=''))
			
		
	}
}
