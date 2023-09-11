function Net = changeNetworkSize(Net, ScalingFactor)
%
%  Net = changeNetworkSize(Net, ScalingFactor)
%
% Version 1.0, 18 Oct. 2008
% Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it

Net.SNParam.N = Net.SNParam.N * ScalingFactor;
Net.CParam.c = Net.CParam.c / ScalingFactor;