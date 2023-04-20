function s_next = MeasureState(s_predict,s_train)
n = size(s_predict,1);
for i = 1:n
    [d(i),index(i)] = min(sum(abs(s_predict(i,:)-s_train),2));
end
Anomaly = AnomalyDetect(d,0.6);
s_next = s_predict;
s_next(Anomaly,:) = s_train(index(Anomaly),:);
end