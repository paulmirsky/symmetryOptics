clear all
close all
clc

colors = colorKit();

% % input parameters, grating
% a = 5;
% b = 2;
% c = 4;
% d = 3;
% frontSizes = { a, b, c, d };
% frontTypes = {'plenary','singular','plenary','singular'};
% frontColorSeq = { colors.get('yellow'), colors.get('green'), colors.get('red'), colors.get('blue') };

% input parameters, beam
a = 3;
b = 6;
frontSizes = { a, b };
frontTypes = {'plenary','singular'};
frontColorSeq = { colors.get('yellow'), colors.get('green') };

% prepare drawing objects
thisFig = figure('position',[300 300 1200 550],'color',[1 1 1]);
facRearAx = subplot(5,1,1,'parent',thisFig);
spaRearAx = subplot(5,1,2,'parent',thisFig);
facFrontAx = subplot(5,1,4,'parent',thisFig);
spaFrontAx = subplot(5,1,5,'parent',thisFig);
title(facRearAx,'REAR focal plane, factors')
title(spaRearAx,'REAR focal plane, spatial')
title(facFrontAx,'FRONT focal plane, factors')
title(spaFrontAx,'FRONT focal plane, spatial')
facRearAx.YColor = 'none';
spaRearAx.YColor = 'none';
facFrontAx.YColor = 'none';
spaFrontAx.YColor = 'none';

% calculate front
listFactorChain('front factor:', frontSizes, frontTypes );
frontPattern = patternFromFacs( frontSizes, frontTypes );

% draw front factor
facFront = drawFac;
facFront.axObj = facFrontAx;
facFront.facSizes = frontSizes; 
facFront.facTypes = frontTypes;
facFront.facColors = frontColorSeq;
facFront.yPlot = 0;
facFront.draw();

% draw front spatial
spaFront = drawDiscreteSpatial;
spaFront.axObj = spaFrontAx;
spaFront.centerPattern = false;
spaFront.drawPattern(frontPattern, 0, colors.get('red') );

% calculate rear
[ rearSizes, rearTypes, rearColorSeq ] = calcRearFlatFac( frontSizes, frontTypes, frontColorSeq );
listFactorChain('rear factor:', rearSizes, rearTypes );
rearPattern = patternFromFacs( rearSizes, rearTypes );

% create rear factor
facRear = drawFac;
facRear.axObj = facRearAx;
facRear.facSizes = rearSizes; 
facRear.facTypes = rearTypes;
facRear.facColors = rearColorSeq;
facRear.yPlot = 0;
facRear.draw();

% create rear spatial
spaRear = drawDiscreteSpatial;
spaRear.axObj = spaRearAx;
spaRear.centerPattern = false;
spaRear.drawPattern(rearPattern, 0, colors.get('red') );

