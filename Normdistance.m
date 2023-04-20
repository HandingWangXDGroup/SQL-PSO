function d = Normdistance(x,y,scale)
n = size(x,2);
d = sum(abs(x - y)./scale,2)./n;
end