function [x_label, y_label, output] = readInput(filename);

s = textread(filename,'%s','delimiter','\t| |,');

x_label = {};
y_label = {};
output = [];

% check if the input has label or not
containChar = false;
Str = s{1};
if (isempty(str2num(Str)))
    containChar = true;
else
    containChar = false;
end

if (containChar)
    NumRead = 0;
    FirstNum = false;
    while (~FirstNum)
        NumRead = NumRead + 1;
        if (NumRead > 1)
            Str = s{NumRead};
            if (isempty(str2num(Str)))
                x_label = {x_label{:}, ['C', num2str(NumRead - 1), ': ', Str]};
            else
                FirstNum = true;
            end
        end
    end
    NumCol = NumRead - 2;
    x_label(NumCol) = [];
    
    if (mod(size(s, 1), NumCol) ~= 0)
        error('The input data must be a rectangular matrix!!');
    else
        NumRow = size(s, 1) / NumCol;
    end
    y_label_ind = [1: (NumRow - 1)] * NumCol + 1;       % indices of y (row) label
    y_label = s(y_label_ind);
    for i = 1: length(y_label)
        y_label{i} = ['R', num2str(i), ':', y_label{i}];
    end
    values = s;
    values([[1: NumCol], y_label_ind]) = [];        % remove the labels
    output = str2double(values);

    output = reshape(output, NumCol - 1, NumRow - 1).';
    
else
    output = textread(filename);
    for i = 1: size(output, 2)
        x_label{i} = ['C', num2str(i)];
    end
    for i = 1: size(output, 1)
        y_label{i} = ['R', num2str(i)];
    end
end

