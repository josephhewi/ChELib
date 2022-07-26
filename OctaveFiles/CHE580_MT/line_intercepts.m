function [error] = line_intercepts(m1,b1,m2,b2,x)
  y1 = m1*x+b1;
  y2 = m2*x+b2;
  error = y1-y2;
endfunction
