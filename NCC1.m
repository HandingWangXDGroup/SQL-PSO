function [ ncc ] = NCC1( x,y)
% Usage: [ ncc ] = NCC1( x,y)
%
% Input:
% x              - variable
% y              - variable
%
% Output: 
% ncc            - NCIE of x and y
% 
n=size(x,1);
b=fix(n^0.5);
if max(x)~=min(x) & max(y)~=min(y)
    detax=(max(x)-min(x)+0.00001*(max(x)-min(x)))/b;
    detay=(max(y)-min(y)+0.00001*(max(y)-min(y)))/b;
    if detax~=0 & detay~=0
    p=zeros(b,b);
    x1=ceil((x-min(x)+0.000005*(max(x)-min(x)))/detax);
    y1=ceil((y-min(y)+0.000005*(max(y)-min(y)))/detay);
    x1(find(x1<=0))=1;
    y1(find(y1<=0))=1;
    x1(find(x1>b))=b;
    y1(find(y1>b))=b;
    for i=1:n 
        p(x1(i),y1(i))=p(x1(i),y1(i))+1/n;  
    end
    ncc=0;
    for i=1:b
        for j=1:b
            if p(i,j)~=0
            ncc=ncc+(p(i,j))*log(p(i,j))/log(b);
            end
        end
    end
    for i=1:b
        if sum(p(i,:))~=0
            ncc=ncc-(sum(p(i,:)))*log(sum(p(i,:)))/log(b);
        end
    end
    for i=1:b
        if sum(p(:,i))~=0
            ncc=ncc-(sum(p(:,i)))*log(sum(p(:,i)))/log(b);
        end
    end
    else
        ncc=0;
    end
else
    ncc=0;
end
% cor=cov(x,y);
% if cor(1,2)<0
%     ncc=0-ncc;
% end
end