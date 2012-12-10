library(SDMTools)
outdata=NULL
taxa=c('amphibians','reptiles','mammals','birds')

for (tax in taxa) { cat(tax,'\n')
	work.dir=paste('/scratch/jc148322/AP02/',tax, '/models/',sep=""); setwd(work.dir)
	species = list.files(work.dir) #get a list of species
	
	for (spp in species) { cat(spp,'\n')
	
	if (file.exists(paste(spp, '/output/summaries/RCP45.',spp,'.coded_summary.csv',sep=''))){
		a = read.csv(paste(spp, '/output/summaries/RCP45.',spp,'.coded_summary.csv',sep=''))
		b = read.csv(paste(spp, '/output/summaries/RCP85.',spp,'.coded_summary.csv',sep=''))
		
			a$RCP='RCP45'
			b$RCP='RCP85'
			tdata=rbind(a,b)
			tdata$species=spp
			tdata$taxa=tax

			outdata=rbind(outdata,tdata)}
	}
}
write.csv(outdata,'/scratch/jc148322/AP02/region.summary.csv', row.names=F)
