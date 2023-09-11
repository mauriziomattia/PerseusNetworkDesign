function NetOut = connectModules(Net1, Net2, InterModuleConnectivity)
%
%  NetOut = connectModules(Net1, Net2, InterModuleConnectivity)
%
%   Copyright 2013-2019 Maurizio Mattia 
%   Version: 1.1 - Oct. 9, 2019
%

NT_VIF = 0;
NT_LIF_LUT = 1;
NT_LIF = 2;
NT_LIFCA = 3;

NetOut.P = Net1.P + Net2.P;
NetOut.ndxE = [Net1.ndxE' Net2.ndxE'+Net1.P]';
NetOut.ndxI = [Net1.ndxI' Net2.ndxI'+Net1.P]';
NetOut.ndxEFg = [Net1.ndxEFg' Net2.ndxEFg'+Net1.P]';
NetOut.ndxEBg = [Net1.ndxEBg' Net2.ndxEBg'+Net1.P]';

%
% Single neuron param. fields...
%
NetOut.SNParam.N = [Net1.SNParam.N' Net2.SNParam.N']';
NetOut.SNParam.Beta = [Net1.SNParam.Beta' Net2.SNParam.Beta']';
NetOut.SNParam.Theta = [Net1.SNParam.Theta' Net2.SNParam.Theta']';
NetOut.SNParam.H = [Net1.SNParam.H' Net2.SNParam.H']';
NetOut.SNParam.Tarp = [Net1.SNParam.Tarp' Net2.SNParam.Tarp']';
NetOut.SNParam.NExt = [Net1.SNParam.NExt' Net2.SNParam.NExt']';
NetOut.SNParam.NuExt = [Net1.SNParam.NuExt' Net2.SNParam.NuExt']';
NetOut.SNParam.JExt = [Net1.SNParam.JExt' Net2.SNParam.JExt']';
NetOut.SNParam.DeltaExt = [Net1.SNParam.DeltaExt' Net2.SNParam.DeltaExt']';
Net.SNParam.IExt = [Net1.SNParam.IExt' Net2.SNParam.IExt']';
Net.SNParam.DIExt = [Net1.SNParam.DIExt' Net2.SNParam.DIExt']';
% NetOut.SNParam.Type = [Net1.SNParam.Type' Net2.SNParam.Type']';
if Net1.SNParam.Type == Net2.SNParam.Type
   NetOut.SNParam.Type = Net1.SNParam.Type;
else
   error('Neuron type of network to combine are different.')
end
if NetOut.SNParam.Type == Net.Constants.NT_LIFCA || NetOut.SNParam.Type == Net.Constants.NT_VIFCA
   NetOut.SNParam.AlphaC = [Net1.SNParam.AlphaC; Net2.SNParam.AlphaC];
   NetOut.SNParam.TauC = [Net1.SNParam.TauC; Net2.SNParam.TauC];
   NetOut.SNParam.GC = [Net1.SNParam.GC; Net2.SNParam.GC];
end
   
k = 0;
for n = 1:Net1.P
   k = k + 1;
   NetOut.SNParam.Phi{k} = Net1.SNParam.Phi{n};
end
for n = 1:Net2.P
   k = k + 1;
   NetOut.SNParam.Phi{k} = Net2.SNParam.Phi{n};
end

NetOut.SNParam.DMin = [Net1.SNParam.DMin' Net2.SNParam.DMin']';
NetOut.SNParam.TauD = [Net1.SNParam.TauD' Net2.SNParam.TauD']';
NetOut.SNParam.IsExc = [Net1.SNParam.IsExc' Net2.SNParam.IsExc']';
NetOut.SNParam.Nu = [Net1.SNParam.Nu' Net2.SNParam.Nu']';


%
% Connectivity param. fields...
%
NetOut.CParam.c(1:Net1.P,1:Net1.P) = Net1.CParam.c;
NetOut.CParam.c((1:Net2.P)+Net1.P,(1:Net2.P)+Net1.P) = Net2.CParam.c;
NetOut.CParam.c(1:Net1.P,Net2.ndxE+Net1.P) = InterModuleConnectivity;
NetOut.CParam.c((1:Net2.P)+Net1.P,Net1.ndxE) = InterModuleConnectivity;

NetOut.CParam.J(1:Net1.P,1:Net1.P) = Net1.CParam.J;
NetOut.CParam.J((1:Net2.P)+Net1.P,(1:Net2.P)+Net1.P) = Net2.CParam.J;
NetOut.CParam.Delta(1:Net1.P,1:Net1.P) = Net1.CParam.Delta;
NetOut.CParam.Delta((1:Net2.P)+Net1.P,(1:Net2.P)+Net1.P) = Net2.CParam.Delta;
NetOut.CParam.DMin(1:Net1.P,1:Net1.P) = Net1.CParam.DMin;
NetOut.CParam.DMin((1:Net2.P)+Net1.P,(1:Net2.P)+Net1.P) = Net2.CParam.DMin;
NetOut.CParam.DMax(1:Net1.P,1:Net1.P) = Net1.CParam.DMax;
NetOut.CParam.DMax((1:Net2.P)+Net1.P,(1:Net2.P)+Net1.P) = Net2.CParam.DMax;
for n = 1:Net1.P
   NetOut.CParam.J(n,Net2.ndxE+Net1.P) = Net1.SNParam.JExt(n);
   NetOut.CParam.Delta(n,Net2.ndxE+Net1.P) = Net1.SNParam.DeltaExt(n);
   NetOut.CParam.DMin(n,Net2.ndxE+Net1.P) = Net1.SNParam.DMin(n);
   NetOut.CParam.DMax(n,Net2.ndxE+Net1.P) = mean(mean(Net2.CParam.DMax(Net2.ndxEBg,Net2.ndxEBg)));
   NetOut.SNParam.NExt(n) = NetOut.SNParam.NExt(n) - sum(Net2.SNParam.N(Net2.ndxE)*InterModuleConnectivity);
   if NetOut.SNParam.NExt(n) <= 0
      disp('[connectModules] Error: Not enough external neurons');
      return;
   end
end
for n = 1:Net2.P
   NetOut.CParam.J(n+Net1.P,Net1.ndxE) = Net2.SNParam.JExt(n);
   NetOut.CParam.Delta(n+Net1.P,Net1.ndxE) = Net2.SNParam.DeltaExt(n);
   NetOut.CParam.DMin(n+Net1.P,Net1.ndxE) = Net2.SNParam.DMin(n);
   NetOut.CParam.DMax(n+Net1.P,Net1.ndxE) = mean(mean(Net1.CParam.DMax(Net1.ndxEBg,Net1.ndxEBg)));
   NetOut.SNParam.NExt(n+Net1.P) = NetOut.SNParam.NExt(n+Net1.P) - sum(Net1.SNParam.N(Net1.ndxE)*InterModuleConnectivity);
   if NetOut.SNParam.NExt(n+Net1.P) <= 0
      disp('[connectModules] Error: Not enough external neurons');
      return;
   end
end
