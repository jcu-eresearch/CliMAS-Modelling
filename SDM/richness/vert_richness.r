args=(commandArgs(TRUE)); for(i in 1:length(args)) { eval(parse(text=args[[i]])) }

library(SDMTools)
source('/home/jc148322/scripts/libraries/cool_functions.r')
base.asc = read.asc.gz('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.asc.gz') #read in the 
base.asc=make.base.asc(base.asc)
taxa=c('amphibians','reptiles','mammals','birds')
famdata=read.csv('/scratch/jc148322/AP02/sp_fam_class.csv',as.is=T)


trichness=base.asc
for (tax in taxa) {
	work.dir=paste('/scratch/jc148322/AP02/',tax, '/richness/',sep="");setwd(work.dir)
	families=unique(famdata$family[which(famdata$class==tax)])

	for (tfam in families) { cat(tfam,'\n')

		if (yr==1990) {tasc=read.asc.gz(paste(yr,'_',tfam,'.asc.gz',sep=''))
		}else {tasc=read.asc.gz(paste(es,'_',yr,'_',tfam,'.asc.gz',sep=''))}
				
		trichness=trichness+tasc

	}
}
out.dir='/scratch/jc148322/AP02/vertebrate_richness/'
if (yr==1990) { write.asc.gz(trichness,paste(out.dir,yr,'_vertebrates', sep='')) 
} else { write.asc.gz(trichness,paste(out.dir,es,'_',yr,'_vertebrates', sep=''))}
