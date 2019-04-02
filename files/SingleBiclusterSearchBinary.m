function bc = SingleBiclusterSearchBinary(data)
%% Search for a bicluster

[m n] = size(data);
P = sum(sum(data))/(m*n);
bcNumRows = floor(rand(1)^2*m/2)+1;
bcNumCols = floor(rand(1)^2*n/2)+1;

% start with a random columnset
% 
randomColPermutation = randperm(n);
colSet = (randomColPermutation<=bcNumCols);
clear fraction2select randomColPermutation;


%% First we search with bcNumRows and bcNumCols fixed
prevAvg = -Inf;
currAvg = 0;
while(prevAvg~=currAvg)
	prevAvg = currAvg;
	
	% calculate the row sums over the selected columns
	% rowSums = sum(data(:,colSet),2);
	
	rowSums = data*colSet';

	% sort sums, saving the info about order
	[sortedRowSums orderRowSums] = sort(rowSums,'descend');

	% select bcNumRows rows with larges averages
	rowSet = zeros(m,1);
	rowSet(orderRowSums(1:bcNumRows)) = true;

	% debug info
	%  	disp(mean(mean(data(logical(rowSet),logical(colSet)))));
	% 	disp(mean(sortedRowSums(1:bcNumRows))/bcNumCols);

	% calculate the column sums over the selected rows
	% colSums = sum(data(logical(rowSet),:),1);
	colSums = rowSet'*data;

	% sort sums, saving the information about permutation]
	[sortedColSums orderColSums] = sort(colSums,'descend');

	% select bcNumRows rows with larges averages
	colSet = zeros(1,n);
	colSet(orderColSums(1:bcNumCols)) = true;

	% mean(mean(data(logical(rowSet),logical(colSet))));
	currAvg = mean(sortedColSums(1:bcNumCols)/bcNumRows);
% 	disp([currAvg prevAvg currAvg==prevAvg]);

% 	disp(mean(sortedColSums(1:bcNumCols))/bcNumRows);
end;

clear prevAvg currAvg rowSums colSums sortedRowSums sortedColSums;
clear orderRowSums orderColSums;

%% now let bcNumRows and bcNumCols be flexible
prevScore = -Inf;
currScore = 0;
while(prevScore~=currScore)
	prevScore = currScore;
	
	% calculate the row sums over the selected columns
	% rowSums = sum(data(:,colSet),2);
	
	rowSums = data*colSet';

	% sort sums, saving the info about order
	[sortedRowSums orderRowSums] = sort(rowSums,'descend');

	% Calculate the sums of potential biclusters
	potBcSumsR = cumsum(sortedRowSums);
	% the Scores of the potential biclusters
	potScoresR = LAS_scoreBinary(potBcSumsR,(1:m)',bcNumCols,m,n,P);
	[maxPotScoreR bcNumRows] = max(potScoresR);
		
% 	disp(['bcNumRows = ' num2str(bcNumRows)]);
	
	rowSet = zeros(m,1);
	rowSet(orderRowSums(1:bcNumRows)) = true;

	% debug info
	%  	disp(mean(mean(data(logical(rowSet),logical(colSet)))));
	% 	disp(mean(sortedRowSums(1:bcNumRows))/bcNumCols);

	% calculate the column sums over the selected rows
	% colSums = sum(data(logical(rowSet),:),1);
	colSums = rowSet'*data;

	% sort sums, saving the information about permutation]
	[sortedColSums orderColSums] = sort(colSums,'descend');

	% Calculate the sums of potential biclusters
	potBcSumsC = cumsum(sortedColSums);
	% the Scores of the potential biclusters
	potScoresC = LAS_scoreBinary(potBcSumsC,bcNumRows,(1:n),m,n,P);
	[maxPotScoreC bcNumCols] = max(potScoresC);
	
% 	disp(['bcNumCols = ' num2str(bcNumCols)]);
	
	% select bcNumRows rows with larges averages
	colSet = zeros(1,n);
	colSet(orderColSums(1:bcNumCols)) = true;

	% mean(mean(data(logical(rowSet),logical(colSet))));
	currScore = maxPotScoreC;
% 	disp([currScore prevScore currScore==prevScore]);
% 	disp(['currScore = ' num2str(currScore)]);

% 	disp(mean(sortedColSums(1:bcNumCols))/bcNumRows);
end;

% clear prevScore rowSums colSums sortedRowSums sortedColSums;
% clear orderRowSums orderColSums;
% clear potBcSumsR potScoresR potBcSumsC potScoresC

bc = struct( ...
	'score', currScore, ...
	'rows', logical(rowSet), ...
	'cols', logical(colSet), ...
	'avg', mean(sortedColSums(1:bcNumCols))/bcNumRows);
return;
