function [ output ] = FilterBiCluster( Biclusters,MinGenes,MinChips,MaxBicluster,MaxOverlap)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
count=0;
[r c]=size(Biclusters);
for i=1:r
    if sum(Biclusters(i,:))>0
        count=count+1; 
    end
end
count2=0;
VectorIndex=0;
newClusters=zeros(count,c);
for i=1:r
    if sum(Biclusters(i,:))>0
        count2=count2+1;
        newClusters(count2,:)=Biclusters(i,:);
        Vector=find(newClusters(count2,:)>0);
        Vector_length=length(Vector);
        VectorIndex(count2)=Vector_length;
    end
end

for i=1:2:count
   if  VectorIndex(i)< MinGenes || VectorIndex(i+1)< MinChips 
       newClusters(i,:)=[];
       newClusters(i+1,:)=[];
   end
end
output=newClusters;
end

