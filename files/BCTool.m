function varargout = BCTool(varargin)
% BCTool MATLAB code for BCTool.fig
%      BCTool, by itself, creates a new BCTool or raises the existing
%      singleton*.
%
%      H = BCTool returns the handle to a new BCTool or the handle to
%      the existing singleton*.
%
%      BCTool('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BCTool.M with the given input arguments.
%
%      BCTool('Property','Value',...) creates a new  or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before _OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BCTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BCTool

% Last Modified by GUIDE v2.5 28-May-2011 20:16:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @BCTool_OpeningFcn, ...
                   'gui_OutputFcn',  @BCTool_OutputFcn, ...
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


% --- Executes just before BCTool is made visible.
function BCTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BCTool (see VARARGIN)

% Choose default command line output for BCTool
handles.output = hObject;

% Update handles structure

    set(handles.Export,'Enable','off');
    set(handles.ISA_Export,'Enable','off');
    set(handles.LAS_Export,'Enable','off');
    set(handles.BIVISU_Export,'Enable','off');
    set(handles.Filter,'Enable','off');
    set(handles.ISA_Filter,'Enable','off');
    set(handles.LAS_Filter,'Enable','off');
    set(handles.BIVISU_Filter,'Enable','off');
    set(handles.Run,'Enable','off');
    %set(handles.LogarithmMenuItem,'Checked','off');
    %set(handles.NoneMenuItem,'Checked','off');
    set(handles.ISA,'Enable','off');
    set(handles.LAS,'Enable','off');
    set(handles.CompareMenu,'Enable','off');
    set(handles.BIVISU, 'Enable', 'off');
    set(handles.Quit,'Enable','on');
    set(handles.Load,'Enable','on');
    
    handles.x_label = {};
    handles.y_label = {};
    handles.CROWS = {};
    handles.CCOLS = {};
    handles.CLUSTNO = 0;

    
guidata(hObject, handles);

% UIWAIT makes BCTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = BCTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Run_Callback(hObject, eventdata, handles)
% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CompareMenu_Callback(hObject, eventdata, handles)
% hObject    handle to CompareMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ComparedBilusters=get(handles.ClusterPathFileEditbox,'string');
% disp(ComparedBilusters)
% AGOPathFile=get(handles.GoPathFileEditbox,'string');
% disp(AGOPathFile)
% [GO LL]=AGO(ComparedBilusters,  AGOPathFile)
%guidata(hObject,handles);




% --------------------------------------------------------------------
% function ISA_Callback(hObject, eventdata, handles)
% hObject    handle to ISA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% ISA( output,13,1,1 )

% --------------------------------------------------------------------
function BIVISU_Callback(hObject, eventdata, handles)
% hObject    handle to BIVISU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Prompt = {'Minimum no. of rows:','Minimum no. of columns','Maximum % of overlapping allowed:','Model type:'};
    Title = 'bivisu run';
    DefaultAnswer = {'10','5','25','a'};
    LineNo = 1;
    Answer = INPUTDLG(Prompt,Title,LineNo,DefaultAnswer);
    [r c]=size(Answer);
    if r > 1
        NoiseTh=std(handles.Input(:));
        [r c]=size(handles.Input);
        Pr=round((str2double(Answer{1,1})/r)*100);
        
        h=msgbox('BIVISU is running....please wait','BIVISU run','none');
        [rg cg]=size(handles.genes_labels);
        [rc cc]=size(handles.chips_labels);
        [handles.Biclusters,no,chips,genes]=BivisuBicluster(handles.Input,NoiseTh, Pr,str2double(Answer{2}),str2double(Answer{3}),Answer{4},cg,cc);
        chips
        genes
        if (no)
            [IROWS,ICOLS] = sortclusters(chips, genes);
            handles.CROWS = IROWS;
            handles.CCOLS = ICOLS;
            handles.CLUSTNO =no;
            handles.CURCLUST = 1;
        else
            msgbox('No bicluster was found.','Warning');
            handles.CROWS = {};
            handles.CCOLS = {};
            handles.CLUSTNO = 0;
            handles.CURCLUST = 0;
        end
        set(handles.Export,'Enable','on');
        set(handles.BIVISU_Export,'Enable','on');
        set(handles.ISA_Export,'Enable','off');
        set(handles.LAS_Export,'Enable','off');
        set(handles.CompareMenu,'Enable','on');
        set(handles.Compare,'Enable','on');
        str=[get(handles.Maintxt,'String'),'. Data is completed running successfully using BIVISU  algorithm.'];
        set(handles.Maintxt,'String',str);
        close(h);
        h = msgbox('Bivisu is completed........','Bivisu run','none');
    else
    end
    guidata(hObject,handles);
    

% --------------------------------------------------------------------
function LAS_Callback(hObject,eventdata , handles)
% hObject    handle to LAS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Prompt = {'Max. number of Biclustes:','No. of iterations per Bicluster','Score Threshold'};
    Title = 'LAS run';
    DefaultAnswer = {'5','5','10'};
    LineNo = 1;
    Answer = INPUTDLG(Prompt,Title,LineNo,DefaultAnswer);
    [r c]=size(Answer);
    genes={};
    chips={};
    if r > 1
        h=msgbox('LAS is running....please wait','LAS run','none');
        [handles.DiscretizedInput]=Discretization(handles.Input);
        [LASBiclusters]=LAS_SearchForBCsBinary(handles.DiscretizedInput,str2double( Answer{1}), str2double(Answer{2}) ,str2double(Answer{3}));
        [r c]=size(LASBiclusters);
        handles.CLUSTNO=c;
        [rg cg]=size(handles.genes_labels);
        [rc cc]=size(handles.chips_labels);
        if cg > cc
           BiClusterMatrix=zeros(2*c,cg);
        else
           BiClusterMatrix=zeros(2*c,cc);
        end

        for i=1:c
           count=0;
           [struct_rGenes struct_cGenes]=size(LASBiclusters(i).rows);
           for j=1:struct_rGenes
               if LASBiclusters(i).rows(j)==1
                   count=count+1;
                   BiClusterMatrix(2*i-1,count)=j;
                   genes{1,i}(count)=j;
               end
           end
           count=0;
           [struct_rChips, struct_cChips]=size(LASBiclusters(i).cols);
           for k=1:struct_cChips
               if LASBiclusters(i).cols(k)==1
                   count=count+1;
                   BiClusterMatrix(2*i,count)=k;
                   chips{1,i}(count)=k;
               end
           end
        end
        handles.CROWS = genes;
        handles.CCOLS = chips;
        handles.LASBiCluster=BiClusterMatrix;
        handles.Biclusters=BiClusterMatrix;  
        set(handles.Export,'Enable','on');
        set(handles.LAS_Export,'Enable','on');
        set(handles.ISA_Export,'Enable','off');
        set(handles.BIVISU_Export,'Enable','off');
        set(handles.CompareMenu,'Enable','on');
        set(handles.Compare,'Enable','on');
        %set(handles.Filter,'Enable','on');
        close(h);
        str=[get(handles.Maintxt,'String'),'.Data is completed running successfully using LAS binary algorithm.'];
        set(handles.Maintxt,'String',str);
        h = msgbox('LAS is completed........','LAS run','none');
        %set(handles.Export,'Enable','on')
        %f = figure('Position', [10 10 752 650]);
        %t = uitable('Parent', f, 'Position', [25 25 700 600]);
        %set(t, 'Data',BiClusterMatrix);
    else
    end
    guidata(hObject,handles);
% --------------------------------------------------------------------
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname, filterindex] = uigetfile('*.txt', 'Pick an Input-file');

%data=textread(filename,'%s','delimiter','\t');
%handles.listbox3=data;
s = textread(filename,'%s','delimiter','\t| |,');
if (filename)
    %     handles.Input = textread(filename);
    [handles.chips_labels, handles.genes_labels, handles.Input] = readInput2(filename);
 
    handles.x_label =handles.chips_labels;
    handles.y_label = handles.genes_labels;
    handles.OriInput = handles.Input;
    if (any(handles.Input(:) <= 0))
        handles.disableLog = 1;
    else
        handles.disableLog = 0;
        handles.LogInput = log10(handles.Input);
    end
    
    set(handles.Export,'Enable','off');
    set(handles.ISA_Export,'Enable','off');
    set(handles.LAS_Export,'Enable','off');
    set(handles.BIVISU_Export,'Enable','off');
    set(handles.Filter,'Enable','off');
    set(handles.ISA_Filter,'Enable','off');
    set(handles.LAS_Filter,'Enable','off');
    set(handles.BIVISU_Filter,'Enable','off');
    set(handles.Run,'Enable','on');
    %set(handles.LogarithmMenuItem,'Checked','off');
    %set(handles.NoneMenuItem,'Checked','off');
    set(handles.ISA,'Enable','on');
    set(handles.LAS,'Enable','on');
    set(handles.CompareMenu,'Enable','off');
    set(handles.BIVISU, 'Enable', 'on');
    set(handles.Quit,'Enable','on');
    Str=['Data sample is loaded successfuly. Number of Genes = ',num2str(length(handles.genes_labels))];
    Str=[Str,' Number of Chips = '];
    Str=[Str,num2str(length(handles.chips_labels))];
    set(handles.Maintxt,'String',Str);
    h = msgbox('Data is loaded successfully','Data load','none');
    %set(handles.HeatmapMenuItem, 'Enable', 'on');
    %set(handles.ConfigurationMenuItem, 'Enable', 'off');
    
    %set(handles.RefColumnPop,'Enable','off');
    
%     handles.ICLUSTNO = 0;
%     handles.IROWS = {};
%     handles.ICOLS = {};
%     
%     handles.CLUSTNO = 0;
%     handles.CROWS = {};
%     handles.CCOLS = {};
%     
%     handles.CURCLUST = 0;
% 
%     handles.prePro = 'None';
%     handles.PLOTTYPE = 1;
%             
%     handles.FilterAns = {};
%     handles.BiclustAns = {};
%     handles.Model = [];
    
%     handles = UpdatePanelGlob(handles);
%     handles = UpdatePanelLoc(handles);
%     PlotFig(handles);
end


guidata(hObject, handles);
% f = figure('Position', [10 10 752 650]);
% t = uitable('Parent', f, 'Position', [25 25 700 600]);
% set(t, 'Data',handles.Input);
% f = figure('Position', [10 10 752 650]);
% t = uitable('Parent', f, 'Position', [25 25 700 600]);
% set(t, 'Data',handles.y_label);

% --------------------------------------------------------------------
function Export_Callback(hObject, eventdata, handles)
% hObject    handle to Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%PPGUI6Pop1(handles);
%handles.Ouput1 = get(handles.Output1Checkbox,'Value');
%handles.Ouput2 = get(handles.Output2Checkbox,'Value');






% --------------------------------------------------------------------
function Filter_Callback(hObject, eventdata, handles)
% hObject    handle to Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function ISA_Callback(hObject, ~, handles)
% hObject    handle to ISA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt={'Set seeds for random number generator','Set t_g (threshold gene):','Set t_c (threshold chips):'...
        ,'Set the number of starting points:'};
name='Run ISA ';
numlines=1;
defaultanswer={'13','2','2','50'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=inputdlg(prompt,name,numlines,defaultanswer,options);
[r ,c]=size(answer);
if r > 1

    set(handles.Export,'Enable','on');
    set(handles.ISA_Export,'Enable','on');
    set(handles.LAS_Export,'Enable','off');
    set(handles.BIVISU_Export,'Enable','off');
    set(handles.CompareMenu,'Enable','on');
    set(handles.Compare,'Enable','on');
    %set(handles.Filter,'Enable','on')ISA_Export
    h=msgbox('ISA is running....please wait','ISA run','none');
    [handles.Biclusters,handles.CLUSTNO,handles.CCOLS,handles.CROWS]=ISA( handles.Input,str2double(answer{1}),str2double(answer{2}),str2double(answer{3}),str2double(answer{4}));
    close(h);
    h=msgbox('ISA is completed....','ISA run','none');
    str=0;
    str=[get(handles.Maintxt,'String'), '.Data is completed running successfully using ISA algorithm.'];
    set(handles.Maintxt,'String',str);
    handles.ISABiClusters=handles.Biclusters;
else 
end
guidata(hObject,handles);

% --------------------------------------------------------------------
function Quit_Callback(hObject, eventdata, handles)
% hObject    handle to Quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;






% --- Executes on button press in right1.
function right1_Callback(hObject, eventdata, handles)
% hObject    handle to right1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%var1 = get_var_names(handles);
list_entries = get(handles.AvailableList,'String');
index_selected = get(handles.AvailableList,'Value');
% if length(index_selected) ~= 2
% 	errordlg('You must select two variables',...
% 			'Incorrect Selection','modal')
% else
	var1 = list_entries{index_selected};
	%var2 = list_entries{index_selected(2)};
 %end 
set(handles.ComparedList,'String',var1);
set(handles.ComparedList,'value',1);
namefile=var1;
set(handles.Fnametext,'string',namefile);
%set(handles.ComparedList,'String',var2);

guidata(hObject,handles)

% --- Executes on button press in left1.
% function left1_Callback(hObject, ~, handles)
% % hObject    handle to left1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% set(handles.ComparedList,'String',[]);
% set(handles.ComparedList,'value',0);
% set(handles.Fnametext,'string',[]);
% guidata(hObject,handles);





function Optionsuipanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Optionsuipanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
%buttonTags = {'Option1RadioBttn' 'Option2radiobttn' 'Option3RadioBttn'};
varTag=get(eventdata.OldValue,'Tag');
varTag=get(eventdata.NewValue,'Tag');
%index = strcmp(varTag,buttonTags);     % Find index of match in buttonTags
%set(handles.lineHandles(index),'Visible','on'); 
switch varTag     % Get Tag of selected object.
    case 'Option1RadioBttn'
        handles.MinGenes='0';
        handles.MinIdenGenes='0';
        handles.Index='1';
        handles.GenOntology=[];
        % Code for when radiobutton1 is selected.
    case 'Option2radiobttn'
        var=get(handles.MinGenesEdtbox,'string');
        v=var(1);
        handles.MinGenes=v;
        var2=get(handles.MinIdentifiedgenesEdtTxt,'string');
        v2=var2(1);
        handles.MinIdenGenes=v2;
        handles.Index=2;
        handles.GenOntology=[];
        % Code for when radiobutton2 is selected.
    case 'Option3RadioBttn'
        var3=get(handles.GeneOntgyEdtTxt,'string');
        handles.GenOntology=var3(1);
        handles.MinGenes=10000;
        handles.MinIdenGenes=10000;
        handles.Index=3;
        % Code for when togglebutton1 is selected.
        % Code for when togglebutton2 is selected.
    % Continue with more cases as necessary.
    otherwise
        % Code for when there is no match.
end
guidata(hObject,handles)


% --- Executes on button press in GetFilebttn.
function GetFilebttn_Callback(hObject, eventdata, handles)
% hObject    handle to GetFilebttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt={'How many Biclusters you want to compare:'};
name='Biclusters Number to compare: ';
numlines=1;
defaultanswer={'3'};
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
answer=inputdlg(prompt,name,numlines,defaultanswer,options);
[r,z]=size(answer);
if r > 0
    StrItems=0;
    FileName=0;
    BC=0;

    for i=1:str2num(answer{1})    
        [filename, pathname, filterindex] = uigetfile('*.txt', 'Pick an Input-file');

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


% --------------------------------------------------------------------
function Compare_Callback(hObject, eventdata, handles)
% hObject    handle to Compare (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Compare(handles);


% --- Executes on selection change in Mainlstbox.
function Mainlstbox_Callback(hObject, eventdata, handles)
% hObject    handle to Mainlstbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Mainlstbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Mainlstbox



% --------------------------------------------------------------------
function ISA_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to ISA_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Prompt = {'Minimum no. of rows:','Minimum no. of columns:','Maximum no. of biclusters:','Maximum % of overlapping allowed:'};
Title = 'Filter Setup Dialog';
%minRow = num2str(size(handles.Input, 1) * str2double(handles.BiclustAns{1})/100);
%minCol = handles.BiclustAns{3};
%maxOverlap = handles.BiclustAns{4};
DefaultAnswer = {'1','1','50','100'};
LineNo = 1;
Answer = {};
Answer = INPUTDLG(Prompt,Title,LineNo,DefaultAnswer);
[r,c]=size(Answer);
if r > 1
    getFileUpdate( str2num(Answer{1}),str2num(Answer{2}),str2num(Answer{3}),str2num(Answer{4}),'isa.txt' );
    h = msgbox('Data is filtered successfully','ISA Filter','none');
    str=[get(handles.Maintxt,'String'), '.Data is filtered successfully with ISA algorithm.'];
    set(handles.Maintxt,'String',str);
else
end
%handles.Biclusters=FilterBiCluster( handles.LASBiCluster,str2double(Answer{1}),str2double(Answer{2}),str2double(Answer{3}),str2double(Answer{4}));
%SaveClusters('LAS.txt',handles.Biclusters);
guidata(hObject, handles);

% --------------------------------------------------------------------
function LAS_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to LAS_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Prompt = {'Minimum no. of rows:','Minimum no. of columns:','Maximum no. of biclusters:','Maximum % of overlapping allowed:'};
Title = 'Filter Setup Dialog';
%minRow = num2str(size(handles.Input, 1) * str2double(handles.BiclustAns{1})/100);
%minCol = handles.BiclustAns{3};
%maxOverlap = handles.BiclustAns{4};
DefaultAnswer = {'1','1','50','100'};
LineNo = 1;
Answer = {};
Answer = INPUTDLG(Prompt,Title,LineNo,DefaultAnswer);
[r,c]=size(Answer);
if r > 1

    getFileUpdate( str2num(Answer{1}),str2num(Answer{2}),str2num(Answer{3}),str2num(Answer{4}),'las.txt' );
    h = msgbox('Data is filtered successfully','LAS Filter','none');
    str=[get(handles.Maintxt,'String'), '.Data is filtered successfully with LAS algorithm.'];
    set(handles.Maintxt,'String',str);
%handles.Biclusters=FilterBiCluster( handles.LASBiCluster,str2double(Answer{1}),str2double(Answer{2}),str2double(Answer{3}),str2double(Answer{4}));
%SaveClusters('LAS.txt',handles.Biclusters);
else
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function BIVISU_Filter_Callback(hObject, eventdata, handles)
% hObject    handle to BIVISU_Filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Prompt = {'Minimum no. of rows:','Minimum no. of columns:','Maximum no. of biclusters:','Maximum % of overlapping allowed:'};
Title = 'Filter Setup Dialog';
%minRow = num2str(size(handles.Input, 1) * str2double(handles.BiclustAns{1})/100);
%minCol = handles.BiclustAns{3};
%maxOverlap = handles.BiclustAns{4};
DefaultAnswer = {'1','1','50','100'};
LineNo = 1;
Answer = {};
Answer = INPUTDLG(Prompt,Title,LineNo,DefaultAnswer);
[r,c]=size(Answer);
if r > 1
    getFileUpdate( str2num(Answer{1}),str2num(Answer{2}),str2num(Answer{3}),str2num(Answer{4}),'bivisue.txt' );
    h = msgbox('Data is filtered successfully','BIVISU Filter','none');
    str=[get(handles.Maintxt,'String'), '.Data is filtered successfully with BIVISU algorithm.'];
    set(handles.Maintxt,'String',str);
else
end
%handles.Biclusters=FilterBiCluster( handles.LASBiCluster,str2double(Answer{1}),str2double(Answer{2}),str2double(Answer{3}),str2double(Answer{4}));
%SaveClusters('LAS.txt',handles.Biclusters);
guidata(hObject, handles);

% --------------------------------------------------------------------
function ISA_Export_Callback(hObject, eventdata, handles)
% hObject    handle to ISA_Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Prompt = {'File name of the output bicluster information:'};
    Title = 'Output the information of all biclusters found';
    DefaultAnswer = {'isa.txt'};
    LineNo = 1;
    Answer = INPUTDLG(Prompt,Title,LineNo,DefaultAnswer);
    [r,c]=size(Answer);
    if r > 0
        SaveClusters(Answer{1},handles.Biclusters);
        set(handles.Filter,'Enable','on');
        set(handles.ISA_Filter,'Enable','on');
        h = msgbox('Data is exported successfully','ISA Export','none');
        str=[get(handles.Maintxt,'String'), '.Data is exported successfully with ISA algorithm.'];
        set(handles.Maintxt,'String',str);
    else
    end
    guidata(hObject,handles);



% --------------------------------------------------------------------
function LAS_Export_Callback(hObject, eventdata, handles)
% hObject    handle to LAS_Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Prompt = {'File name of the output bicluster information:'};
    Title = 'Output the information of all biclusters found';
    DefaultAnswer = {'las.txt'};
    LineNo = 1;
    Answer = INPUTDLG(Prompt,Title,LineNo,DefaultAnswer);
    [r,c]=size(Answer);
    if r > 0
        SaveClusters(Answer{1},handles.Biclusters);
        set(handles.Filter,'Enable','on');
        set(handles.LAS_Filter,'Enable','on');
        h = msgbox('Data is exported successfully','LAS Export','none');
        str=[get(handles.Maintxt,'String'), '.Data is exported successfully with LAS algorithm.'];
        set(handles.Maintxt,'String',str);
    else
    end
    guidata(hObject,handles);


% --------------------------------------------------------------------
function BIVISU_Export_Callback(hObject, eventdata, handles)
% hObject    handle to BIVISU_Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    Prompt = {'File name of the output bicluster information:'};
    Title = 'Output the information of all biclusters found';
    DefaultAnswer = {'bivisue.txt'};
    LineNo = 1;
    Answer = INPUTDLG(Prompt,Title,LineNo,DefaultAnswer);
    [r,c]=size(Answer);
    if r > 0
        SaveClusters(Answer{1},handles.Biclusters);
        set(handles.Filter,'Enable','on');
        set(handles.BIVISU_Filter,'Enable','on');
        set(handles.Maintxt,'String','Data is exported successfully.');
        h = msgbox('Data is exported successfully','BIVISU Export','none');
        str=[get(handles.Maintxt,'String'), '.Data is exported successfully with BIVISU algorithm.'];
        set(handles.Maintxt,'String',str);
    else
    end
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function Mainlstbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Mainlstbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Display_Callback(hObject, eventdata, handles)
% hObject    handle to Display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --------------------------------------------------------------------
function HeatMap_Callback(hObject, eventdata, handles)
% hObject    handle to HeatMap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HeatmapDisp(handles);
