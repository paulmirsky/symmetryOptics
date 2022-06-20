clear all
close all
clc

% input parameters
dBeam = 200e-6;
wavelength = 1e-6;
zVals = 0:1e-4:400e-3;

% calculate curvature in conventional manner, see https://en.wikipedia.org/wiki/Gaussian_beam
zRayleigh = pi*(dBeam/2)^2 / wavelength;
curv = zVals ./ ( zVals.^2 + zRayleigh^2 );

% calculate parity
calc = parityCalc();
correctionFactor = sqrt(pi/4);
calc.wFlat = correctionFactor * dBeam / wavelength;
calc.lensLimited = false;
parities = nan(size(zVals));
for ii = 1:numel(zVals)
    parities(ii) = calc.getParity(zVals(ii)/wavelength);
end

% scaled parity
scaledParities = parities / (calc.wFlat^2 * wavelength);

% plot all
figure('position',[200 200 900 600]);
plot(zVals,curv)
hold on
plot(zVals,scaledParities)
legend({'curvature','scaled parity'})



