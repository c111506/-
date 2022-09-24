function R=Centerprof(B)
    %图形中心信息的相关计算
    [y,x]=find(B==1);
    xc=mean(x);%找中心点
    yc=mean(y);
    B(round(yc),round(xc))=0;

    %%
    E=bwperim(B); %找边界
    [y,x]=find(E==1);
    n=length(x)
    %勾股定理计算边到中心点的距离和角度
    ro=sqrt((x-xc).^2+(y-yc).^2);
    % arctan计算到中心点的距离
    % 90°附近精度差，所以用atan2d
    fi=atan2d(y-yc,x-xc);

    %%
    R=zeros(361,1);%改成361了
    for i=1:n
        ID=floor(fi(i)+181);
        R(ID)=max(R(ID),ro(i));%对于多连通图，要取最大值
    end
    R=R/mean(R);%归一化
end
