library(SDMTools)


spdata=read.csv('/scratch/jc148322/AP02/region.summary.csv')
regiondata=read.csv('/home/jc148322/AP02/region.codes.csv',as.is=T)
types=as.vector(unique(spdata$region.type))
ESs=c('RCP45','RCP85')
taxa=c('amphibians','reptiles','mammals','birds')
out.dir='/home/jc148322/AP02/climate.summaries/downloadable.data/'

for (type in types) {

	regions=as.vector(unique(spdata$region.code[which(spdata$region.type==type)]))
	
	for (r in regions){
		regioncode=regiondata[which(regiondata[,2]==type & regiondata[,3]==r),c(2,4)]
		regioncode=paste(regioncode[1,1], regioncode[1,2],sep=' ')
		regioncode=gsub(' ','_',regioncode); cat(regioncode,'\n')
		
		tdata=spdata[which(spdata$region.type==type & spdata$region.code==r),]
		out=NULL
		for (es in ESs){
			
			d=tdata[which(tdata$RCP==es),]
			tout=matrix(NA,nc=12,nr=20)
			colnames(tout)=c('RCP','taxa','outcome', 'current',seq(2015,2085,10))
			tout=as.data.frame(tout)
			tout$RCP=es
			tout$taxa=c(rep(taxa[1],4),rep(taxa[2],4),rep(taxa[3],4),rep(taxa[4],4),rep('total',4))
			tout$outcome=c(rep(c('kept','added','lost','total'),5))
			
			for (tax in taxa){
				dtax=d[which(d$taxa==tax),3:11]
				count=function(x){ sum(dtax[,x]==3)}
				tout[which(tout$taxa==tax & tout$outcome=='kept'),4:12]=sapply(1:9,count)
				count=function(x){ sum(dtax[,x]==2)}
				tout[which(tout$taxa==tax & tout$outcome=='added'),4:12]=sapply(1:9,count)
				count=function(x){ sum(dtax[,x]==1)}
				tout[which(tout$taxa==tax & tout$outcome=='lost'),4:12]=sapply(1:9,count)
				count=function(x){ sum(dtax[,x]==3 | dtax[,x]==2)}
				tout[which(tout$taxa==tax & tout$outcome=='total'),4:12]=sapply(1:9,count)
			
			}
			total=function(x) {sum(tout[c(1,5,9,13),x])}
			tout[which(tout$taxa=='total' & tout$outcome=='kept'),4:12]=sapply(4:12,total)
			
			total=function(x) {sum(tout[c(2,6,10,14),x])}
			tout[which(tout$taxa=='total' & tout$outcome=='added'),4:12]=sapply(4:12,total)
			
			total=function(x) {sum(tout[c(3,7,11,15),x])}
			tout[which(tout$taxa=='total' & tout$outcome=='lost'),4:12]=sapply(4:12,total)
			
			total=function(x) {sum(tout[c(4,8,12,16),x])}
			tout[which(tout$taxa=='total' & tout$outcome=='total'),4:12]=sapply(4:12,total)
			
			
			
			out=rbind(out,tout)
		}	
		write.csv(out,paste(out.dir, regioncode,'/biodiversity.summary.csv',sep=''),row.names=FALSE)
	}
	
}
