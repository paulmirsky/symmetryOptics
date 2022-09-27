clear all
close all
clc

fac = opFactor();
fac.type = 'position';
fac.size = 5;
fac.calcAll();

allStates = fac.states
state_1 = fac.states{1}
state_2 = fac.states{2}
state_3 = fac.states{3}
state_4 = fac.states{4}
state_5 = fac.states{5}



