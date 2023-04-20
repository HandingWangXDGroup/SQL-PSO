function L = buildL(s,x,r,n)
% n为目标集合的大小
 %创建Q列表
    L.sx = [];
    L.Q = [];
    L.s = [];
    L.x = [];
    L.r = [];
    p = size(x,1);
    sx = [ones(p,1)*s,x];
    [~,I] = max(r);
    if size(L.sx,1) == 0
        L.sx = [L.sx; sx(I,:)];
        L.s = [L.s; s];
        L.x = [L.x; x(I,:)];
        L.r = [L.r; r(I)];
        L.Q = [L.Q;rand];
    end
    x(I,:) = [];
    r(I) = [];
    sx(I,:) = [];
    p = p - 1;
    q = 1;
    scale = max(abs([x,r]),[],1);
    while q < n
        d = zeros(p,q);
        for i = 1:q
            d(:,i) = Normdistance([x,r],[L.x(i,:),L.r(i,:)],scale);
        end
        D = min(d,[],2);%候选集合中每个元素到目标集合的距离
        [~,I] = max(D);
        %将选中的元素加入目标集合
        L.sx = [L.sx; sx(I,:)];
        L.s = [L.s; s];
        L.x = [L.x; x(I,:)];
        L.r = [L.r; r(I)];
        L.Q = [L.Q; rand];
        %删除候选集和中的已选元素w
        x(I,:) = [];
        r(I) = [];
        sx(I,:) = [];
        p = p-1;
        q = q+1;
    end
end