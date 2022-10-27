function R=my_NorCorr(A,B)%标准化（减去平均亮度—消除亮度对处理的影响）
    
    [h,w]=size(A);    
    [h1,w1]=size(B);
    
    B=B-mean(B(:)); 
    % 不同的搜索目标，对应的平均背景亮度不同
    % 使用B大小的滤波器进行滤波，获得A的标准值
    m=ones(size(B));
    m=m/sum(m(:));
    Amean=imfilter(A,m);
    A=A-Amean;

    Sa=fft2(A); %2维信号用fft2/fftw
    Sb=fft2(B,h,w); % Sa和Sb的维数不同——以0扩充Sb的维数（0不会影响相关的值）
    Sb=conj(Sb); %取共轭
    Sr=Sa.*Sb; % 点积
    R=ifft2(Sr); %逆变换

end
