#drafted by lauren hodgson... lhodgson86@gmail.com
#R ... creative commons, no warranties.
#creates matrices 2 matrices of species occurrence, by bioregion and by state.
##################################################################################
library(SDMTools)

wd='/home/jc148322/AP02/1K/vetting/';setwd(wd)
data.dir='/home/jc148322/AP02/1K/working.data/'

#read in your clipping asciis

state.asc=read.asc('state.asc')
ibra.asc=read.asc('ibra7_pos_aligned.asc')
base.asc = read.asc.gz('/home/jc165798/Climate/CIAS/Australia/1km/baseline.76to05/base.asc.gz') #read in the base asc 


#find number of regions
states=unique(state.asc);states=states[which(is.finite(states))];states=sort(states)
ibras=unique(ibra);ibras=ibras[which(is.finite(ibras))];ibras=sort(ibras)

#read in your clipping action
clipaction=read.asc('clipaction.csv',as.is=TRUE)
clip.by=c(state,ibra)

for (i in 1:2) {cat(clip.by,'\n')
	tasc=paste(clip.by[i],'.asc')
	all.regions=unique(tasc)
	all.regions=all.regions[which(is.finite(all.regions))];all.regions=sort(all.regions)
	rois=grep(clip.by[i],clipaction$clip.by) #???
	species=clipaction$species[rois] #???
	tdata=matrix(0,nr=length(species),nc=length(all.regions))
	colnames(tdata)=all.regions
	i=1 #row counter
	
	for (spp in species) { cat(spp, '\n')
		#prepare your data
		occur=read.csv(paste(data.dir,spp,'.csv',sep=''),as.is=TRUE)
		
		d = format(occur$DATE)
		d = as.numeric(substr(d,1,4))
		post1950 = d>1950
		post1950 =  subset(occur[c('LONGDEC','LATDEC')], post1950 == TRUE)
		no.date = is.na(d)
		no.date=subset(occur[c('LONGDEC','LATDEC')], no.date == TRUE)
		pre1950 = d<=1950
		pre1950 = subset(occur[c('LONGDEC','LATDEC')], pre1950 == TRUE)
		
		toccur=occur[c('LONGDEC','LATDEC')]
		toccur$LATDEC = round(toccur$LATDEC/0.01)*0.01;
		toccur$LONGDEC = round(toccur$LONGDEC/0.01)*0.01;
		toccur=unique(toccur)
		
		regions = extract.data(toccur,tasc) #extract the regions occurrences fall within
		regions = unique(regions);regions=regions[which(is.finite(regions))] #identify the unique regions
		
		
		if (length(regions)>0) {
			for (region in regions){
				coi=match(region,colnames(tdata))
				tdata[i,coi]=1 
				}
				
				clipasc=base.asc
				posoi = which(tasc %in% regions) #identify locations within these regions
				clipasc[which(is.finite(clipasc))] = 0; clipasc[posoi] = NA #change everything to 0 and only locations in bioregions 
				
				cols=rainbow(max(all.regions))
				png(paste('images/',clip.by[i],spp,'.png',sep=''),width=17, height=10, units='cm', res=350, pointsize=7.5, bg='white')
					image(tasc,ann=FALSE,axes=FALSE,col=cols)
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
	tdata=cbind(species,tdata)
	write.csv(tdata,paste('/home/jc148322/AP02/vetting/',clip.by[i],'.csv'),row.names=FALSE)
	
}
