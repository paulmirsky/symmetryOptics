clear all
close all
clc

calc = gaussianGrating();

% set feature sizes
calc.wavelength = 500e-9;
calc.stripe = 7e-5;
calc.period = 5e-4;
calc.array = 3e-3;
calc.lensFL = .15;

% set angle and position states (default is zero)
% calc.stripeShift = 4e-4;
% calc.arrayAngle = 2e-3;
% calc.stripeAngle = 4e-3;
% calc.arrayShift = 4e-4;

calc.xMax = .002;
calc.labelXmax = false;
calc.fontSize = 14;

calc.calcFrontFlat;
calc.calcRearFlat;
calc.startFig();
calc.draw(calc.stateFrontFlat,'Front');
calc.draw(calc.stateRearFlat,'Rear');    
