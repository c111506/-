% 在大地图中找到目标区域
% 需要计算目标区域与整个地图的相关函数来确定位置

clc
clear
close all

A=imread('concordorthophoto.png');%读取地图
figure(1),imshow(A),title("карта");

B=imread('westconcordorthophoto.png');%读取目标图象
figure(2),imshow(B),title("кадр");

%% 使用相位法，找到未加干扰前的最匹配位置
R=my_PhaseCorr(A,B); % 相位法准，以它为基准
Rmax=max(R(:));
[y,x]=find(R==Rmax);
y_true=y(1);x_true=x(1); %以真实位置作为标准，与后续改B后的结果比较，来确定误差


%% 对B进行变换/干扰—验证各方法的性能
% B=B-20; %未-20，图像匹配程度低
% B对整个谱的值影响较大
% B=B+100; % 验证相位法-对亮度不敏感
% B=imnoise(B,'salt & pepper',0.8);% 验证相位法-对噪声不敏感
% B=imrotate(B,15);% 验证相位法-不能处理旋转,梯度法可以
B=imresize(B,0.8);% 验证相位法-不能处理缩放

%% 获取图像基本信息
[h,w]=size(A); %获取图像尺寸
[h1,w1]=size(B);
R=zeros(h,w);

%% 此法计算相关太慢—需要计算4个循环
% for dx=1:w-w1-1
%     disp(dx)
%     for dy=1:h-h1-1
%         s=0;
%         for x=1:w1
%             for y=1:h1
%                 s=A(y+dy,x+dx)*B(y,x);
%             end
%         end
%         R(dy,dx)=s;
%     end
% end
    
%% 引入傅里叶变换，计算两图的谱的乘积
% Sa=fft2(A); % 2维信号用fft2/fftw
% Sb=fft2(B,h,w); % Sa和Sb的维数不同——以0扩充Sb的维数（0不会影响相关的计算）
% Sb=conj(Sb); % 取共轭
% Sr=Sa.*Sb; % 点积
% R=ifft2(Sr); % 逆变换

%% 将上述封装为函数
%R=my_Corr(A,B); %匹配不准确，对亮度敏感чувствительность к условиям освещенности
% 环境亮度改变一点即对结果产生较大影响

%     tic
    % нормированная корреляционная функция 标准化方法
    % 计算并减去平均亮度，减小环境亮度对结果的影响
    % 相比之下，是最慢、最不精确的方法
%     R=my_NorCorr(A,B); 
    
    % метод фазовой корреляции-除以模长—>减小亮度的影响 % 最快的方法
    %显著减小亮度、噪声对匹配的影响，但对旋转、缩放不敏感
%     R=my_PhaseCorr(A,B); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%
%     R = my_GradCorr(A,B); %% 梯度相关
    
%     R = my_GradCorrXY( A,B ); %% 梯度相关—X、Y方向分别计算
    
    
    % R=my_ContCorr(A,B);   %% 轮廓相关
    
%     toc

    % figure(3),imshow(R,[]);

    %% 在A绘出B
    Rmax=max(R(:));
    [y,x]=find(R==Rmax);
    y=y(1);x=x(1);
    
    err=round(sqrt((x-x_true)^2+(y-y_true)^2)); % 误差—评价各个方法的匹配程度
    % 即该方法最匹配点到相位法最匹配点的距离
    
% end

A(y:y+h1-1,x:x+w1-1)=B+75;%在图中显示B
figure(4),imshow(A);
