function   SaveClusters(OutFN, Biclusters)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
count=0;
[r c]=size(Biclusters);
for i=1:r
    if sum(Biclusters(i,:))>0
        count=count+1; 
    end
end
count2=0;
newClusters=zeros(count,c);
for i=1:r
    if sum(Biclusters(i,:))>0
        count2=count2+1;
        newClusters(count2,:)=Biclusters(i,:);
    end
end

fid_Out = fopen(OutFN, 'wt');
%Genes=handles.Genes;
%Chips=handles.Chips;
cluster=0;
clusterNo=0;
%NoofClusters=count\2;
if count>0
    %fprintf(fid_Out, 'Total number of bicluster: %u', NoofClusters);
    for i=1:2:count-1
        clusterNo=clusterNo+1;
        v=find(newClusters(i,:)>0);
        v2=find(newClusters(i+1,:)>0);
        [r2,c2]=size(v2);
        [r1,c1]=size(v);
        for k=1:c1
            cluster(k)=newClusters(i,k);
        end
        fprintf(fid_Out, '%i %i\n',c1,c2);
        %fprintf(fid_Out, '\n\n%s ' , );
        for n=1:c1
            str1=strcat('g',num2str(cluster(n)));
            %str=genes_lables{cluster(n)};
            fprintf(fid_Out,'%s ',str1);
        end
        cluster=0;
        for m=1:c2
            cluster(m)=newClusters(i+1,m);
        end
        fprintf(fid_Out, '\n%s','');
        for r=1:c2
            str2=strcat('c',num2str(cluster(r)));
            %str=chips_lables{cluster(r)};
            fprintf(fid_Out, '%s ',str2);
        end
        
            %fprintf(fid_Out, '\n\n%s','Chips No.: ');
              
        %fprintf(fid_Out, '\n\nSize of cluster is: %i ',c1*c2);
        cluster=0;
        fprintf(fid_Out, '\n%s','');
    end
   
else
    fprintf(fid_Out, 'No bicluster is found.');
end          
fclose(fid_Out);
end

