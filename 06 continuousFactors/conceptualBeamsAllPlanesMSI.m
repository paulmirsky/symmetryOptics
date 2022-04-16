clear all
close all
clc

% define grating
a = 4;
b = 6;
c = 12;
e = 4; % e is the ratio of Z_farLimit / Z_lateElbow
d = a*b*c*e;

staticSizesMSI = { a, b, c, d };
staticTypesMSI = { 'plenary', 'singular', 'plenary', 'singular' };

staticSizesEarly = { a, b*c*d };
staticTypesEarly = { 'plenary', 'singular' };

staticSizesInterval = { a*b, c*d };
staticTypesInterval = { 'plenary', 'singular' };

staticSizesLate = { a*b*c, d };
staticTypesLate = { 'plenary', 'singular' };

allStageSizes = [a,a,b,b,c,c,e];
allZs = 1;
zStepSize = .5;
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

% set up colors
colors = colorKit();

% set up live
calcLiveMSI = calcLive();
calcLiveMSI.reportNewSprouts = false;
calcLiveMSI.staticSizes = staticSizesMSI;
calcLiveMSI.staticTypes = staticTypesMSI;

calcLiveEarly = calcLive();
calcLiveEarly.reportNewSprouts = false;
calcLiveEarly.staticSizes = staticSizesEarly;
calcLiveEarly.staticTypes = staticTypesEarly;

calcLiveInterval = calcLive();
calcLiveInterval.reportNewSprouts = false;
calcLiveInterval.staticSizes = staticSizesInterval;
calcLiveInterval.staticTypes = staticTypesInterval;

calcLiveLate = calcLive();
calcLiveLate.reportNewSprouts = false;
calcLiveLate.staticSizes = staticSizesLate;
calcLiveLate.staticTypes = staticTypesLate;

for ii = 1:numel(allZs)
    
    thisZ = allZs(ii);
    calcLiveMSI.calcLiveAtZ(thisZ);
    calcLiveEarly.calcLiveAtZ(thisZ);
    calcLiveInterval.calcLiveAtZ(thisZ);
    calcLiveLate.calcLiveAtZ(thisZ);

    % calculate ceiling widths from factor chain sizes
    staticCeilingsMSI = cumprod( cell2mat(staticSizesMSI) );
    liveCeilingsMSI = cumprod( cell2mat(calcLiveMSI.liveSizes) );
    staticCeilingsEarly = cumprod( cell2mat(staticSizesEarly) );
    liveCeilingsEarly = cumprod( cell2mat(calcLiveEarly.liveSizes) );
    staticCeilingsInterval = cumprod( cell2mat(staticSizesInterval) );
    liveCeilingsInterval = cumprod( cell2mat(calcLiveInterval.liveSizes) );
    staticCeilingsLate = cumprod( cell2mat(staticSizesLate) );
    liveCeilingsLate = cumprod( cell2mat(calcLiveLate.liveSizes) );

    splitLiveEarly = splitFacChain();
    splitLiveEarly.sizesIn = calcLiveEarly.liveSizes;
    splitLiveEarly.typesIn = calcLiveEarly.liveTypes;
    splitLiveEarly.breakpoints = staticCeilingsEarly;
    splitLiveEarly.split();
    splitStaticEarly = splitFacChain();
    splitStaticEarly.sizesIn = staticSizesEarly;
    splitStaticEarly.typesIn = staticTypesEarly;
    splitStaticEarly.breakpoints = liveCeilingsEarly;
    splitStaticEarly.split();
    
    splitLiveInterval = splitFacChain();
    splitLiveInterval.sizesIn = calcLiveInterval.liveSizes;
    splitLiveInterval.typesIn = calcLiveInterval.liveTypes;
    splitLiveInterval.breakpoints = staticCeilingsInterval;
    splitLiveInterval.split();
    splitStaticInterval = splitFacChain();
    splitStaticInterval.sizesIn = staticSizesInterval;
    splitStaticInterval.typesIn = staticTypesInterval;
    splitStaticInterval.breakpoints = liveCeilingsInterval;
    splitStaticInterval.split();
    
    splitLiveLate = splitFacChain();
    splitLiveLate.sizesIn = calcLiveLate.liveSizes;
    splitLiveLate.typesIn = calcLiveLate.liveTypes;
    splitLiveLate.breakpoints = staticCeilingsLate;
    splitLiveLate.split();
    splitStaticLate = splitFacChain();
    splitStaticLate.sizesIn = staticSizesLate;
    splitStaticLate.typesIn = staticTypesLate;
    splitStaticLate.breakpoints = liveCeilingsLate;
    splitStaticLate.split();

    synthEarly = continuousDistribFromChains();
    synthEarly.staticSizes = splitStaticEarly.splitSizes;
    synthEarly.staticTypes = splitStaticEarly.splitTypes;
    synthEarly.liveSizes = splitLiveEarly.splitSizes;
    synthEarly.liveTypes = splitLiveEarly.splitTypes;
    synthEarly.synthesize();
    synthEarly.combineRepeated(); % recombine screen pattern    
    
    synthInterval = continuousDistribFromChains();
    synthInterval.staticSizes = splitStaticInterval.splitSizes;
    synthInterval.staticTypes = splitStaticInterval.splitTypes;
    synthInterval.liveSizes = splitLiveInterval.splitSizes;
    synthInterval.liveTypes = splitLiveInterval.splitTypes;
    synthInterval.synthesize();
    synthInterval.combineRepeated(); % recombine screen pattern    
    
    synthLate = continuousDistribFromChains();
    synthLate.staticSizes = splitStaticLate.splitSizes;
    synthLate.staticTypes = splitStaticLate.splitTypes;
    synthLate.liveSizes = splitLiveLate.splitSizes;
    synthLate.liveTypes = splitLiveLate.splitTypes;
    synthLate.synthesize();
    synthLate.combineRepeated(); % recombine screen pattern    
    
    % collect feature widths
    [ staticStripes(ii), staticPeriods(ii), staticArrays(ii), staticWideLimits(ii) ] =...
        getFeatureSizes(staticSizesMSI);
    [ liveStripes(ii), livePeriods(ii), liveArrays(ii), liveWideLimits(ii) ] =...
        getFeatureSizes(calcLiveMSI.liveSizes);
    [ ~, ~, earlyBeamStripes(ii), ~ ] = getFeatureSizes(synthEarly.screenPattSizes);
    [ ~, ~, intervalBeamStripes(ii), ~ ] = getFeatureSizes(synthInterval.screenPattSizes);
    [ ~, ~, lateBeamStripes(ii), ~ ] = getFeatureSizes(synthLate.screenPattSizes);    
    
        
end

% plot static and live
loglog(staticLiveAx,allZs,staticStripes,'Marker','.','MarkerEdgeColor',colors.get('grey'),'Color',colors.get('grey'));
hold(staticLiveAx,'on')
loglog(staticLiveAx,allZs,staticPeriods,'Marker','+','MarkerEdgeColor',colors.get('grey'),'Color',colors.get('grey'));
loglog(staticLiveAx,allZs,staticArrays,'Marker','x','MarkerEdgeColor',colors.get('grey'),'Color',colors.get('grey'));
loglog(staticLiveAx,allZs,staticWideLimits,'Marker','*','MarkerEdgeColor',colors.get('grey'),'Color',colors.get('grey'));
loglog(staticLiveAx,allZs,liveStripes,'Marker','.','MarkerEdgeColor',colors.get('grey'),'Color',colors.get('grey'));
loglog(staticLiveAx,allZs,livePeriods,'Marker','+','MarkerEdgeColor',colors.get('grey'),'Color',colors.get('grey'));
loglog(staticLiveAx,allZs,liveArrays,'Marker','x','MarkerEdgeColor',colors.get('grey'),'Color',colors.get('grey'));
loglog(staticLiveAx,allZs,liveWideLimits,'Marker','*','MarkerEdgeColor',colors.get('grey'),'Color',colors.get('grey'));

loglog(staticLiveAx,allZs,earlyBeamStripes,'Marker','o','MarkerEdgeColor',colors.get('red'),'Color',colors.get('red'));
loglog(staticLiveAx,allZs,intervalBeamStripes,'Marker','o','MarkerEdgeColor',colors.get('yellow'),'Color',colors.get('yellow'));
loglog(staticLiveAx,allZs,lateBeamStripes,'Marker','o','MarkerEdgeColor',colors.get('purple'),'Color',colors.get('purple'));


title(staticLiveAx, 'Static/Live Feature Sizes')
xlabel(staticLiveAx,'Z')
ylabel(staticLiveAx,'width')
legend(staticLiveAx,{'static stripe','static period','static array','static wide limit',...
    'live stripe','live period','live array','live wide limit','early beam','interval beam',...
    'late beam'},'location','northwest')


