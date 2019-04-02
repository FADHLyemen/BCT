function [ output] = Discretization( input)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[rows,colms]=size(input);
minVar=min(min(input));
maxVar=max(max(input));
threshold=minVar+(maxVar-minVar)/2;
for i=1:rows
    for j=1:colms
        if input(i,j)> threshold
            output(i,j)=1;
        else
            output(i,j)=0;
        end
    end
end


end

