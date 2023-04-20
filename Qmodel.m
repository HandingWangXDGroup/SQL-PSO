function [ W2,B2,Centers,Spreads,scale ] = Qmodel(s,x,Q,n,w)
SamIn = [s,x];
SamOut = Q;
[ W2,B2,Centers,Spreads,scale ] = RBF2( SamIn,SamOut,n,w);
end