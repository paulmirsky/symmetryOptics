clear all
close all
clc

% input parameters
dBeam = 200e-6;
wavelength = 1e-6;
zVals = 0:1e-3:400e-3;

% calculate curvature in conventional Gaussian manner, see https://en.wikipedia.org/wiki/Gaussian_beam
zRayleigh = pi*(dBeam/2)^2 / wavelength;
gaussianCurv = zVals ./ ( zVals.^2 + zRayleigh^2 );

% calculate curvature with symmetry-optical method
correctionFactor = sqrt(pi/4);
staticStripe = (correctionFactor * dBeam / wavelength);
zElbow = staticStripe^2;
symmOpsCurve = nan(size(zVals));
for ii = 1:numel(zVals)
    liveStripe = zVals(ii) / wavelength / staticStripe;
    staticOverLive = staticStripe/liveStripe;
    liveOverStatic = liveStripe/staticStripe;
    radius = ( staticOverLive + liveOverStatic ) * (zElbow * wavelength);
    symmOpsCurve(ii) = 1 / radius;
end

% plot all
figure('position',[200 200 900 600]);
hold on
plot(zVals,gaussianCurv,'LineStyle','none','Marker','.');
plot(zVals,symmOpsCurve,'LineStyle','none','Marker','o');
legend({'Gaussian','symmetry-optical'})
title('Comparing two methods of computing curvature')



