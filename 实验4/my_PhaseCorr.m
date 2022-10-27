function R=my_PhaseCorr(A,B) %相位法
    
    [h,w]=size(A);    
    Sa=fft2(A); 
    Sb=fft2(B,h,w); % Sa和Sb的维数不同——以0扩充Sb的维数（0不会影响相关的值）
    Sb=conj(Sb); 
    Sr=Sa.*Sb; 
 
    Sr=Sr./abs(Sr);% 除以模

    R=ifft2(Sr); 

end
