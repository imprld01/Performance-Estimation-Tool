function varargout = PET(varargin)
    % PET MATLAB code for PET.fig
    %      PET, by itself, creates a new PET or raises the existing
    %      singleton*.
    %
    %      H = PET returns the handle to a new PET or the handle to
    %      the existing singleton*.
    %
    %      PET('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in PET.M with the given input arguments.
    %
    %      PET('Property','Value',...) creates a new PET or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before PET_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to PET_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help PET

    % Last Modified by GUIDE v2.5 21-Sep-2017 12:31:45

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @PET_OpeningFcn, ...
                       'gui_OutputFcn',  @PET_OutputFcn, ...
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
end


% --- Executes just before PET is made visible.
function PET_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to PET (see VARARGIN)

    % Choose default command line output for PET
    handles.output = hObject;

    % Customized Global Variables
    handles.idx = 0;        % current index
    handles.imgs = {};      % image path list
    handles.gt = {};        % ground truth
    handles.do = {};        % detected object
    handles.troubleID = []; % trouble frame name list
    
    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes PET wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = PET_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end


function edit2_Callback(hObject, eventdata, handles)
    % hObject    handle to edit2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hints: get(hObject,'String') returns contents of edit2 as text
    %        str2double(get(hObject,'String')) returns contents of edit2 as a double
end


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to edit2 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% Bottom-Back Button
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton8 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end


% Bottom-Next Button
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton9 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end


% Left-Back Button
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton10 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end


% Right-Next Button
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton11 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end


% first ... which is related to GT
% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton12 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end


% second ... which is related to DO
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton13 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end


% third ... which is related to Frame Dir
% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton14 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end


% Set
% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton15 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end


% Go
% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton16 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
end