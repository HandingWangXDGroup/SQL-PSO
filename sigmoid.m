function f = sigmoid(beta,alpha,x)
n = size(x,1);
f = (beta(1)./(1+exp(-alpha*x)) - beta(1)/2)+beta(2);
% f = f'; 
end
