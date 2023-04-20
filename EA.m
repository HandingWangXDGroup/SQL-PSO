function [personalbest_x,personalbest_faval,x_all,f_all,fevn,W,H,X,theta] = EA(problem_name,b,m,type,typeS,fevn,n,W,H,X,theta,Action_pre,bd,bu,MaxNum,particlesize)
c1 = 1.4;                                
c2 = 1.4;                                 
w = 0.75;                                 
vmax = 0.8;                             
v = 2*rand(particlesize,n);
x = lhsdesign(particlesize, n).*(ones(particlesize, n)*(bu-bd))+ones(particlesize, n)*bd;
[ f,fevn,W,H,X,theta] = ComputeObjectives(x,problem_name,b,m,type,typeS,fevn,n,W,H,X,theta,Action_pre);
x_all = x;
f_all = f;
personalbest_x=x;         
personalbest_faval=f;     
[globalbest_faval,index] = max(personalbest_faval); 
globalbest_x = personalbest_x(index,:);   
k = 1; 
while k < MaxNum   
    for i = 1:particlesize
        v(i,:) = w*v(i,:) + c1*rand*(personalbest_x(i,:) - x(i,:)) + c2*rand*(globalbest_x -x(i,:)); 
        for j = 1:n   
            if v(i,j) > vmax
                v(i,j) = vmax;
            elseif v(i,j) < -vmax
                v(i,j) = -vmax;
            end
        end
        x(i,:) = x(i,:) + v(i,:); 
        for j = 1:n
            if x(i,j) > bu
                x(i,j) = bu;
            end
            if x(i,j) < bd
                x(i,j) = bd;
            end
        end
    end
    [ f,fevn,W,H,X,theta] = ComputeObjectives(x,problem_name,b,m,type,typeS,fevn,n,W,H,X,theta,Action_pre);
    I = find(f-personalbest_faval>0);
    personalbest_faval(I) = f(I);
    personalbest_x(I,:) = x(I,:); 
    x_all = [x_all;x];
    f_all = [f_all;f];
    k = k + 1;
    [globalbest_faval,index] = max(personalbest_faval);
    globalbest_x = personalbest_x(index,:); 
end
end