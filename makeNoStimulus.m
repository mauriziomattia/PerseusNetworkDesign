function DNuExt = makeNoStimulus(Life, Dt, Net)
%
%  DNuExt = makeNoStimulus(Life, Dt, Net)
%
% Version 1.0, 4 Dec. 2006
% Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it
%

DNuExt.Freq = zeros(Net.P, floor(Life / Dt) + 1);
DNuExt.Pop = [];
DNuExt.Time = [];
DNuExt.DeltaNu = [];