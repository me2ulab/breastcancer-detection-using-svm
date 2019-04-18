function [breastClassifier,breastIndex,breastTraining]=trainSvm()
breastDatabase=imageSet('dataset','recursive');
[breastTraining breastTest]=partition(breastDatabase,[0.9,0.1]);
breastFeatureCount=1;
for i=1:size(breastTraining,2)
    for j=1:breastTraining(i).Count
        img=read(breastTraining(i),j);
         dwt=pdwt(img);
         gray=rgb2gray(dwt);
        zero=edge(gray,'log');
        breastTrainingFeatures(breastFeatureCount,:)=double(zero(:))';
        breastTrainingLabel{breastFeatureCount}=breastTraining(i).Description;
        breastFeatureCount=breastFeatureCount+1;
    end
    breastIndex{i}=breastTraining(i).Description;
end
breastClassifier=fitcecoc(breastTrainingFeatures,breastTrainingLabel);
save('dataSet','breastClassifier','breastTraining','breastIndex');
msgbox('Training Completed');
end

