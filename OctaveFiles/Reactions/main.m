function [t dCdt] = main(t, Y0)
  % retrieve concnetration data at time t and state other constants
  Ca = Y0(1); Cb = Y0(2); Cc = Y0(3); Cd = Y0(4); V = Y0(5);
  Cbo = 0.5; % mol/L
  k1 = 0.5; % L/mol-h
  k2 = 0.25; % L/mol-h
  v = 1000; % L/h  - fill rate, 100% B @ 0.5 mol/L
  dV = v;

  % rate data
  ra = k1*Ca*Cb;
  rd = k2*Cb^2;
  
  % rate of change of each component concentration
  dCa = - ra - Ca*v/V;
  dCb = - ra - rd + v*(Cbo-Cb)/V;
  dCc = ra - Cc*v/V;
  dCd = rd - Cd*v/V;
  
  % return derivative
  dCdt = [dCa dCb dCc dCd dV];
endfunction
