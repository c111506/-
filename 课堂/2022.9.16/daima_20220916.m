clc
clear 
close all

A=imread('mydetails.bmp');
figure,imshow(A);
figure,plot(imhist(A));
L=75;
B=im2bw(A,L/255);
figure,imshow(B);

L2=50; %改变L
B2=im2bw(A,L2/255);
figure,imshow(B2);

%% метод Оцу
L1=graythresh(A); % 计算间隔点/计算全局图像阈值
disp(L1*255);
B1=im2bw(A,L1);
figure,imshow(B1);

%% 
C=imcomplement(B); %机器处理黑背景，白色物体，而人眼相反
% 因此图象处理时需先黑白转换
figure,imshow(C);
