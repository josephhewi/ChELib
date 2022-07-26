clf; clear; clc;
t = 0:0.01:7; % time interval is 1 second
Co = [2 0.25 0 0 1000]; % initial concentrations
[t C] = ode45(@main, t, Co);
plot(t,C);