% 从多个形状中找到五边形，并标红
clc
clear
close all

A=imread('mydetails.bmp');%读取整个图象
L=graythresh(A);
B=im2bw(A);
B=imcomplement(B); %黑白转换

%% 标准
A1=imread('pentagon.bmp');%读取五边形图象
L1=graythresh(A1);
B1=im2bw(A1);
B1=imcomplement(B1); %黑白转换
R=Centerprof(B1);%获得五边形的中心信息

%% 图象处理
C=bwareaopen(B,10); %剔除像素点少的点
%给各个图形编号
[T,n]=bwlabel(C);
figure(3),imshow(T,[]);
title('Разметка');

Red=zeros(size(C));
Green=zeros(size(C));
Blue=zeros(size(C));

for i=1:n
    D=zeros(size(C));
    D(find(T==i))=1;
    R1=Centerprof(D);
    e(i)=sum(abs(R-R1));
    if e(i)<5
        figure,imshow(D);
        Red=Red+D;
    else
        Red=Red+D;
        Green=Green+D;
        Blue=Blue+D;
    end
end
E=cat(3,Red,Green,Blue);
figure,imshow(E);





