Tr = 1
Pr = 1
g = 0
C = 0


function [g,C] = RK_water(Tr,Pr)
  A = 0.42747 * Pr / (Tr ^ (5 / 2));
  B  = 0.08664 * Pr / Tr;  
  r = A*B;
  q = B^2+B-A
  
  f = (-3 * q - 1) / 3
  g = (-27 * r - 9 * q - 2) / 27
  C = (f / 3) ^ 3 + (g / 2) ^ 2
endfunction





g,C = RK_water(Tr,Pr)
if (C>=0)
  D = (-g / 2 + Sqr(C)) ^ (1 / 3)
  E = _E_(g,C)
  z = D+E+1/3
else
  pringf(1)
endif


function [E] = _E_(g,C)
  x = -g/2 + sqrt(C);
  E = sin(x)+abs(x)^(1/3);
endfunction

function [z] = root1(g,C)
    
endfunction
