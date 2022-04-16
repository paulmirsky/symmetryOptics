function [ patternAsVector, patternAsArray ] = patternFromFacsByVec(facSizes, facTypes)

    % validate inputs
    if ~isequal( numel(facSizes), numel(facTypes) )
        error('factor size vector and factor type vector must have the same dimensions!');
    end
    if ( isempty(facSizes) || isempty(facTypes) )
        error('factor specification can not be empty!');
    end
    if ~allEntriesAreIntegers(cell2mat(facSizes),1e-9)
        error('factor size is not an integer!');
    end

    % note -- the algorithm in this function is somewhat different from the
    % one given in the lecture/notes, because Matlab makes it surprisingly 
    % to form an outer product of vectors when the number of factors is not
    % known at design time.
    % instead, flatten the outer product after *each additional factor is
    % added.
    nFacs = numel(facSizes);
    patternAsVector = 1;
    for ii = 1:nFacs % for each factor...
        nPoints = facSizes{ii};  
        if strcmp(facTypes(ii),'plenary')
            thisFacVec = ones([nPoints,1]); % if plenary, the factor vector is all 1's
        elseif strcmp(facTypes(ii),'singular') % if plenary, the factor vector is all 0's except for one centered 1
            thisFacVec = zeros([nPoints,1]);
            thisFacVec( ceil(nPoints/2) ) = 1;
        else
            error('invalid factor type!')
        end
        patternAsVector = reshape(patternAsVector * thisFacVec.', length(thisFacVec)*length(patternAsVector), 1); % flatten
    end
    
    % Matlab makes it very easy to convert the flattened array into the
    % multidimensional one.
    if (numel(facSizes) > 1)
        patternAsArray = reshape(patternAsVector, cell2mat(facSizes) );
    else
        patternAsArray = patternAsVector; % reshape doesn't work with just one dim
    end

end