
library(SDMTools)

taxa=c('amphibians','reptiles','mammals')

actionlist=NULL

for (tax in taxa) { cat(tax, '\n') #BUT RUN EACH TAXA SEPERATELY, POSSIBLY BREAK IT UP MORE!
work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species
taxa.action=matrix(NA,nr=length(species),nc=3)

i=1
#cycle through each of the species
for (spp in species) { cat(spp, '\n')
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	
	toccur=read.csv('occur.csv')
	
	if (nrow(toccur)>=10) {
		action='modelled'
		taxa.action[i,]=c(spp, tax, action)
	} else {
		#delete ascii folder
		wd=paste(spp.dir,'/output/',sep='');setwd(wd)
		
		asc.dir=list.files(pattern='ascii')
		unlink(asc.dir, recursive=T)
		action='not_modelled'
		taxa.action[i,]=c(spp, tax, action)
	
	}
	i=i+1
}
actionlist=rbind(actionlist,taxa.action)

}
colnames(actionlist)=c('species','class','action')
write.csv(actionlist, '/scratch/jc148322/AP02/actionlist.csv',row.names=FALSE)



library(SDMTools)

taxa=c('amphibians','reptiles','mammals')

tax=taxa[3]

work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species

not.modelled=NULL
#cycle through each of the species
for (spp in species) { 
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	
	toccur=read.csv('occur.csv')
	
	if (nrow(toccur)>=10) {
		
	} else {
		
		not.modelled=c(not.modelled,spp)
	}
	
}

#####################################
#delete not modelled asciis and summaires
library(SDMTools)

taxa=c('amphibians','reptiles','mammals')
tax=taxa[3]

work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species

#cycle through each of the species
for (spp in species) { cat(spp, '\n')
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	
	toccur=read.csv('occur.csv')
	
	if (nrow(toccur)>=10) {

	} else { cat(spp, '\n')
		#delete ascii folder
		wd=paste(spp.dir,'/output/',sep='');setwd(wd)
		
		asc.dir=list.files(pattern='ascii')
		unlink(asc.dir, recursive=T)
		
		sum.dir=list.files(pattern='summaries')
		unlink(sum.dir, recursive=T)
	}
	
}


















