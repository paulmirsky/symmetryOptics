clear all
close all
clc

fac = opFactor();
fac.type = 'angle';
fac.size = 5;
fac.calcAll();

xform = xforms();
xform.size = 5;
xform.calcAll();

tilt = xform.tilt

stateNow = fac.states{3}
stateNow = tilt * stateNow
stateNow = tilt * stateNow
stateNow = tilt * stateNow
stateNow = tilt * stateNow
stateNow = tilt * stateNow



