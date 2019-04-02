function varargout = Compare(varargin)
% COMPARE MATLAB code for Compare.fig
%      COMPARE, by itself, creates a new COMPARE or raises the existing
%      singleton*.
%
%      H = COMPARE returns the handle to a new COMPARE or the handle to
%      the existing singleton*.
%
%      COMPARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COMPARE.M with the given input arguments.
%
%      COMPARE('Property','Value',...) creates a new COMPARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Compare_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Compare_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Compare

% Last Modified by GUIDE v2.5 21-May-2011 20:19:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Compare_OpeningFcn, ...
                   'gui_OutputFcn',  @Compare_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Compare is made visible.
function Compare_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Compare (see VARARGIN)

% Choose default command line output for Compare
handles.output = hObject;
handles.MinGenes=0;
handles.MinIdenGenes=0;
handles.Index=3;
handles.NoOfBiclusters=0;
handles.GenOntology=get(handles.GeneOntgyEdtTxt,'String');
set(handles.Optionsuipanel,'SelectionChangeFcn',@Optionsuipanel_SelectionChangeFcn);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Compare wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Compare_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in ComparedList.
function ComparedList_Callback(hObject, eventdata, handles)
% hObject    handle to ComparedList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ComparedList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ComparedList


% --- Executes during object creation, after setting all properties.
function ComparedList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ComparedList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GoPathFileEditbox_Callback(hObject, eventdata, handles)
% hObject    handle to GoPathFileEditbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GoPathFileEditbox as text
%        str2double(get(hObject,'String')) returns contents of GoPathFileEditbox as a double


% --- Executes during object creation, after setting all properties.
function GoPathFileEditbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GoPathFileEditbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Comparebttn.
function Comparebttn_Callback(hObject, eventdata, handles)
% hObject    handle to Comparebttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FileCompareCluster=get(handles.Fnametext,'string');
AGOPathFile=get(handles.GoPathFileEditbox,'string');
%NoOfComparisons=str2num(get(handles.NoOfBiclusters,'String'));
AGO(FileCompareCluster,  AGOPathFile,handles.MinGenes,handles.MinIdenGenes,handles.Index,handles.GenOntology,handles.NoOfBiclusters);
guidata(hObject,handles);


% --- Executes on button press in GetFilebttn.
function GetFilebttn_Callback(hObject, eventdata, handles)
% hObject    handle to GetFilebttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt={'How many Biclusters you want to compare:'};
name='Biclusters Number to compare: ';
numlines=1;
defaultanswer={'2'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=inputdlg(prompt,name,numlines,defaultanswer,options);
[r,c]=size(answer);
if r > 0
    StrItems=0;
    FileName=0;
    handles.NoOfBiclusters=round(str2num(answer{1}));
    BC=0;

    for i=1:str2num(answer{1})    
        [filename, ~, filterindex] = uigetfile('*.txt', 'Pick an Input-file');

        if i==1
            StrItems=filename;
            for m=1:length(filename)-4
                FileName(m)=filename(m);
            end
        else
            StrItems=strcat(StrItems,'|');
            StrItems=strcat(StrItems,filename);
            for m=1:length(filename)-4
                BC(m)=filename(m);
            end

            FileName=[FileName,' '];
            FileName=[FileName,BC];
            %FileName=strcat(FileName,BC);
        end
        BC=0;
    end
        set(handles.ComparedList,'String',StrItems);
        set(handles.ComparedList,'value',[1 str2num(answer{1})]);
        set(handles.ComparedList,'Max',str2num(answer{1}));
        set(handles.ComparedList,'Min',0);
        set(handles.Fnametext,'String',FileName);
else
end
guidata(hObject,handles)



function GeneOntgyEdtTxt_Callback(hObject, eventdata, handles)
% hObject    handle to GeneOntgyEdtTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GeneOntgyEdtTxt as text
%        str2double(get(hObject,'String')) returns contents of GeneOntgyEdtTxt as a double


% --- Executes during object creation, after setting all properties.
function GeneOntgyEdtTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GeneOntgyEdtTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MinIdentifiedgenesEdtTxt_Callback(hObject, eventdata, handles)
% hObject    handle to MinIdentifiedgenesEdtTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinIdentifiedgenesEdtTxt as text
%        str2double(get(hObject,'String')) returns contents of MinIdentifiedgenesEdtTxt as a double


% --- Executes during object creation, after setting all properties.
function MinIdentifiedgenesEdtTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinIdentifiedgenesEdtTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MinGenesEdtbox_Callback(hObject, eventdata, handles)
% hObject    handle to MinGenesEdtbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinGenesEdtbox as text
%        str2double(get(hObject,'String')) returns contents of MinGenesEdtbox as a double


% --- Executes during object creation, after setting all properties.
function MinGenesEdtbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinGenesEdtbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in Optionsuipanel.
function Optionsuipanel_SelectionChangeFcn(hObject, eventdata)
% hObject    handle to the selected object in Optionsuipanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
Tagevent=get(eventdata.OldValue,'Tag');
Tagevent=get(eventdata.NewValue,'Tag') ;
%index = strcmp(varTag,buttonTags);     % Find index of match in buttonTags
%set(handles.lineHandles(index),'Visible','on'); 
switch Tagevent     % Get Tag of selected object.
    case 'Option1RadioBttn'
        handles.MinGenes=0;
        handles.MinIdenGenes=0;
        handles.Index=1;
        handles.GenOntology='';
        % Code for when Option3RadioBttn is selected.
    case 'Option2radiobttn'
        var=get(handles.MinGenesEdtbox,'String');
        %v=var(1);
        handles.MinGenes=str2num(var);
        var2=get(handles.MinIdentifiedgenesEdtTxt,'String');
        %v2=var2(1);
        handles.MinIdenGenes=str2num(var2);
        handles.Index=2;
        handles.GenOntology='';
        % Code for when Option2radiobttn is selected.
    case 'Option3RadioBttn'
        var3=get(handles.GeneOntgyEdtTxt,'String');
        handles.GenOntology=var3;
        handles.MinGenes=0;
        handles.MinIdenGenes=0;
        handles.Index=3;
        % Code for when togglebutton1 is selected.
        % Code for when togglebutton2 is selected.
    % Continue with more cases as necessary.
    otherwise
        % Code for when there is no match.
end
guidata(hObject,handles);
