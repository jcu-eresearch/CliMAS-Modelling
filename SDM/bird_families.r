wd='/scratch/jc148322/AP02/birds/models/'
species=list.files(wd)
out.dir='/home/jc148322/AP02/birdfamilies/';dir.create(out.dir);setwd(out.dir)
for (spp in species) {cat(spp,'\n')
	system(paste('wget http://bie.ala.org.au/ws/guid/',spp,sep=''))
	system(paste('mv ',spp,' ',spp,'.json',sep=''))
	}

library(rjson)
wd='/home/jc148322/AP02/birdfamilies/';setwd(wd)
out.dir='/home/jc148322/AP02/birdfamilies/profile/';dir.create(out.dir);setwd(out.dir)
for (spp in species){
	tfile=readLines(paste(wd,spp,'.json',sep=''))
	tt=fromJSON(tfile)
	
	system(paste('wget http://bie.ala.org.au/species/shortProfile/',tt[[1]]$identifier,'.json',sep=''))
	system(paste('mv ',tt[[1]]$identifier,'.json',' ',spp,'.json',sep=''))
}

wd='/home/jc148322/AP02/birdfamilies/profile/';setwd(wd)
out=NULL
for (spp in species) {
	tfile=readLines(paste(wd,spp,'.json',sep=''))
	tt=fromJSON(tfile)
	out=rbind(out,c(spp,tt$family))
}

for (spp in species) {
	tfam=out[which(out[,1]==spp),2]
	tfam=tolower(tfam)
	tfam=gsub('(^[[:alpha:]])',toupper(substring(tfam,1,1)),tfam)
	out[which(out[,1]==spp),2]=tfam
	}
actionlist=read.csv('/scratch/jc148322/AP02/actionlist.csv',as.is=T)
tlist=actionlist[which(actionlist$species %in% species),]
out=as.data.frame(out);colnames(out)=c('species','family')
tout=merge(out,tlist[,c('species','class')],by='species')

sp_fam_class=read.csv('/scratch/jc148322/AP02/sp_fam_class.csv',as.is=T)
sp_fam_class=rbind(sp_fam_class, tout)
write.csv(sp_fam_class,'/scratch/jc148322/AP02/sp_fam_class.csv',row.names=F)