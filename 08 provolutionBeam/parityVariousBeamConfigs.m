clear all
close all
clc

% free config
calc = parityCalc();
calc.wFlat = 4;
calc.lensLimited = false;
zVals = 0:96;
parities = nan(size(zVals));
for ii = 1:numel(zVals)
    parities(ii) = calc.getParity(zVals(ii));
end
figure('position',[200 200 600 400]);
plot(zVals,parities)
title('free configuration')


% lens-limited config, narrow start
calc = parityCalc();
calc.fLens = 48;
calc.wFlat = 4;
calc.lensLimited = true;
zVals = 0:2*calc.fLens;
parities = nan(size(zVals));
for ii = 1:numel(zVals)
    parities(ii) = calc.getParity(zVals(ii));
end
figure('position',[300 300 600 400]);
plot(zVals,parities)
line([calc.fLens calc.fLens], [0 1])
title('lens-limited configuration, narrow starting beam')


% lens-limited config, wide start
calc = parityCalc();
calc.fLens = 48;
calc.wFlat = 12;
calc.lensLimited = true;
zVals = 0:2*calc.fLens;
parities = nan(size(zVals));
for ii = 1:numel(zVals)
    parities(ii) = calc.getParity(zVals(ii));
end
figure('position',[400 400 600 400]);
plot(zVals,parities)
line([calc.fLens calc.fLens], [0 1])
title('lens-limited configuration, wide starting beam')



