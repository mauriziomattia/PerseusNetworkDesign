function plotMFTDynamics(t, Nu, plt, Events)
%
%   plotMFTDynamics(t, Nu[, plt[, Events]])
%
%   Plot the firing rate Nu resulting from a dynamic mean-field simulation as 
%   MFTDynamics.
%
%   Version: 1.1 - Jul. 10, 2019
%   Version: 1.0 - Oct. 18, 2008
%   Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it
%

GRAY = [0.9 0.9 0.9];

NuMax = ceil((max(Nu(:)))/5)*5;
if NuMax == 0
   NuMax = 1;
end

if exist('Events','var')
   for n=1:2:length(Events)-1
      h = patch([Events(n) Events(n+1) Events(n+1) Events(n)], ...
            [0 0 NuMax NuMax], GRAY);
      set(h, 'FaceColor', GRAY, 'EdgeColor', 'none');
      hold on;
   end
end

if exist('plt','var')
   for n = 1:length(plt)
      h(n) = plot(t, Nu(plt(n).popndx,:), 'Color', plt(n).color, ...
                  'LineWidth', plt(n).linewidth);
      hold on;
      lgnstr{n} = plt(n).label;
   end
else
   plot(t, Nu, 'LineWidth', 1);
end
hold on;

if exist('Events','var')
   for n=1:length(Events)
      plot([Events(n) Events(n)], [0 NuMax], 'k:');
   end
end
if exist('plt','var')
%    legend(h, lgnstr, 'Location','NorthEastOutside');
   legend(h, lgnstr, 'Location','NorthEast');
end
xlabel('Time (s)');
ylabel('Emission rate (Hz)');
%XLim = get(gca,'XLim');
%set(gca, 'XLim', [0 XLim(2)], 'YLim', [0 NuMax], 'Layer', 'top', 'Box', 'on');
set(gca, 'XLim', [0 t(end)], 'YLim', [0 NuMax], 'Layer', 'top', 'Box', 'on');
