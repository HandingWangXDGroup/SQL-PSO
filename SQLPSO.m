function [x,fitness,accum_reward,x_opt,fitness_opt,accum_reward_opt] = SQLPSO(problem_name,b,m,type,typeS,n,bu,bd,t_max,fevnmax,e)
% SQL-PSO: Surrogate-Assisted Evolutionary Q-Learning
% 
% ------------------------------- Reference --------------------------------
% 
% Zhang T, Wang H, Yuan B, et al. Surrogate-Assisted Evolutionary Q-Learning for Black-Box Dynamic Time-Linkage Optimization Problems[J]. IEEE Transactions on Evolutionary Computation, 2022.
% 
% ------------------------------- Copyright --------------------------------
% 
% Copyright (c) 2022 HandingWangXD Group. Permission is granted to copy and use this code for research, noncommercial purposes, provided this copyright notice is retained and the origin of the code is cited. The code is provided "as is" and without any warranties, express or implied.
% 
% This code is written by Tuo Zhang.
% 
% Email: zhangtuo@stu.xidian.edu.cn
% 
% -------------------------------- Usage------------------------------------
% 
% Run SQLPSO_test.m to test the proposed algorithm.


W=[];H=[];X=[];theta=[];
fevn = 0;  % number of evaluation
% parameters
gamma = 0.8;
MaxNum=100;
particlesize=100;

s = [];
x = [];
R = [];
Action_pre = [];
x_opt = [];x_pre = [];fitness_opt = zeros(t_max,1);
Model_Q = cell(t_max,1);
Model_State = [];
for t = 1:t_max
    a = 100/(150+t);
    
    % explore by EA
    [~,~,x_t,r_t,fevn,W,H,X,theta] = EA(problem_name,b,m,type,typeS,fevn,n,W,H,X,theta,Action_pre,bd,bu,MaxNum,particlesize);
    
    % theoretially optimum
    [fitness_opt(t),x_pre] = optimal(problem_name,b,m,type,typeS,W,H,X,x_pre);
    x_opt = [x_opt;x_pre];
    
    % state extracting
    s_t = state_extracting2(r_t);
    s = [s;s_t];
    SizeS = 0;
    
    % build list "L"
    ModelSP = StatePredictor3(t,s,x);
    if n < 20
        sizeL = 200;
    else
        sizeL = 11*n;
    end
    L{t} = buildL(s_t,x_t,r_t,sizeL);
    sp1=[];Qp1=[];
    for i = 1:sizeL
        if t > 4
            L{t}.Q(i) = Qpredict2(L{t}.s(i,:),L{t}.x(i,:),Model_Q,t-SizeS-1);
            L{t}.s_next(i,:) = StatePredict(t,s,[L{t}.s(i,:),L{t}.x(i,:)],ModelSP);
            if isempty(sp1)
                [~,Qnext,~,~,~] = EA_Q2(L{t}.s_next(i,:),Model_Q,n,bd,bu,t-SizeS-1);
                L{t}.Q(i) = (1-a)*L{t}.Q(i) + a*(L{t}.r(i) + gamma*Qnext);
                sp1 = [sp1; L{t}.s_next(i,:)];
                Qp1 = [Qp1;Qnext];
            else
                scale = max(abs(L{t}.s_next),[],1);
                d = Normdistance(sp1,L{t}.s_next(i,:),scale);
                I1 = find(d<3*e);
                if isempty(I1)
                    [~,Qnext,~,~,~] = EA_Q2(L{t}.s_next(i,:),Model_Q,n,bd,bu,t-SizeS-1);
                    L{t}.Q(i) = (1-a)*L{t}.Q(i) + a*(L{t}.r(i) + gamma*Qnext);
                    sp1 = [sp1; L{t}.s_next(i,:)];
                    Qp1 = [Qp1;Qnext];
                else
                    L{t}.Q(i) = (1-a)*L{t}.Q(i) + a*(L{t}.r(i) + gamma*mean(Qp1(I1)));
                end
            end
        else
            L{t}.Q(i) = L{t}.Q(i) + L{t}.r(i);
        end
    end
    
    %train Q model
    Nc = floor(sqrt(sizeL));
    w = ones(1,n);
    [ Model_Q{t-SizeS}.W2,Model_Q{t-SizeS}.B2,Model_Q{t-SizeS}.Centers,Model_Q{t-SizeS}.Spreads] = RBF2(L{t}.x,L{t}.Q,Nc,w);
    Model_Q{t-SizeS}.State = s_t;
    Model_Q{t-SizeS}.t = t-SizeS;
    Model_State = [Model_State;s_t];
    
    % update Q models
    if t>4
        scale = max(abs(L{t}.s_next),[],1);
        for i = 1:t-1
            d_q(i,1) = Normdistance(s(t-1,:),Model_Q{i}.State,scale);
        end
        I2 = find(d_q<e);
        sp2=[];Qp2=[];
        if isempty(I2)==0
            for j = I2'
                for i = 1:sizeL
                    L{j}.Q(i) = Qpredict2(L{j}.s(i,:),L{j}.x(i,:),Model_Q,t-SizeS);
                    L{j}.s_next(i,:) = StatePredict(t,s,[L{j}.s(i,:),L{j}.x(i,:)],ModelSP);
                    if isempty(sp2)
                        [~,Qnext,~,~,~] = EA_Q2(L{j}.s_next(i,:),Model_Q,n,bd,bu,t-SizeS);
                        L{j}.Q(i) = (1-a)*L{j}.Q(i) + a*(L{j}.r(i) + gamma*Qnext);
                        sp2 = [sp2; L{j}.s_next(i,:)];
                        Qp2 = [Qp2;Qnext];
                    else
                        scale3 = max(abs(L{j}.s_next),[],1);
                        d3 = Normdistance(sp2,L{j}.s_next(i,:),scale3);
                        I3 = find(d3<e);
                        if isempty(I3)
                            [~,Qnext,~,~,~] = EA_Q2(L{j}.s_next(i,:),Model_Q,n,bd,bu,t-SizeS);
                            L{j}.Q(i) = (1-a)*L{j}.Q(i) + a*(L{j}.r(i) + gamma*Qnext);
                            sp2 = [sp2; L{j}.s_next(i,:)];
                            Qp2 = [Qp2;Qnext];
                        else
                            L{j}.Q(i) = (1-a)*L{j}.Q(i) + a*(L{j}.r(i) + gamma*mean(Qp2(I3)));
                        end
                    end
                end
                [ Model_Q{j-SizeS}.W2,Model_Q{j-SizeS}.B2,Model_Q{j-SizeS}.Centers,Model_Q{j-SizeS}.Spreads] = RBF2(L{j}.x,L{j}.Q,Nc,w);
            end
            
        end
    end
    
    % predict the next state
    p = size(x_t,1);
    s_next = StatePredict(t,s,[ones(fevnmax,1)*s_t,x_t],ModelSP);
    scale2 = max(abs(s_next),[],1);
    
    % reevaluate the Q value of each x
    sp = [];Qp = [];robustness = zeros(p,1);
    Q = zeros(p,1);
    [~,globalbest_Q,~,~,~] = EA_Q2(s_next(1,:),Model_Q,n,bd,bu,t-SizeS);
    Q(1) = (1-a)*r_t(1) + a*gamma*globalbest_Q;
    sp = [sp;s_next(1,:)];
    Qp = [Qp;globalbest_Q];
    [distance,~] = min(Normdistance(Model_State,s_next(1,:),scale2));
    robustness(1)  = 1/((1+distance)^4);
    for i = 2:p
        d2 = Normdistance(sp,s_next(i,:),scale2);
        I = find(d2<e);
        [distance,~] = min(Normdistance(Model_State,s_next(i,:),scale2));
        if isempty(I)==0
            Q(i) = (1-a)*r_t(i) + a*gamma*mean(Qp(I));
            robustness(i)  = 1/((1+distance)^4);
        else
            [~,globalbest_Q,~,~,~] = EA_Q2(s_next(i,:),Model_Q,n,bd,bu,t-SizeS);
            Q(i) = (1-a)*r_t(i) + a*gamma*globalbest_Q;
            sp = [sp;s_next(i,:)];
            Qp = [Qp;globalbest_Q];
            robustness(i)  = 1/((1+distance)^4);
        end
    end
    
    % Anomaly detection
    Q_data = mapminmax(Q',0,1)';
    robustness = mapminmax(robustness',0,1)';
    Anomaly = AnomalyDetect([Q_data,robustness],0.75);
    
    % 0.1-greedy to select x
    if rand > 0.1
        [Q_sorted,Index] = sort(Q,'descend');
        for i = 1:p
            if Anomaly(i)==false
                Q_best(t)=Q_sorted(i);
                x(t,:) = x_t(Index(i),:);
                R(t) = r_t(Index(i));
                break
            end
        end
    else
        perm = randperm(p);
        Q_best(t) = Q(perm(1));
        x(t,:) = x_t(perm(1),:);
        R(t) = r_t(perm(1));
    end
    Action_pre = x(t,:);
    fitness = R;
    accum_reward = cumsum(R);
    accum_reward_opt = cumsum(fitness_opt);
end
end