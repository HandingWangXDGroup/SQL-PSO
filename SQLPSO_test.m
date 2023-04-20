clear;clc;
problemname = {'MPB';'DRPBG'};
b = [10;50;100];
m = [1;10;50];
type = {'Static','SmallStep','LargeStep','Random','Chaotic','Recurrent','Noisy'};
typeS = [1 1 1];
NameNum = size(problemname,1);
bNum = size(b,1);
N = [1 2 10 30];
bu = 5;
bd = -5;
t_max = 100;
fevnmax = 10000;
point = 1;
e = 0.3;
n = 10;
result = cell(2,7);
for i = 1:2
    for j = 1:7
        typeS = [j j j];
        [result{i,j}.x,result{i,j}.fitness,result{i,j}.Reward,~,~,~] = SQLPSO(problemname{i},b(2),m(2),type,typeS,n,bu,bd,t_max,fevnmax,e);
    end
end
    