Tr = 1
Pr = 2
function [z] = RK(Tr,Pr)
  A2 = 0.42747*(Pr/(Tr^(5/2)));
  B = 0.08664*(Pr/Tr);
  r = A2*B
  q = B*B+B-A2
  f = (-3*q-1)/3
  g = (-27*r-9*q-2)/27
  C = (f/3)^3+(g/2)^2
  if (C>=0)
    D = (-g/2+sqrt(C))^(1/3)
    if (sqrt(C)>g/2)
      E=0
    else
      E = (-g/2-sqrt(C))^(1/3)
    endif
    z = D+E+1/3
  else
    phi = Acos(Sqr(((g ^ 2) / 4) / (-(f ^ 3) / 27)))
    RK_EOS_WATER = 2 * Sqr(-f / 3) * Cos(phi / 3 + (2 * pi) / 3) + 1 / 3
  endif
endfunction