function [r_opt,X_pre]=optimal(problem_name,b,m,type,typeS,W,H,X,X_pre)
% switch problem_name
%     case{'MPB50+_T1_10','MPB50+_T1_1'}
%         b = 50;
% end
[Hmax,Imax] = max(H);
x = X(Imax,:);
switch problem_name
    case 'MPB'
        if size(X_pre,1)==0|size(X_pre,2)==0
            r_opt=MPBG(W,H,X,x)+b;
        else
            x=X;
            r=zeros(size(X,1),1);
            for i=1:size(X,1)
                xt=x(i,:);
                xt(1)=0;
                if x(i,1)<0
                    if H(i)-b>=MPBG(W,H,X,xt)+b
                        if X_pre(1)>=0
                            r(i)=MPBG(W,H,X,x(i,:))+b;
                        else
                            r(i)=MPBG(W,H,X,x(i,:))-b;
                        end
                    else
                        x(i,1)=0;
                        r(i)=MPBG(W,H,X,x(i,:))+b;
                    end
                else
                    if X_pre(1)>=0
                        r(i)=MPBG(W,H,X,x(i,:))+b;
                    else
                        r(i)=MPBG(W,H,X,x(i,:))-b;
                    end
                end
            end
            [r_opt,Imax]=max(r);
            x=x(Imax,:);
        end
        X_pre=x;
    case 'DRPBG'
        if size(X_pre,1)==0|size(X_pre,2)==0
            r_opt=DRPBG(W,H,X,x)+b;
        else
            x=X;
            r=zeros(size(X,1),1);
            for i=1:size(X,1)
                xt=x(i,:);
                xt(1)=0;
                if x(i,1)<0
                    if H(i)-b>=DRPBG(W,H,X,xt)+b
                        if X_pre(1)>=0
                            r(i)=DRPBG(W,H,X,x(i,:))+b;
                        else
                            r(i)=DRPBG(W,H,X,x(i,:))-b;
                        end
                    else
                        x(i,1)=0;
                        r(i)=DRPBG(W,H,X,x(i,:))+b;
                    end
                else
                    if X_pre(1)>=0
                        r(i)=DRPBG(W,H,X,x(i,:))+b;
                    else
                        r(i)=DRPBG(W,H,X,x(i,:))-b;
                    end
                end
            end
            [r_opt,Imax]=max(r);
            x=x(Imax,:);
        end
        X_pre=x;
end
end