library(SDMTools)

for (tax in taxa) {
	tax='amphibians'
	work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep="")
	species = list.files(work.dir) #get a list of species
		
	for (spp in species) {
		
		spp.dir = paste(work.dir,spp,'/output/',sep=''); setwd(spp.dir) #set the working directory to the species directory
		files=list.files('summaries/');
		files=grep('50th',files,value=T)
			
		for (tfile in files) { cat(tfile,'\n')

			load(paste('summaries/',tfile,sep=''))
			threshold = read.csv('maxentResults.csv'); 
			threshold = threshold$Equate.entropy.of.thresholded.and.original.distributions.logistic.threshold[1]#extract the species threshold value

			current=read.asc.gz('ascii/1990.asc.gz')
			pos.quant$current=extract.data(cbind(pos.quant$lon,pos.quant$lat),current)
			pos.quant=pos.quant[,c(1:7,16,8:15)]
			pos.quant=as.matrix(pos.quant)
			tdata=pos.quant[,8:16]
			tdata[which(tdata<threshold)]=0
			tdata[which(tdata>0)]=1
			pos.quant[,8:16]=tdata

			##summarise data
			statedata=pos.quant[,c(5,8:16)];statedata=na.omit(statedata)
			aggstate=aggregate(statedata,list(statedata[,'state']),max)
			aggstate[,1]='State'; colnames(aggstate)[1:2]=c('region.type','region.code')

			nrmdata=pos.quant[,c(6,8:16)];nrmdata=na.omit(nrmdata)
			aggnrm=aggregate(nrmdata,list(nrmdata[,'nrm']),max)
			aggnrm[,1]='NRM'; colnames(aggnrm)[1:2]=c('region.type','region.code')

			ibradata=pos.quant[,c(7,8:16)];ibradata=na.omit(ibradata)
			aggibra=aggregate(ibradata,list(ibradata[,'ibra']),max)
			aggibra[,1]='IBRA'; colnames(aggibra)[1:2]=c('region.type','region.code')

			aggspp=rbind(aggstate,aggnrm,aggibra)
			
			
			speciesdata=aggspp
			speciesdata[,4:11]=speciesdata[,4:11]*2
			speciesdata[,4:11]=speciesdata[,4:11]+speciesdata$current
			speciesdata$current=speciesdata$current*3
			# 0+0 = 0 = never there
			# 0+2 = 2 = gained
			# 1+2 = 3 = retained
			# 1+0 = 1 = lost
			write.csv(aggspp,paste('summaries/',strsplit(tfile,'\\.')[[1]][1],'.',spp,'.binary_summary.csv',sep=''),row.names=F)
			write.csv(speciesdata,paste('summaries/',strsplit(tfile,'\\.')[[1]][1],'.',spp,'.coded_summary.csv',sep=''),row.names=F)
		}
	}
}