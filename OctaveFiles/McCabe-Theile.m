
function[ N_stages x] = McCabe_Theile(input)
% This code was originally written in Octave (MatLab clone), then modified to 
% be optimized for use in MatLab.
%
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

% =============================================
% Known information
% =============================================
% Feed information and process specs
% feed 1 is closest to the reboiler
zf1 = input(1);
zf2 = input(2);
q1 = input(3);
q2 = input(4);
xd = input(5);
xb = input(6);
reflux_ratio = input(7);; %Rop/Rmin
boilup_ratio = input(8);; %Vbop/Vbmin
MakePlot = input(9);

% The MakePlot option allows the user to specify whether a graph is desired.  If
% MakePlot = 1, a series of if statements provide controls to generate the stage
% counting graph.
if MakePlot == 1
  hold on;
end

% Physical Properties - this section can be modified to define alpha as a
% function handle to calculate relative volatility as a function of
% compositions. This would be useful for non-ideal systems, but would require
% additional regressed or predicted data to provide binary interaction
% parameters.
alpha = 2.85;

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
end

if q2 == 1
  x2qmin = zf2;
else
  fun = @(x) eqline_qline(x,zf2,q2,alpha);
  x2qmin = fzero(fun,0.5);
end
% Generates the Y-value corresponding to the q-line intersection with the
% equilibrium line.
y1qmin = equilibriumy(x1qmin,alpha);
y2qmin = equilibriumy(x2qmin,alpha);

% =============================================
% Operating Lines
% =============================================
% Define R_op and V_Bop by calling functions that define Rmin and Vbmin.  These
% calculations are based on the equations provided in Chapter 7 of Separation 
% Process Principles 3rd ED by Seader et al. This section was written in order
% to keep this code versitile in that I have not applied the constraint that the 
% boilup and reflux ratios are the same.  That constraint is specific to our
% system, so it would be unwise to apply it universally.
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
mR = Rop/(1+Rop); % slope of the rectifying section operating line
bR = xd/(Rop+1); % intercept of the rectifying section operating line
% The X and Y values for the end of the q-line are defined next.  This code uses
% the same logic as previous calculations with the q-lines in order to prevent
% using an undefined slope.
if q1 == 1
  x1 = zf1;
  y1 = mR*x1+bR;
else
  m2 = q1/(q1-1);
  b2 = zf1/(1-q1);
  fun = @(x) line_intercepts(mR,bR,m2,b2,x);
  x1 = fzero(fun,0.5);
  y1 = mR*x1+bR;
end

% Stripping Section (mS and bS)
mS = (Vbop+1)/Vbop; % slope of the stripping section operating line
bS = -xb/Vbop; % intercept of the stripping section operating line
if q2 == 1
  x2 = zf2;
  y2 = mS*x2+bS;
else
  m2 = q2/(q2-1);
  b2 = zf2/(1-q2);
  fun = @(x) line_intercepts(mS,bS,m2,b2,x);
  x2 = fzero(fun,0.5);
  y2 = mS*x2+bS;
end

% Define operating region between the q-lines (mI and bI).  The I on these
% variables is an abbreviation for Interfeed region.
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
  y = mR*x+bR; %calculate y value corresponding to x on the operating line
  stage_x = [stage_x x]; % append coordiante to arrray
  stage_y = [stage_y y]; % append coordiante to arrray
  x = equilibriumx(y,alpha); % find x for the y on the equilibrium line
  stage_x = [stage_x x]; % append coordiante to arrray
  stage_y = [stage_y y]; % append coordiante to arrray
  N_stages = N_stages + 1; % add to stage count 
  if MakePlot == 1 % if the user desires a graph, add stage text
    text(x,y,sprintf('%d',N_stages),'HorizontalAlignment','right');
  end
end
% Region 2
while x > x2
  y = mI*x+bI; %calculate y value corresponding to x on the operating line
  stage_x = [stage_x x]; % append coordiante to arrray
  stage_y = [stage_y y]; % append coordiante to arrray
  x = equilibriumx(y,alpha); % find x for the y on the equilibrium line
  stage_x = [stage_x x]; % append coordiante to arrray
  stage_y = [stage_y y]; % append coordiante to arrray
  N_stages = N_stages + 1;% add to stage count 
  if MakePlot == 1 % if the user desires a graph, add stage text
    text(x,y,sprintf('%d',N_stages),'HorizontalAlignment','right');
  end
end
% Region 3
while x > xb
  y = mS*x+bS; %calculate y value corresponding to x on the operating line
  stage_x = [stage_x x]; % append coordiante to arrray
  stage_y = [stage_y y]; % append coordiante to arrray
  x = equilibriumx(y,alpha); % find x for the y on the equilibrium line
  stage_x = [stage_x x]; % append coordiante to arrray
  stage_y = [stage_y y]; % append coordiante to arrray
  N_stages = N_stages + 1; % add to stage count 
  if MakePlot == 1 % if the user desires a graph, add stage text
    text(x,y,sprintf('%d',N_stages),'HorizontalAlignment','right');
  end

% =============================================
% Graph Generation
% =============================================
if MakePlot == 1
  hold on
    X = linspace(0,1); % array from 0 to 1 in 50 equal steps
    Y = equilibriumy(X,alpha); % array of ys from 0 to 1
    plot([zf1 zf1],[0 zf1],'-.k') % feed line 1
    plot([zf2 zf2],[0 zf2],':k') % feed line 2
    plot([zf1 x1qmin],[zf1 y1qmin],'-.k') % q line 1
    plot([zf2 x2qmin],[zf2 y2qmin],':k') % q line 2
    plot([0 1],[0 1],'k') % 45-degree line
    plot(X,Y,'r') % equilibrium curve
    plot([xb,x2,x1,xd],[xb,y2,y1,xd],'b') % all operating lines
    plot(stage_x,stage_y,'g') % all stages
    xlabel("X") % x label 
    ylabel("Y") % y label
  hold off
end

end % end function

























