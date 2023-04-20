function [ ft1 ] = DynamicChanges( ft,type,a,amax,sev,frg,fmin,A,P,fai,t,Nsev)
m=size(ft,2);
r=2*rand(1,m)-1;
switch type
    case 'Static'
        ft1=ft;
    case 'SmallStep'
        derta=a*sev*r*frg;
        ft1=ft+derta;
    case 'LargeStep'
        derta=sev*(a*sign(r)+(amax-a)*r)*frg;
        ft1=ft+derta;
    case 'Random'
        derta=sev*randn(1,m);
        ft1=ft+derta;
    case 'Chaotic'
        ft1=A*(ft-fmin).*(1-((ft-fmin)/frg));
    case 'Recurrent'
        ft1=fmin*ones(1,m)+0.5*frg*(sin(2*pi*t/P+fai)+1);
    case 'Noisy'
        ft1=fmin*ones(1,m)+0.5*frg*(sin(2*pi*t/P+fai)+1)+Nsev*randn(1,m);
end
I=find(ft1>fmin+frg|ft1<fmin);
ft1(I)=ft1(I)-floor((ft1(I)-fmin)/frg)*frg;
end

