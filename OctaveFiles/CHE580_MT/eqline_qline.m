function error = eqline_qline(x,zf,q,a)
  qline = q.*x./(q-1)+zf./(1-q);
  rline = x.*a./(1+x.*(a-1));
  error = qline-rline ;
endfunction

