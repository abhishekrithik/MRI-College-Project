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

Featt=train(A3);
load netan
y=round(abs(sim(netan,Featt)));
 if y==1
     msgbox('Benign');
 elseif y==2
     msgbox('Malignant');
     Ib1=A3;
ss=regionprops(Ib1);
ar=(ss.Area)/100;
sss='Affected % =  ';
sst=num2str(ar);
arr=strcat(sss,sst);
msgbox(arr);

 else 
     msgbox('Normal');
 end
 
