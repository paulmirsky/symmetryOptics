clear all
close all
clc

sizes = { 5, 2, 4, 3 };
types = {'plenary','singular','plenary','singular'};

% calculate two different ways
pattern = patternFromFacs( sizes, types )