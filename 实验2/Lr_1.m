clc
clear
close all

A=imread('detail2.bmp');
L=graythresh(A);
B=im2bw(A,L);
B=imcomplement(B); %黑白转换
figure(1),imshow(B);

% 找边界
% se=[1 1 1;1 1 1;1 1 1]; %搜寻3*3=9的九宫格的像素 
% 改成5*5/7*7的--->搜寻范围加大，效果更明显
se=ones(5);
% se=ones(11);

% for i=1
%     %% 腐蚀、膨胀、开、闭
%     %imerode——Эрозия（腐蚀）
%     C0=imerode(B,se);% 膨胀——腐蚀掉白色干扰，黑色干扰扩大
%     figure(2),imshow(C0);
%     title('Дилатация');
%     %imdilate——Дилатация（膨胀）
%     C1=imdilate(B,se);% 腐蚀——去除黑色干扰，白色干扰扩大
%     figure(3),imshow(C1);
%     title('Эрозия');
% 
%     % 膨胀+腐蚀=闭操作Замыкание
%     C2=imerode(C1,se);
%     figure(4),imshow(C2);
%     title('Дилатация+Эрозия')
%     % imclose——Замыкание 与图4对比
%     C3=imclose(B,se);
%     figure(5),imshow(C3);
%     title('Замыкание');
% 
%     % 腐蚀+膨胀=开操作Размыкание
%     C4=imdilate(C0,se);
%     figure(6),imshow(C4);
%     title('Эрозия+Дилатация');
%     % imopen——Размыкание与图6对比
%     C5=imopen(B,se);
%     figure(7),imshow(C5);
%     title('Размыкание');
% 
%     % 开+闭
%     C6=imopen(B,se);
%     C7=imclose(C6,se);
%     figure(8),imshow(C7);
%     title('Размыкание+Замыкание');
% 
    % 闭+开
%     C8=imclose(B,se);
%     C9=imopen(C8,se);
%     figure(8),imshow(C9);
%     title('Размыкание+Замыкание');
% end

%% 去除小干扰
%从二值图像 BW 中删除少于 P 个像素的所有连通分量
% C10=bwareaopen(B,2000);
% figure(9),imshow(C10);
% title('bwareaopen');

%% 二维中位数滤波——用于减少“椒盐”噪声
% C11=medfilt2(B);%删除小噪点
% figure(10),imshow(C11);

%% 编号处理
% 图象预处理
C12=medfilt2(B);
C12=imclose(C12,se);
C12=imopen(C12,se);
figure(11),imshow(C12);
C12=bwareaopen(C12,2000);
R=bwlabel(C12); % 连通图象编号处理
figure(11),imshow(R,[]);
title('Разметка');

D1=zeros(size(C12));
D1(find(R==1))=1; % 找到编号为1的零件
figure(12),imshow(D1);
title('第1个零件1-я деталь');

D2=zeros(size(C12));
D2(find(R==2))=1;
figure(13),imshow(D2);
title('第2一个零件2-я деталь');

D3=zeros(size(C12));
D3(find(R==3))=1;
figure(14),imshow(D3);
title('第3个零件3-я деталь');

S1=sum(D1(:)); % 获得图象的面积
S2=sum(D2(:));
S3=sum(D3(:));

%% 获得图象边界
% 需是连续的图形
E1=bwperim(D1);
figure(15),imshow(E1);
title('Точки границы');
E2=bwperim(D2);
figure(16),imshow(E2);
title('Точки границы');
E3=bwperim(D3);
figure(17),imshow(E3);
title('Точки границы');

P1=sum(E1(:)); %计算周长
P2=sum(E2(:));
P3=sum(E3(:));
fprintf('1.Пл=%d перим=%d\n',S1,P1);
fprintf('2.Пл=%d перим=%d\n',S2,P2);
fprintf('3.Пл=%d перим=%d\n',S3,P3);

%% скелетные линии
% 比较bwmorph中的不同操作
% S1=bwmorph(D1,'skel',Inf); % 获得图象的骨架
% S2=bwmorph(D2,'skel',Inf);
% S3=bwmorph(D3,'skel',Inf);
% S1=bwmorph(S1,'spur',Inf); 
% S2=bwmorph(S2,'spur',Inf);
% S3=bwmorph(S3,'spur',Inf);
S1=bwmorph(D1,'thin',Inf);
S2=bwmorph(D2,'thin',Inf);
S3=bwmorph(D3,'thin',Inf);

figure(18),imshow(S1);
figure(19),imshow(S2);
figure(20),imshow(S3);
