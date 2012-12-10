args=(commandArgs(TRUE)); for(i in 1:length(args)) { eval(parse(text=args[[i]])) }

library(SDMTools)

source('/home/jc148322/scripts/libraries/cool_functions.r')

pos = read.csv('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.positions.csv',as.is=TRUE) 
base.asc = read.asc.gz('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.asc.gz') #read in the base asc file

setwd('/home/jc148322/AP02/climate.summaries/region_layers/')
vois=c('state','nrm','ibra')
for (voi in vois) { cat(voi,'\n')
	pos[,voi]=extract.data(cbind(pos$lon,pos$lat),read.asc(paste(voi,'.asc',sep='')))
}


YEARs=seq(2015,2085,10)
setwd(spp.dir)
load(tfile)
pos.quant=matrix(NA,nr=nrow(pos),nc=8)

coi=0
for (yr in YEARs) { cat (yr,'\n')
	coi=coi+1
	
	cois=grep(yr, colnames(pot.mat))
	tdata=pot.mat[,cois]
	
	out.quant=t(apply(tdata,1,function(x) { return(quantile(x,0.5,na.rm=TRUE,type=8)) }))
	tasc=make.asc(out.quant)
	write.asc.gz(tasc,paste(work.dir, spp, '/output/ascii/',es,'_all_',yr,sep=''))
	
	pos.quant[,coi]=out.quant


}
pos.quant=cbind(pos,pos.quant)
colnames(pos.quant)=c('lat','lon','row','col', 'state','nrm','ibra',YEARs)
save(pos.quant, file=paste(spp.dir,es,'.50th.percentile.Rdata',sep=''))