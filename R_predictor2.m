function R = R_predictor2(t,s,x,sx_test,gamma,bd,bu,ModelSP)
K = ceil(log(0.1)/log(gamma));
% K = 1;
w = gamma.^[1:K];
r = zeros(K,1);
SamNum = 5;%ÿһά�Ȳ�����
for k = 1:K
%    [s_next,choose] = StatePredict(t,s,sx_test,ModelSP);
    [s_next,choose] = StatePredict2(t,s,sx_test,ModelSP);
    [r(k),Imax] = max(sum(s_next,2));
    s_next = s_next(Imax,:);
    Ns = size(s,2);%״̬��������
    Nx = size(x,2);%������������
    t = t+1;
    s = [s;s_next];
    x = [x;sx_test(Imax,Ns+1:Ns+Nx)];
    sx_t = [];
    for i = 1:Ns
        n(i) = size(choose{i},2);%��״̬������صĶ�������ά��
        for j = 1:n(i)
            if choose{i}(j) > Ns
                sx = ones(SamNum,1)*sx_test(Imax,:);
                x_sample = bd+(bu-bd)*rand(SamNum,1);
                sx(:,choose{i}(j)) = x_sample;
                sx_t = [sx_t;sx];
            end
        end
    end
    q = size(sx_t,1);
    if q ~= 0
        sx_t(:,1:Ns) = ones(q,1)*s_next;
        sx_test = sx_t;
    end
end
R = w*r;
end