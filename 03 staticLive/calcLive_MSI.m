clear all
close all
clc

% define static, for many-slit interference
staticSizes = { 3, 2, 6, 4 }; % a, b, c, d
staticTypes = { 'plenary', 'singular', 'plenary', 'singular' };
listFactorChain('static:', staticSizes, staticTypes )

z = 24

% calculate live
calc = calcLive();
calc.staticSizes = staticSizes;
calc.staticTypes = staticTypes;
% calc.reportNewSprouts = true;
calc.calcLiveAtZ(z);

listFactorChain('live:', calc.liveSizes, calc.liveTypes )





