wd='/home/jc148322/AP02/edgar.data/';setwd(wd)
out.dir='/scratch/jc148322/AP02/birds/models/'
files=list.files()
#copy the files
for (tfile in files[3:length(files)]) { cat(tfile,'\n')
	tt=tfile
	tt=gsub('^[^(]*[(]','',tt)
	tt=gsub('[)]$','',tt)
	tt=gsub('[(][^)]+[)]','',tt)
	sciname=gsub('\\s+','_',tt)
	
	system(paste('cp -r "',wd,tfile,'" ',out.dir,sciname,sep=''))
	
}

wd=out.dir; setwd(wd)
files=list.files()
species=files

#order ascii directories appropriately
for (spp in species){
	spp.dir=paste(wd,spp,'/',sep='');setwd(spp.dir)
	asciis=paste(spp.dir,'projected-distributions/latest-projected-distributions.zip',sep='')
	out.dir=paste(spp.dir,'output/',sep='');dir.create(out.dir,recursive=T);setwd(out.dir)
	system(paste('mv ',asciis,' ',out.dir,sep=''))
	system(paste('unzip ',out.dir,'latest-projected-distributions.zip',sep=''))
	dir.create(paste(out.dir,'ascii/',sep=''))
	system(paste('mv *.asc ',out.dir,'/ascii/',sep=''))
}

#deal with occurrences
for (spp in species[1:2]){
	spp.dir=paste(wd,spp,'/',sep='');setwd(spp.dir)
	system(paste('unzip ',spp.dir,'occurrences/latest-occurrences.zip',sep=''))
	toccur=read.csv('public_occur.csv',as.is=T)
	if (length(toccur$CLASSIFICATION[which(toccur$CLASSIFICATION=='core')])<5) { #if data has no polygon and has not been vetted
		toccur=toccur
	} else { toccur=toccur[which(toccur$CLASSIFICATION=='core'),] } #if vetting has occured, only use core data
	toccur$LATDEC = round(toccur$LATDEC/0.05)*0.05; 
	toccur$LONGDEC = round(toccur$LONGDEC/0.05)*0.05; 
	toccur$SPPCODE=spp
	toccur = toccur[,c('SPPCODE','LATDEC','LONGDEC')] #keep only columns of interest
	nrow(toccur); toccur = unique(toccur); nrow(toccur) #keep only unique info
	if (nrow(toccur)>10) {	write.csv(toccur,'occur.csv',row.names=F) } #only write file if >10 occurrences
	
}

#bird actionlist
#only birds with file 'occur.csv' had enough records to be modelled legitemately

actionlist=read.csv(