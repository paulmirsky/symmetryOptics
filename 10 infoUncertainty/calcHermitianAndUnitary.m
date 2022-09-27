clear all
close all
clc

factorSize = 5;

% make tilt operator
thisFactor = opFactor();
thisFactor.type = 'position';
% thisFactor.type = 'angle';
thisFactor.size = factorSize;
thisFactor.calcAll();

orthogonalBasis = thisFactor.states;
realEigenvalues = thisFactor.values;

% for hermitian:
eigenvalues = realEigenvalues;

% for unitary:
% unitPhase = i*(2*pi)/thisFactor.size;
% eigenvalues = exp(realEigenvalues * unitPhase);

% write vectors and eigenvalues
for (ii = 1:thisFactor.size)
    disp(['State vector for eigenvalue ', num2str(eigenvalues(ii))]);
    disp(thisFactor.states{ii});
end

% create operator
xform = xforms();
xform.size = factorSize;
synthesizedMatrix = xform.makeOperator(orthogonalBasis, eigenvalues)

% go in reverse and calculate the eigenvalues
[calcedEigenvectors, calcedEvalsAreDiagonals] = eigs(synthesizedMatrix)





