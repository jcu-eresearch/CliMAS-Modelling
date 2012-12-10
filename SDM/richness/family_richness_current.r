args=(commandArgs(TRUE)); for(i in 1:length(args)) { eval(parse(text=args[[i]])) }

library(SDMTools)
source('/home/jc148322/scripts/libraries/cool_functions.r')
base.asc = read.asc.gz('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.asc.gz') #read in the 
base.asc=make.base.asc(base.asc)


work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
out.dir=paste('/scratch/jc148322/AP02/',tax, '/richness/',sep="");dir.create(out.dir)
famdata=read.csv('/scratch/jc148322/AP02/sp_fam_class.csv',as.is=T)

famdata=famdata[which(famdata$class==tax),]
species=famdata$species[which(famdata$family==tfam)]	
	trichness=base.asc
	for (spp in species) {
		spp.dir=paste(work.dir, spp,'/output/',sep='');setwd(spp.dir)
		
		asc.dir=list.files(pattern='ascii')
		if (length(asc.dir)==0){
		} else{
		
		tasc=read.asc.gz(paste(spp.dir,'ascii/',yr,'.asc.gz',sep=''))
				
		threshold = read.csv('maxentResults.csv'); 
		threshold = threshold$Equate.entropy.of.thresholded.and.original.distributions.logistic.threshold[1]#extract the species threshold value

		tasc[which(tasc<threshold)]=0; tasc[which(tasc>=threshold)]=1
		
		trichness=trichness+tasc
		
		}
		}
	

	write.asc.gz(trichness,paste(out.dir,yr,'_',tfam, sep=''))

