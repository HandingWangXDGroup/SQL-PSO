function [ R,theta ] =  TransformationM( thetat,type,a,amax,sev,frg,fmin,A,P,fai,t,Nsev,n)
theta=DynamicChanges( thetat,type,a,amax,sev,frg,fmin,A,P,fai,t,Nsev);
R=eye(n);
for i=1:n/2
    R=R*RotationM(theta,2*i-1,2*i,n);
end
end
