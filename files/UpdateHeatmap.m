function UpdateHeatmap(handles);

[M, N] = size(handles.Input);

if (handles.CLUSTNO > 0)
    % rows and columns of the bicluster
    BicRow = handles.CROWS{handles.CURCLUST};
    BicCol = handles.CCOLS{handles.CURCLUST};

    % rows and columns not in the bicluster
    NonBicRow = setdiff([1: M], BicRow);
    NonBicCol = setdiff([1: N], BicCol);

    % re-arranged order for display
    NewRowOrder = [BicRow, NonBicRow];
    NewColOrder = [BicCol, NonBicCol];

    % update list boxes for the current bicluster
    set(handles.BicGeneListbox, 'String', handles.y_label(BicRow));
    set(handles.BicCondListbox, 'String', handles.x_label(BicCol));

    set(handles.BicSelPopMenu, 'Value', handles.CURCLUST);
    
else
    NewRowOrder = [1: M];
    NewColOrder = [1: N];
    
end

% set current axes to the axes for heatmap plot
axes(handles.HeatmapPlot);
handles.Input(NewRowOrder, NewColOrder);
imagesc(handles.Input(NewRowOrder, NewColOrder));
colormap(handles.HM_Colormap);

hold on;

% draw boundaries for each datum
for i = 1: (M - 1)
    plot([0.5, N + 0.5], [0.5, 0.5] + i, 'b');
end
for j = 1: (N - 1)
    plot([0.5, 0.5] + j, [0.5, M + 0.5], 'b');
end

if (handles.CLUSTNO > 0)
    % draw boundaries for the bicluster
    plot([0.5, length(BicCol) + 0.5], [0.55, 0.55], 'c', 'LineWidth', 2);
    plot([0.5, length(BicCol) + 0.5], [length(BicRow), length(BicRow)] + 0.5, 'c', 'LineWidth', 2);
    plot([0.55, 0.55], [0.5, length(BicRow) + 0.5], 'c', 'LineWidth', 2);
    plot([length(BicCol), length(BicCol)] + 0.5, [0.5, length(BicRow) + 0.5], 'c', 'LineWidth', 2);
end

hold off;

% Create the labels for x-axis and y-axis
Y_AxisLabel = {};
for i = 1: M
    Y_AxisLabel{i} = ['R', num2str(NewRowOrder(i))];
end
X_AxisLabel = {};
for j = 1: N
    X_AxisLabel{j} = ['C', num2str(NewColOrder(j))];
end

% reset the position of the plot and update the ticks
set(gca, 'XLim', [0.5, handles.dx + 0.5], 'YLim', [0.5, handles.dy + 0.5], ...
         'XTickLabel', X_AxisLabel, 'YTickLabel', Y_AxisLabel, ...
         'XTick', [1: N], 'YTick', [1: M], ...
         'TickLength', [0, 0], ...
         'FontUnits', 'points', 'FontSize', 8);

set(handles.HeatmapPlot, 'XAxisLocation', 'top');

% reset the values of the sliders
set(handles.HorSlider, 'Value', get(handles.HorSlider, 'Min'));
set(handles.VerSlider, 'Value', get(handles.VerSlider, 'Max'));
    
% update colorbar for the heatmap
axes(handles.HM_Colorbar);          % change the current axis to the colorbar

MaxVal = max(handles.Input(:));
MinVal = min(handles.Input(:));
Val = (MaxVal - MinVal) * [0: 255] / 255 + MinVal;
imagesc(Val, [0, 1], repmat([0: 255], 2, 1));
colormap(handles.HM_Colormap);
set(handles.HM_Colorbar, 'YTick', [], 'XTick', [MinVal, MaxVal], ...
                         'FontUnits', 'points', 'FontSize', 8);


axes(handles.HeatmapPlot);      % change the current axis back to the heatmap plot

