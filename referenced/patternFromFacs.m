function cumulativePattern = patternFromFacs(facSizes, facTypes)

    % validate inputs
    if ~isequal( numel(facSizes), numel(facTypes) )
        error('factor size vector and factor type vector must have the same dimensions!');
    end
    if ( isempty(facSizes) || isempty(facTypes) )
        error('factor specification can not be empty!');
    end
    if ~allEntriesAreIntegers(cumprod(cell2mat(facSizes)),1e-9)
        error('factors will produce non-integer feature sizes!');
    end

    cumulativePattern = 1; % it starts off trivially
    nFacs = numel(facSizes);
    for ii = 1:nFacs % for each factor...
        nPoints = facSizes{ii};
        nPoints = round(nPoints,9); % this is needed to correct for small numerical errors
        if strcmp(facTypes(ii),'plenary') % if plenary, replicate the cumulative pattern
            cumulativePattern = repmat(cumulativePattern, [nPoints, 1]);
        elseif strcmp(facTypes(ii),'singular') % if singular, expand cumulative pattern with dark space
            nBefore = floor(nPoints/2);
            nAfter = ceil(nPoints/2)-1;
            % nBefore = ceil(nPoints/2)-1;
            % nAfter = floor(nPoints/2);
            cumulativeSize = numel(cumulativePattern);
            darkBefore = zeros([nBefore*cumulativeSize,1]);
            darkAfter = zeros([nAfter*cumulativeSize,1]);
            cumulativePattern = [ darkBefore; cumulativePattern; darkAfter];
        else
            error('invalid factor type!')
        end
    end

end

