function [ R ] = RotationM(theta,l1,l2,n)
R=eye(n);
R(l1,l1)=cos(theta);
R(l2,l2)=cos(theta);
R(l1,l2)=sin(theta);
R(l2,l1)=-sin(theta);
end

