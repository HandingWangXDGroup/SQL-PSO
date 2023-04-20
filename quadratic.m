function f = quadratic(a, x)
% f = a(1) + a(2)*x +a(3)*(x.^2);
[n,m] = size(x); %n为样本个数，m为x的维数
basis = [];
for i = 1:m
    for j = i:m
        basis = [basis x(:,i).*x(:,j)];
    end
end
basis = [basis x ones(n,1)];
f = basis*a;
end