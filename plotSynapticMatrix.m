function plotSynapticMatrix(Net)
%
%  plotSynapticMatrix(Net)
%
%  Plot the mean-field synaptic matrix for the network Net.
%
%   Version: 1.2 - Jul. 11, 2019
%   Version: 1.1 - Apr. 16, 2013
%   Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it 
%

COLOR_NUM = 64;

JMax = max(max(Net.CParam.J));
JMin = min(min(Net.CParam.J));

if JMax > 0
   if JMin < 0
      RedColors = round(COLOR_NUM * JMax / (JMax - JMin));
      RedCB = [ones(RedColors+1, 1) repmat(linspace(1, 0, RedColors+1)', 1, 2)];
      RedCB = RedCB(2:end,:);
      BlueCB = [repmat(linspace(0, 1, COLOR_NUM - RedColors)', 1, 2) ones(COLOR_NUM - RedColors, 1)];
      WholeCB = [BlueCB' RedCB']';
   else
      WholeCB = [ones(COLOR_NUM, 1) repmat(linspace(1, JMin / JMax, COLOR_NUM)', 1, 2)];
   end
else
   WholeCB = [repmat(linspace(abs(JMax / JMin), 1, COLOR_NUM)', 1, 2) ones(COLOR_NUM, 1)];
end
      

figure
imagesc(Net.CParam.J);
colormap(WholeCB);
hcb = colorbar();
set(get(hcb,'YLabel'),'String', 'Synaptic strength');
xlabel('pre-synaptic pop.');
ylabel('post-synaptic pop.');

FigSize = [5 4];
set(gcf, 'PaperUnits', 'inch', 'PaperSize', FigSize, 'PaperPosition', [0 0 FigSize]);
print('-dpdf', 'SynapticMatrix');


figure
RemappedC = log(Net.CParam.c*100+1);
imagesc(RemappedC);
colormap((1.5-gray)/1.5);
hcb = colorbar();
set(get(hcb,'YLabel'),'String', 'Connectivity (%)');
set(hcb,'YTickLabel',num2str(exp(get(hcb,'YTick'))'-1,2));
xlabel('pre-synaptic pop.');
ylabel('post-synaptic pop.');

FigSize = [5 4];
set(gcf, 'PaperUnits', 'inch', 'PaperSize', FigSize, 'PaperPosition', [0 0 FigSize]);
print('-dpdf', 'ConnectivityMatrix');