function [Q,robustness] = Qpredict2(s,x,Model_Q,t)
e = 0.3;
scale = abs(max([s;Model_Q{t}.State],[],1));
n = size(x,1);
for i = 1:t
    d(i,1) = Normdistance(s,Model_Q{i}.State,scale);
end
I = find(d<=e);
if isempty(I)
    [~,I]  = min(d);
end
for i = 1:length(I)
   q(:,i) = RBF_predictor(Model_Q{I(i)}.W2,Model_Q{I(i)}.B2,Model_Q{I(i)}.Centers,Model_Q{I(i)}.Spreads,x);
end
Q = mean(q,2);
if isnan(Q)
    disp('nan');
end
robustness = 1/(min(d)+1);
end