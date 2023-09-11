function DNuExt = addConstantStimulus(DNuExt, t0, Pop, DeltaNu, Dt, Net)
%
% DNuExt = addConstantStimulus(DNuExt, t0, Pop, DeltaNu, Dt, Net)
%
% Version 1.0, 18 Oct. 2008
% Copyright (c) Maurizio Mattia, maurizio.mattia@iss.it
%

ndx = (floor(t0 / Dt) + 1):size(DNuExt.Freq,2);

if length(ndx) == 0
   return
end

TauMin = min(Net.SNParam.TauD);
if round(TauMin / Dt) > 0
   XTransient = linspace(0, 1, floor(TauMin / Dt) + 1);
   DeltaNu0 = DNuExt.Freq(Pop, ndx(1));
   YTransient = (DeltaNu - DeltaNu0) * (1 - cos(pi * XTransient)) / 2;
else
   XTransient = [];
   YTransient = [];
end

if length(ndx) >= length(YTransient)
   if length(YTransient)>0
      DNuExt.Freq(Pop, ndx(1:length(YTransient))) = ...
         DNuExt.Freq(Pop, ndx(1:length(YTransient))) + ...
         YTransient;
   end
    DNuExt.Freq(Pop, ndx(length(YTransient) + 1):end) = DeltaNu;
else
    DNuExt.Freq(Pop, ndx(1):end) = ...
        DNuExt.Freq(Pop, ndx(1):end) + YTransient(1:length(ndx));
end

DNuExt.Pop = [DNuExt.Pop Pop];
DNuExt.Time = [DNuExt.Time t0];
DNuExt.DeltaNu = [DNuExt.DeltaNu DeltaNu];