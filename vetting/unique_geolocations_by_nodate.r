library(SDMTools)
wd = '/home/jc214262/Refugia/Vert_data/ALA_Vertebrate_data/'; setwd(wd) #define and set theworking directory

species.data=read.csv('/home/jc148322/AP02/vetting_clips/actionlist.csv')

species=species.data$SPECIES[which(species.data$ACTION=='RM_NODATE')]

occur.data=matrix(NA,nc=4,nr=length(species))
colnames(occur.data)=c('species','unique locations 5k','unique locations lost','percent records lost')
i=1
for (spp in species) {cat(spp, '\n')
	toccur = read.csv(paste(wd,spp,'.csv',sep=''),as.is=TRUE) #get the observations for the species
	toccur = toccur[which(toccur$UNCERTAINTY<=25000 | is.na(toccur$UNCERTAINTY)),] #keep only things with <20km accuracy

	tdata=toccur[,c('LATDEC','LONGDEC')]
	tdata$LATDEC = round(tdata$LATDEC/0.05)*0.05; 
	tdata$LONGDEC = round(tdata$LONGDEC/0.05)*0.05; 

	tdata = unique(tdata); #keep only unique info
	
	hasdate=toccur[which(toccur$DATE!=""),]
	hasdate=hasdate[,c('LATDEC','LONGDEC')]
	hasdate$LATDEC = round(hasdate$LATDEC/0.05)*0.05; 
	hasdate$LONGDEC = round(hasdate$LONGDEC/0.05)*0.05; 
	hasdate=unique(hasdate)
	
	occur.data[i,1]=spp
	occur.data[i,2]=nrow(tdata)
	occur.data[i,3]=nrow(tdata)-nrow(hasdate)
	percent.lost=(nrow(tdata)-nrow(hasdate))/nrow(tdata)*100
	occur.data[i,4]=round(percent.lost,1)
	i=i+1
	}

write.csv(occur.data, '/home/jc148322/AP02/vetting_clips/no_date_summary_5K.csv',row.names=F)

occur.data=matrix(NA,nc=4,nr=length(species))
colnames(occur.data)=c('species','unique locations 1k','unique locations lost','percent records lost')
i=1
for (spp in species) {cat(spp, '\n')
	toccur = read.csv(paste(wd,spp,'.csv',sep=''),as.is=TRUE) #get the observations for the species
	toccur = toccur[which(toccur$UNCERTAINTY<=25000 | is.na(toccur$UNCERTAINTY)),] #keep only things with <20km accuracy

	tdata=toccur[,c('LATDEC','LONGDEC')]
	tdata$LATDEC = round(tdata$LATDEC/0.01)*0.01; 
	tdata$LONGDEC = round(tdata$LONGDEC/0.01)*0.01; 

	tdata = unique(tdata); #keep only unique info
	
	hasdate=toccur[which(toccur$DATE!=""),]
	hasdate=hasdate[,c('LATDEC','LONGDEC')]
	hasdate$LATDEC = round(hasdate$LATDEC/0.01)*0.01; 
	hasdate$LONGDEC = round(hasdate$LONGDEC/0.01)*0.01; 
	hasdate=unique(hasdate)
	
	occur.data[i,1]=spp
	occur.data[i,2]=nrow(tdata)
	occur.data[i,3]=nrow(tdata)-nrow(hasdate)
	percent.lost=(nrow(tdata)-nrow(hasdate))/nrow(tdata)*100
	occur.data[i,4]=round(percent.lost,1)
	i=i+1
	}

write.csv(occur.data, '/home/jc148322/AP02/vetting_clips/no_date_summary_1K.csv',row.names=F)