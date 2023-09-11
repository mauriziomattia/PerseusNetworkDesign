function [t, Nu] = MeanFieldNetDynamics(Nu0, t0, tMax, Dt, Net, DNuExt)
%
%  [t, Nu] = MeanFieldNetDynamics(Nu0, t0, tMax, Dt, Net[, DNuExt])
%
% Version 1.1, 12 Dec. 2017
% Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it

ONLINE_PLOT = 0;
PRINT_ELAPSED_TIME = 10; % Seconds between two consecutive prints of the
                         % numerical integration state.

%% Set time samples to be numerically integrated.
%
t = t0:Dt:tMax;

%% Parameter processing.
%
if size(Nu0,1)==1
   Nu0 = Nu0';
end
if exist('DNuExt','var') == 0
   DNuExt.Freq = zeros(Net.P, numel(t));
end

%% Set initial condition and memory structures.
%
Nu = zeros(Net.P, floor((tMax-t0)/Dt)+1);
NuN = zeros(Net.P, floor((tMax-t0)/Dt)+1);
Nu(:,1) = Nu0;
NuN(:,1) = Phi(Nu(:,1), Net);

OriginalNuExt = Net.SNParam.NuExt;
NuExt = repmat(Net.SNParam.NuExt, 1, numel(t)) + DNuExt.Freq;

%% Open a new grafic window to plot the advancement of the numerical integration.
%
if ONLINE_PLOT
   %
   % Color plot initialization.
   %
   clrbase = 'rbmcygkk';
   clrndx = (mean(Net.CParam.J,1)<0)+1;
   inhndx = find(clrndx==2);
   for j = 1:(length(inhndx)-1)
      clrndx((inhndx(j)+1):length(clrndx)) = clrndx((inhndx(j)+1):length(clrndx)) + 2;
   end
   clr = clrbase(clrndx);
   
   % Lines initialization.
   for p = 1:Net.P
%       h(p) = line('Color', clr(p), 'Marker','.', 'markersize',5, 'erase','none', 'xdata',[],'ydata',[]);
      h(p) = line('Color',clr(p),'Marker','.','markersize',5,'xdata',[],'ydata',[]);
   end
   
end

%% Numerical integration of the mean-field dynamics of the network.
%
StartPrintStatus = cputime;
ElapsedTime = PRINT_ELAPSED_TIME;
for n = 2:length(t)
   Nu(:,n) = (1 - Dt ./ Net.SNParam.TauD) .* Nu(:,n-1) + Dt * NuN(:,n-1) ./ Net.SNParam.TauD;
   
   Net.SNParam.NuExt = NuExt(:,n);
   NuN(:,n) = Phi(Nu(:,n), Net);
   
   if ONLINE_PLOT
      for p = 1:Net.P
%          set(h(p),'xdata',t(n),'ydata',Nu(p,n));
         set(h(p),'xdata',t(1:n),'ydata',Nu(p,1:n));
      end
      drawnow;
   end
   
%    MuVsTime(:,n) = Mu(Nu(:,n), Net);
%    Sigma2VsTime(:,n) = Sigma2(Nu(:,n), Net);
   
   %% Print intermediated status of the numerical integration.
   %
   if cputime > ElapsedTime + StartPrintStatus
      if ElapsedTime > 60
         if ElapsedTime > 3600
            str = sprintf('%g h', ElapsedTime/3600);
         else
            str = sprintf('%g min', ElapsedTime/60);
         end
      else
         str = sprintf('%g s', ElapsedTime);
      end
      ElapsedTime = ElapsedTime + PRINT_ELAPSED_TIME;
      sprintf('Integrated time %g s, Processing status %3g %% (Real time elapsed: %s)', t(n)-t(1), 100*(t(n)-t(1))/(t(end)-t(1)), str);
   end

end

%% Restore original values of the external spike rate.
%
Net.SNParam.NuExt = OriginalNuExt;