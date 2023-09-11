function Sigma2Out = Sigma2(NuIn, Net)
%
%   Sigma2Out = Sigma2(NuIn, Net)
%
%   Infinitesimal variance of the input current under mean-field and diffusion 
%   approximation.
%
%   Version: 1.1 - May 17, 2013
%   Version: 1.0 - Jun. 23, 2010
%   Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it
%

% Verifies input params 
Sigma2Out = [];
if size(NuIn,1) ~= Net.P
   disp('Error [Sigma2]: NuIn rows different from Net.P');
   return
end

% Works out Sigma2...
CJ2 = Net.CParam.c .* (Net.CParam.J.^2) .* (1 + Net.CParam.Delta.^2);

Sigma2Out = CJ2 * (Net.SNParam.N.*NuIn) + Net.SNParam.NExt .* (Net.SNParam.JExt.^2) .* (1 + Net.SNParam.DeltaExt.^2) .* Net.SNParam.NuExt;
