function [] =getgenemerge(clusters_input,genemerge_output)
        global directory;
         fidx=fopen(strcat(directory,clusters_input),'r');
%               ss=fgetl(fidx);
%        while isempty(findstr(ss,'OPSMcluster5.txt'))
%            ss=fgetl(fidx);
%        end
        fidx2=fopen(strcat(directory,genemerge_output),'r');
%         ss2=fgetl(fidx2);
%         while isempty(findstr(ss2,'GOOPSMcluster5.txt'))
%            ss2=fgetl(fidx2);
%          end

       while ~feof(fidx)
               ss=fgetl(fidx);
               ss2=fgetl(fidx2);
               perl('GeneMerge1.2.pl', 'S_cerevisiae.BP', 'GO.BP.use', 'pop.txt', strcat(directory,ss), strcat(directory,ss2));
       end% end while
       fclose(fidx);
       fclose(fidx2);
