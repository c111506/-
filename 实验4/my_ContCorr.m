function R=my_ContCorr(A,B) %轮廓相关

[h,w]=size(A);
Ea=edge(A,'Sobel');
Eb=edge(B,'Sobel');
%计算两幅图像的轮廓相关函数

Sa=fft2(Ea);%傅立叶 二维快速傅里叶变换
Sb=fft2(Eb,h,w);%图像光谱与图像大小完全相同
Sb=conj(Sb);%复共轭
Sr=Sa.*Sb;%矩阵乘法
R=ifft2(Sr);%逆变换 二维快速傅里叶逆变换 ifft2 计算大于 2 的每个维度的二维逆变换。输出 X 的大小与 Y 相同
end