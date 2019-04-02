%%% getclusters generate ORF files for each cluster
function[]=getclusters(inputfilename,genes)
global directory;
                                                 if (strcmp(inputfilename,'bivisu'))~=1
clusternum=0;
bicatfile=strcat(inputfilename,'.txt');
clusterlistfile=strcat(directory ,inputfilename,'cluster_list','.txt');
genemergelistfile=strcat(directory ,'GO',inputfilename,'cluster_list','.txt');
fid2=fopen(clusterlistfile,'w');
fid=fopen(bicatfile,'r');
fid3=fopen(genemergelistfile,'w');
s=fgetl(fid);
while ~feof(fid)
spieces=regexp(s,'(\S+)','match');
r=strncmp(spieces{1},'g',1);
        if r==1
        clusternum=clusternum+1;
        spieces=regexp(s,'(\d+)','match');
        v=str2num(strvcat(spieces));
        %v=v+1;
        u=genes(v);
        filename=strcat(inputfilename,'cluster',num2str(clusternum),'.txt');
        %dlmwrite(filename,u,'');
        fid4=fopen(strcat(directory ,filename),'wt');
        fprintf(fid4,'%s\n',u{:});
        fprintf(fid2,'%s\n',filename);
        fprintf(fid3,'%s\n',strcat('GO',filename));
        fclose(fid4);
        end
s=fgetl(fid);
end%end while
fclose(fid);
fclose(fid2);
fclose(fid3);
                                                           else

clusternum=0;
bicatfile=strcat(inputfilename,'.txt');
clusterlistfile=strcat(directory ,inputfilename,'cluster_list','.txt');
genemergelistfile=strcat(directory ,'GO',inputfilename,'cluster_list','.txt');
fid2=fopen(clusterlistfile,'w');
fid=fopen(bicatfile,'r');
fid3=fopen(genemergelistfile,'w');
s=fgetl(fid);
while ~feof(fid)
spieces=regexp(s,'(\S+)','match');
d=isempty(spieces);
if d~=1
r=strncmp(spieces{1},'R',1);
        if r==1
        clusternum=clusternum+1;
        spieces=regexp(s,'(\d+)','match');
        v=str2num(strvcat(spieces));
        %v=v+1;
        u=genes(v);
        filename=strcat(inputfilename,'cluster',num2str(clusternum),'.txt');
        %dlmwrite(filename,u,'');
        fid4=fopen(strcat(directory ,filename),'wt');
        fprintf(fid4,'%s\n',u{:});
        fprintf(fid2,'%s\n',filename);
        fprintf(fid3,'%s\n',strcat('GO',filename));
        fclose(fid4);
        end
end%end if
s=fgetl(fid);
end%end while
fclose(fid);
fclose(fid2);
fclose(fid3);
                                                 end