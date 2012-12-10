args=(commandArgs(TRUE)); for(i in 1:length(args)) { eval(parse(text=args[[i]])) }

library(SDMTools)
pos = read.csv('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.positions.csv',as.is=TRUE) 

ESs=c('RCP3PD','RCP45','RCP6','RCP85')

spp.dir = paste(work.dir,spp,'/',sep=''); setwd(spp.dir) #set the working directory to the species directory
out.dir = paste(spp.dir, 'output/summaries/', sep=''); dir.create(out.dir)
	
files=list.files('output/ascii/');
	
for (es in ESs) {
	tfiles=grep(es,files,value=TRUE)
	tfiles=tfiles[-grep('all',tfiles)]
	pot.mat=matrix(NA, nr=nrow(pos),nc=length(tfiles))
	colnames(pot.mat)=gsub('.asc.gz','',tfiles)
	for (tfile in tfiles) { cat(tfile, '\n')
		tasc=read.asc.gz(paste('output/ascii/',tfile,sep=''))
		filename=gsub('.asc.gz','',tfile)
		
		pot.mat[,filename]=tasc[which(is.finite(tasc))]
		
	}

	save(pot.mat, file=paste(out.dir,es,'.potential.dist.mat.Rdata',sep=''))
}
