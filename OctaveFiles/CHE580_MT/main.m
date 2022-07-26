function [N_stages x] = main(zf1,zf2,q1,q2,xd,xb,reflux_ratio,boilup_ratio,MakePlot)
%clear; clc; clf;
% This section defines the operating conditions of the distillation column.  
% First, it calculates Rmin by quantifying the graphical techniques in McCabe-
% Theile.  The operating reflux ratio is then defined.  The operating boilup
% ratio is then defined through the intersection of the operating line and the
% q-line.  McCabe-Theile is then automated by starting at the distillate 
% composition, solving for the equilibrium line x-value for the given y, then
% solving for the rectifying line y-value for this new x.  This is repeated
% until the x-value drops below the x-value of the intersection of the q and 
% operating lines.  We then switch to using the stripping section operating line
% instead of the enrichment section line.

% Plot Requiest
% to generate a plot, MakePlot must equal 1
if MakePlot == 1
  hold on;
endif
% =============================================
% Known information
% =============================================
% Feed information and process specs
% feed 1 is closest to the reboiler
%zf1 = 0.75;
%zf2 = 0.25;
%q1 = -0;
%q2 = -0.1;
%xd = 0.925;
%xb = 0.075;
%reflux_ratio = 1.7; %Rop/Rmin
%boilup_ratio = 1.7; %Vbop/Vbmin

% Physical Properties
alpha = 2.85;

% Flow Data - none specified

% =============================================
% q-line intersection points for minimum reflux.
% =============================================
% This section is set up so that either feed stream can have an undefined q-line
% slope and still work.  I did this in order to use the program for other
% models at later times.
% from Workshop 2, I use the fzero function to determine the intersection point
% of the q-line and the equilibrium line.  The fun is defined by fixing the zf
% and q in the opline_qline function, and is associated using the function 
% handle (@).  syntax is fun = @(variables) f(varaiables,fixed_variables).  An 
% initial guess of 0.5 should work for all uses of fzero, as x is bound by 0 and
% 1.
if q1 == 1 % slope is undefined under this condition
  x1qmin = zf1;
else % the intersection point can be explicitly solved for using alegbra and the
  % quadratic equation, but the fzero function works as well.
  fun = @(x) eqline_qline(x,zf1,q1,alpha);
  x1qmin = fzero(fun,0.5);
endif

if q2 == 1
  x2qmin = zf2;
else
  fun = @(x) eqline_qline(x,zf2,q2,alpha);
  x2qmin = fzero(fun,0.5);
endif

y1qmin = equilibriumy(x1qmin,alpha);
y2qmin = equilibriumy(x2qmin,alpha);

% =============================================
% Operating Lines
% =============================================
% Define R_op and V_Bop
R =  Rmin(xd,x1qmin,y1qmin);
Vb = Vbmin(xb,x2qmin,y2qmin);
Rop = R*reflux_ratio;
Vbop = Vb*boilup_ratio;

% Determine the boundaries of the 3 operating regions
% xd = beginning of region 1
% x1 = end of region 1, beginning of region 2
% x2 = end of region 2, beginning of region 3
% xb = end of region 3
% Rectifying Section (mR and bR)
mR = Rop/(1+Rop);
bR = xd/(Rop+1);
if q1 == 1
  x1 = zf1;
  y1 = mR*x1+bR;
else
  m2 = q1/(q1-1);
  b2 = zf1/(1-q1);
  fun = @(x) line_intercepts(mR,bR,m2,b2,x);
  x1 = fzero(fun,0.5);
  y1 = mR*x1+bR;
endif

% Stripping Section (mS and bS)
mS = (Vbop+1)/Vbop;
bS = -xb/Vbop;
if q2 == 1
  x2 = zf2;
  y2 = mS*x2+bS;
else
  m2 = q2/(q2-1);
  b2 = zf2/(1-q2);
  fun = @(x) line_intercepts(mS,bS,m2,b2,x);
  x2 = fzero(fun,0.5);
  y2 = mS*x2+bS;
endif

% Define operating region between the q-lines (mI and bI)
mI = (y2-y1)/(x2-x1);
bI = y1-mI*x1;

% =============================================
% Stage Counting
% =============================================
% Each loop begins by assuming that we need to define the line segment from the
% equilibrium curve to the operating line.  This step does not add any stages.
% Stages are only counted when the end on the equilibrium curve.
% Begin at top of column
x = xd;
y = xd;
stage_x = [];
stage_y=[];
N_stages = 0;
% Region 1
while x > x1 
  y = mR*x+bR;
  stage_x = [stage_x x];
  stage_y = [stage_y y];
  x = equilibriumx(y,alpha);
  stage_x = [stage_x x]; % append coordiante to arrray
  stage_y = [stage_y y];
  N_stages = N_stages + 1;
  if MakePlot == 1
    text(x,y,sprintf('%d',N_stages),'HorizontalAlignment','right');
  endif
endwhile
% Region 2
while x > x2
  y = mI*x+bI;
  stage_x = [stage_x x];
  stage_y = [stage_y y];
  x = equilibriumx(y,alpha);
  stage_x = [stage_x x];
  stage_y = [stage_y y];
  N_stages = N_stages + 1;
  if MakePlot == 1
    text(x,y,sprintf('%d',N_stages),'HorizontalAlignment','right');
  endif
endwhile
% Region 3
while x > xb
  y = mS*x+bS;
  stage_x = [stage_x x];
  stage_y = [stage_y y];
  x = equilibriumx(y,alpha);
  stage_x = [stage_x x];
  stage_y = [stage_y y];
  N_stages = N_stages + 1;
  if MakePlot == 1
    text(x,y,sprintf('%d',N_stages),'HorizontalAlignment','right');
  endif
endwhile
if MakePlot == 1
  hold off;
endif
% Stage counting is complete, now we generate the graph (if desired)
if MakePlot == 1
  hold on
    X = linspace(0,1);
    Y = equilibriumy(X,alpha);
    plot([zf1 zf1],[0 zf1],'-.k')
    plot([zf2 zf2],[0 zf2],':k')
    plot([zf1 x1qmin],[zf1 y1qmin],'-.k')
    plot([zf2 x2qmin],[zf2 y2qmin],':k')
    plot([0 1],[0 1],'k')
    plot(X,Y,'r')
    plot([xb,x2,x1,xd],[xb,y2,y1,xd],'b')
    plot(stage_x,stage_y,'g')
  hold off
endif






















