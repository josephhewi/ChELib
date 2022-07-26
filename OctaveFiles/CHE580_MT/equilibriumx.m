function [x] = equilibriumx(y,alpha)
  x = y./(y+alpha*(1-y));
endfunction
