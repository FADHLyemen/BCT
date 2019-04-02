function [nRows, nCols, nNoClust] = FilterBiclust(Rows, Cols, NoClust, MIN_NUM_ROW, MIN_NUM_COL, MAX_NUM_BIC, OVERLAP_ALLOW);

% DESCRIPTION
%
%   This function performs filtering of biclusters with respect to minimum no. of
%   rows, minimum no. of columns, maximum no. of biclusters and maximum of
%   overlapping allowed
%
% INPUT PARAMETERS
%   Rows    -   A structure array contains rows of each input bicluster. Rows{i} contains
%               the rows of the i-th bicluster.
%   Cols    -   A structure array contains columns of each input biclusters. Cols{i}
%               contains the columns of the i-th bicluster.
%   NoClust -   Number of input biclusters
%   MIN_NUM_ROW -   minimum number of rows allowed
%   MIN_NUM_COL -   minimum number of columns allowed
%   MAX_NUM_BIC -   maximum number of biclusters allowed
%   OVERLAP_ALLOW -   maximum of overlapping allowed. It has values between 0 and 100
%                     0 means no overlapping allowed. 100 means complete overlapping
%                     is allowed
%
% OUTPUT
%   nRows   -   A structure array contains rows of each bicluster after filtering. Rows{i}
%               contains the rows of the i-th bicluster.
%   nCols   -   A structure array contains columns of each biclusters after filtering.
%               Cols{i} contains the columns of the i-th bicluster.
%   nNoClust    -   Number of biclusters after filtering
%
%

OVERLAP_ALLOW = OVERLAP_ALLOW / 100;        % normalize the range from [0, 100] to [0, 1]

% initialize output variables
nRows = Rows;
nCols = Cols;
nNoClust = NoClust;

% filter with respect to min. number of rows and min. number of columns
tRows = {};
tCols = {};
tNoClust = 0;

for i_B = 1: nNoClust
    if ((length(Rows{i_B}) >= MIN_NUM_ROW) & (length(Cols{i_B}) >= MIN_NUM_COL))
        tNoClust = tNoClust + 1;
        tRows{tNoClust} = nRows{i_B};
        tCols{tNoClust} = nCols{i_B};
    end
end
% update output variable
nRows = tRows;
nCols = tCols;
nNoClust = tNoClust;


% sort the bicluster in the descending order of their sizes
BicSize = zeros(1, nNoClust);
for i_B = 1: nNoClust
    BicSize(i_B) = length(nRows{i_B}) * length(nCols{i_B});
end
[sBicSize, sInd] = sort(BicSize);
% convert from ascending order to descending order
sBicSize = sBicSize(end: -1: 1);
sInd = sInd(end: -1: 1);
nRows = nRows(sInd);
nCols = nCols(sInd);


% filter with respect to overlap allowed
%
% check the overlap begin with the largest bicluster
tRows = {};
tCols = {};
tNoClust = 0;
for i_B = 1: nNoClust
    if (tNoClust == 0)
        % add first bicluster
        tNoClust = tNoClust + 1;
        tRows{tNoClust} = nRows{i_B};
        tCols{tNoClust} = nCols{i_B};
    else
        % check overlap with the already added biclusters
        AddNew = 1;
        for i_tB = 1: tNoClust
            RowInt = intersect(tRows{i_tB}, nRows{i_B});
            ColInt = intersect(tCols{i_tB}, nCols{i_B});
            if ((length(RowInt) > OVERLAP_ALLOW * min(length(tRows{i_tB}), length(nRows{i_B}))) & (length(ColInt) > OVERLAP_ALLOW * min(length(tCols{i_tB}), length(nCols{i_B}))))
                AddNew = 0;
                break;
            end
        end
        
        if (AddNew == 1)
            tNoClust = tNoClust + 1;
            tRows{tNoClust} = nRows{i_B};
            tCols{tNoClust} = nCols{i_B};
        end
    end
end
nRows = tRows;
nCols = tCols;
nNoClust = tNoClust;


% filter with respect to max number of biclusters (note that they are sorted)
if (nNoClust > MAX_NUM_BIC)
    nRows = nRows(1: MAX_NUM_BIC);
    nCols = nCols(1: MAX_NUM_BIC);
    nNoClust = MAX_NUM_BIC;
end

