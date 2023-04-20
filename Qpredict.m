function Q = Qpredict(s,x,W2,B2,Centers,Spreads)
TestSamIn = [s,x];
Q = RBF_predictor(W2,B2,Centers,Spreads,TestSamIn);
end