function indices = indexRange( nPoints, leftOrRightForEven )
% leftOrRightForEven means: for even numbers, is zero on the left or the right of the middle

    if strcmp(leftOrRightForEven,'left')
        lowestExponent = -1*ceil(nPoints/2) + 1;
    elseif strcmp(leftOrRightForEven,'right')
        lowestExponent = -1*floor(nPoints/2);
    else
        error('invalid left-or-right tag!')
    end

    highestExponent = lowestExponent + nPoints - 1;
    indices = lowestExponent:highestExponent;

end