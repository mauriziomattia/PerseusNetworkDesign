function makePhiExpLUT(OutFileName)
%
%  makePhiExpLUT([OutFileName])
%
%   Compute and save the look-up-table (LUT) to speed-up the evaluation of the 
%   current-to-rate gain function (Phi) of the leaky integrate-and-fire (LIF) 
%   neuron.
%
%   Version: 1.0 - Jul. 27, 2006
%   Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it
%

XMin = -5.0;
XMax = 5.0;
XBins = 20;
YMin = -10.0;
YMax = 20.0;
YBins = 40;

clear Z;
[X,Y] = meshgrid(linspace(XMin, XMax, XBins), linspace(YMin, YMax, YBins));
tic;
for n = 1:size(X,1)
    for m = 1:size(X,2)
        Z(n,m) = quad(@auxPhiExp, X(n,m) - exp(Y(n,m)), X(n,m));
    end
end
toc;

PhiExpLUT.cshigh = csapi({X(1,:),Y(:,1)'},log(Z)');

MaxExp = 9;
ExpBin = 0.5;

clear Z;
[X,Y] = meshgrid(fliplr(XMin-(2.^(0:ExpBin:MaxExp)-1)), ...
                 linspace(YMin, YMax, YBins));
for n = 1:size(X,1)
    for m = 1:size(X,2)
        Z(n,m) = quad(@auxPhiExp, X(n,m) - exp(Y(n,m)), X(n,m));
    end
end

PhiExpLUT.cslow = csapi({X(1,:),Y(:,1)'},log(Z)');

PhiExpLUT.bMax = XMax;
PhiExpLUT.bLowHigh = XMin;
PhiExpLUT.bMin = XMin-(2^MaxExp-1);
PhiExpLUT.logbaMax = YMax;
PhiExpLUT.logbaMin = YMin;

if exist('OutFileName')
   save(OutFileName, 'PhiExpLUT');
else
   save('PhiExpLUT.mat', 'PhiExpLUT');
end