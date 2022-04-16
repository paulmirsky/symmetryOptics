clear all
close all
clc

% define grating
a = 6;
b = 20;

% % if b is too small, try this:
% e = 2; % e is the ratio of Z_farLimit / Z_Elbow
% b = a*e;

staticSizes = { a, b };
staticTypes = { 'plenary', 'singular' };

Z = a*a;

% screen figures / axes
factorFig = figure('position',[300 500 1000 220],'color',[1 1 1]);
factorAx = axes('parent',factorFig);

% screen figures / axes
spatialFig = figure('position',[300 150 1000 220],'color',[1 1 1]);
spatialAx = axes('parent',spatialFig);

colors = colorKit();
liveColors = { colors.get('yellow'), colors.get('green'), colors.get('red'), colors.get('blue') };
staticColors = repmat({colors.sourceColor},[1 numel(staticSizes)]);

% calculate live
calcLive = calcLive();
calcLive.reportNewSprouts = false;
calcLive.staticSizes = staticSizes;
calcLive.staticTypes = staticTypes;
calcLive.calcLiveAtZ(Z);  

% draw live factors
drawConStatic = drawContinuousFacChain;
drawConStatic.axObj = factorAx;
drawConStatic.maxZ = a*b;
drawConStatic.yPlot = -1;
drawConStatic.sizes = staticSizes;
drawConStatic.types = staticTypes;
drawConStatic.colors = staticColors;
drawConStatic.draw;

drawConLive = drawContinuousFacChain;
drawConLive.axObj = factorAx;
drawConLive.maxZ = a*b;
drawConLive.yPlot = 1;
drawConLive.sizes = calcLive.liveSizes;
drawConLive.types = calcLive.liveTypes;
drawConLive.colors = liveColors;
drawConLive.draw(); 

% calculate ceiling widths from factor chain sizes
staticCeilings = cumprod( cell2mat(staticSizes) );
liveCeilings = cumprod( cell2mat(calcLive.liveSizes) );

% split the chains
splitLive = splitFacChain();
splitLive.sizesIn = calcLive.liveSizes;
splitLive.typesIn = calcLive.liveTypes;
splitLive.breakpoints = staticCeilings;
splitLive.colorsIn = liveColors;
splitLive.split();

splitStatic = splitFacChain();
splitStatic.sizesIn = staticSizes;
splitStatic.typesIn = staticTypes;
splitStatic.breakpoints = liveCeilings;
splitStatic.colorsIn = repmat({colors.sourceColor},[1 numel(staticSizes)]);
splitStatic.split();

% calculate screen pattern and roundness
synthCalcChain = continuousDistribFromChains();
synthCalcChain.staticSizes = splitStatic.splitSizes;
synthCalcChain.staticTypes = splitStatic.splitTypes;
synthCalcChain.liveSizes = splitLive.splitSizes;
synthCalcChain.liveTypes = splitLive.splitTypes;
synthCalcChain.synthesize();
synthCalcChain.combineRepeated(); % recombine screen pattern

% draw spatial screen pattern
drawScreenPattern = drawContinuousFeaturesSpatial();
drawScreenPattern.ax = spatialAx;
drawScreenPattern.heightFrac = 1;
drawScreenPattern.a = synthCalcChain.screenPattSizes{1};
drawScreenPattern.b = synthCalcChain.screenPattSizes{2};
drawScreenPattern.clipExcessDark = true;
drawScreenPattern.drawIt();



