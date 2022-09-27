clear all
close all
clc

con = SnS_controller;
con.figPosVec = [200, 100, 1400, 900]; % set size, as appropriate for your monitor      
con.initialize();
con.view.setFont(16, 'Calibri'); % set font size to look right on your monitor   

% set sizes
con.sizeA = 5;
con.sizeB = 1;
con.sizeC = 1;
con.sizeD = 1;

% calc and viewing mode
con.showRearFlat = false;
con.showPattern = false;
con.view.byValue.Value = true; % choose control mode, from options: byEval, byTransform
con.view.positionFactor.Value = true; % choose the archetype, from options: positionFactor, angleFactor, beam, grating

con.sync.uic2fig();
con.view.setFormat(con.showRearFlat, con.showPattern)

% set diagram sizes as appropriate
con.view.setAxesWidths(0.7);
con.view.maxPatternPatchDrawnSize = .08;
con.view.maxFactorPointDrawnSize = .08;

% create
con.regenerate();

