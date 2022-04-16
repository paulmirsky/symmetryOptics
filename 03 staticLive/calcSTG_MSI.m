clear all
close all
clc

% define static
staticSizes = { 2, 2, 4, 2 }; % a, b, c, d 
staticTypes = { 'plenary', 'singular', 'plenary', 'singular' };

Z = 16;

% calculate static
calcLiveObj = calcLive();
calcLiveObj.staticSizes = staticSizes;
calcLiveObj.staticTypes = staticTypes;
calcLiveObj.calcLiveAtZ(Z);

% calculate static and live patterns
staticPattern = patternFromFacs( staticSizes, staticTypes );
livePattern = patternFromFacs( calcLiveObj.liveSizes, calcLiveObj.liveTypes );

% calculate the STG
stg = sourceTargetGrid();
stg.staticPattern = staticPattern;
stg.livePattern = livePattern;
stg.calc();

% set up drawing obj
tabulateFig = figure('position',[300 380 900 600],'color',[1 1 1]);
tabulateAx = axes('parent',tabulateFig);
colors = colorKit();
drawSTG = drawDiscreteSpatial();
drawSTG.axObj = tabulateAx;
drawSTG.markerWidthFrac = 0.70;
drawSTG.markerHeightFrac = 0.85;
drawSTG.centerPattern = true;
drawSTG.trimDark = false;
drawSTG.centerByWholePatch = true;

% draw STG
spacing = 4;
drawSTG.drawPattern(livePattern, -spacing, colors.get('red'));
text(0, -spacing-1, 'Live', 'parent', tabulateAx, 'horizontalAlignment', 'center', 'fontSize', 12, 'fontWeight', 'bold');
drawSTG.drawPattern(staticPattern, 0, colors.sourceColor);
text(0, -1, 'Static', 'parent', tabulateAx, 'horizontalAlignment', 'center', 'fontSize', 12, 'fontWeight', 'bold');
drawSTG.drawPattern(stg.stg, spacing, colors.colorList);
text(0, spacing-1, 'Source-Target Grid', 'parent', tabulateAx, 'horizontalAlignment', 'center', 'fontSize', 12, 'fontWeight', 'bold');
drawSTG.clearBorder;

% draw reduced
drawSTG.trimDark = true;
reduceFig = figure('position',[700 60 900 600],'color',[1 1 1]);
fullStgAx = subplot(2,1,1,'parent',reduceFig);
distribAx = subplot(4,1,3,'parent',reduceFig);
screenPatternAx = subplot(4,1,4,'parent',reduceFig);

title(fullStgAx, 'Source-Target Grid','verticalAlignment','bottom');
drawSTG.axObj = fullStgAx;
drawSTG.drawPattern(stg.stg, 0, colors.colorList);
drawSTG.clearBorder;

title(distribAx, 'Distribution');
drawSTG.axObj = distribAx;
drawSTG.drawPattern(stg.distribution, 0, colors.get('red'));
drawSTG.clearBorder;

title(screenPatternAx, 'Screen pattern');
drawSTG.axObj = screenPatternAx;
drawSTG.drawPattern(stg.screenPattern, 0, colors.get('red'));
drawSTG.clearBorder;

figure(tabulateFig); % brings STG to front