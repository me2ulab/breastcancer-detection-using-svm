
breastDatabase=imageSet('dataset','recursive');
[breastTraining breastTest]=partition(breastDatabase,[0.9,0.1]);
breastFeatureCount=1;
for i=1:size(breastTraining,2)
    for j=1:breastTraining(i).Count
        img=read(breastTraining(i),j);
         dwt=pdwt(img);
         gray=rgb2gray(dwt);
        zero=edge(gray,'log');
        faceTrainingFeatures(breastFeatureCount,:)=double(zero(:))';
        faceTrainingLabel{breastFeatureCount}=breastTraining(i).Description;
        breastFeatureCount=breastFeatureCount+1;
    end
    breastIndex{i}=breastTraining(i).Description;
end
breastClassifier=fitcecoc(faceTrainingFeatures,faceTrainingLabel);

handles.faceClassifier=breastClassifier;
handles.faceIndex=breastIndex;
handles.faceTraining=breastTraining;
msgbox('Training Completed');
%%
testImg=imread('Malign20.jpg');
dwt=pdwt(testImg);
         gray=rgb2gray(dwt);
        zero=edge(gray,'log');
    
queryFeatures=double(zero(:))';
faceLabel=predict(breastClassifier,queryFeatures);
booleanIndex=strcmp(faceLabel, breastIndex);
integerIndex= booleanIndex;
facede=breastTraining(integerIndex).Description;