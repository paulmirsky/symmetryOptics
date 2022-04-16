function [ stripe, period, array, wideLimit ] = getFeatureSizes( sizesIn )

    featureSizes = cumprod( cell2mat(sizesIn) );
    nEmpties = 4 - numel(featureSizes);
    emptyFeatures = nan([1,nEmpties]);
    allFeatureSizes = [ emptyFeatures, featureSizes ];

    stripe = allFeatureSizes(1);
    period = allFeatureSizes(2);
    array = allFeatureSizes(3);
    wideLimit = allFeatureSizes(4);
    
end

