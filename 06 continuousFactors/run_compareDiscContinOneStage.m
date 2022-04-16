clear all
close all
clc

% screen figures / axes
figWH = [960 900];
tickBand = .05;
thisFig = figure('position',[300 50 figWH],'color',[1 1 1],'visible','on');
thisAx = axes('parent',thisFig,'units','normalized','position',[ tickBand, tickBand, 1-2*tickBand, 1-2*tickBand]);

comp = compareDiscContinOneStage();
comp.a = 1;
comp.b = 4;
comp.c = 2;
comp.stageStartZ = comp.a * comp.a * comp.b * comp.b * comp.c;
comp.zIncreases = 1:(comp.c);        
comp.plotAx = thisAx;
comp.maxRoundness = 2; 

comp.drawAll();
disp(['Max roundness was ',num2str(comp.maxRoundnessLastDraw)]);


