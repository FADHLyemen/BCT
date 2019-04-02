function  getFileUpdate( MinGenes,MinChips,MaxBicluster,MaxOverlap,filename )

s=struct('size',{},'genes',{},'chips',{});
sNew=struct('size',{},'genes',{},'chips',{});
%[filename, pathname, filterindex] = uigetfile('*.txt', 'Pick an Input-file');
%s = textread(filename,'%s','delimiter','\t| |,');
%s(1)
%s(2)
Index=0;
count_index=0;
count=1;
fid = fopen(filename);
tline = fgetl(fid);
while ischar(tline)
    if count==1
        [r c]=size(tline);
        s(count).size=tline;
        tline=fgetl(fid);
        s(count).genes=tline;
        tline = fgetl(fid);
        s(count).chips=tline;
        count=count+1;
    else
        tline = fgetl(fid);
        s(count).size=tline;
        tline=fgetl(fid);
        s(count).genes=tline;
        tline = fgetl(fid);
        s(count).chips=tline;
        count=count+1;
    end
end
[r c]=size(s);
fclose(fid);

for i=1:c-1
    vect=s(i).size;
    V=textscan(vect,'%d\t');
        if V{1,1}(1)< MinGenes || V{1,1}(2) < MinChips
            %count_index=count_index+1;
            %Index(count_index)=i;
        else
            count_index=count_index+1;
            sNew(count_index).size=s(i).size;
            sNew(count_index).genes=s(i).genes;
            sNew(count_index).chips=s(i).chips;
        end
end
        
[r c]=size(sNew);
%OrderClusters=orderfields(sNew);
fid = fopen(filename,'wt');
for i=1:c
    fprintf(fid, '%s\n',sNew(i).size);
    fprintf(fid,'%s ',sNew(i).genes);
    fprintf(fid,'\n%s','');
    fprintf(fid,'%s ',sNew(i).chips);
    fprintf(fid,'\n%s','');
end
fclose(fid);
end

