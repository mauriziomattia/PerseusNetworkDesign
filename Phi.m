function NuOut = Phi(NuIn, Net)
%
% NuOut = Phi(NuIn, Net)
%
% Current-to-rate gain function of a generic integrate-and-fire neuron.
%
%   Version: 1.0 - Jun. 28, 2006
%   Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it
%

if size(NuIn,1) == 1
   NuIn = NuIn';
end

lMu = Mu(NuIn, Net);
lSigma2 = Sigma2(NuIn, Net);

for i = 1:Net.P
   NuOut(i,1) = feval(Net.SNParam.Phi{i}, lMu(i), lSigma2(i), Net.SNParam.Beta(i), Net.SNParam.H(i), Net.SNParam.Theta(i), Net.SNParam.Tarp(i));
end
