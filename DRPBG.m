function [ f ] = DRPBG( W,H,X,x )
n=size(x,2);
m=size(X,1);
f=max(H./(1+W.*(((sum((X-ones(m,1)*x).^2,2)/n))')));
end

