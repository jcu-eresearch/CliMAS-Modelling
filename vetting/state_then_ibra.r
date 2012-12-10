library(SDMTools)

wd="/home/jc148322/AP02/working.data/";setwd(wd)
species.data=read.csv("/home/jc148322/AP02/vetting_clips/old_files/clipaction2.csv",as.is=TRUE)
state.matrix=read.csv('/home/jc148322/AP02/vetting_clips/old_files/states.matrix2_changed.csv')
species=intersect(species.data$SPECIES[which(species.data$ACTION=='IBRA2')],state.matrix$species)

for (spp in species) {  cat(spp,'\n')#cycle through each of the species numbers

	toccur = read.csv(paste(wd,spp,'.csv',sep=''),as.is=TRUE) #get the observations for the species

		clipasc=read.asc.gz(paste('/home/jc148322/AP02/vetting_clips/state/',spp,'.bioregion.clip.asc.gz',sep=''))
		toccur$clip=extract.data(cbind(toccur$LONGDEC,toccur$LATDEC),clipasc)
		toccur=toccur[which(toccur$clip==1),] #wonder if na.omit does the same job
		
	toccur=toccur[,c(1:5)]
	write.csv(toccur,paste(wd,spp,'.csv',sep=''),row.names=F)
}	
species=species.data$SPECIES[which(species.data$ACTION=='IBRA2')]
base.asc = read.asc.gz('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.asc.gz') #read in the base asc 

ibra=read.asc('/home/jc148322/AP02/vetting_clips/ibra.asc')
ibras=unique(ibra);ibras=ibras[which(is.finite(ibras))];ibras=sort(ibras)
dir.create('/home/jc148322/AP02/ibra3')
ibras.matrix=matrix(0,nr=length(species),nc=length(ibras))
colnames(ibras.matrix)=ibras
i=1
for (spp in species) { cat(spp, '\n')
	
	#prepare your data
	occur=read.csv(paste(spp,'.csv',sep=''),as.is=TRUE)
	
	d = format(occur$DATE)
	d = as.numeric(substr(d,1,4))
	post1950 = d>1950
	post1950 =  subset(occur[c('LONGDEC','LATDEC')], post1950 == TRUE)
	no.date = is.na(d)
	no.date=subset(occur[c('LONGDEC','LATDEC')], no.date == TRUE)
	pre1950 = d<=1950
	pre1950 = subset(occur[c('LONGDEC','LATDEC')], pre1950 == TRUE)
	
	toccur=occur[c('LONGDEC','LATDEC')]
	toccur$LATDEC = round(toccur$LATDEC/0.05)*0.05;
	toccur$LONGDEC = round(toccur$LONGDEC/0.05)*0.05;
	toccur=unique(toccur)
	
	regions = extract.data(toccur,ibra) #extract the regions occurrences fall within
	regions = unique(regions);regions=regions[which(is.finite(regions))] #identify the unique regions
	
	
	if (length(regions)>0) {
		for (region in regions){
			coi=match(region,colnames(ibras.matrix))
			ibras.matrix[i,coi]=1 
			}
			#tasc=ibra
			clipasc=base.asc
			posoi = which(ibra %in% regions) #identify locations within these regions
			clipasc[which(is.finite(clipasc))] = 0; clipasc[posoi] = NA #change everything to 0 and only locations in bioregions 
			#clipasc=base.asc; clipasc[posoi]=tasc[posoi]
			
			cols=rainbow(89)
			png(paste('/home/jc148322/AP02/ibras2/',spp,'.png',sep=''),width=17, height=10, units='cm', res=350, pointsize=7.5, bg='white')
				image(ibra,ann=FALSE,axes=FALSE,col=cols)
				image(clipasc,ann=FALSE,axes=FALSE,col='grey88',add=TRUE)
				points(pre1950,col='white',pch=16,cex=0.5)
				points(no.date,col='grey50',pch=13,cex=0.5)
				points(post1950,col='black',pch=16,cex=0.5)
				text (132, -43, gsub('_',' ',spp), cex=1)
				legend(107,-10,sort(regions),fill=cols[sort(regions)],cex=0.7)
				legend(112,-10,c('no date','pre1950','post1950'),pch=c(13,1,16),col=c('grey50','grey','black'),cex=0.7,bty='n')
				dev.off()
			
		}
		
	i=i+1
                }
ibras.matrix=cbind(species,ibras.matrix)

write.csv(ibras.matrix,'/home/jc148322/AP02/ibras2/ibras.matrix2.csv',row.names=FALSE)
