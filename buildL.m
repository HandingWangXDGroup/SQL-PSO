function L = buildL(s,x,r,n)
% nΪĿ�꼯�ϵĴ�С
 %����Q�б�
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
        D = min(d,[],2);%��ѡ������ÿ��Ԫ�ص�Ŀ�꼯�ϵľ���
        [~,I] = max(D);
        %��ѡ�е�Ԫ�ؼ���Ŀ�꼯��
        L.sx = [L.sx; sx(I,:)];
        L.s = [L.s; s];
        L.x = [L.x; x(I,:)];
        L.r = [L.r; r(I)];
        L.Q = [L.Q; rand];
        %ɾ����ѡ�����е���ѡԪ��w
        x(I,:) = [];
        r(I) = [];
        sx(I,:) = [];
        p = p-1;
        q = q+1;
    end
end