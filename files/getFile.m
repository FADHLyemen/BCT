function  getFileUpdate( MinGenes,MinChips,MaxBicluster,MaxOverlap )

s=struct('size',{},'genes',{},'chips',{});
[filename, pathname, filterindex] = uigetfile('*.txt', 'Pick an Input-file');
%s = textread(filename,'%s','delimiter','\t| |,');
%s(1)
%s(2)
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
fclose(fid);
Index=0;
count_index=0;
for i=1:count
    s(i).size
    V=textscan(s(1).size,'%d\t');
    if str2num(V{1,1}(1))< MinGenes || str2num(V{1,1}(2)) < MinChips
        count_index=count_index+1;
        Index(count_index)=i;
    end
end
for i=1:length(Index)
    s(Index(i))=[];
end
    

end

