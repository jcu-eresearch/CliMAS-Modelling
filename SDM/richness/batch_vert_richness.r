library(SDMTools)

sh.dir='/home/jc148322/scripts/AP02/richness.sh/';dir.create(sh.dir) #dir to write sh scripts to

ESs=c('RCP3PD','RCP45','RCP6','RCP85')
YEARs=seq(2015,2085,10)

setwd(sh.dir)
for (es in ESs) {
	for (yr in YEARs) { cat(paste(es,' + ', yr, sep=''), '\n')
	
		
		##create the sh file
		 zz = file(paste(es,'.',yr,'.verts.sh',sep=''),'w')
			 cat('#!/bin/bash\n',file=zz)
			 cat('cd $PBS_O_WORKDIR\n',file=zz)
			 cat("R CMD BATCH --no-save --no-restore '--args es=\"",es,"\" yr=\"",yr,"\" ' ~/scripts/AP02/SDM/vert_richness.r ",es,'.',yr,'.verts.Rout \n',sep='',file=zz) #run the R script in the background
			 
		close(zz) 

		##submit the script
		system(paste('qsub -m n ',es,'.',yr,'.verts.sh',sep=''))
		

		}
	}


###current
yr=1990	
##create the sh file
		 zz = file(paste(yr,'.verts.sh',sep=''),'w')
			 cat('#!/bin/bash\n',file=zz)
			 cat('cd $PBS_O_WORKDIR\n',file=zz)
			 cat("R CMD BATCH --no-save --no-restore '--args yr=\"",yr,"\" ' ~/scripts/AP02/SDM/vert_richness.r ",yr,'.verts.Rout \n',sep='',file=zz) #run the R script in the background
			 
		close(zz) 

		##submit the script
		system(paste('qsub -m n ',yr,'.verts.sh',sep=''))
		