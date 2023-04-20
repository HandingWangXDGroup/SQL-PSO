function [globalbest_x,globalbest_faval,x_all,f_all,robustness] = EA_Q2(s,Model_Q,n,bd,bu,t)               
MaxNum = 20;                                                   
particlesize = 10;                      
c1 = 1.4;                                 
c2 = 1.4;                                 
w = 0.6;                                 
vmax = 0.8;                             
v = 2*rand(particlesize,n);
x = lhsdesign(particlesize, n).*(ones(particlesize, n)*(bu-bd))+ones(particlesize, n)*bd;
[f,robustness] = Qpredict2(s,x,Model_Q,t);
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
    for i = 1:particlesize   
        [f(i),robustness] = Qpredict2(s,x(i,:),Model_Q,t);
        if f(i) > personalbest_faval(i)   
            personalbest_faval(i) = f(i); 
            personalbest_x(i,:) = x(i,:);
        end
    end
    x_all = [x_all;x];
    f_all = [f_all;f];
    k = k + 1;
    [globalbest_faval,index] = max(personalbest_faval);
    globalbest_x = personalbest_x(index,:); 
end
end