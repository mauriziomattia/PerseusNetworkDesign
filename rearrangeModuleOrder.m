function Net = rearrangeModuleOrder(Net,ndxRearrange)
%
%  Net = rearrangeModuleOrder(Net,ndxRearrange)
%
%   Version: 1.1 - May 24, 2016
%   Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it
%

[~,ndxOldToNew] = sort(ndxRearrange);


%% SETs constants of interest...
%
NT_VIF = 0;
NT_LIF_LUT = 1;
NT_LIF = 2;
NT_LIFCA = 3;

%% REORDERS whole module param. fields...
%
Net.ndxE = ndxOldToNew(Net.ndxE);
Net.ndxI = ndxOldToNew(Net.ndxI);
Net.ndxEFg = ndxOldToNew(Net.ndxEFg);
Net.ndxEBg = ndxOldToNew(Net.ndxEBg);

%% REORDERS single neuron param. fields...
%
Net.SNParam.N = Net.SNParam.N(ndxRearrange);
Net.SNParam.Beta = Net.SNParam.Beta(ndxRearrange);
Net.SNParam.Theta = Net.SNParam.Theta(ndxRearrange);
Net.SNParam.H = Net.SNParam.H(ndxRearrange);
Net.SNParam.Tarp = Net.SNParam.Tarp(ndxRearrange);
Net.SNParam.NExt = Net.SNParam.NExt(ndxRearrange);
Net.SNParam.NuExt = Net.SNParam.NuExt(ndxRearrange);
Net.SNParam.JExt = Net.SNParam.JExt(ndxRearrange);
Net.SNParam.DeltaExt = Net.SNParam.DeltaExt(ndxRearrange);
% Net.SNParam.Type = Net.SNParam.Type(ndxRearrange);
if Net.SNParam.Type == NT_LIFCA
   Net.SNParam.AlphaC = Net.SNParam.AlphaC(ndxRearrange);
   Net.SNParam.TauC = Net.SNParam.TauC(ndxRearrange);
   Net.SNParam.GC = Net.SNParam.GC(ndxRearrange);
end
for k = 1:Net.P
   Phi{k} = Net.SNParam.Phi{ndxRearrange(k)};
end
for k = 1:Net.P
   Net.SNParam.Phi{k} = Phi{k};
end
Net.SNParam.DMin = Net.SNParam.DMin(ndxRearrange);
Net.SNParam.TauD = Net.SNParam.TauD(ndxRearrange);
Net.SNParam.IsExc = Net.SNParam.IsExc(ndxRearrange);
Net.SNParam.Nu = Net.SNParam.Nu(ndxRearrange);

%% CONCATS connectivity param. fields...
%
Net.CParam.c = Net.CParam.c(ndxRearrange,ndxRearrange);
Net.CParam.J = Net.CParam.J(ndxRearrange,ndxRearrange);
Net.CParam.Delta = Net.CParam.Delta(ndxRearrange,ndxRearrange);
Net.CParam.DMin = Net.CParam.DMin(ndxRearrange,ndxRearrange);
Net.CParam.DMax = Net.CParam.DMax(ndxRearrange,ndxRearrange);
