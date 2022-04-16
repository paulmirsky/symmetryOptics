clear all
close all
clc

sizes = { 5, 2, 4, 3 };
types = {'plenary','singular','plenary','singular'};

% calculate two different ways
pattern = patternFromFacs( sizes, types );
[patternByVec, patternByVecAsArray] = patternFromFacsByVec( sizes, types );

% compare the two vectors side-by-side
compareTheTwo = [pattern, patternByVec]

% compare them both with the array 
patternByVecAsArray

