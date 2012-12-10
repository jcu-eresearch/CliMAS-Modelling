library(SDMTools)

sh.dir='/home/jc148322/scripts/AP02/richness.sh/';dir.create(sh.dir) #dir to write sh scripts to

famdata=read.csv('/scratch/jc148322/AP02/sp_fam_class.csv',as.is=T)
tax='birds'
famdata=famdata[which(famdata$class==tax),]
families=unique(famdata$family)

ESs=c('RCP3PD','RCP45','RCP6','RCP85')
YEARs=seq(2015,2085,10)

setwd(sh.dir)
for (tfam in families[51:length(families)]){
	for (es in ESs) {
		for (yr in YEARs) { 
	
		
		##create the sh file
		 zz = file(paste(es,'.',yr,'.',tfam,'.sh',sep=''),'w')
			 cat('#!/bin/bash\n',file=zz)
			 cat('cd $PBS_O_WORKDIR\n',file=zz)
			 cat("R CMD BATCH --no-save --no-restore '--args es=\"",es,"\" yr=\"",yr,"\" tfam=\"",tfam,"\" tax=\"",tax,"\" ' ~/scripts/AP02/SDM/family_richness.r ",es,'.',yr,'.',tfam,'.Rout \n',sep='',file=zz) #run the R script in the background
			 
		close(zz) 

		##submit the script
		system(paste('qsub -m n ',es,'.',yr,'.',tfam,'.sh',sep=''))
		

		}
	}
}



###current

library(SDMTools)

sh.dir='/home/jc148322/scripts/AP02/richness.sh/';dir.create(sh.dir) #dir to write sh scripts to

famdata=read.csv('/scratch/jc148322/AP02/sp_fam_class.csv',as.is=T)
tax='birds'
famdata=famdata[which(famdata$class==tax),]
families=unique(famdata$family)
yr=1990

setwd(sh.dir)
for (tfam in families){

	
		
		##create the sh file
		 zz = file(paste(yr,'.',tfam,'.sh',sep=''),'w')
			 cat('#!/bin/bash\n',file=zz)
			 cat('cd $PBS_O_WORKDIR\n',file=zz)
			 cat("R CMD BATCH --no-save --no-restore '--args yr=\"",yr,"\" tfam=\"",tfam,"\" tax=\"",tax,"\" ' ~/scripts/AP02/SDM/family_richness_current.r ",yr,'.',tfam,'.Rout \n',sep='',file=zz) #run the R script in the background
			 
		close(zz) 

		##submit the script
		system(paste('qsub -m n ',yr,'.',tfam,'.sh',sep=''))


}
