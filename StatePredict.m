function [s_next,chosen] = StatePredict(t,s,sx_test,ModelSP)
q = size(sx_test,1);
if t <= size(s,2)+2
    s_next = ones(q,1)*s(t,:) + rand(q,2);
    chosen = {};
else
choose1 = ModelSP.choose{1};
choose2 = ModelSP.choose{2};
chosen = {choose1;choose2};
MSE = ModelSP.MSE;
Error = ModelSP.Error;
Error = abs(Error);
alpha = ModelSP.alpha;
beta1 = ModelSP.beta1;
beta2 = ModelSP.beta2;
k1 = ModelSP.k1;
k2 = ModelSP.k2;
a1 = ModelSP.a1;
a2 = ModelSP.a2;
b1 = ModelSP.b1;
b2 = ModelSP.b2;
I1 = ModelSP.I1;
I2 = ModelSP.I2;
w1 = ModelSP.w1;
w2 = ModelSP.w2;
% Ô¤²âs_next1
%     alpha = 100*ones(1,size(choose1,1));
%     beta1 = lsqcurvefit(@(beta,x) sigmoid(beta,alpha,x),ones(1,1),sx1_train',s1_train');
%     s1_p1 = sigmoid(beta1,alpha,sx1_train')';
%     MSE(1,1) = mean((s1_train-s1_p1).^2);
%
%     b1 = regress(s1_train,[ones(t-1,1),sx1_train]);
%     s1_p2 = [ones(p,1),sx1_train]*b1;
%     MSE(1,2) = mean((s1_train-s1_p2).^2);
%
%     a1 = lsqcurvefit(@(a,x) quadratic(a,x),[1 1 1],sx1_train',s1_train');
%     s1_p3 = quadratic(a1, sx1_train')';
%     MSE(1,3) = mean((s1_train-s1_p3).^2);

    [~,index1] = min(MSE(1,:));
    s_1 = [];
    for i = I1
%         [pvalue(1,i),H(1,i)] = ranksum(Error(1,:,index1),Error(1,:,i),0.05);
%         if H(1,i) == 0
            if i == 1
                s_n = sigmoid(beta1,alpha,sx_test(:,choose1)')';
                s_n1(:,i) = s_n*k1;
                s_1 = [s_1,s_n1(:,i)];
            elseif i == 2
                s_n1(:,i) = quadratic(a1,sx_test(:,choose1));
                s_1 = [s_1,s_n1(:,i)];
            elseif i == 3
                s_n1(:,i) = ones(q,1)*trigonometric(b1,t);
                s_1 = [s_1,s_n1(:,i)];
            end
%         else
%             s_n1(:,i) = zeros(q,1);
%         end
    end
%     I1 = find(H(1,:)==0);
    s_next1 = s_1*w1;
%     w1 = (1./(1+MSE(1,I1)))./sum(1./(1+MSE(1,I1)));
%     s_next1 = s_1*w1';
%     if MSE(1,index1)>1000
% %         s_next1 = sx_test(:,choose1)+rand;
%         s_next1 = ones(q,1)*s(t,1) + rand(q,2);
%     else
%         if index1 == 1
%             s_next1 = sigmoid(beta1,alpha,sx_test(:,choose1)')';
%             s_next1 = s_next1*k1;
%         elseif index1 == 2
%             s_next1 = quadratic(a1,sx_test(:,choose1));
%         else
%             s_next1 = ones(q,1)*trigonometric(b1,t);
%         end
%     end
    
    % Ô¤²âs_next2
    %     beta2 = lsqcurvefit(@(beta,x) sigmoid(beta,alpha,x),ones(1,1),sx2_train',s2_train');
    %     s2_p1 = sigmoid(beta2,alpha,sx2_train')';
    %     MSE(2,1) = mean((s2_train-s2_p1).^2);
    %
    %     b2 = regress(s2_train,[ones(t-1,1),sx2_train]);
    %     s2_p2 = [ones(p,1),sx2_train]*b1;
    %     MSE(2,2) = mean((s2_train-s2_p2).^2);
    %
    %     a2 = lsqcurvefit(@(a,x) quadratic(a,x),[1 1 1],sx2_train',s2_train');
    %     s2_p3 = quadratic(a2, sx2_train')';
    %     MSE(2,3) = mean((s2_train-s2_p3).^2);
    
%     [~,index2] = min(MSE(2,:));
    s_2 = [];
    for i = I2
%         [pvalue(2,i),H(2,i)] = ranksum(Error(2,:,index2),Error(2,:,i),0.05);
%         if H(2,i) == 0
            if i == 1
                s_p = sigmoid(beta2,alpha,sx_test(:,choose2)')';
                s_n2(:,i) = s_p*k2;
                s_2 = [s_2,s_n2(:,i)];
            elseif i == 2
                s_n2(:,i) = quadratic(a2,sx_test(:,choose2));
                s_2 = [s_2,s_n2(:,i)];
            elseif i == 3
                s_n2(:,i) = ones(q,1)*trigonometric(b2,t);
                s_2 = [s_2,s_n2(:,i)];
            end
%         else
%             s_n2(:,i) = zeros(q,1);
%         end
        
    end
%      I2 = find(H(2,:)==0);
%     w2 = exp(MSE(2,I2))./sum(exp(MSE(2,I2)));
%     w2 = (1./(1+MSE(2,I2)))./sum(1./(1+MSE(2,I2)));
    s_next2 = s_2*w2;
    
%     if MSE(2,index2)>1000
% %         s_next2 = sx_test(:,choose2)+rand;
%         s_next2 = ones(q,1)*s(t,2) + rand(q,2);
%     else
%         if index2 == 1 
%             s_next2 = sigmoid(beta2,alpha,sx_test(:,choose2)')';
%             s_next2 = s_next2*k2;
%         elseif index2 == 2
%             s_next2 = quadratic(a2,sx_test(:,choose2));
%         else
%             s_next2 = ones(q,1)*trigonometric(b2,t);
%         end
%     end
    s_next = [s_next1,s_next2];
end
% q = size(sx_test,1);
% s_next1 = sigmoid(beta,alpha,sx_test(:,choose1)');
% s_next2 = [ones(q,1),sx_test(:,choose2)]*b2;
% s_next = [s_next1',s_next2];
% n = size(choose,1); 
% for i = 1:n
%     if choose(i)>n
%         chosen = choose(i) - n;
%     end
% end
% % »­Í¼
% [~,index] = sort(sx_test(:,3));
% figure(100);
% plot(sx_test(index,3),s_next1(index),'.');
% xlabel('x(1)'); % ¸øxÖáÌù±êÇ©
% ylabel('b'); % ¸øyÖáÌù±êÇ©
end