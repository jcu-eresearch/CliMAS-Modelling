library(SDMTools)

wd="/home/jc214262/Refugia/Vertebrate_data/";setwd(wd)

species.data=read.csv('/home/jc214262/Refugia/species_points/all.vert.records_sorted_list_to_use2.csv',as.is=TRUE)
species=species.data$Species[which(species.data$action1=='central_aus_mask' | species.data$action1=='intrastate' | species.data$action1=='state_mask' | species.data$action1=='SW_mask')]


state=read.asc("/home/jc148322/AP02/states/states.asc")
base.asc = read.asc.gz('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.asc.gz') #read in the base asc 
pos = read.csv('/home/jc165798/Climate/CIAS/Australia/5km/baseline.76to05/base.positions.csv',as.is=TRUE)
pos$state=extract.data(cbind(pos$lon,pos$lat), state)
pos$state[which(pos$state==9)]=1
state=base.asc; state[cbind(pos$row,pos$col)]=pos$state
states=unique(pos$state);states=states[which(is.finite(states))];states=sort(states)


states.matrix=matrix(0,nr=length(species),nc=length(states))
colnames(states.matrix)=states
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
	
	regions = extract.data(toccur,state) #extract the regions occurrences fall within
	regions = unique(regions);regions=regions[which(is.finite(regions))] #identify the unique regions
	
	
	if (length(regions)>0) {
		for (region in regions){
			coi=match(region,colnames(states.matrix))
			states.matrix[i,coi]=1 
			}
			#tasc=state
			clipasc=base.asc
			posoi = which(state %in% regions) #identify locations within these regions
			clipasc[which(is.finite(clipasc))] = 0; clipasc[posoi] = NA #change everything to 0 and only locations in bioregions 
			#clipasc=base.asc; clipasc[posoi]=tasc[posoi]
			
			cols=rainbow(9)
			png(paste('/home/jc148322/AP02/states/','region9','.png',sep=''),width=17, height=10, units='cm', res=350, pointsize=7.5, bg='white')
				image(state,ann=FALSE,axes=FALSE,col=cols)
				image(clipasc,ann=FALSE,axes=FALSE,col='grey88',add=TRUE)
				# points(pre1950,col='white',pch=16,cex=0.5)
				# points(no.date,col='grey50',pch=13,cex=0.5)
				# points(post1950,col='black',pch=16,cex=0.5)
				# text (132, -43, gsub('_',' ',spp), cex=1)
				legend(107,-10,sort(regions),fill=cols[sort(regions)],cex=0.7)
				# legend(112,-10,c('no date','pre1950','post1950'),pch=c(13,1,16),col=c('grey50','grey','black'),cex=0.7,bty='n')
				dev.off()
			
		}
		
	i=i+1
                }
states.matrix=cbind(species,states.matrix)

write.csv(states.matrix,'/home/jc148322/AP02/states/states.presence.csv',row.names=FALSE)
