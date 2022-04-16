clear all
close all
clc

% define grating
a = 3;
b = 3;
c = 4;
d = 3;
% % if d is too small, try this:
% e = 2; % e is the ratio of Z_farLimit / Z_lateElbow
% d = a*b*c*e;
staticSizes = { a, b, c, d };
staticTypes = { 'plenary', 'singular', 'plenary', 'singular' };

% options
drawCommonFloors = true; % ceilings, too
splitLiveAtStaticFloors = false; % break the static up into sub-factors at floors
showNewSprouts = true;

% % Z values, up to early elbow
% stageStartZ = a; 
% zIncreases = 1:a;

% Z values, up to core start
stageStartZ = a*a; 
zIncreases = 1:b;

% % Z values, up to interval elbow
% stageStartZ = a*a*b; 
% zIncreases = 1:b;

% % Z values, up to breakout
% stageStartZ = a*a*b*b; 
% zIncreases = 1:(c/b);

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
thisFig = figure('position',[300 50 1000 900],'color',[1 1 1]);
thisAx = axes('parent',thisFig);
thisAx.YColor = 'none';
pair = drawChainPair();
pair.axObj = thisAx;
pair.unit = 0.3 * stageStartZ;
pair.staticSizes = staticSizes; 
pair.staticTypes = staticTypes;
pair.separatorDot = ~drawCommonFloors;
pair.draw(0);

colorsObj = colorKit();

splitter = splitFacChain();
splitter.breakpoints = cumprod( cell2mat(staticSizes) );

% set up live calc
calcLive = calcLive();
calcLive.reportNewSprouts = showNewSprouts;
calcLive.staticSizes = staticSizes;
calcLive.staticTypes = staticTypes;

for ii = 1:numel(zIncreases)

    thisIncrease = zIncreases(ii);
    thisZ = thisIncrease * stageStartZ;
    
    calcLive.calcLiveAtZ(thisZ);   
    pair.liveSizes = calcLive.liveSizes; 
    pair.liveTypes = calcLive.liveTypes;        
    
    if splitLiveAtStaticFloors
        splitter.sizesIn = calcLive.liveSizes;
        splitter.typesIn = calcLive.liveTypes;
        splitter.colorsIn = { colorsObj.get('yellow'), colorsObj.get('green'), colorsObj.get('red'), colorsObj.get('blue') };
        splitter.split();
        pair.liveTypes = splitter.splitTypes;
        pair.liveSizes = splitter.splitSizes;
        pair.liveColors = splitter.splitColors;
    end
    
    pair.draw(thisZ);
    
    if drawCommonFloors
        pair.drawCommonFloors(thisZ);
    end
    
end


