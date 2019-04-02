function [Biclusters,no,chips,genes]=ISA( E_GC,seeds,Tg,Tc,NumberOfTrial )
%ISA Summary of this function goes here
%   Detailed explanation goes here
%MeanMatrix=mean(E_GC,2);
chips={};
genes={};
% normalization
Mean_E_GC_rows=mean(E_GC,2);
STD_E_GC_rows=std(E_GC,0,2);
Mean_E_GC_colmn=mean(E_GC);
STD_E_GC_colmn=std(E_GC,0,1);

% normalization of matrix EG_gc and EC_gc
[rows,colmn]=size(E_GC);
NoOfClusters=1;
for i=1:rows
    for j=1:colmn
        EG_gc(i,j)=(E_GC(i,j)-Mean_E_GC_rows(i))/STD_E_GC_rows(i);
        %EG_gc(i,j)=(E_GC(i,j)-Mean_E_GC_rows(j))/abs(E_GC(i,j)-Mean_E_GC_rows(j));
        EC_gc(i,j)=(E_GC(i,j)-Mean_E_GC_colmn(j))/STD_E_GC_colmn(j);
        %EC_gc(i,j)=(E_GC(i,j)-Mean_E_GC_colmn(i))/abs(E_GC(i,j)-Mean_E_GC_colmn(i));
    end 
end
mEG_colmn=mean(EG_gc);
mEG_rows=mean(EG_gc,2);
% for i=rows
%         matrix1(i)=sum(EC_gc(i,:));
%         matrix2(i)=sum(EC_gc(i,:).^2);
% end
% matrix1
% matrix2
%EG_gc
%EC_gc
%bicluster_genes=zeros(NumberOfTrial,rows);
%bicluster_chips=zeros(NumberOfTrial,colmn);
%  fid = fopen('results_genes.txt','w+');
%  fid2=fopen('results_chips.txt','w+');

% the seeds number
Clusters_count=0;
BiclusterGenes=0;
BIclusterChips=0;
BiclusterCount=0;
for Count_bicluster=1:NumberOfTrial
    rows_seeds = randi([1,rows],[1,seeds]);
    flag=1;
    %ori_seeds=rows_seeds;
    count_trial=1;
% get the scores of each column and the selected rows
%for h=1:NumOfTrial
    while (flag || count_trial<10 )
        
        count_trial=count_trial+1;
        [r,c]=size(rows_seeds);
        scores_EG=0;
        totalscores=0;
        for i=1:colmn
          for j=1:c
              if ((j==1) && (rows_seeds(j)>0)) 
                 totalscores=EG_gc(rows_seeds(j),i);
              elseif rows_seeds(j)>0 
                totalscores=totalscores+EG_gc(rows_seeds(j),i);
              end    
          end
            scores_EG(i)=totalscores/c;
        end
        %scores_EG=abs(scores_EG);
% compute the threshold
               
        Rc=1/sqrt(c);
        threshold_EG_gc=Tc*Rc;
        [rscores,cscores]=size(scores_EG);
        count=1;
        indexes=0;
        %Selected_C=0;
        for i=1:colmn
            if scores_EG(i)>threshold_EG_gc
                indexes(count)=i;
                %Selected_C(count)=scores_EG(i);
                count=count+1;
            end  
        end

% get the scores for all rows and pass columns only for matrix EC_gc.
        scores_EC=0;
        totalscores=0;
        [r_pass_colmn,c_pass_colmn]=size(indexes);
        sum=0;
        for i=1:rows
           for j=1:c_pass_colmn
              if j==1 && indexes(j)>0 
                 totalscores=EC_gc(i,indexes(j))*scores_EG(indexes(j));
                 sum=scores_EG(indexes(j));
              elseif indexes(j)>0
                 totalscores=totalscores+ EC_gc(i,indexes(j))*scores_EG(indexes(j));
                 sum=sum+scores_EG(indexes(j));
              end
           end
           %compute the weighted average
           scores_EC(i)=totalscores/c_pass_colmn;
        end
        %scores_EC= scores_EC-Mean_E_GC_rows;
        Rg=1/sqrt(c_pass_colmn);
        threshold_EC_gc=Tg*Rg;
        count=1;
        selected_genes=0;
        Selected_G=0;
        for i=1:rows
           if scores_EC(i)>threshold_EC_gc
              selected_genes(count)=i;
              Selected_G(count)=scores_EC(i);
              count=count+1;
           end 
        end
        flag=checkEquality(rows_seeds,selected_genes);
       
        if (flag==0)
            rows_seeds=selected_genes;
        else
            Clusters_count=Clusters_count+1;
            %bicluster_genes(i,:)=selected_genes;
            %bicluster_chips(i,:)=indexes;
            count_trial=11;
            flag=0;
            %NoOfClusters=NoOfClusters+2;
            [r_genes,c_genes]=size(selected_genes);
            [r_chips,c_chips]=size(indexes);
            if(NoOfClusters==1)
                if rows>colmn
                  GenesClustersChips=zeros(rows*2,rows);
                else 
                  GenesClustersChips=zeros(colmn*2,colmn);
                end
                  %ChipsClusters=zeros(colmn);
                  for i=1:c_genes
                      GenesClustersChips(NoOfClusters,i)=selected_genes(i);
                      genes{1,1}(i)=selected_genes(i);
                  end
                  for j=1:c_chips
                      GenesClustersChips(NoOfClusters+1,j)=indexes(j);
                      chips{1,1}(j)=indexes(j);
                  end
                  NoOfClusters=NoOfClusters+2;
            else
                 for i=1:c_genes
                      GenesClustersChips(NoOfClusters,i)=selected_genes(i); 
                      genes{1,Clusters_count}(i)=selected_genes(i);
                 end
                 for j=1:c_chips
                      GenesClustersChips(NoOfClusters+1,j)=indexes(j);
                      chips{1,Clusters_count}(j)=indexes(j);
                 end
                 NoOfClusters=NoOfClusters+2;
            end 
        end
    end
end 

no=Clusters_count;
%Biclusters=unique(GenesClustersChips,'rows');
%chips=unique(ChipsClusters,'rows');
Biclusters=GenesClustersChips;
%Biclusters
%chips
%end
%bicluster_genes
%bicluster_chips
%Selected_G
%Selected_C

   
end

