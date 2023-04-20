function [ModelSP] = StatePredictor3(t,s,x)
T = [1:t-1]';
sx = [s(1:t-1,:),x(1:t-1,:)];
n = size(sx,2);
m = size(s,2);
if t <= size(s,2)+2
    ModelSP.choose1 = {};
    ModelSP.choose2 = {};
else
    Cor1 = [];Cor2 = [];
    for i = 1:n
        NCC1(sx(:,i),s(2:t,1))
        [ Cor1(1,i) ] = abs(NCC1(sx(:,i),s(2:t,1)));
        [ Cor2(1,i) ] = abs(NCC1(sx(:,i),s(2:t,2)));
    end
    
    % feature selection
    if t < n
        [~,choose1] = max(Cor1);
        [~,choose2] = max(Cor2);
        choose = {choose1;choose2};
    else
        CorSorted = zeros(m,n);
        Position = zeros(m,n);
        Cor = [Cor1;Cor2];
        [CorSorted(1,:),Position(1,:)] = sort(Cor1,'descend');
        [CorSorted(2,:),Position(2,:)] = sort(Cor2,'descend');
        d = CorSorted(:,1:n-1) - CorSorted(:,2:n);
        [dmax,I] = max(d,[],2);
        choose1 = Position(1,1:I(1,1));
        choose2 = Position(2,1:I(2,1));
    end
    n1 = length(choose1);
    n2 = length(choose2);
    sx1_train = sx(:,choose1);
    s1_train = s(2:t,1);
    sx2_train = sx(:,choose2);
    s2_train = s(2:t,2);
    p = size(sx,1);
    
    % predict s_next1
    alpha = 100*ones(1,size(choose1,1));
    for i = 1:n1
        beta1(i,:) = lsqcurvefit(@(beta,x) sigmoid(beta,alpha,x),ones(1,2),sx1_train(:,i)',s1_train');
        f11(:,i) = sigmoid(beta1(i,:),alpha,sx1_train(:,i)')';
        
    end
    k11 = regress(s1_train,f11);
    s1_p1 = f11*k11;
    a1 = quadmodel(sx1_train,s1_train);
    s1_p2 = quadratic(a1,sx1_train);
    y1min = min(s1_train);
    y1max = max(s1_train);
    b1 = rand(4,1);
    b1(1) = (y1min+y1max)/2;
    b1(2) = (y1min-y1max)/2;
    s1_min = [];
    s1_max = [];
    for i = 2:t-2
        if s1_train(i)-s1_train(i-1)<0 & s1_train(i)-s1_train(i+1)<0
            s1_min = s1_train(i);
            s1_minI = T(i);
        end
        if s1_train(i)-s1_train(i-1)>0 & s1_train(i)-s1_train(i+1)>0
            s1_max = s2_train(i);
            s1_maxI = T(i);
        end
        if (~isempty(s1_min))&(~isempty(s1_max))
            b1(4) = 2*pi/(2*abs(s1_maxI-s1_minI));
            break
        end
    end
    b1(3) = nlinfit(T',s1_train',@(b,x) b1(1)+b1(2)*sin(b+b1(4)*x),rand);
    s1_p3 = trigonometric(b1,T);
    Error(1,:,1) = s1_train-s1_p1;
    Error(1,:,2) = s1_train-s1_p2;
    Error(1,:,3) = s1_train-s1_p3;
    MSE(1,1) = mean((s1_train-s1_p1).^2);
    MSE(1,2) = mean((s1_train-s1_p2).^2);
    MSE(1,3) = mean((s1_train-s1_p3).^2);
    [~,index1] = min(MSE(1,:));
    s_1 = [];
    for i = 1: 3
        [pvalue(1,i),H(1,i)] = ranksum(Error(1,:,index1),Error(1,:,i),0.05);
        if H(1,i) == 0
            if i == 1
                s_p = sigmoid(beta1,alpha,sx1_train')';
                s_n1(:,i) = s_p*k11;
                s_1 = [s_1,s_n1(:,i)];
            elseif i == 2
                s_n1(:,i) = quadratic(a1,sx1_train);
                s_1 = [s_1,s_n1(:,i)];
            elseif i == 3
                s_n1(:,i) = trigonometric(b1,T);
                s_1 = [s_1,s_n1(:,i)];
            end
            
        end
        
    end
    I1 = find(H(1,:)==0);
    w1 = regress(s1_train,s_1);
    
    % predict s_next2
    for i = 1:n2
        beta2(i,:) = lsqcurvefit(@(beta,x) sigmoid(beta,alpha,x),ones(1,2),sx2_train(:,i)',s2_train');
        f21(:,i) = sigmoid(beta2(i,:),alpha,sx2_train(:,i)')';
        
    end
    k21 = regress(s2_train,f21);
    s2_p1 = f21*k21;
    a2 = quadmodel(sx2_train,s2_train);
    s2_p2 = quadratic(a2,sx2_train);
    y2min = min(s2_train);
    y2max = max(s2_train);
    b2 = rand(4,1);
    b2(1) = (y2min+y2max)/2;
    b2(2) = (y2min-y2max)/2;
    s2_min = [];
    s2_max = [];
    for i = 2:t-2
        if s2_train(i)-s2_train(i-1)<0 & s2_train(i)-s2_train(i+1)<0
            s2_min = s2_train(i);
            s2_minI = T(i);
        end
        if s2_train(i)-s2_train(i-1)>0 & s2_train(i)-s2_train(i+1)>0
            s2_max = s2_train(i);
            s2_maxI = T(i);
        end
        if (~isempty(s2_min))&(~isempty(s2_max))
            b2(4) = 2*pi/(2*abs(s2_maxI-s2_minI));
            break
        end
    end
    b2(3) = nlinfit(T',s2_train',@(b,x) b2(1)+b2(2)*sin(b+b2(4)*x),rand);
    s2_p3 = trigonometric(b2,T);
    
    Error(2,:,1) = s2_train-s2_p1;
    Error(2,:,2) = s2_train-s2_p2;
    Error(2,:,3) = s2_train-s2_p3;
    MSE(2,1) = mean((s2_train-s2_p1).^2);
    MSE(2,2) = mean((s2_train-s2_p2).^2);
    MSE(2,3) = mean((s2_train-s2_p3).^2);
    [~,index2] = min(MSE(2,:));
    s_2 = [];
    for i = 1: 3
        [pvalue(2,i),H(2,i)] = ranksum(Error(2,:,index2),Error(2,:,i),0.1);
        if H(2,i) == 0
            if i == 1
                s_p = sigmoid(beta2,alpha,sx2_train')';
                s_n2(:,i) = s_p*k21;
                s_2 = [s_2,s_n2(:,i)];
            elseif i == 2
                s_n2(:,i) = quadratic(a2,sx2_train);
                s_2 = [s_2,s_n2(:,i)];
            elseif i == 3
                s_n2(:,i) = trigonometric(b2,T);
                s_2 = [s_2,s_n2(:,i)];
            end  
        end
    end
    I2 = find(H(2,:)==0);
    w2 = regress(s2_train,s_2);
    
    ModelSP.choose{1} = choose1;
    ModelSP.choose{2} = choose2;
    ModelSP.MSE = MSE;
    ModelSP.Error = Error;
    ModelSP.alpha = alpha;
    ModelSP.beta1 = beta1;
    ModelSP.beta2 = beta2;
    ModelSP.k1 = k11;
    ModelSP.k2 = k21;
    ModelSP.a1 = a1;
    ModelSP.a2 = a2;
    ModelSP.b1 = b1;
    ModelSP.b2 = b2;
    ModelSP.I1 = I1;
    ModelSP.I2 = I2;
    ModelSP.w1 = w1;
    ModelSP.w2 = w2;
end
end