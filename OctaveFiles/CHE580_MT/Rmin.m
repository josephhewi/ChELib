function R = Rmin(xd,xq,yq)
  m = (xd-yq)/(xd-xq);
  R = -m/(m-1);
endfunction
