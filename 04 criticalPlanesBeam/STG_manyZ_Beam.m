clear all
close all
clc

% define grating
a = 5;
e = 3;
b = a*e;
staticSizes = { a, b };
staticTypes = { 'plenary', 'singular' };

collapseToDistribution = false; % if true, it draws the distribution instead of the STG

% % Z values, factor A
% stageStartZ = 1; 
% zIncreases = 1:a;

% Z values, up to elbow
stageStartZ = a; 
zIncreases = 1:a;

% % Z values, elbow to far limit
% stageStartZ = a*a; 
% zIncreases = 1:e;

% screen figures / axes
thisFig = figure('position',[500 100 800 700],'color',[1 1 1]);
thisAx = axes('parent',thisFig);
colors = colorKit();
drawSTG = drawDiscreteSpatial;
drawSTG.axObj = thisAx;
drawSTG.markerWidthFrac = 0.70;
drawSTG.markerHeightFrac = 0.85;
drawSTG.centerPattern = true;
drawSTG.trimDark = true;
drawSTG.centerByWholePatch = true;
drawSTG.inPlaneScale = 0.5 * 1/a * stageStartZ;

% set up live calc
calcLiveObj = calcLive();
calcLiveObj.staticSizes = staticSizes;
calcLiveObj.staticTypes = staticTypes;

% calculate the STG
stg = sourceTargetGrid();
staticPattern = patternFromFacs( staticSizes, staticTypes );
stg.staticPattern = staticPattern;
drawSTG.drawPattern(staticPattern, 0, colors.sourceColor);

for ii = 1:numel(zIncreases)

    thisIncrease = zIncreases(ii);
    thisZ = thisIncrease * stageStartZ;
    calcLiveObj.calcLiveAtZ(thisZ);   
    livePattern = patternFromFacs( calcLiveObj.liveSizes, calcLiveObj.liveTypes );
    stg.livePattern = livePattern;
    stg.calc();

    if collapseToDistribution
        drawSTG.drawPattern(stg.distribution, thisZ, colors.get('red'));
    else
        drawSTG.drawPattern(stg.stg, thisZ, colors.colorList);
    end
    
end

thisAx.YLim(1) = 0;
