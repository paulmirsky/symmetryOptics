function varargout = SnS_Fig(varargin)
% SNS_FIG MATLAB code for SnS_Fig.fig
%      SNS_FIG, by itself, creates a new SNS_FIG or raises the existing
%      singleton*.
%
%      H = SNS_FIG returns the handle to a new SNS_FIG or the handle to
%      the existing singleton*.
%
%      SNS_FIG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SNS_FIG.M with the given input arguments.
%
%      SNS_FIG('Property','Value',...) creates a new SNS_FIG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SnS_Fig_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SnS_Fig_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SnS_Fig

% Last Modified by GUIDE v2.5 23-Sep-2022 13:04:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SnS_Fig_OpeningFcn, ...
                   'gui_OutputFcn',  @SnS_Fig_OutputFcn, ...
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


% --- Executes just before SnS_Fig is made visible.
function SnS_Fig_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SnS_Fig (see VARARGIN)

% Choose default command line output for SnS_Fig
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SnS_Fig wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SnS_Fig_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in tiltA.
function tiltA_Callback(hObject, eventdata, handles)
% hObject    handle to tiltA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in valA.
function valA_Callback(hObject, eventdata, handles)
% hObject    handle to valA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns valA contents as cell array
%        contents{get(hObject,'Value')} returns selected item from valA


% --- Executes during object creation, after setting all properties.
function valA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in phaseA.
function phaseA_Callback(hObject, eventdata, handles)
% hObject    handle to phaseA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in slideA.
function slideA_Callback(hObject, eventdata, handles)
% hObject    handle to slideA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function sizeA_Callback(hObject, eventdata, handles)
% hObject    handle to sizeA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sizeA as text
%        str2double(get(hObject,'String')) returns contents of sizeA as a double


% --- Executes during object creation, after setting all properties.
function sizeA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizeA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in valB.
function valB_Callback(hObject, eventdata, handles)
% hObject    handle to valB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns valB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from valB


% --- Executes during object creation, after setting all properties.
function valB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in phaseB.
function phaseB_Callback(hObject, eventdata, handles)
% hObject    handle to phaseB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in slideB.
function slideB_Callback(hObject, eventdata, handles)
% hObject    handle to slideB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tiltB.
function tiltB_Callback(hObject, eventdata, handles)
% hObject    handle to tiltB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function sizeB_Callback(hObject, eventdata, handles)
% hObject    handle to sizeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sizeB as text
%        str2double(get(hObject,'String')) returns contents of sizeB as a double


% --- Executes during object creation, after setting all properties.
function sizeB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizeB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in regenerate.
function regenerate_Callback(hObject, eventdata, handles)
% hObject    handle to regenerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in aux.
function aux_Callback(hObject, eventdata, handles)
% hObject    handle to aux (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function auxSelection_Callback(hObject, eventdata, handles)
% hObject    handle to auxSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of auxSelection as text
%        str2double(get(hObject,'String')) returns contents of auxSelection as a double


% --- Executes during object creation, after setting all properties.
function auxSelection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to auxSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showRearFlat.
function showRearFlat_Callback(hObject, eventdata, handles)
% hObject    handle to showRearFlat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showRearFlat


% --- Executes on button press in showArrayOnly.
function showArrayOnly_Callback(hObject, eventdata, handles)
% hObject    handle to showArrayOnly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showArrayOnly


% --- Executes on button press in arrayOnlyRear.
function arrayOnlyRear_Callback(hObject, eventdata, handles)
% hObject    handle to arrayOnlyRear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of arrayOnlyRear


% --- Executes on button press in applyEvalExps.
function applyEvalExps_Callback(hObject, eventdata, handles)
% hObject    handle to applyEvalExps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in valD.
function valD_Callback(hObject, eventdata, handles)
% hObject    handle to valD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns valD contents as cell array
%        contents{get(hObject,'Value')} returns selected item from valD


% --- Executes during object creation, after setting all properties.
function valD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in phaseD.
function phaseD_Callback(hObject, eventdata, handles)
% hObject    handle to phaseD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in slideD.
function slideD_Callback(hObject, eventdata, handles)
% hObject    handle to slideD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tiltD.
function tiltD_Callback(hObject, eventdata, handles)
% hObject    handle to tiltD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function sizeD_Callback(hObject, eventdata, handles)
% hObject    handle to sizeD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sizeD as text
%        str2double(get(hObject,'String')) returns contents of sizeD as a double


% --- Executes during object creation, after setting all properties.
function sizeD_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizeD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in valC.
function valC_Callback(hObject, eventdata, handles)
% hObject    handle to valC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns valC contents as cell array
%        contents{get(hObject,'Value')} returns selected item from valC


% --- Executes during object creation, after setting all properties.
function valC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in phaseC.
function phaseC_Callback(hObject, eventdata, handles)
% hObject    handle to phaseC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in slideC.
function slideC_Callback(hObject, eventdata, handles)
% hObject    handle to slideC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tiltC.
function tiltC_Callback(hObject, eventdata, handles)
% hObject    handle to tiltC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function sizeC_Callback(hObject, eventdata, handles)
% hObject    handle to sizeC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sizeC as text
%        str2double(get(hObject,'String')) returns contents of sizeC as a double


% --- Executes during object creation, after setting all properties.
function sizeC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizeC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in showPattern.
function showPattern_Callback(hObject, eventdata, handles)
% hObject    handle to showPattern (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of showPattern
