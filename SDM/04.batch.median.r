library(SDMTools)

sh.dir='/home/jc148322/scripts/AP02/median.sh/';dir.create(sh.dir) #dir to write sh scripts to


taxa=c('amphibians','reptiles','mammals')
ESs=c('RCP3PD','RCP45','RCP6','RCP85')


for (tax in taxa) { cat(tax, '\n')
	work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
	species = list.files(work.dir) #get a list of species

	#cycle through each of the species
	for (spp in species) {

		spp.dir = paste(work.dir,spp,'/output/summaries/',sep=''); setwd(spp.dir) #set the working directory to the species directory
		files=list.files();
		for (es in ESs) {
			tfile=grep(es,files,value=TRUE)
			setwd(sh.dir)
			##create the sh file
			 zz = file(paste('04.',spp,'.',es,'.median.sh',sep=''),'w')
				 cat('#!/bin/bash\n',file=zz)
				 cat('cd $PBS_O_WORKDIR\n',file=zz)
				 cat("R CMD BATCH --no-save --no-restore '--args spp=\"",spp,"\" tfile=\"",tfile,"\" work.dir=\"",work.dir,"\" es=\"",es,"\" spp.dir=\"",spp.dir,"\" ' ~/scripts/AP02/SDM/04.run.median.r 04.",spp,'.',es,'.median.Rout \n',sep='',file=zz) #run the R script in the background
				 
			close(zz) 

			##submit the script
			system(paste('qsub -m n 04.',spp,'.',es,'.median.sh',sep=''))
			

		}
	}
}




