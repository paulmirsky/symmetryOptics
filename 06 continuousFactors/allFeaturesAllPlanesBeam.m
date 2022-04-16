clear all
close all
clc

% define grating
a = 4;
e = 12; % e is the ratio of Z_farLimit / Z_Elbow
b = a*e;

staticSizes = { a, b };
staticTypes = { 'plenary', 'singular' };

allStageSizes = [a,a,e];

allZs = 1;
zStepSize = 1;
for jj = 1:numel(allStageSizes)
    increasesThisStage = 1:zStepSize:allStageSizes(jj); % all integers
    increasesThisStage = [ increasesThisStage.'; allStageSizes(jj) ]; % add the segment end, if not an integer
    increasesThisStage(1) = []; % clip off 1 at the beginning
    increasesThisStage = unique(increasesThisStage); % get rid of duplicates
    newValsThisStage = increasesThisStage * allZs(end);
    allZs = [allZs; newValsThisStage];
end


% screen figures / axes
staticLiveFig = figure('position',[300 90 1000 800],'color',[1 1 1]);
staticLiveAx = axes('parent',staticLiveFig);
screenPattRndFig = figure('position',[350 140 1000 800],'color',[1 1 1]);
screenPattRndAx = axes('parent',screenPattRndFig);

% set up colors
colors = colorKit();
staticColors = repmat({colors.sourceColor},[1 numel(staticSizes)]);

% set up live
calcLive = calcLive();
calcLive.reportNewSprouts = false;
calcLive.staticSizes = staticSizes;
calcLive.staticTypes = staticTypes;

for ii = 1:numel(allZs)
    
    thisZ = allZs(ii);
    calcLive.calcLiveAtZ(thisZ);

    % calculate ceiling widths from factor chain sizes
    staticCeilings = cumprod( cell2mat(staticSizes) );
    liveCeilings = cumprod( cell2mat(calcLive.liveSizes) );

    % split the chains
    splitLive = splitFacChain();
    splitLive.sizesIn = calcLive.liveSizes;
    splitLive.typesIn = calcLive.liveTypes;
    splitLive.breakpoints = staticCeilings;
    splitLive.split();

    splitStatic = splitFacChain();
    splitStatic.sizesIn = staticSizes;
    splitStatic.typesIn = staticTypes;
    splitStatic.breakpoints = liveCeilings;
    splitStatic.split();

    % calculate screen pattern and roundness
    synthCalcChain = continuousDistribFromChains();
    synthCalcChain.staticSizes = splitStatic.splitSizes;
    synthCalcChain.staticTypes = splitStatic.splitTypes;
    synthCalcChain.liveSizes = splitLive.splitSizes;
    synthCalcChain.liveTypes = splitLive.splitTypes;
    synthCalcChain.synthesize();
    synthCalcChain.combineRepeated(); % recombine screen pattern    

    % collect feature widths
    [ ~, ~, staticStripes(ii), staticWideLimits(ii) ] = getFeatureSizes(staticSizes);
    [ ~, ~, liveStripes(ii), liveWideLimits(ii) ] = getFeatureSizes(calcLive.liveSizes);
    [ ~, ~, screenPattStripes(ii), screenPattWideLimits(ii) ] = getFeatureSizes(synthCalcChain.screenPattSizes);
    roundnesses(ii) = synthCalcChain.roundness;
    
end

% plot static and live
loglog(staticLiveAx,allZs,staticStripes,'Marker','.','MarkerEdgeColor',colors.sourceColor,'Color',colors.sourceColor);
hold(staticLiveAx,'on')
loglog(staticLiveAx,allZs,staticWideLimits,'Marker','*','MarkerEdgeColor',colors.sourceColor,'Color',colors.sourceColor);
loglog(staticLiveAx,allZs,liveStripes,'Marker','.','MarkerEdgeColor',colors.get('red'),'Color',colors.get('red'));
loglog(staticLiveAx,allZs,liveWideLimits,'Marker','.','MarkerEdgeColor',colors.get('blue'),'Color',colors.get('blue'));
title(staticLiveAx, 'Static/Live Feature Sizes')
xlabel(staticLiveAx,'Z')
ylabel(staticLiveAx,'width')
legend(staticLiveAx,{'static stripe','static wide limit','live stripe','live wide limit'},'location','northwest')

% plot screen pattern and roundness
loglog(screenPattRndAx,allZs,screenPattStripes,'Marker','.','MarkerEdgeColor',colors.get('purple'),'Color',colors.get('purple'));
hold(screenPattRndAx,'on')
loglog(screenPattRndAx,allZs,screenPattWideLimits,'Marker','.','MarkerEdgeColor',colors.get('grey'),'Color',colors.get('grey'));
loglog(screenPattRndAx,allZs,roundnesses,'Marker','.','MarkerEdgeColor',colors.get('brown'),'Color',colors.get('brown'));
title(screenPattRndAx, 'Screen Pattern, Roundness')
xlabel(screenPattRndAx,'Z')
ylabel(screenPattRndAx,'width')
legend(screenPattRndAx,{'scrn patt stripe','scrn patt wide limit','roundness'},'location','northwest')


