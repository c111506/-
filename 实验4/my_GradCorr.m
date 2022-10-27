function R=my_GradCorr(A,B) %梯度法
    
    [h,w]=size(A);    
    Ga=imgradient(A,'Sobel');
    Gb=imgradient(B,'Sobel');
    
    Sa=fft2(Ga); %2维信号用fft2/fftw
    Sb=fft2(Gb,h,w); % Sa和Sb的维数不同——以0扩充Sb的维数（0不会影响相关的值）
    Sb=conj(Sb); %取共轭
    Sr=Sa.*Sb; % 点积
    R=ifft2(Sr); %逆变换

end