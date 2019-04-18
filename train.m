breastImgDatabase=imageSet('dataset','recursive');
[breastTraining breastTest]=partition(breastImgDatabase,[0.9,0.1]);
breastFeatureCount=1;
for i=1:size(breastTraining,2)
    for j=1:breastTraining(i).Count
        img=read(breastTraining(i),j);
%         dwt=pdwt(img);
%         gray=rgb2gray(dwt);
%         zero=edge(gray,'log');
        gray=rgb2gray(img);
        breastTrainingFeatures(breastFeatureCount,:)=gray(:)';
        breastTrainingLabel{breastFeatureCount}=breastTraining(i).Description;
        breastFeatureCount=breastFeatureCount+1;
    end
    breastIndex{i}=breastTraining(i).Description;
end
% faceClassifier=fitcecoc(faceTrainingFeatures,faceTrainingLabel);
% handles.faceClassifier=faceClassifier;
% handles.faceIndex=faceIndex;
% handles.faceTraining=faceTraining;
% msgbox('Training Completed');