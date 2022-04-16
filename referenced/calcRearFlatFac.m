function [ rearSizes, rearTypes, rearColors ] = calcRearFlatFac( varargin )
% inputs are frontSizes, frontTypes, optionalColors

    frontSizes = varargin{1};
    frontTypes = varargin{2};
    
    if ~isequal(size(frontSizes),size(frontTypes))
        error('sizes and types must have equal dimensions!');
    end
    if ~isequal( [size(frontSizes,1),size(frontTypes,1)], [1,1] )
        error('sizes and types must be row vectors!');
    end

    rearSizes = fliplr( frontSizes );
    rearTypes = fliplr( invertFacType( frontTypes ) );
    
    % color sequence is optional
    if (nargin > 2)
        frontColors = varargin{3};
        if ~isequal(size(frontSizes),size(frontColors))
            error('sizes and colors must have equal dimensions!');
        end
        rearColors = fliplr( frontColors );
    end

end

