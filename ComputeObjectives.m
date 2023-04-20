function [ obj,fevn,W,H,X,theta] = ComputeObjectives(POP,problem_name,b,m,type,typeS,fev,n,W,H,X,theta,Action_pre)
obj=zeros(size(POP,1),1);
fevn=fev;
frequency=10000;
P=12;
Nsev=0.8;
A=3.67;
a=0.04;
amax=0.1;
fai=0;
Hsev=5;
Hrg=90;
Hmin=10;
Wsev=0.5;
Wrg=9;
Wmin=1;
Xmin=-5;
Xrg=10;
Xsev=0.5;
thsev=1;
thrg=2*pi;
thmin=-pi;
xmax=5;
switch problem_name
    case 'MPB'
        for i=1:size(POP,1)
            if floor((fevn-1)/frequency)~=floor(fevn/frequency)
                t=floor(fevn/frequency);
                if fevn==0
                    W=5*ones(1,m);
                    H=50*ones(1,m);
                    X=rand(m,n)*Xrg+Xmin;
                    X(:,1)=rand(m,1)*Xrg*0.5;
                    theta=rand*thrg+thmin;
                else
                    W=DynamicChanges( W,type{typeS(1)},a,amax,Wsev,Wrg,Wmin,A,P,fai,t,Nsev);
                    H=DynamicChanges( H,type{typeS(2)},a,amax,Hsev,Hrg,Hmin,A,P,fai,t,Nsev);
                    [ R,theta ] =  TransformationM( theta,type{typeS(3)},a,amax,thsev,thrg,thmin,A,P,fai,t,Nsev,n);
                    X=X*R;
                    I=find(X>Xmin+Xrg|X<Xmin);
                    X(I)=X(I)-floor((X(I)-Xmin)/Xrg)*Xrg;
                end
            end
            if size(Action_pre,1)==0|size(Action_pre,2)==0
                [obj(i)]=MPBG( W,H,X,POP(i,1:n) )+b;
            else
                [obj(i)]=MPBG( W,H,X,POP(i,1:n) )+b*sgn(Action_pre(1));
            end
            fevn=fevn+1;
        end
    case 'DRPBG'
        for i=1:size(POP,1)
            if floor((fevn-1)/frequency)~=floor(fevn/frequency)
                t=floor(fevn/frequency);
                if fevn==0
                    W=5*ones(1,m);
                    H=50*ones(1,m);
                    X=rand(m,n)*Xrg+Xmin;
                    X(:,1)=rand(m,1)*Xrg*0.5;
                    theta=rand*thrg+thmin;
                else
                    W=DynamicChanges( W,type{typeS(1)},a,amax,Wsev,Wrg,Wmin,A,P,fai,t,Nsev);
                    H=DynamicChanges( H,type{typeS(2)},a,amax,Hsev,Hrg,Hmin,A,P,fai,t,Nsev);
                    [ R,theta ] =  TransformationM( theta,type{typeS(3)},a,amax,thsev,thrg,thmin,A,P,fai,t,Nsev,n);
                    X=X*R;
                    I=find(X>Xmin+Xrg|X<Xmin);
                    X(I)=X(I)-floor((X(I)-Xmin)/Xrg)*Xrg;
                end
            end
            if size(Action_pre,1)==0|size(Action_pre,2)==0
                obj(i)=DRPBG( W,H,X,POP(i,1:n) )+b;
            else
                obj(i)=DRPBG( W,H,X,POP(i,1:n) )+b*sgn(Action_pre(1));
            end
            fevn=fevn+1;
        end
end
end