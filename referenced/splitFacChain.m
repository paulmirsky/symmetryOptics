classdef splitFacChain < handle
    
    properties
        sizesIn
        typesIn
        colorsIn
        breakpoints
        splitSizes = {}
        splitTypes = {}
        splitColors = {}

    end
    
    
    methods
        
        % constructor
        function this = splitFacChain()
        % constructor end
        end 
        
        
    
        % this is the less-advanced version
        function split(this)
            
            % reset
            this.splitSizes = {};
            this.splitTypes = {};
            this.splitColors = {};
            
            % get colors
            if (numel(this.colorsIn)==0) % if there are no colors, make them all black
                colorsToUse = repmat({[0 0 0]},[1,numel(this.sizesIn)]); 
            elseif ( numel(this.colorsIn) == numel(this.sizesIn) ) % this is the intended case
                colorsToUse = this.colorsIn;
            elseif ( numel(this.colorsIn) > numel(this.sizesIn) ) % if too many, trim away
                colorsToUse = this.colorsIn((end+1-numel(this.sizesIn)):end);
            else % if too few, repeat the first one
                nExtra = numel(this.sizesIn) - numel(this.colorsIn);
                extraColors = repmat(this.colorsIn(1),[1,nExtra]);
                colorsToUse = cat(2,extraColors,this.colorsIn);
            end
            
            % get ceilings
            ceilingsIn = cumprod( cell2mat(this.sizesIn) );
            pointsToSplit = this.breakpoints( this.breakpoints <= ceilingsIn(end) );
            allCeilings = unique( [ ceilingsIn, pointsToSplit ] );
            recorded = false(size(allCeilings));
            
            % split factors by ceilings
            for ii = 1:numel(ceilingsIn)
                iThisFactor = find( (allCeilings <= ceilingsIn(ii)) & ~recorded );
                this.splitTypes(iThisFactor) = repmat( this.typesIn(ii), size(iThisFactor) );
                this.splitColors(iThisFactor) = repmat( colorsToUse(ii), size(iThisFactor) );
                recorded(iThisFactor) = true;               
            end
            
            % turn ceilings into factors
            denominators = [1, allCeilings(1:(end-1))];
            this.splitSizes = num2cell( allCeilings ./ denominators );
        
        % function end
        end        
        
               
    % end of methods           
    end

% end of class       
end

