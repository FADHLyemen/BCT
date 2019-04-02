function [R,S] = sortclusters(ROWS, COLS);

for i = 1:length(ROWS)
    clustSize(i) = length(ROWS{i})*length(COLS{i});
end

[clustSize, index] = sort(clustSize);

R = cell(0);
S = cell(0);

for i = 1:length(index)
     R{length(index)-(i-1)} = ROWS{index(i)};
     S{length(index)-(i-1)} = COLS{index(i)};
end