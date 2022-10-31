function H=my_GHT(A,B)
    
    Ea=edge(A,'Sobel'); 
    Eb=edge(B,'Sobel'); % 获得边界
    [h,w]=size(A);

    [yb,xb]=find(Eb==1);
    nb=length(xb);
    
    if nb>0 % nb不为0—噪声小，还能获得边界

        [h1,w1]=size(B);
        H=zeros(h,w);

        [~,GammaA]=imgradient(A,'Sobel'); % 获得边界梯度
        [~,GammaB]=imgradient(B,'Sobel');

        gb=zeros(size(xb)); 
        for i=1:nb
            gb(i)=GammaB(yb(i),xb(i)); %建立各点的梯度，后面再进行排序
        end


    Qsort(1,nb);

    % 填充+划分成360份
    Q=zeros(361,1);
    Q(1)=1;
    Q(361)=nb+1;  % Q的数量多了1，需要减去？

    % 将梯度排序，统计每个区间内梯度的数量，便于后续匹配
    for i=2:360
        for j=Q(1):nb
%             Q(i)=Q(i-1); % 此行无用吧？
            if gb(j)>i-1-180 % 梯度179+时对应i=360，i=2时对应梯度-179~-178
                % 其实“扣其两端”就行了，选最大或是最小的边界就可以确定这个表达式了
                Q(i)=j;
                break;
            end
        end
    end

    eps=2; % 用于扩大匹配区间，提高抗干扰

    % 梯度排序后，以梯度为标准，匹配相同梯度的点的横纵坐标
    % 梯度和横纵坐标都匹配，结果更加可靠
     for x=1:w
         for y=1:h
             if Ea(y,x)==1
                 q=floor(GammaA(y,x)+181+1); % floor---向下取整
                 % 还是扣其两端，floor对应+1，GammaA最小为-180，
                 % 所以需要加181对应B的0-1区间的梯度
                 q1=q-eps;q2=q+eps-1; % 扩大匹配区间

                 if q2>361,q2=361;end
                 if q1<1,q1=1;end

                 for i=Q(q1):Q(q2)-1
                     dx=x-xb(i);
                     dy=y-yb(i);
                     if (dx>=1)&&(dx<=w)&&(dy>=1)&&(dy<=h)
                         H(dy,dx)=H(dy,dx)+1;
                     end
                 end
             end
         end
     end

     % 抗干扰滤波
     r=3;
     m=ones(r,r);
     H=imfilter(H,m);
     
    else %噪声巨大时
        
        H=zeros(h,w);
        H(1,1)=1;
        
    end
     
     % 排序算法
    function Qsort(a,b)
        L=a; %定义左右边界
        R=b;
        m=gb(round((a+b)/2));
        while (L<=R)
            while (gb(L)<m),L=L+1;end
            while (gb(R)>m),R=R-1;end
            if (L<=R)
                g=gb(L);gb(L)=gb(R);gb(R)=g;
                t=xb(L);xb(L)=xb(R);xb(R)=t;
                t=yb(L);yb(L)=yb(R);yb(R)=t;
                L=L+1;
                R=R-1;
            end
        end
        if a<R, Qsort(a,R);end
        if L<b,Qsort(L,b);end
    end
end
