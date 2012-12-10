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

wd='/scratch/jc148322/AP02/birds/models/'; setwd(wd)
species=list.files()
tlist=NULL
#order ascii directories appropriately
for (spp in species){
        spp.dir=paste(wd,spp,'/',sep='');setwd(spp.dir)
        if (!file.exists(paste(spp.dir,'output/ascii/',sep='')) |
length(list.files(paste(spp.dir,'output/ascii/',sep='')))<609 ) {
tlist=c(tlist,spp)
        }
}
for (spp in tlist[9:12]){
        spp.dir=paste(wd,spp,'/',sep='');setwd(spp.dir)
        if (!file.exists(paste(spp.dir,'output/ascii/',sep='')) |
length(list.files(paste(spp.dir,'output/ascii/',sep='')))<609 ) {
cat(paste('******************',spp,sep=''),'\n')
                asciis=paste(spp.dir,
'projected-distributions/latest-projected-distributions.zip', sep='')
                out.dir=paste(spp.dir,'output/',sep='');dir.create(out.dir,recursive=T);setwd(out.dir)
                system(paste('mv ',asciis,' ',out.dir,sep=''))
                system(paste('unzip ',out.dir,'latest-projected-distributions.zip',sep=''))
                dir.create(paste(out.dir,'ascii/',sep=''))
                system(paste('mv *.asc ',out.dir,'/ascii/',sep=''))
        }
}

wd='/scratch/jc148322/AP02/birds/models/'; setwd(wd)
species=list.files()
tlist=NULL
#order ascii directories appropriately
for (spp in species){
        spp.dir=paste(wd,spp,'/output/ascii/',sep='');
        if (file.exists(spp.dir) &
length(list.files(spp.dir,pattern='.gz'))!=609) { tlist=c(tlist,spp)
        }
}
species=tlist
sh.dir='/home/jc148322/scripts/AP02/zipping_birds.sh/';dir.create(sh.dir)
for (spp in species[6:length(species)]) {
        spp.dir=paste(wd,spp,'/output/ascii/',sep='')
        setwd(sh.dir)
        zz = file(paste(sh.dir,spp,'.zip.projections.sh',sep=''),'w') #create
the shell
                cat('gzip ',spp.dir,'*asc\n',sep='',file=zz)
        close(zz)
        system(paste('qsub -m n ',spp,'.zip.projections.sh',sep=''));
}


#deal with occurrences
for (spp in species){
        spp.dir=paste(wd,spp,'/',sep='');setwd(spp.dir)
        system(paste('unzip ',spp.dir,'occurrences/latest-occurrences.zip',sep=''))
        toccur=read.csv('public_occur.csv',as.is=T)
        if (length(toccur$CLASSIFICATION[which(toccur$CLASSIFICATION=='core')])<5)
{ #if data has no polygon and has not been vetted
                        toccur=toccur
        } else { toccur=toccur[which(toccur$CLASSIFICATION=='core'),] } #if
vetting has occured, only use core data
        toccur$LATDEC = round(toccur$LATDEC/0.05)*0.05;
        toccur$LONGDEC = round(toccur$LONGDEC/0.05)*0.05;
        toccur$SPPCODE=spp
        toccur = toccur[,c('SPPCODE','LATDEC','LONGDEC')] #keep only columns
of interest
        nrow(toccur); toccur = unique(toccur); nrow(toccur) #keep only unique info
        if (nrow(toccur)>10) {  write.csv(toccur,'occur.csv',row.names=F) }
#only write file if >10 occurrences

}


#bird actionlist
#only birds with file 'occur.csv' had enough records to be modelled legitemately
wd='/scratch/jc148322/AP02/birds/models/';setwd(wd)
species=list.files()
actionlist=read.csv('/scratch/jc148322/AP02/actionlist.csv',as.is=T)
for (spp in species) {
        spp.dir=paste(wd,spp,'/',sep='');setwd(spp.dir)
        if (file.exists('occur.csv')){
actionlist=rbind(actionlist,c(spp,'birds','modelled'))
        } else { actionlist=rbind(actionlist,c(spp,'birds','not_modelled'))}
 }