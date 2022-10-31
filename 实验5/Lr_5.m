% 霍夫变换寻找物体

clear
close all
clc

A=imread('concordorthophoto.png');%读取地图
% figure(1),imshow(A),title("карта");
B=imread('westconcordorthophoto.png');%读取目标图象
% figure(2),imshow(B),title("кадр");

[h,w]=size(A);
[h1,w1]=size(B);
H=zeros(h,w);

% 给B加干扰
% B=imrotate(B,15);
% B=imresize(B,0.95);
% 噪声过大时，无法获得B的轮廓，导致后续报错
% B=imnoise(B,'salt & pepper',0.85);

%% 简易算法
% 只利用坐标差值，找到重合点最大处
% 此法慢
% Ea=edge(A,'Sobel');
% Eb=edge(B,'Sobel');
% 
% [yb,xb]=find(Eb==1);
% nb=length(xb);
% tic
% % a=0;
% for x=1:w % 遍历A中每个值为1的点和B中每一个值为1的点...
%     for y=1:h % ...求它们的坐标差值，可视为将它们两两相连做216566*5970个向量...
%         if Ea(y,x)==1 % ...将向量起点移至原点，找到重合最多的向量，其坐标值即为图像位置...
%             for i=1:nb 
%                 dx=x-xb(i);
%                 dy=y-yb(i);
%                 if (dx>1)&&(dx<=w)&&(dy>1)&&(dy<=h)
%                     H(dy,dx)=H(dy,dx)+1;
%                 end
% %                 a=a+1; %用于验证求差次数
%             end
%         end
%     end
% end
% toc
% figure(3), imshow(H,[])

%% 结合梯度的表格法

tic
H=my_GHT(A,B);
toc
figure(4), imshow(H,[])

% 在A中绘B
Hmax=max(H(:));
[y,x]=find(H==Hmax);
x=x(1);
y=y(1);

A(y:y+h1-1,x:x+w1-1)=B+50;
figure(5),imshow(A);

