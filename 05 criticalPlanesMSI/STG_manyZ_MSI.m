clear all
close all
clc

% define grating
a = 2;
b = 3;
c = 9;
d = 3;
% % if d is too small, try this:
% e = 2; % e is the ratio of Z_farLimit / Z_lateElbow
% d = a*b*c*e;
staticSizes = { a, b, c, d };
staticTypes = { 'plenary', 'singular', 'plenary', 'singular' };

collapseToDistribution = true; % if true, it draws the distribution instead of the STG

% % Z values, up to early elbow
% stageStartZ = a; 
% zIncreases = 1:a;

% % Z values, up to core start
% stageStartZ = a*a; 
% zIncreases = 1:b;

% % Z values, up to interval elbow
% stageStartZ = a*a*b; 
% zIncreases = 1:b;

% Z values, up to breakout
stageStartZ = a*a*b*b; 
zIncreases = 1:(c/b);

% % Z values, up to core end
% stageStartZ = a*a*b*b*(c/b); 
% zIncreases = 1:b;

% % Z values, up to late elbow
% stageStartZ = a*a*b*b*c; 
% zIncreases = 1:c;

% % Z values, up to far limit.  You need to define 'e' for this one! instead of d
% % see note up at the top
% stageStartZ = a*a*b*b*c*c; 
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
drawSTG.inPlaneScale = 0.5 * 1/(a*c) * stageStartZ;

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
    if ~allEntriesAreIntegers(cell2mat(calcLiveObj.liveSizes),1e-9)
        disp('can not calculate pattern! not all factor sizes are integers');
        continue
    end    
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
