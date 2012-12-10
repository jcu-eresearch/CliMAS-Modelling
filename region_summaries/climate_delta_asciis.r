library(SDMTools)

#for now, just trial one full image for current
climate.dir = '/home/jc165798/Climate/CIAS/Australia/5km/bioclim_asc/'; setwd(climate.dir)

current=list.files(pattern='current')
files=list.files(pattern='2085')
files=grep('RCP',files,value=TRUE)
files=c(current,files)

pos = read.csv('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.positions.csv',as.is=TRUE)

#extract the data for all GCMs, all, RCPs 2085
for (tfile in files) {cat (tfile,'\n')
	tasc=read.asc.gz(paste(tfile,'/bioclim_12.asc.gz',sep=''))
	pos[,tfile]=extract.data(cbind(pos$lon,pos$lat),tasc)
}

#find quantiles for each RCP
ESs=c('RCP3PD','RCP45','RCP6','RCP85')
pos.quant=pos[,1:4]
for (es in ESs) { cat(es,'\n')
	cois=grep(es,colnames(pos)) #columns of interest
	out.quant=t(apply(pos[,cois],1,function(x) { return(quantile(x,c(0.1,0.5,0.9),na.rm=TRUE,type=8)) }))
	colnames(out.quant)=c(paste(es, '.10th',sep=''),paste(es, '.50th',sep=''),paste(es, '.90th',sep=''))
	pos.quant=cbind(pos.quant,out.quant)
}

#find the delta for the quantiles
pos.quant[,5:ncol(pos.quant)]=pos.quant[,5:ncol(pos.quant)]-pos[,'current.76to05']

#make asciis out of the quantiles
base.asc = read.asc.gz('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.asc.gz') #read in the base asc file
out.dir='/home/jc148322/AP02/climate.summaries/asciis/bioclim_12/';dir.create(out.dir)
deltas=colnames(pos.quant[,5:ncol(pos.quant)])

for (d in deltas) { cat(d, '\n')
	tasc=base.asc
	tasc[cbind(pos$row,pos$col)]=pos.quant[,d]
	write.asc.gz(tasc, paste( out.dir,d ,sep=''))
	
}

