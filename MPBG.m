function f = MPBG(W,H,C,x)
m = size(C,1);
% size(H)
% size(W)
% size(C)
% size(x)
% size(ones(m,1)*x)
f = max(H-W.*(sqrt(sum((ones(m,1)*x-C).^2,2))'));
end