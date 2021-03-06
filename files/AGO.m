function AGO(inputfile,dire,minGenes,MinPercIdenTifiedGenes,index,GenOntlgy,NoOfBiclusters)
%h=msgbox('Comparison is running....please wait','Comparison run','none');
h = waitbar(0,'Please wait...');
fidx2=fopen('pop.txt');
C= textscan(fidx2, '%s');
genes=C{1};
fclose(fidx2);
global directory;
dir=dire;
pieces = regexp(inputfile, '(\S+)', 'match');
for i=1:size(pieces,2)
     directory=strcat(dir,pieces{i},'\');
     getclusters(pieces{i},genes);
     getgenemerge(strcat(pieces{i},'cluster_list.txt'),strcat('GO',pieces{i},'cluster_list.txt'));
     if (index==1 || index==2)
        GO(i,:)=GET_Percentage_of_Enriched_Biclusters(strcat('GO',pieces{i},'cluster_list.txt'),minGenes,MinPercIdenTifiedGenes);
     else
        ll{i,:}=GET_Certian_Match(strcat('GO',pieces{i},'cluster_list.txt'),GenOntlgy);
     end
end
if (index==1 || index==2) 
  dlmwrite('GO.text',GO);
  f3 = figure('Position', [10 10 752 650]);
  bar(GO,1);
  ylabel('Percentage of Enriched Biclusters %')
  legend('p 0.001%','p 0.005%','p 0.01%','p 0.05%','p 0.1%','p 0.5%','p 1%','p 5%');
  xlabel('Bicluster Algorithms')
  %propertyeditor('on');
else
    for i=1:NoOfBiclusters
        f = figure('Position', [0 0 752 650]);
        t = uitable('Parent', f, 'Position', [0 0 752 650]);
        set(t, 'data',ll{i,1}(:,:));
    end
end
close(h);
   
end
% f=ll;




