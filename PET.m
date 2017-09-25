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
    
    troubleID = handles.troubleID;
    limit = size(troubleID);
    if handles.idx <= findImagesIndex(handles.imgs, troubleID(1))
        warndlg('No Previous Trouble Frame Available!','Warning');
    else
        for index = limit(2) : -1 : 1
            idx = findImagesIndex(handles.imgs, troubleID(index));
            if idx < handles.idx
                handles.idx = idx;
                guidata(hObject, handles);
                showImageMarks(handles);
                break;
            end
        end
    end
end


% Bottom-Next Button
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton9 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    troubleID = handles.troubleID;
    limit = size(troubleID);
    if handles.idx >= findImagesIndex(handles.imgs, troubleID(limit(2)))
        warndlg('No Next Trouble Frame Available!','Warning');
    else
        for index = 1 : limit(2)
            idx = findImagesIndex(handles.imgs, troubleID(index));
            if idx > handles.idx
                handles.idx = idx;
                guidata(hObject, handles);
                showImageMarks(handles);
                break;
            end
        end
    end
end


% Left-Back Button
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton10 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if handles.idx > 1
        handles.idx = handles.idx - 1;
        guidata(hObject, handles);
        showImageMarks(handles);
    else
        warndlg('No Previous Frame Available!','Warning');
    end
end


% Right-Next Button
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton11 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if handles.idx < length(handles.imgs)
        handles.idx = handles.idx + 1;
        guidata(hObject, handles);
        showImageMarks(handles);
    else
        warndlg('No Next Frame Available!','Warning');
    end
end


% first ... which is related to GT
% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton12 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    [fName_gt,pName_gt] = uigetfile('*.txt','Select the ground truth file');
    fPath = strcat(pName_gt, fName_gt);
    set(handles.text11, 'String', fPath);   % set path on ui

    [frames, lbx, lby, rtx, rty] = textread(fPath, '%s %f %f %f %f');
    
    handles.gt = [frames, num2cell(lbx), num2cell(lby), num2cell(rtx), num2cell(rty)];
    guidata(hObject, handles);
end


% second ... which is related to DO
% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton13 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    [fName_do,pName_do] = uigetfile('*.txt','Select the detected output file');
    fPath = strcat(pName_do, fName_do);
    set(handles.text13, 'String', fPath);   % set path on ui
    
    [frames, lbx, lby, rtx, rty, ~] = textread(fPath, '%s %f %f %f %f %f');
    
    handles.do = [frames, num2cell(lbx), num2cell(lby), num2cell(rtx), num2cell(rty)];
    guidata(hObject, handles);
end


% third ... which is related to Frame Dir
% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton14 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    dName_img = uigetdir('');
    set(handles.text12, 'String', dName_img);   % set path on ui
    
    % save all files' path string array in global area
    handles.imgs = getAllFiles(dName_img);
    guidata(hObject, handles);
end


% Set
% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton15 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if handles.idx == 0
        handles.idx = 1;
        guidata(hObject, handles);
    end
    
    handles.troubleID = calTroubles(handles);
    guidata(hObject, handles);
    
    showImageMarks(handles);
end


% Go
% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton16 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    wanted = get(handles.edit2, 'String');
    result = findImagesIndex(handles.imgs, wanted);
    if handles.idx ~= result
        handles.idx = result;
        guidata(hObject, handles);
        showImageMarks(handles);
    end
end


% from https://cn.mathworks.com/matlabcentral/fileexchange/48238-nonstationary-extreme-value-analysis--neva--toolbox?focused=5028815&tab=function
function fileList = getAllFiles(dirName)
    dirData = dir(dirName);      
    dirIndex = [dirData.isdir]; 
    fileList = {dirData(~dirIndex).name}';  
    if ~isempty(fileList)
        fileList = cellfun(@(x) fullfile(dirName,x),fileList,'UniformOutput',false);
    end
    subDirs = {dirData(dirIndex).name};  
    validIndex = ~ismember(subDirs,{'.','..'});                                            
    for iDir = find(validIndex)                  
        nextDir = fullfile(dirName,subDirs{iDir});    
        fileList = [fileList; getAllFiles(nextDir)];  
    end
end


function index = findImagesIndex(imgArray, wanted)
    bool = contains(imgArray, wanted);
    index = find(bool == 1, 1);
end


function showImageMarks(handles)
    pimg = handles.imgs{handles.idx};
    imshow(pimg);
    hold on;
    
    results = calPerformance(handles);
    
    if ~isempty(results)
        % show pair marks with >=60% or not
        pairs = results.pairs;
        limit = size(pairs);
        for idx = 1 : limit(1)
            if pairs(idx, 9) >= 0.60
                % normal
                showImageMarksRectGT(pairs(idx, 1:4));
                showImageMarksRectDO(pairs(idx, 5:8));
            else
                % trouble
                showTroubleRectGT(pairs(idx, 1:4));
                showTroubleRectDO(pairs(idx, 5:8));
            end
        end

        % show gt unpair
        ugt = results.unpairs_gt;
        if ~isempty(ugt)
            limit = size(ugt);
            for idx = 1 : limit(1)
                % trouble
                showTroubleRectGT(ugt(idx, 1:4));
            end
        end

        % show do unpair
        udo = results.unpairs_do;
        if ~isempty(udo)
            limit = size(udo);
            for idx = 1 : limit(1)
                % trouble
                showTroubleRectDO(udo(idx, 1:4));
            end
        end
    end
    
    % show filename
    [~,name,ext] = fileparts(pimg);
    set(handles.edit2, 'String', strcat(name, ext));
end


function indexArray = findPairsIndex(frames, wanted)
    indexArray = find(strcmp(frames, wanted));
end


function showImageMarksRectGT(iPos)
    pos = [iPos(1:2), iPos(3)-iPos(1), iPos(4)-iPos(2)];
    rectangle('Position', pos,'Curvature', 0.2, 'EdgeColor', 'r', 'LineWidth', 1, 'LineStyle', '-');
end


function showImageMarksRectDO(iPos)
    pos = [iPos(1:2), iPos(3)-iPos(1), iPos(4)-iPos(2)];
    rectangle('Position', pos,'Curvature', 0.2, 'EdgeColor', 'g', 'LineWidth', 1, 'LineStyle', '-');
end


function showTroubleRectGT(iPos)
    pos = [iPos(1:2), iPos(3)-iPos(1), iPos(4)-iPos(2)];
    rectangle('Position', pos,'Curvature', 0.2, 'EdgeColor', 'r', 'LineWidth', 1, 'LineStyle', '-.');
    %rectangle('Position', pos,'Curvature', 0.2, 'EdgeColor', 'r', 'FaceColor', 'r', 'LineWidth', 1, 'LineStyle', '-.');
end


function showTroubleRectDO(iPos)
    pos = [iPos(1:2), iPos(3)-iPos(1), iPos(4)-iPos(2)];
    rectangle('Position', pos,'Curvature', 0.2, 'EdgeColor', 'g', 'LineWidth', 1, 'LineStyle', '-.');
    %rectangle('Position', pos,'Curvature', 0.2, 'EdgeColor', 'g', 'FaceColor', 'g', 'LineWidth', 1, 'LineStyle', '-.');
end

function troubles = calTroubles(handles)
    gt = handles.gt;
    do = handles.do;
    
    nameIndex = unique([gt(:,1); do(:,1)]);
    
    [~, gt_col_limit] = size(gt);
    [~, do_col_limit] = size(do);
    
    troubles = [];
    [limit, ~] = size(nameIndex);
    for idx = 1 : limit
        base = nameIndex(idx);
        gt_row_idxs = transpose(find(strcmp(gt(:, 1), base)));
        do_row_idxs = transpose(find(strcmp(do(:, 1), base)));
        
        % extract 2 points and add labels
        A = [num2cell(transpose(1:length(gt_row_idxs))), gt(gt_row_idxs, 2 : gt_col_limit)];
        B = [num2cell(transpose((length(gt_row_idxs) + 1) : (length(gt_row_idxs) + length(do_row_idxs)))), do(do_row_idxs, 2 : do_col_limit)];
        
        [A_row_length, A_col_length] = size(A);
        [B_row_length, ~] = size(B);
        
        % every possible pairs
        rowSize = A_row_length * B_row_length;
        if rowSize == 0
            rowSize = max(A_row_length, B_row_length);
        end
        EA = zeros(rowSize, A_col_length);
        for indx = 1 : rowSize
            rix = fix((indx - 1) /B_row_length + 1);
            if B_row_length == 0
                rix = indx;
            end
            if A_row_length ~= 0
                EA(indx, :) = cell2mat(A(rix, :));
            end
        end
        EB = cell2mat(repmat(B, A_row_length, 1));
        if A_row_length == 0
            EB = cell2mat(repmat(B, 1, 1));
        end
        
        % check it is intersecton or not in y: [~,~,y,~,y]
        pax = EA(:, [2,4]); pbx = EB(:, [2,4]);
        pay = EA(:, [3,5]); pby = EB(:, [3,5]);
        intersection_bool = ~(pay(:,1) > pby(:,2) | pby(:,1) > pay(:,2) | pbx(:,1) > pax(:,2) | pax(:,1) > pbx(:,2));
        row_select = transpose(find(intersection_bool));
        %non_select = transpose(find(intersection_bool, 0));
        result = zeros(rowSize, 3);
        % no intersection case(actually do nothing)
        % result(non_select, 3) = 0;
        % intersection case
        Y = sort([EA(row_select, [3,5]),EB(row_select, [3,5])], 2);
        iy = Y(:,3) - Y(:,2);
        % for x: [x,~,x,~]
        X = sort([EA(row_select, [2,4]),EB(row_select, [2,4])], 2);
        ix = X(:,3) - X(:,2);
        % calculate the intersection area
        area = ix .* iy;
        % calculate the union phase
        union = (EA(row_select, 4) - EA(row_select, 2)) .* (EA(row_select, 5) - EA(row_select, 3)) + (EB(row_select, 4) - EB(row_select, 2)) .* (EB(row_select, 5) - EB(row_select, 3)) - area;
        % save ratio
        result(row_select, 1) = EA(row_select, 1);
        result(row_select, 2) = EB(row_select, 1);
        result(row_select, 3) = area ./ union;
        
        % sorting the ratio
        pairs_0 = sortrows(result, 3, 'descend');
        cut_idxs = find(pairs_0(:,1) == 0);
        if ~isempty(cut_idxs)
            pairs_temp = pairs_0(1 : cut_idxs(1) - 1, :);
        else
            pairs_temp = pairs_0;
        end
        
        % filter pairs without intersection
        standardIndex = 1:length(gt_row_idxs) + length(do_row_idxs);
        limit = size(pairs_temp);
        for indx = 1 : limit(1)
            T1 = ismember(standardIndex, pairs_temp(indx, 1));
            T2 = ismember(standardIndex, pairs_temp(indx, 2));
            
            if sum(T1) && sum(T2)% paired condition
                % set pair index as zero
                standardIndex = ~T1 .* standardIndex;
                standardIndex = ~T2 .* standardIndex;
            end
        end
        
        if sum(pairs_temp(:, 3) < 0.60) > 0
            troubles = [troubles, base];
        end
        
        % unpair part
        limit = size(standardIndex);
        for indx = 1 : limit(2)
            if standardIndex(indx)
                troubles = [troubles, base];
            end
        end
        
        troubles = unique(troubles);
    end
end


function output = calPerformance(handles)
    gt = handles.gt;
    do = handles.do;
    
    [~, gt_col_limit] = size(gt);
    [~, do_col_limit] = size(do);
    
    [~,name,ext] = fileparts(handles.imgs{handles.idx});
    base = strcat(name, ext);
    gt_row_idxs = transpose(find(strcmp(gt(:, 1), base)));
    do_row_idxs = transpose(find(strcmp(do(:, 1), base)));
    
    if ~isempty(gt_row_idxs) || ~isempty(do_row_idxs)
        % extract 2 points and add labels
        A = [num2cell(transpose(1:length(gt_row_idxs))), gt(gt_row_idxs, 2 : gt_col_limit)];
        B = [num2cell(transpose((length(gt_row_idxs) + 1) : (length(gt_row_idxs) + length(do_row_idxs)))), do(do_row_idxs, 2 : do_col_limit)];

        [A_row_length, A_col_length] = size(A);
        [B_row_length, ~] = size(B);

        % every possible pairs
        rowSize = A_row_length * B_row_length;
        if rowSize == 0
            rowSize = max(A_row_length, B_row_length);
        end
        EA = zeros(rowSize, A_col_length);
        for indx = 1 : rowSize
            rix = fix((indx - 1) /B_row_length + 1);
            if B_row_length == 0
                rix = indx;
            end
            if A_row_length ~= 0
                EA(indx, :) = cell2mat(A(rix, :));
            end
        end
        EB = cell2mat(repmat(B, A_row_length, 1));
        if A_row_length == 0
            EB = cell2mat(repmat(B, 1, 1));
        end

        % check it is intersecton or not in y: [~,~,y,~,y]
        pax = EA(:, [2,4]);
        pbx = EB(:, [2,4]);
        pay = EA(:, [3,5]); pby = EB(:, [3,5]);
        intersection_bool = ~(pay(:,1) > pby(:,2) | pby(:,1) > pay(:,2) | pbx(:,1) > pax(:,2) | pax(:,1) > pbx(:,2));
        row_select = transpose(find(intersection_bool));
        %non_select = transpose(find(intersection_bool, 0));
        result = zeros(rowSize, 3);
        % no intersection case(actually do nothing)
        % result(non_select, 3) = 0;
        % intersection case
        Y = sort([EA(row_select, [3,5]),EB(row_select, [3,5])], 2);
        iy = Y(:,3) - Y(:,2);
        % for x: [x,~,x,~]
        X = sort([EA(row_select, [2,4]),EB(row_select, [2,4])], 2);
        ix = X(:,3) - X(:,2);
        % calculate the intersection area
        area = ix .* iy;
        % calculate the union phase
        union = (EA(row_select, 4) - EA(row_select, 2)) .* (EA(row_select, 5) - EA(row_select, 3)) + (EB(row_select, 4) - EB(row_select, 2)) .* (EB(row_select, 5) - EB(row_select, 3)) - area;
        % save ratio
        result(row_select, 1) = EA(row_select, 1);
        result(row_select, 2) = EB(row_select, 1);
        result(row_select, 3) = area ./ union;

        % sorting the ratio
        pairs_0 = sortrows(result, 3, 'descend');
        cut_idxs = find(pairs_0(:,1) == 0);
        if ~isempty(cut_idxs)
            pairs_temp = pairs_0(1 : cut_idxs(1) - 1, :);
        else
            pairs_temp = pairs_0;
        end

        % filter pairs without intersection
        standardIndex = 1:length(gt_row_idxs) + length(do_row_idxs);
        limit = size(pairs_temp);
        pairs = cell(limit(1), 9);
        unpairs_gt = cell(limit(1), 4);
        unpairs_do = cell(limit(1), 4);
        for indx = 1 : limit(1)
            T1 = ismember(standardIndex, pairs_temp(indx, 1));
            T2 = ismember(standardIndex, pairs_temp(indx, 2));

            if sum(T1) && sum(T2)% paired condition
                % save A(x,y)
                pairs{indx, 1} = A{[A{:,1}] == pairs_temp(indx, 1), 2};
                pairs{indx, 2} = A{[A{:,1}] == pairs_temp(indx, 1), 3};
                pairs{indx, 3} = A{[A{:,1}] == pairs_temp(indx, 1), 4};
                pairs{indx, 4} = A{[A{:,1}] == pairs_temp(indx, 1), 5};
                % save B(x,y)
                pairs{indx, 5} = B{[B{:,1}] == pairs_temp(indx, 2), 2};
                pairs{indx, 6} = B{[B{:,1}] == pairs_temp(indx, 2), 3};
                pairs{indx, 7} = B{[B{:,1}] == pairs_temp(indx, 2), 4};
                pairs{indx, 8} = B{[B{:,1}] == pairs_temp(indx, 2), 5};
                % save ratio
                pairs{indx, 9} = pairs_temp(indx, 3);
                % set pair index as zero
                standardIndex = ~T1 .* standardIndex;
                standardIndex = ~T2 .* standardIndex;
            end
        end

        % unpair part
        limit = size(standardIndex);
        for indx = 1 : limit(2)
            if standardIndex(indx)
                if fix(standardIndex(indx)) <= length(gt_row_idxs)
                    % save unpair at A
                    unpairs_gt{indx, 1} = A{[A{:,1}] == standardIndex(indx), 2};
                    unpairs_gt{indx, 2} = A{[A{:,1}] == standardIndex(indx), 3};
                    unpairs_gt{indx, 3} = A{[A{:,1}] == standardIndex(indx), 4};
                    unpairs_gt{indx, 4} = A{[A{:,1}] == standardIndex(indx), 5};
                else
                    % save unpair at B
                    unpairs_do{indx, 1} = B{[B{:,1}] == standardIndex(indx), 2};
                    unpairs_do{indx, 2} = B{[B{:,1}] == standardIndex(indx), 3};
                    unpairs_do{indx, 3} = B{[B{:,1}] == standardIndex(indx), 4};
                    unpairs_do{indx, 4} = B{[B{:,1}] == standardIndex(indx), 5};
                end
            end
        end
        
        output = struct('pairs', cell2mat(pairs), 'unpairs_gt', cell2mat(unpairs_gt), 'unpairs_do', cell2mat(unpairs_do));
    else
        output = [];
    end
end