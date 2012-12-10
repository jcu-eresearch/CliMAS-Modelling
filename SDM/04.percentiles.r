library(SDMTools)

pos = read.csv('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.positions.csv',as.is=TRUE) 

taxa=c('amphibians','reptiles','mammals')
ESs=c('RCP3PD','RCP45','RCP6','RCP85')
YEARs=seq(2015,2085,10)

for (tax in taxa) { cat(tax, '\n')
work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
species = list.files(work.dir) #get a list of species

#cycle through each of the species
for (spp in species) {
	spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
	out.dir = paste(spp.dir, 'output/summaries/', sep=''); dir.create(out.dir)
	
	files=list.files('output/ascii/');
	
	for (es in ESs) {
		tfiles=grep(es,files,value=TRUE)
		pot.mat=matrix(NA, nr=nrow(pos),nc=length(tfiles))
		colnames(pot.mat)=gsub('.asc.gz','',tfiles)
		for (tfile in tfiles) { cat(tfile, '\n')
			tasc=read.asc.gz(paste('output/ascii/',tfile,sep=''))
			filename=gsub('.asc.gz','',tfile)
			
			pot.mat[,filename]=tasc[which(is.finite(tasc))]
			
		}
	
		save(pot.mat, file=paste(out.dir,es,'.potential.dist.mat.Rdata',sep=''))
	}
	
}
}

