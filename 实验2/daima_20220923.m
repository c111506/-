%米粒处理
clc
clear
close all

%% 处理米粒图
A=imread('rice.png');
figure(1),imshow(A);

%% 上下图象的亮度不同，需要分层处理
A1=A(1:128,:);
A2=A(129:end,:);
L1=graythresh(A1);%取不同的L值
L2=graythresh(A2);
B1=im2bw(A1,L1);
B2=im2bw(A2,L2);
B=zeros(size(A));
B(1:128,:)=B1;
B(129:end,:)=B2;
figure(2),imshow(B);

%% 课堂任务
%1处理图象
C=bwareaopen(B,10); %剔除像素点少的点

%2给各个米编号
[R,n]=bwlabel(C);
figure(3),imshow(R,[]);
title('Разметка');

%3找出座号的米
D=zeros(size(C));
D(find(R==13))=1;
figure(4),imshow(D);
title('第13粒米');

%4计算米的数量
disp(max(R(:)))

%5找到重叠的米—根据米的平均面积（像素）来判断
R=uint8(R);
h=imhist(R);
h=h(2:end);
figure(5),plot(h)

for pass=1:4
    [v,x]=max(h);
    D1=zeros(size(B));
    D1(find(R==x))=1;
    h(x)=0;%置0，寻找下一粒米
    figure,imshow(D1);
    title('重叠的米');
end

