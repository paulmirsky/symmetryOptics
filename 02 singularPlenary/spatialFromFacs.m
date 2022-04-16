clear all
close all
clc

colors = colorKit();

% input parameters, grating
a = 5;
b = 2;
c = 4;
d = 3;
sizes = { a, b, c, d };
types = {'plenary','singular','plenary','singular'};
colorSeq = { colors.get('yellow'), colors.get('green'), colors.get('red'), colors.get('blue') };

% % input parameters, beam
% a = 3;
% b = 6;
% sizes = { a, b };
% types = {'plenary','singular'};
% colorSeq = { colors.get('yellow'), colors.get('green') };

listFactorChain('factor sequences:', sizes, types );
pattern = patternFromFacs( sizes, types )

% prepare drawing objects
thisFig = figure('position',[300 350 1200 350],'color',[1 1 1]);
factorAx = subplot(2,1,1,'parent',thisFig);
spatialAx = subplot(2,1,2,'parent',thisFig);
title(factorAx,'Factor chain')
title(spatialAx,'Spatial')
factorAx.YColor = 'none';
spatialAx.YColor = 'none';

% draw factor diagram
facDiagram = drawFac;
facDiagram.axObj = factorAx;
facDiagram.facSizes = sizes; 
facDiagram.facTypes = types;
facDiagram.facColors = colorSeq;
facDiagram.yPlot = 0;
facDiagram.draw();

% draw spatial diagram
spatialDiagram = drawDiscreteSpatial;
spatialDiagram.axObj = spatialAx;
spatialDiagram.centerPattern = false;
spatialDiagram.drawPattern(pattern, 0, colors.get('red') );



