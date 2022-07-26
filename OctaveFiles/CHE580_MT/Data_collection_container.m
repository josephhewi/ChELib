clear; clc; clf;
steps = 50;
MakePlot  =  0;
q = [-0.1:0.1:1.1];
ratios = zeros(10,10);
r = [1.1:(2-1.1)/(steps-1):2]
data = [];

zf1 = 0.75;
zf2 = 0.25;
q1 = 1;
q2 = 0;
xd = 0.925;
xb = 0.075;
reflux_ratio = 1.7; %Rop/Rmin
boilup_ratio = 1.7; %Vbop/Vbmin

stages = zeros(steps,steps);
xs = zeros(steps,steps);
variables = zeros(steps,steps);
for i = [1:steps]
  reflux_ratio = r(i);
  for j = [1:steps]
    boilup_ratio = r(j);
    [a b] = main(zf1,zf2,q1,q2,xd,xb,reflux_ratio,boilup_ratio,MakePlot);
    stages(j,i) = a;
    xs(j,i) = b; 
  endfor
endfor
xs = (xs-0.075)^2;

[X,Y] = meshgrid(r,r)
surf(X,Y,xs)