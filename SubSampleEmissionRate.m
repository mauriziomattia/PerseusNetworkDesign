function [tSS, NuSS] = SubSampleEmissionRate(t, Nu, Samples)
%
%  [tSS, NuSS] = SubSampleEmissionRate(t, Nu, Samples)
%
%   Version: 1.0 - Apr. 18, 2008
%   Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it
%
 
cols = floor(length(t)/Samples);
tSS = mean(reshape(t(1:(Samples*cols)), Samples, cols))';

for n = 1:size(Nu,2)
   NuSS(:,n) = mean(reshape(Nu(1:(Samples*cols),n), Samples, cols))';
end