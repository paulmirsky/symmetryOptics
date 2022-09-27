clear all
close all
clc

fac = opFactor();
fac.type = 'position';
fac.size = 5;
fac.calcAll();

xform = xforms();
xform.size = 5;
xform.calcAll();

slide = round(xform.slide)

stateNow = fac.states{3}
stateNow = slide * stateNow
stateNow = slide * stateNow
stateNow = slide * stateNow
stateNow = slide * stateNow
stateNow = slide * stateNow



