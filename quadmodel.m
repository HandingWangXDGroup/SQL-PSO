function a = quadmodel(SamIn,SamOut)
% f = a(1) + a(2)*x +a(3)*(x.^2);
[n,m] = size(SamIn); %n为样本个数，m为x的维数
basis = [];
for i = 1:m
    for j = i:m
        basis = [basis SamIn(:,i).*SamIn(:,j)];
    end
end
basis = [basis,SamIn,ones(n,1)];
% a = ((basis'*basis)\basis')*SamOut;
a = pinv(basis)*SamOut;
% a1 = pinv(basis'*basis)*basis'*SamOut;
end