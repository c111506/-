clc
clear
close all

A=imread('ConcordOrthoPhoto.png');
% figure,imshow(A),title('Карта');
B=imread('WestConcordOrthoPhoto.png');
% figure,imshow(B),title('Кадр');

N=0:5:100; %Уровень шума
Ang=0:1:20; %Угол поворота
M=100:-1:80; %Масштаб

Exp=1; %* 1-шум 2-поворот 3-масштаб *

[h,w]=size(A);
[h1,w1]=size(B);

%Ищем правильное положение
R=my_PhaseCorr(A,B);
Rmax=max(R(:));
[y,x]=find(R==Rmax);
xtrue=x(1);ytrue=y(1);

E=zeros(20,1); %график ошибки
T=zeros(20,1); %подпись для оси x

for pass=1:20
     if Exp==1, B1=imnoise(B,'salt & pepper',N(pass)/100); 
         T(pass)=N(pass); tt='Чувствительность к шуму';
         elseif Exp==2, B1=imrotate(B,Ang(pass)); 
         T(pass)=Ang(pass); tt='Чувствительность к повороту';
         elseif Exp==3, B1=imresize(B,M(pass)/100);
         T(pass)=M(pass); tt='Чувствительность к масштабу';
         else B1=B; T(pass)=pass; tt='Не задано.';
     end
    % *Выбираем один из методов:* 
%     R=my_PhaseCorr(A,B1);
%     R=my_GradCorr(A,B1);
%     R=my_GradCorrXY(A,B1);
    R=my_ContCorr(A,B1);
    Rmax=max(R(:));
    [y,x]=find(R==Rmax);
    x=x(1);y=y(1);
    err=round(sqrt((x-xtrue)^2+(y-ytrue)^2));
    E(pass)=err;
    fprintf('Pass=%d Err=%d\n ',pass,err);
end;
Ecrit=20*ones(size(E));
figure('Name',tt);plot(T,E,T,Ecrit);