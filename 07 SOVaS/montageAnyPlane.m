clear all
close all
dbstop on error
clc

% define grating
a = 4;
b = 8;
c = 8;

e = 1; % e is the ratio of Z_farLimit / Z_lateElbow
d = a*b*c*e;

staticSizes = { a, b, c, d };
staticTypes = { 'plenary', 'singular', 'plenary', 'singular' };

Z = a*a*b*b;

calculateAsCoincidence = true;

% screen figures / axes
spatialFig = figure('position',[300 150 1000 220],'color',[1 1 1]);
spatialAx = axes('parent',spatialFig);

mont = montageMSI();
mont.plotAx = spatialAx;
mont.a = a;
mont.b = b;
mont.c = c;
mont.d = d;
mont.coincidence = calculateAsCoincidence;
mont.useLens = true;
mont.fLens = 500;
mont.centerOdd = false;
mont.showXAxis = true;

mont.calcScreenPatt(Z);
mont.draw;






