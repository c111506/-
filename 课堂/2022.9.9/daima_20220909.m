% 2022.9.9 
% 
% image Processing Toolbox
close all
clc
clear

A=imread('pout.tif'); %读图片操作
imfinfo pout.tif; % 获得图片信息
figure,plot(A); 
figure,imshow(A) ,title('Загруженное изображение')%展示图片并命名
h=imhist(A); % 读取图像亮度直方图
figure, plot(h),title('Гистограмма яркости'); %显示亮度图，第一个峰为背景，第二个附近为物体
% 两峰距离较近

%% 线性矫正
% 有亮度区间线性放大
B=imadjust(A,[75/255 175/255],[0 1]); % 改变亮度区间
figure, imshow(B),title('Линейная коррекция')
figure,plot(imhist(B))

%% 非线性矫正
% 强调物体，弱化背景
C1=imadjust(A,[75/255 175/255],[0 1],0.75);%强调亮部
C2=imadjust(A,[75/255 175/255],[0 1],1.5); %强调暗部
figure, imshow(C1),title('Нелинейная коррекция');
figure,plot(imhist(C1));
figure, imshow(C2),title('Нелинейная коррекция');
figure,plot(imhist(C2));

%% 不均匀矫正
% 亮度大的拉长，亮度小的压缩
% 背景和物体的区分不明显了
D=histeq(A);
figure,imshow(D),title('histeq');
figure,plot(imhist(D));
figure,imshow(A,[]);%[]——将 I 中的最小值显示为黑色，将最大值显示为白色


%% 彩色图像
A=imread('moon.tif'); 
figure,imshow(A),title('moon-原始图像');
%% 旋转图像
B=imrotate(A,15); %图像逆时针选择15度
figure,imshow(B),title('Луна повернутая');

%% 图像缩放
% 缩小再放大4倍后，图像失真
C=imresize(A,1/4);figure,imshow(C);
D=imresize(C,4);figure,imshow(D),title('Луна восстановление');
% 3种插值对比
D1=imresize(C,4,'nearest');
D2=imresize(C,4,'bilinear');
D3=imresize(C,4,'bicubic');
figure,imshow(D1)
figure,imshow(D2)
figure,imshow(D3)

%% 噪声
N=imnoise(A,'salt & pepper',0.25);figure,imshow(N)

%卷积
M=ones(3);
M=M/9;
F1=imfilter(N,M);figure,imshow(F1);
M1=ones(5)/25;
F2=imfilter(N,M1);figure,imshow(F2);

% 高斯滤波——处理白噪声效果比较好
M2=fspecial('gaussian',51,5)
F3=imfilter(N,M);figure,imshow(F3);

% 二维中位数滤波——将噪点变黑/白
% 使像素点靠近周围像素点？
F4=medfilt2(N),figure,imshow(F4);

% 找到轮廓
M3=[0 -1 0;-1 12 -1;0 -1 0]/8;
E=imfilter(A,M3);figure,imshow(E);