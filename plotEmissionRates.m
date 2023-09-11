function plotEmissionRates(InFileName, plt, Events, TransientToRemove, PrintRateStat)
%
%  plotEmissionRates([InFileName[, plt[, Events[, TransientToRemove]]]])
%
%  Plot the emission rate resulting from a Perseus simulation and stored in the file 
%  named InFileName.
%
%   Version: 1.2 - Sep. 27, 2020
%   Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it
%

if exist('TransientToRemove','var') == 0
   TRANSIENT_TO_REMOVE = 0.0;
else
   TRANSIENT_TO_REMOVE = TransientToRemove;
end

if exist('plt','var') == 0
   plt = [];
end
if exist('Events','var') == 0
   Events = [];
end

if exist('PrintRateStat','var') == 0
   PrintRateStat = 0;
end

%
% Processes the input parameters and loads data...
%
if exist(InFileName,'file')
   rates = load(InFileName);
   ndx = findstr(InFileName, '.');
   if length(ndx) > 1
      RunName = InFileName(ndx(1)+1:ndx(end));
      EPSFileName = ['EmissionRates.' RunName];
   else
      EPSFileName = 'EmissionRates';
   end
else
   rates = load('rates.dat');
   EPSFileName = 'EmissionRates';
end

%
% Processes the data loaded to make them feasable to plot...
%
t = rates(:,1)'/1000;
Nu = rates(:,2:end)';

ndx = find(t >= TRANSIENT_TO_REMOVE);
t = t(ndx);
Nu = Nu(:,ndx);
t = t - TRANSIENT_TO_REMOVE;

if PrintRateStat
   for n = 1:size(Nu,1)
      fprintf('#-----\n');
      fprintf('# Nu_%d mean = %g +- %g Hz\n', n, mean(Nu(n,:)), std(Nu(n,:))/sqrt(length(t)));
      fprintf('# Nu_%d st. dev. = %g Hz\n', n, std(Nu(n,:)));
   end
end

%
% Plots the emission rates...
%
figure;
if isempty(plt) == 0
   if isempty(Events) == 0
      plotMFTDynamics(t, Nu, plt, Events);
   else
      plotMFTDynamics(t, Nu, plt);
   end
else
   plotMFTDynamics(t, Nu);
end
set(gca, 'TickDir', 'out', 'Box', 'off');
set(gcf, 'PaperUnits', 'inch', 'PaperSize',[6 4],'PaperPosition', [0 0 6 4]);
print('-dpdf', EPSFileName);
