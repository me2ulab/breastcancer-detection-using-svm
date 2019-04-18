function varargout = main(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
ha=axes('units','normalized','position',[0 0 1 1]);
%Move background axes to the bottom behind all other UI control
uistack(ha,'bottom');
%Import bgimage and show it on the axis
bg=imread('bg.jpg');
imagesc(bg);
handles.output = hObject;


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in BrowseImage.
function BrowseImage_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


    [filename, pathname] = uigetfile('*.jpg', 'Pick a Image');
    if isequal(filename,0) || isequal(pathname,0)
       warndlg('User pressed cancel')
    else
    filename=strcat(pathname,filename);
    
    InputImage=imread(filename);
    
    axes(handles.axes1);
    imshow(InputImage);
    
    handles.InputImage=InputImage;
    end
    % Update handles structure
guidata(hObject, handles);


% --- Executes on button press in Weiner Filter.
function WeinerFilter_Callback(hObject, eventdata, handles)
% hObject    handle to WeinerFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

        InputImage=handles.InputImage;
        GrayScaleImage=rgb2gray(InputImage);
               
        NoisyImage=GrayScaleImage;
        NoisyImage=double(GrayScaleImage);
        preProcessedImage3=wiener2(NoisyImage,[5,5]);
        preProcessedImage=preProcessedImage3;
        preProcessedImage=uint8(preProcessedImage);
        axes(handles.axes2);
        imshow(preProcessedImage,[]);
        handles.preProcessedImage=preProcessedImage;
    
    % Update handles structure
guidata(hObject, handles);

warndlg('Stage 1 completed'); 
    
    
    


% --- Executes on button press in ZeroCrossing.
function ZeroCrossing_Callback(hObject, eventdata, handles)
% hObject    handle to ZeroCrossing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dwtImage=handles.dwtImage;
zerocrossImage=edge(rgb2gray(dwtImage),'log');
axes(handles.axes2);
imshow(zerocrossImage);
handles.zerocrossImage=zerocrossImage;

        

    guidata(hObject, handles);
warndlg('stage 2 completed'); 

% --- Executes on button press in TrainNN.
function TrainNN_Callback(hObject, eventdata, handles)
% hObject    handle to TrainNN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[classifier,breastIndex,breastTraining]=trainSvm();
handles.classifier=classifier;
handles.breastIndex=breastIndex;
handles.breastTraining=breastTraining;
guidata(hObject,handles);

% --- Executes on button press in loaddatabase.
function loaddatabase_Callback(hObject, eventdata, handles)
% hObject    handle to loaddatabase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    




% --- Executes on button press in Predict.
function Predict_Callback(hObject, eventdata, handles)
% hObject    handle to Predict (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zero=handles.zerocrossImage;
breastClassifier=handles.classifier;
breastTraining=handles.breastTraining;
breastIndex=handles.breastIndex;
queryFeatures=double(zero(:))';
breastLabel=predict(breastClassifier,queryFeatures);
booleanIndex=strcmp(breastLabel, breastIndex);
integerIndex= booleanIndex;
breastde=breastTraining(integerIndex).Description;
set(handles.result,'String',breastde);



function result_Callback(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of result as text
%        str2double(get(hObject,'String')) returns contents of result as a double


% --- Executes during object creation, after setting all properties.
function result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clear.
function clear_Callback(hObject, eventdata, handles)
% hObject    handle to clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
a=ones(256,256);
axes(handles.axes1);
imshow(a);
axes(handles.axes2);
imshow(a);
%clear;
set(handles.result,'String',' ');


% --- Executes on button press in dwt.
function dwt_Callback(hObject, eventdata, handles)
% hObject    handle to dwt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputImage=handles.InputImage;
% Di
dwtImage=pdwt(inputImage);
handles.dwtImage=dwtImage;
axes(handles.axes2);
imshow(dwtImage);
guidata(hObject, handles);

% --- Executes on button press in imageCropping.
function imageCropping_Callback(hObject, eventdata, handles)
% hObject    handle to imageCropping (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputImage=handles.InputImage;
grayImage=rgb2gray(inputImage);
croppedImage=imresize(grayImage,[256,256]);
axes(handles.axes1);
imshow(croppedImage);


% --- Executes on button press in loadDatabase.
function loadDatabase_Callback(hObject, eventdata, handles)
% hObject    handle to loadDatabase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load dataset
handles.classifier=breastClassifier;
handles.breastTraining=breastTraining;
handles.breastIndex=breastIndex;
guidata(hObject,handles);