#drafted by Jeremy VanDerWal ( jjvanderwal@gmail.com ... www.jjvanderwal.com )
#GNU General Public License .. feel free to use / distribute ... no warranties

################################################################################

taxa=c('amphibians','reptiles','mammals')
for (tax in taxa) { cat(tax, '\n') #BUT RUN EACH TAXA SEPERATELY, POSSIBLY BREAK IT UP MORE!
work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species

#cycle through each of the species
for (spp in species) {
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	
	zip.list = list.files(paste(spp.dir,"output/ascii/",sep='')) ; zip.list = zip.list[-grep('.gz',zip.list)]
	
	
	jj=length(list.files(paste(spp.dir,"output/ascii/",sep='')))
	
	
	if (jj>577) { cat(spp,'\n')
		
		zz = file(paste(spp.dir,'01.zip.projections.sh',sep=''),'w') #create the shell script to run the maxent model
		
			cat('#!/bin/bash\n',file=zz)
			cat('cd $PBS_O_WORKDIR\n',file=zz)
			cat('source /etc/profile.d/modules.sh\n',file=zz)
			cat('module load java\n',file=zz)
			
			cat('gzip ',spp.dir,'output/ascii/*asc\n',sep='',file=zz)
		close(zz) 

		#submit the script
		system('qsub -m n 01.zip.projections.sh')
		  }
	
}
}

######tidying reptiles.
# zip all where only some portion of the asciis have been zipped. (577-number of files = 0)
tax=taxa[2]
work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species

for (spp in species) {
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	
	zip.list = list.files(paste(spp.dir,"output/ascii/",sep='')) ; zip.list = zip.list[-grep('.gz',zip.list)]
	
	if (length(zip.list)==0) { #cat(spp, '\n')
	} else { 
	jj=length(list.files(paste(spp.dir,"output/ascii/",sep='')))
	jj=jj-577
	
	if (jj==0) { cat (paste(spp, ' zipping',sep=''),'\n')
		
		# zz = file(paste(spp.dir,'01.zip.projections.sh',sep=''),'w') #create the shell script to run the maxent model
		
			# cat('#!/bin/bash\n',file=zz)
			# cat('cd $PBS_O_WORKDIR\n',file=zz)
			# cat('source /etc/profile.d/modules.sh\n',file=zz)
			# cat('module load java\n',file=zz)
			
			# cat('gzip ',spp.dir,'output/ascii/*asc\n',sep='',file=zz)
		# close(zz) 

		##submit the script
		# system('qsub -l nodes=2 -l pmem=1gb 01.zip.projections.sh')
		 } else { }
	}
}

# 60 zipping jobs.

##deleting jobs

tax=taxa[3]
work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species

for (spp in species) {
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	
	zip.list = list.files(paste(spp.dir,"output/ascii/",sep='')) ; zip.list = zip.list[-grep('.gz',zip.list)]
	
	if (length(zip.list)==0) { cat(paste(spp, ' -- no work',sep=''),'\n')
	} else { 
	jj=length(list.files(paste(spp.dir,"output/ascii/",sep='')))
	jj=jj-577
	tt=length(zip.list)
	
	if (jj==tt) { #number of extra files is equal to number of files in zip list
		for (i in zip.list){
			unlink(paste("output/ascii/",i,sep=''))
		}
		cat(paste(spp, ' -- deleting extra asciis',sep=''),'\n')
		 } else {cat(paste(spp, ' -- no work',sep=''),'\n')}
	}
}



tax=taxa[3]
work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species

for (spp in species) {
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	
	zip.list = list.files(paste(spp.dir,"output/ascii/",sep='')) ; zip.list = zip.list[-grep('.gz',zip.list)]
	
	if (length(zip.list)==0) { #cat(spp, '\n')
	} else { 
		jj=length(list.files(paste(spp.dir,"output/ascii/",sep='')))
		jj=jj-577
		tt=length(zip.list); cat(paste(spp, " -- ",jj,'  :  ',tt, sep=''), '\n')
		
	}
}









#######tidying frogs.  delete unnecessary asciis, run pot.mat
tax=taxa[1]
work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species

#cycle through each of the species
for (spp in species) {
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	
	del.list = list.files(paste(spp.dir,"output/ascii/",sep='')) ; del.list = del.list[-grep('.gz',del.list)]
	
	if (length(del.list)==0) { cat(spp, '\n')
	} else { 
		cat (spp, '\n')
		for (i in del.list){
			tt=paste("output/ascii/",i,sep='')
			unlink(tt)
		}
	
	}
}

#run pot mat for species that do not have the files
sh.dir='/home/jc148322/scripts/AP02/pot.mat.sh/';dir.create(sh.dir) #dir to write sh scripts to
work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species

for (spp in species) {
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	
	data.list = list.files(paste(spp.dir,"output/summaries/",sep='')) ; 
	
	tt=length(data.list)
	
	if(tt<4) { cat(paste(spp, '  pot.mat running',sep=''),'\n')
	
		setwd(sh.dir)
		#create the sh file
		 zz = file(paste('03.',spp,'.pot.mat.sh',sep=''),'w')
			 cat('#!/bin/bash\n',file=zz)
			 cat('cd $PBS_O_WORKDIR\n',file=zz)
			 cat("R CMD BATCH --no-save --no-restore '--args spp=\"",spp,"\" spp.dir=\"",spp.dir,"\" ' ~/scripts/AP02/SDM/03.run.pot.mat.r 03.",spp,'.pot.mat.Rout \n',sep='',file=zz) #run the R script in the background
			 
		close(zz) 

		#submit the script
		system(paste('qsub -l nodes=2 -l pmem=2gb 03.',spp,'.pot.mat.sh',sep=''))
		
	
	} 
	
	
}
########################################################
#explore pot.mat
taxa=c('amphibians','reptiles','mammals')

tax=taxa[1]
work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species

for (spp in species) {
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	
	data.list = list.files(paste(spp.dir,"output/summaries/",sep='')) ; 
	
	tt=length(data.list)
	
	if(tt<4) { cat(paste(spp, ' -- no pot.mat ',sep=''),'\n')
	
		
	
	} else {}
	}
	
#exploring zipping/modelling
library(SDMTools)
taxa=c('amphibians','reptiles','mammals')

tax=taxa[1]
work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species


for (spp in species) {
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	
	zip.list = list.files(paste(spp.dir,"output/ascii/",sep='')) ; zip.list = zip.list[-grep('.gz',zip.list)]
	
	
		jj=length(list.files(paste(spp.dir,"output/ascii/",sep='')))
		
		tt=length(zip.list)
	if (jj !=577 & jj >0) {
		 cat(paste(spp, " -- number of files: ",jj, sep=''), '\n') } else {}
		
	

}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	



