library(SDMTools)

wd="/home/jc214262/Refugia/Vertebrate_data/";setwd(wd)

species.data=read.csv('/home/jc214262/Refugia/species_points/all.vert.records_sorted_list_to_use2.csv',as.is=TRUE)
species=species.data$Species[which(species.data$action1=='central_aus_mask' | species.data$action1=='intrastate' | species.data$action1=='state_mask' | species.data$action1=='SW_mask')]


ibra=read.asc("/home/jc148322/NARP_terrestrial/ibra7_pos_aligned.asc")
base.asc = read.asc.gz('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.asc.gz') #read in the base asc 
pos = read.csv('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.positions.csv',as.is=TRUE)
pos$ibra=extract.data(cbind(pos$lon,pos$lat), ibra)
ibra=base.asc; ibra[cbind(pos$row,pos$col)]=pos$ibra
ibras=unique(pos$ibra);ibras=ibras[which(is.finite(ibras))];ibras=sort(ibras)


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
			png(paste('/home/jc148322/AP02/ibras/',spp,'.png',sep=''),width=17, height=10, units='cm', res=350, pointsize=7.5, bg='white')
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

write.csv(ibras.matrix,'/home/jc148322/AP02/ibras/ibras.presence.csv',row.names=FALSE)


####now in reverse!!!!!
####now in reverse!!!!!
library(SDMTools)
ibra.matrix=read.csv('/home/jc148322/AP02/vetting_clips/ibra.sub_changed.csv',as.is=TRUE)
colnames(ibra.matrix)=gsub('X','',colnames(ibra.matrix))
species=ibra.matrix$species
ibra=read.asc("/home/jc148322/NARP_terrestrial/ibra7_pos_aligned.asc")
wd='/home/jc148322/AP02/vetting_clips/ibra/';setwd(wd)

i=1
for (spp in species) {	cat(spp, '\n')
	regions=colnames(ibra.matrix[,grep(1,ibra.matrix[i,])])
	regions=as.numeric(regions)
	clipasc=ibra
	posoi = which(clipasc %in% regions) #identify locations within these regions
	clipasc[which(is.finite(clipasc))] = NA; clipasc[posoi] = 1 #change everything to 0 and only locations in bioregions of interest to 1
	write.asc.gz(clipasc,paste(spp,'.bioregion.clip.asc',sep='')) #write out the clipping ascii
	
	i=i+1
}
















