library(SDMTools)

sh.dir='/home/jc148322/scripts/AP02/richness.sh/';dir.create(sh.dir) #dir to write sh scripts to


taxa=c('amphibians','reptiles','mammals','birds')
tax=taxa[4]
ESs=c('RCP3PD','RCP45','RCP6','RCP85')
YEARs=seq(2015,2085,10)

setwd(sh.dir)
for (es in ESs) {
	for (yr in YEARs) { cat(paste(es,' + ', yr, sep=''), '\n')
	
		
		##create the sh file
		 zz = file(paste(es,'.',yr,'.richness.sh',sep=''),'w')
			 cat('#!/bin/bash\n',file=zz)
			 cat('cd $PBS_O_WORKDIR\n',file=zz)
			 cat("R CMD BATCH --no-save --no-restore '--args es=\"",es,"\" yr=\"",yr,"\" tax=\"",tax,"\" ' ~/scripts/AP02/SDM/genus_richness.r ",es,'.',yr,'.richness.Rout \n',sep='',file=zz) #run the R script in the background
			 
		close(zz) 

		##submit the script
		system(paste('qsub -m n ',es,'.',yr,'.richness.sh',sep=''))
		

		}
	}

	

	
###current	
library(SDMTools)

sh.dir='/home/jc148322/scripts/AP02/richness.sh/';dir.create(sh.dir) #dir to write sh scripts to


taxa=c('amphibians','reptiles','mammals','birds')

yr=1990

setwd(sh.dir)

for (tax in taxa) {
	
		
		##create the sh file
		 zz = file(paste(yr,'.',tax,'.richness.sh',sep=''),'w')
			 cat('#!/bin/bash\n',file=zz)
			 cat('cd $PBS_O_WORKDIR\n',file=zz)
			 cat("R CMD BATCH --no-save --no-restore '--args yr=\"",yr,"\" tax=\"",tax,"\" ' ~/scripts/AP02/SDM/genus_richness_current.r ",yr,'.',tax,'.richness.Rout \n',sep='',file=zz) #run the R script in the background
			 
		close(zz) 

		##submit the script
		system(paste('qsub -m n ',yr,'.',tax,'.richness.sh',sep=''))
		

		}




