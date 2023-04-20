function [R] =  GenerateM(n,m)
R=zeros(n,n,m);
for j=1:m
    R1=eye(n);
    theta=rand*2*pi-pi;
    for i=1:n/2
        R1=R1*RotationM(theta,2*i-1,2*i,n);
    end
    R(:,:,j)=R1;
end
end
