clc
clear 
close all

% Read image
[aa bb]=uigetfile('.jpg');
I=imread([bb aa]);

% image resizing
I1=imresize(I,[256,256]);
figure,imshow(I1)
title('Input Image');

% Color conversion
if(size(I1,3)==3)
    I2=rgb2gray(I1);
else
    I2=I1;
end
figure,imshow(I2)
title('Gray Image');

% add noise
I3=imnoise(I2,'gaussian',0.03);
figure,imshow(I3);
title('Noisy Image');

Imr=medfilt2(I3);
% segment an image and remove  noise
im2=I1;
[lb,center] = segment(im2(:,:,2));
figure,imshow(lb,[]);
impixelinfo
I1=lb;
[m,n]=size(I1);
for i=1:m
    for j=1:n
              if I1(i,j)==3
                 A3(i,j)=1;
             else 
                 A3(i,j)=0;
              end
        end
end
figure,imshow(A3);

matlabroot='E:\2020-2021 Projects\PSEUDO SCRIPTS\P008 Brain CNN\Code\Code\Seg Images'
DatasetPath = fullfile(matlabroot);
Data = imageDatastore(DatasetPath, ...
        'IncludeSubfolders',true,'LabelSource','foldernames');
Data.ReadFcn = @(loc)imresize(imread(loc),[227 227]);

[trainData] = splitEachLabel(Data,0.8,'randomize');

     
CountLabel = Data.countEachLabel;

%% Define the Network Layers
      layers1=[imageInputLayer([227 227 1
          ],'DataAugmentation', 'randfliplr')
            convolution2dLayer(11,128,'Padding',0,'stride',4)
           reluLayer
            crossChannelNormalizationLayer(5)
            maxPooling2dLayer(3,'Stride',2,'Padding',0)
            convolution2dLayer(5,512,'Padding',2,'stride',1)
            reluLayer
            crossChannelNormalizationLayer(5)
            maxPooling2dLayer(3,'Stride',2,'Padding',0)
            convolution2dLayer(3,384,'Padding',1,'stride',1)
            reluLayer
            convolution2dLayer(3,256,'Padding',1,'stride',1)
            reluLayer
            convolution2dLayer(3,256,'Padding',1,'stride',1)
            reluLayer
            maxPooling2dLayer(3,'Stride',2,'Padding',0)
            fullyConnectedLayer(5000)
            reluLayer
            dropoutLayer
            fullyConnectedLayer(1000)
            reluLayer
            dropoutLayer
            fullyConnectedLayer(3)
            softmaxLayer
            classificationLayer];
      
      
      
options = trainingOptions('sgdm','MaxEpochs', 5  , ...
	'InitialLearnRate',0.0001,'LearnRateSchedule','piecewise','VerboseFrequency',2,'L2Regularization',0.001);  

netan = trainNetwork(trainData,layers1,options);
Featr=train(A3);

load netan
y=round(abs(sim(netan,Featr)))
 if y==1
     msgbox('Benign');
 elseif y==2
     msgbox('Malignant');
 else 
     msgbox('Normal');
 end
 
