classdef synthesizeGrid  < handle
    
    properties     
        areaFacSizes
        areaFacTypes
        roundness
        grid
        ignoreFreeSky = true
        sizesAreIntegers
        roundoffQty = 1e-9
    end

    
    methods
        
        % constructor
        function this = synthesizeGrid()
        end 
        

        % 
        function synthesize(this)
            
            if this.ignoreFreeSky
                iLastEven = find(ismember(this.areaFacTypes,'plenary'),1,'last');
                validSizes = this.areaFacSizes(1:iLastEven);
                validTypes = this.areaFacTypes(1:iLastEven);              
            else
                validSizes = this.areaFacSizes;
                validTypes = this.areaFacTypes;
            end
         
            % check whether all are integers
            if allEntriesAreIntegers(cell2mat(validSizes), this.roundoffQty)
                this.sizesAreIntegers = true;
            else
                this.sizesAreIntegers = false;
                return
            end               
            
            screenPattern = patternFromFacs( validSizes, validTypes );
            roundPattern = patternFromFacs( { this.roundness }, {'plenary'} );
            this.grid = screenPattern * roundPattern.';
        
        % function end
        end        


               
    % end of methods           
    end

% end of class       
end

