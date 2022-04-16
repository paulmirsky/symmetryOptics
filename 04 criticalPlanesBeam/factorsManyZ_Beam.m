clear all
close all
clc

% define grating
a = 5;
e = 3;
b = a*e;
staticSizes = { a, b };
staticTypes = { 'plenary', 'singular' };

% options
drawCommonFloors = true; % ceilings, too
splitLiveAtStaticFloors = true; % break the static up into sub-factors at floors
showNewSprouts = true;

% Z values, factor A
stageStartZ = 1; 
zIncreases = 1:a;

% % Z values, up to elbow
% stageStartZ = a; 
% zIncreases = 1:a;

% % Z values, elbow to far limit
% stageStartZ = a*a; 
% zIncreases = 1:e;

% screen figures / axes
thisFig = figure('position',[500 50 1000 900],'color',[1 1 1]);
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


