function out = PhiLin(mu, sigma2, beta, h, theta, tarp)
%
% out = PhiLin(mu, sigma2, beta, h, theta, tarp)
%
% Current-to-rate gain function for VLSI integrate-and-fire neuron as introduced in
% (Fusi & Mattia, Neural Comput 1999).
%
%   Version: 1.0 - Jun. 23, 2006
%   Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it
%
   mu = mu - beta;
   csi = mu./sigma2;
   out = 1./(1./(2*csi.*mu).*(exp(-2*theta.*csi)-exp(-2*h.*csi)) + (theta-h)./mu + tarp);

