clear all
close all
clc

% define static
staticSizes = { 2, 2, 4, 2 }; % a, b, c, d 
staticTypes = { 'plenary', 'singular', 'plenary', 'singular' };
listFactorChain('static:', staticSizes, staticTypes )

z = 16;

% calculate the static pattern
staticPattern = patternFromFacs( staticSizes, staticTypes )

% set up live calc
calcLive = calcLive();
calcLive.staticSizes = staticSizes;
calcLive.staticTypes = staticTypes;
calcLive.calcLiveAtZ(z);
if ~allEntriesAreIntegers(cell2mat(calcLive.liveSizes),1e-9)
    error('can not calc pattern! not all fac sizes are integers');
end
listFactorChain('live:', calcLive.liveSizes, calcLive.liveTypes )

% calculate the static pattern
livePattern = patternFromFacs( calcLive.liveSizes, calcLive.liveTypes )

% prepare figures etc
thisFig = figure('position',[500 180 680 600],'color',[1 1 1]);
staticFacAx = subplot(5,1,4,'parent',thisFig);
staticSpaAx = subplot(5,1,5,'parent',thisFig);
liveFacAx = subplot(5,1,1,'parent',thisFig);
liveSpaAx = subplot(5,1,2,'parent',thisFig);
title(staticFacAx,'Static factors')
title(staticSpaAx,'Static spatial')
title(liveFacAx,'Live factors')
title(liveSpaAx,'Live spatial')
staticFacAx.YColor = 'none';
staticSpaAx.YColor = 'none';
liveFacAx.YColor = 'none';
liveSpaAx.YColor = 'none';

% draw static factor diagram
colors = colorKit();
drawStaticFac = drawFac;
drawStaticFac.axObj = staticFacAx;
drawStaticFac.facSizes = staticSizes; 
drawStaticFac.facTypes = staticTypes;
drawStaticFac.facColors = repmat( { colors.sourceColor }, [1 numel(staticSizes)] );
drawStaticFac.draw();

% draw static spatial diagram
drawStaticSpa = drawDiscreteSpatial;
drawStaticSpa.axObj = staticSpaAx;
drawStaticSpa.centerPattern = false;
drawStaticSpa.drawPattern(staticPattern, 0, colors.sourceColor );

% draw live factor diagram
drawLiveFac = drawFac;
drawLiveFac.axObj = liveFacAx;
drawLiveFac.facSizes = calcLive.liveSizes; 
drawLiveFac.facTypes = calcLive.liveTypes;
colorSeq = { colors.get('yellow'), colors.get('green'), colors.get('red'), colors.get('blue') };
drawLiveFac.facColors = colorSeq;
drawLiveFac.draw();

% draw live spatial diagram
drawLiveSpa = drawDiscreteSpatial;
drawLiveSpa.axObj = liveSpaAx;
drawLiveSpa.centerPattern = false;
drawLiveSpa.drawPattern(livePattern, 0, colors.get('red') );

% make static and live scales the same
liveFacAx.XLim = staticFacAx.XLim;
liveSpaAx.XLim = staticSpaAx.XLim;


