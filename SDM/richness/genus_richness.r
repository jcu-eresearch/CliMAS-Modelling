args=(commandArgs(TRUE)); for(i in 1:length(args)) { eval(parse(text=args[[i]])) }

library(SDMTools)
source('/home/jc148322/scripts/libraries/cool_functions.r')
base.asc = read.asc.gz('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.asc.gz') #read in the 
base.asc=make.base.asc(base.asc)


work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
out.dir=paste('/scratch/jc148322/AP02/',tax, '/richness/',sep="");dir.create(out.dir)
species = list.files(work.dir) #get a list of species

genus.list=NULL
for (spp in species) {
	
	genus=strsplit(spp,'_')[[1]][1]
	genus.list=c(genus.list,genus)
	
	}
genus.list=unique(genus.list)

for (g in genus.list){ cat(g,'\n')
	tspecies=grep(g, species,value=TRUE)
	
	trichness=base.asc
	for (tspp in tspecies) {
		spp.dir=paste(work.dir, tspp,'/output/',sep='');setwd(spp.dir)
		
		asc.dir=list.files(pattern='ascii')
		if (length(asc.dir)==0){
		} else{
		
		tasc=read.asc.gz(paste(spp.dir,'ascii/',es,'_all_',yr,'.asc.gz',sep=''))
				
		threshold = read.csv('maxentResults.csv'); 
		threshold = threshold$Equate.entropy.of.thresholded.and.original.distributions.logistic.threshold[1]#extract the species threshold value

		tasc[which(tasc<threshold)]=0; tasc[which(tasc>=threshold)]=1
		
		trichness=trichness+tasc
		
		}
	
	}
	if (max(trichness,na.rm=T)>0){
	write.asc.gz(trichness,paste(out.dir,es,'_',yr,'_',g, sep=''))

	}

}
