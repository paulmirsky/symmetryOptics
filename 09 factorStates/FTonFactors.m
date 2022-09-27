clear all
close all
clc

fac = opFactor();
fac.type = 'angle';
% fac.type = 'position';
fac.size = 5;
fac.calcAll();

stateIndex = 3;

frontFlatState = fac.states{stateIndex}

rearFlatState = doFT(frontFlatState, fac.type)



