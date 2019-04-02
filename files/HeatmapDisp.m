function varargout = HeatmapDisp(varargin)
% HEATMAPDISP M-file for HeatmapDisp.fig
%      HEATMAPDISP, by itself, creates a new HEATMAPDISP or raises the existing
%      singleton*.
%
%      H = HEATMAPDISP returns the handle to a new HEATMAPDISP or the handle to
%      the existing singleton*.
%
%      HEATMAPDISP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HEATMAPDISP.M with the given input arguments.
%
%      HEATMAPDISP('Property','Value',...) creates a new HEATMAPDISP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HeatmapDisp_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HeatmapDisp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HeatmapDisp

% Last Modified by GUIDE v2.5 07-Jun-2007 17:30:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HeatmapDisp_OpeningFcn, ...
                   'gui_OutputFcn',  @HeatmapDisp_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HeatmapDisp is made visible.
function HeatmapDisp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HeatmapDisp (see VARARGIN)

% Choose default command line output for HeatmapDisp
handles.output = hObject;

% Input parameter contains handles of the calling GUI
InputHandles = varargin{1};

% Obtain the input data
handles.Input = InputHandles.Input;     % current data
handles.OriInput = handles.Input;       % original data

handles.x_label = InputHandles.x_label;
handles.y_label = InputHandles.y_label;

handles.CLUSTNO = InputHandles.CLUSTNO;

handles.CROWS = InputHandles.CROWS;
handles.CCOLS = InputHandles.CCOLS;

% disable if no bicluster is input
if (handles.CLUSTNO <= 0)
    handles.CURCLUST = 0;
    
    set(handles.BicSelPopMenu, 'String', '0', 'Enable', 'off');
    
    set(handles.PrevButton, 'Enable', 'off');
    set(handles.NextButton, 'Enable', 'off');
    
    set(handles.BicGeneListbox, 'String', '-');
    set(handles.BicCondListbox, 'String', '-');
    
else
    handles.CURCLUST = 1;
    
    % initialize the popup menu for the bicluster selection
    set(handles.BicSelPopMenu, 'String', num2cell([1: handles.CLUSTNO]));
    
end

% initialize the list boxes for the entire expression matrix
set(handles.OverallGeneListbox, 'String', handles.y_label);
set(handles.OverallCondListbox, 'String', handles.x_label);
    
[M, N] = size(handles.Input);

% the intervals for displaying the heatmap
handles.dx = 20;
handles.dy = 20;

% initialize the sliders
if (N - handles.dx > 0)
    set(handles.HorSlider, 'Min', 0, 'Max', N - handles.dx);
else
    set(handles.HorSlider, 'Enable', 'off', 'Visible', 'off');
end
if (M - handles.dy > 0)
    set(handles.VerSlider, 'Min', 0, 'Max', M - handles.dy);
else
    set(handles.VerSlider, 'Enable', 'off', 'Visible', 'off');
end

% initialize the figure
set(gcf, 'doublebuffer', 'on');     % avoids flickering when using sliders to update the plot

% generate colormap for heatmap
handles.HM_Colormap = zeros(256, 3);
handles.HM_Colormap(1: 128, 2) = [128: -1: 1].' / 128;      % green to black
handles.HM_Colormap(129: 256, 1) = [0: 1: 127] / 127;       % black to red

% update the heatmap based on the initial values
UpdateHeatmap(handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HeatmapDisp wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = HeatmapDisp_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function HorSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to HorSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function HorSlider_Callback(hObject, eventdata, handles)
% hObject    handle to HorSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.HeatmapPlot, 'XLim', [0.5, handles.dx + 0.5] + get(hObject, 'Value'));
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function VerSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VerSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function VerSlider_Callback(hObject, eventdata, handles)
% hObject    handle to VerSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

set(handles.HeatmapPlot, 'YLim', [0.5, handles.dy + 0.5] + size(handles.Input, 1) - handles.dy - get(hObject, 'Value'));
guidata(hObject, handles);


% --- Executes on button press in PrevButton.
function PrevButton_Callback(hObject, eventdata, handles)
% hObject    handle to PrevButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (handles.CURCLUST <= 1)
    handles.CURCLUST = handles.CLUSTNO;
else
    handles.CURCLUST = handles.CURCLUST - 1;
end
UpdateHeatmap(handles);

guidata(hObject, handles);




% --- Executes on button press in NextButton.
function NextButton_Callback(hObject, eventdata, handles)
% hObject    handle to NextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (handles.CURCLUST >= handles.CLUSTNO)
    handles.CURCLUST = 1;
else
    handles.CURCLUST = handles.CURCLUST + 1;
end
UpdateHeatmap(handles);

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function OverallCondListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OverallCondListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in OverallCondListbox.
function OverallCondListbox_Callback(hObject, eventdata, handles)
% hObject    handle to OverallCondListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns OverallCondListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OverallCondListbox


% --- Executes during object creation, after setting all properties.
function OverallGeneListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OverallGeneListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in OverallGeneListbox.
function OverallGeneListbox_Callback(hObject, eventdata, handles)
% hObject    handle to OverallGeneListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns OverallGeneListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OverallGeneListbox


% --- Executes during object creation, after setting all properties.
function BicCondListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BicCondListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in BicCondListbox.
function BicCondListbox_Callback(hObject, eventdata, handles)
% hObject    handle to BicCondListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns BicCondListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BicCondListbox


% --- Executes during object creation, after setting all properties.
function BicGeneListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BicGeneListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in BicGeneListbox.
function BicGeneListbox_Callback(hObject, eventdata, handles)
% hObject    handle to BicGeneListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns BicGeneListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BicGeneListbox


% --- Executes during object creation, after setting all properties.
function BicSelPopMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BicSelPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in BicSelPopMenu.
function BicSelPopMenu_Callback(hObject, eventdata, handles)
% hObject    handle to BicSelPopMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns BicSelPopMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BicSelPopMenu

handles.CURCLUST = get(hObject, 'Value');
UpdateHeatmap(handles);

guidata(hObject, handles);


% --- Executes when figure1 window is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in ExitButton.
function ExitButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on button press in ClipOutlinerBtn.
function ClipOutlinerBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ClipOutlinerBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClipOutlinerBtn

handles.Input = handles.OriInput;
if (get(hObject, 'Value'))
    % remove outliners which are defined as 2.5% data at the upper and lower ends
    [sData, sInd] = sort(handles.OriInput(:));
    NumThres = ceil(length(sData) * 0.025);
    MinThres = sData(NumThres);
    MaxThres = sData(end - NumThres + 1);

    handles.Input(sInd(1: NumThres)) = MinThres;
    handles.Input(sInd(end - NumThres + 1: end)) = MaxThres;
end

UpdateHeatmap(handles);
guidata(hObject, handles);
