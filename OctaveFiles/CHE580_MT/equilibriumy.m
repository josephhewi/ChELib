function [y] = equilibriumy(x,alpha)
  y = (x.*alpha)./(1+x.*(alpha-1));
endfunction
