function [r_opt,X_pre]=Opt_R(problem_name,W,H,X,X_pre,bu,bd)
switch problem_name
    case {'FB100_STC_1','CMPB100_STC_1','FB100_STCH1_1','FB100_STCH2_1','FB100_STCH3_1','FB100_STCH4_1','FB100_STCH5_1','FB100_STCH6_1','FB100_STC_M1','FB100_STC_M2','FB100_STC_M5','FB100_STC_M10','FB100_RT1_M1','FB100_RT1_M2','FB100_RT1_M5','FB100_RT1_M10','FB100+_RT1_1'}
        b=100;
    case {'FB10_STC_1','CMPB10_STC_1','FB10+_RT1_1','FB10+_T1_10','FB10+_T2_10','FB10+_T3_10','FB10+_T4_10','FB10+_T5_10','FB10+_T6_10'}
        b=10;    
    case {'FB50_STC_1','CMPB50_STC_1','FB50_CT1_1','FB50_CT2_1','FB50_CT3_1','FB50_CT4_1','FB50_CT5_1','FB50_CT6_1','FB50_T1_1','FB50_T2_1','FB50_T3_1','FB50_T4_1','FB50_T5_1','FB50_T6_1','FB50+_RT1_1'}
        b=50;
    case {'FB0+_RT1_1'}
        b=0;
    case {'FB5+_RT1_1'}
        b=5;
    case {'FB30+_RT1_1'}
        b=30;
end
[Hmax,Imax]=max(H);
x=X(Imax,:);
switch problem_name
     case {'FB100+_RT1_1','FB10+_RT1_1','FB50+_RT1_1','FB10+_T1_10','FB10+_T2_10','FB10+_T3_10','FB10+_T4_10','FB10+_T5_10','FB10+_T6_10','FB0+_RT1_1','FB5+_RT1_1','FB30+_RT1_1'}
        if size(X_pre,1)==0|size(X_pre,2)==0
            r_opt=DRPBG(W,H,X,x)+b;   
        else
            x=X;
            r=zeros(size(X,1),1);
            for i=1:size(X,1)
                xt=x(i,:);
                xt(1)=bu(1);
                if H(i)+b*x(i,1)>=DRPBG(W,H,X,xt)+b*xt(1)
                    r(i)=DRPBG(W,H,X,x(i,:))+b*X_pre(1);
                else
                    x(i,1)=bu(1);
                    r(i)=DRPBG(W,H,X,x(i,:))+b*X_pre(1);
                end
            end
            [r_opt,Imax]=max(r);
            x=x(Imax,:);
        end
    X_pre=x;
    case {'FB100_STC_M1','FB100_STC_M2','FB100_STC_M5','FB100_STC_M10','FB100_RT1_M1','FB100_RT1_M2','FB100_RT1_M5','FB100_RT1_M10'}
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
    case {'FB100_STC_1','FB50_STC_1','FB10_STC_1','FB50_CT1_1','FB50_CT2_1','FB50_CT3_1','FB50_CT4_1','FB50_CT5_1','FB50_CT6_1','FB50_T1_1','FB50_T2_1','FB50_T3_1','FB50_T4_1','FB50_T5_1','FB50_T6_1','FB100_STCH1_1','FB100_STCH2_1','FB100_STCH3_1','FB100_STCH4_1','FB100_STCH5_1','FB100_STCH6_1'}
        if size(X_pre,1)==0|size(X_pre,2)==0
            r_opt=DRPBG(W,H,X,x)+b;   
        else
            xt=x;
            xt(1)=0;
            if x(1)<0
                if Hmax-b>=DRPBG(W,H,X,xt)+b
                    if X_pre(1)>=0
                        r_opt=DRPBG(W,H,X,x)+b;
                    else
                        r_opt=DRPBG(W,H,X,x)-b;
                    end
                else
                    x(1)=0;
                    r_opt=DRPBG(W,H,X,x)+b;
                end
            else
                if X_pre(1)>=0
                    r_opt=DRPBG(W,H,X,x)+b;
                else
                    r_opt=DRPBG(W,H,X,x)-b;
                end
            end
        end
        X_pre=x;
        case {'CMPB100_STC_1','CMPB50_STC_1','CMPB10_STC_1'}
        if size(X_pre,1)==0|size(X_pre,2)==0
            r_opt=DRPBG(W,H,X,x)+b;   
        else
            xt=x;
            xt(1)=0;
            if x(1)<0
                if Hmax-b>=CMPB(W,H,X,xt)+b
                    if X_pre(1)>=0
                        r_opt=CMPB(W,H,X,x)+b;
                    else
                        r_opt=CMPB(W,H,X,x)-b;
                    end
                else
                    x(1)=0;
                    r_opt=CMPB(W,H,X,x)+b;
                end
            else
                if X_pre(1)>=0
                    r_opt=CMPB(W,H,X,x)+b;
                else
                    r_opt=CMPB(W,H,X,x)-b;
                end
            end
        end
        X_pre=x;
end
end