function  [output]=checkEquality( x,y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[r1 ,c1]=size(x);
[r2 ,c2]=size(y);
count=0;
if (c1~=c2)
    flag=0;
else
    for i=1:c1
        if (x(i)==y(i))
            count=count+1;
        end
    end     
end

if (count==c1)
    flag=1;
else
    flag=0;
end

output=flag;

end

