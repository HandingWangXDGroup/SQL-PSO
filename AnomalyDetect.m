function Anomaly = AnomalyDetect(Data,threshold)
% Run iForest
% Anomaly = false(size(Data,1),1);
% parameters for iForest
NumTree = 100; % number of isolation trees
NumSub = 256; % subsample size
NumDim = size(Data, 2); % do not perform dimension sampling 
rseed = sum(100 * clock);
Forest = IsolationForest(Data, NumTree, NumSub, NumDim, rseed);
[Mass, ~] = IsolationEstimation(Data, Forest);
score = 2.^(-mean(Mass, 2)/Forest.c);
Anomaly = score > threshold;
end