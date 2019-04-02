%this program return the percentage of the functionaly enriched clusters
%determine by percentage variables.
function GO  =GET_Percentage_of_Enriched_Biclusters(input_file,min_no_genes,min_percentage)% enter the file name which include the files name of genemerge output
global directory;
x=1;
mingeneno=min_no_genes; % threshold number of idenifed gene per each GO  
percentage=min_percentage;
numofclusters=0;
r=zeros(10,8);
if x==1% to don't enter second time to overcome fclose problems
                fidx=fopen(strcat(directory,input_file),'a+');%append empty lines to the last line of list file to overcome eof problem
                fwrite(fidx, zeros(1,1));
                fclose(fidx);
                fidx=fopen(strcat(directory,input_file),'r');
                ss=fgetl(fidx);
                
                while ~feof(fidx)
                                        numofclusters=numofclusters+1;
                                        putin=1;
                                        fl=getfl(ss);%get the number of intersted lines
                        if fl~=0
                                                fid = fopen(strcat(directory,ss),'r');
                                                s=fgetl(fid);
                                        while isempty(findstr(s,'GMRG_Term'))
                                                   s=fgetl(fid);
                                        end
                                        nsel=cell(fl,4);%file lenght
                                        idx = 0;
                                        s=fgetl(fid);
                                        while (~strcmp(s,''))%read till before this line Total number of genes:
                                                   idx = idx + 1;
                                                   pieces = regexp(s, '(\S+)', 'match');%Walter Roberson Idea mathkb
                                                   spieces = regexp(s, '[^\t]*', 'match');%Jason Breslau idea
                                                   nsel{idx,1} = pieces{4};
                                                   nsel{idx,2} = pieces{5};
                                                   nsel{idx,3}=spieces{1};
                                                   nsel{idx,4}=spieces{7};
                                                   s=fgetl(fid);
                                        end
                                        fclose(fid);
                                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                for i=1:size(nsel,1)
                                 xx(i,1)=strcmp(nsel{i,2},'NA');
                                end
                                nsel(xx,:)=[];  
                                xx=false;
                                
                                B = sortrows(nsel,2);
                                B=flipud(B);
                                        count1=1;
                                        count2=1;
                                        count3=1;
                                        count4=1;
                                        count5=1;
                                        count6=1;
                                        count7=1;
                                        count8=1;
                                        for i=1:size(B,1)
                                            e = regexp(B{i,1}, '(\d+)', 'match');
                                            u=str2num(B{i,2});
                                            v=str2num(B{i,1});
                                       
                                            %SL= 0.00001 0.00005 0.0001  0.0005 0.001  0.005 0.01 0.05
                                            
                                            if percentage~=0
                                                            if(u<=0.00001 && ((v*100)>percentage||str2num(e{1})>= mingeneno))     % siginificance level=1.E-5
                                                                r(count1,1)=v;
                                                                ll(numofclusters,putin)=strcat(B(i,1),B(i,3),B(i,4));
                                                                putin=putin+1;
                                                           count1=count1+1;
                                                            end
                                                            if (u<=0.00005  && ((v*100)>percentage||str2num(e{1})>= mingeneno)) % siginificance level=5.E-5
                                                                r(count2,2)=v;
                                                                  ll(numofclusters,putin)=strcat(B(i,1),B(i,3),B(i,4));
                                                                  putin=putin+1;
                                                           count2=count2+1;
                                                            end
                                                            if (u<=0.0001  && ((v*100)>percentage||str2num(e{1})>= mingeneno))% siginificance level=1E-4
                                                                r(count3,3)=v;
                                                                  ll(numofclusters,putin)=strcat(B(i,1),B(i,3),B(i,4));
                                                                  putin=putin+1;
                                                           count3=count3+1;
                                                            end
                                                            if (u<=0.0005 && ((v*100)>percentage||str2num(e{1})>= mingeneno))% siginificance level=5E-4
                                                                r(count4,4)=v;
                                                                  ll(numofclusters,putin)=strcat(B(i,1),B(i,3),B(i,4));
                                                                  putin=putin+1;
                                                           count4=count4+1;
                                                            end
                                                            if (u<=0.001 && ((v*100)>percentage||str2num(e{1})>= mingeneno))% siginificance level=1E-3
                                                                r(count5,5)=v;
                                                                  ll(numofclusters,putin)=strcat(B(i,1),B(i,3),B(i,4));
                                                                  putin=putin+1;
                                                           count5=count5+1;
                                                            end
                                                            if (u<=0.005  && ((v*100)>percentage||str2num(e{1})>= mingeneno))% siginificance level=5E-3
                                                                r(count6,6)=v;
                                                                  ll(numofclusters,putin)=strcat(B(i,1),B(i,3),B(i,4));
                                                                  putin=putin+1;
                                                           count6=count6+1;
                                                            end
                                                            if (u<=0.01  && ((v*100)>percentage||str2num(e{1})>= mingeneno))% siginificance level=1E-2
                                                                r(count7,7)=v;
                                                                  ll(numofclusters,putin)=strcat(B(i,1),B(i,3),B(i,4));
                                                                  putin=putin+1;
                                                           count7=count7+1;
                                                            end
                                                            if (u<=0.05  && ((v*100)>percentage||str2num(e{1})>= mingeneno))% siginificance level=5E-2
                                                                r(count8,8)=v;
                                                                  ll(numofclusters,putin)=strcat(B(i,1),B(i,3),B(i,4));
                                                                  putin=putin+1;
                                                           count8=count8+1;
                                                            end
                                            else
                                             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                        if u<0.00001   % siginificance level=1.E-5
                                                            r(count1,1)=v;
                                                       count1=count1+1;
                                                        end
                                                        if u<0.00005 %siginificance level=5.E-5
                                                            r(count2,2)=v;
                                                       count2=count2+1;
                                                        end
                                                        if u<0.0001% siginificance level=1E-4
                                                            r(count3,3)=v;
                                                       count3=count3+1;
                                                        end
                                                        if u< 0.0005% siginificance level=5E-4
                                                            r(count4,4)=v;
                                                       count4=count4+1;
                                                        end
                                                        if u<0.001 % siginificance level=1E-3
                                                            r(count5,5)=v;
                                                       count5=count5+1;
                                                        end
                                                        if u<0.005 % siginificance level=5E-3
                                                            r(count6,6)=v;
                                                       count6=count6+1;
                                                        end
                                                        if u<0.01 % siginificance level=1E-2
                                                            r(count7,7)=v;
                                                       count7=count7+1;
                                                        end
                                                        if u<0.05 % siginificance level=5E-2
                                                            r(count8,8)=v;
                                                       count8=count8+1;
                                                        end
                                            end %end if percentage
                                        end% END FOR  
                                         % remove zeros and caluculate the average for each significance
                                         %x=x+1;
                                           k1=r(:,1);
                                           k1=k1(find(k1~=0));
                                           if numel(k1)~=0
                                           k1=(sum(k1)/numel(k1));
                                           else
                                               k1=0;
                                           end

                                           k2=r(:,2);
                                           k2=k2(find(k2~=0));
                                           if numel(k2)~=0
                                           k2=(sum(k2)/numel(k2));
                                           else
                                               k2=0;
                                           end

                                           k3=r(:,3);
                                           k3=k3(find(k3~=0));
                                           if numel(k3)~=0
                                           k3=(sum(k3)/numel(k3));
                                           else
                                               k3=0;
                                           end

                                           k4=r(:,4);
                                           k4=k4(find(k4~=0));
                                           if numel(k4)~=0
                                           k4=(sum(k4)/numel(k4));
                                           else
                                               k4=0;
                                           end

                                           k5=r(:,5);
                                           k5=k5(find(k5~=0));
                                           if numel(k5)~=0
                                           k5=(sum(k5)/numel(k5));
                                           else
                                               k5=0;
                                           end

                                           k6=r(:,6);
                                           k6=k6(find(k6~=0));
                                           if numel(k6)~=0
                                           k6=(sum(k6)/numel(k6));
                                           else
                                               k6=0;
                                           end

                                           k7=r(:,7);
                                           k7=k7(find(k7~=0));
                                           if numel(k7)~=0
                                           k7=(sum(k7)/numel(k7));
                                           else
                                               k7=0;
                                           end

                                           k8=r(:,8);
                                           k8=k8(find(k8~=0));
                                           if numel(k8)~=0
                                           k8=(sum(k8)/numel(k8));
                                           else
                                               k8=0;
                                           end

                                          k(numofclusters,:)=[k1 k2 k3 k4 k5 k6 k7 k8 numofclusters ];
                                          r(:)=0;
                                           ss=fgetl(fidx) ;
                                        %     pause();  


                      else 
                           k(numofclusters,:)=[0 0 0 0 0 0 0 0 numofclusters ];
                           r(:)=0;
                           ss=fgetl(fidx);
                       
                        end%enf if fl~=0
                end%end while
                fclose(fidx);
                x=2;
                for j=1:size(k,2)-1
                        p=k(:,j);
                        x=p(find(p~=0));
                        y=numel(x);
                        GO(1,j)=(y/numofclusters)*100;
                end
                
               % xlswrite(strcat(directory,'GOterm.xls'),ll)
                %bar(GO,0.5);
                %propertyeditor('on');
end%end if x==1%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fl]  =getfl(ss)
global directory;
numemptyline=0;
fid = fopen(strcat(directory,ss),'r');
s=fgetl(fid);
while isempty(findstr(s,'GMRG_Term'))
s=fgetl(fid);
end
while (~strcmp(s,''))
numemptyline=numemptyline+1;
s=fgetl(fid);
end
fl=numemptyline-1;
fclose(fid);
return;


