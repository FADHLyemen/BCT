function [ str ] = test( )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
S={};
for i=1:10
    S{1,1}(i)=i;
end
for j=1:20
    S{1,2}(j)=j;
end
for i=1:2
    S{1,i}
end
S
end

