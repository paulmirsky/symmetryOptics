classdef SnS_model  < handle
    
    properties
        factors = {}
        xforms = {}
        frontFactors = {}
        showArrayOnly
        
    end
    properties (Access = 'private')
    end

    
    methods
        
        
        % constructor
        function this = SnS_model()
        % constructor end
        end 
                
        
        
        %
        function clearObject(this)
            
            this.factors = {};
            this.xforms = {};
            this.frontFactors = {};
            
        % function end
        end
        
               
        
        %
        function addFactorAndXform(this, size, type)
            
            nFactorsNow = numel(this.factors);
            
            % add new factor
            thisFac = opFactor();
            thisFac.size = size;
            thisFac.type = type;
            thisFac.calcAll();
            this.factors{nFactorsNow + 1} = thisFac;
            
            % add corresponding new transformation
            thisOp = xforms();
            thisOp.size = size;
            thisOp.calcAll();
            this.xforms{nFactorsNow + 1} = thisOp;
            
        % function end
        end
                   
        
                       
        % 
        function setFrontFactorState(this, indices)
            
            nFactors = numel(indices);
            this.frontFactors = cell(1,nFactors); % initialize
            for ii = 1:nFactors
                if indices{ii} > this.factors{ii}.size
                    errorMsg = ['index ', num2str(indices{ii}), ' is out of range 1-',...
                        num2str(this.factors{ii}.size) ];
                    error(errorMsg);
                end
                this.frontFactors{ii} = this.factors{ii}.states{indices{ii}};
            end
            
        % function end
        end            
        
        
        
        % 
        function applyXform(this, whichXform, iXform)
            
            % choose the appropriate transformation
            thisXformSet = this.xforms{iXform};
            if strcmp(whichXform,'tilt')
                thisXform = thisXformSet.tilt;
            elseif strcmp(whichXform,'slide')
                thisXform = thisXformSet.slide;
            elseif strcmp(whichXform,'phase')
                thisXform = thisXformSet.phase;
            else
                error('invalid transformation tag!');
            end
            
            % apply the transformation to the front factors
            this.frontFactors{iXform} = thisXform * this.frontFactors{iXform};
            
        % function end
        end            
        
      
                
        % 
        function [frontFactors, pattern] = calcFrontFlat(this)
            
            pattern = this.calcDirectProduct(this.frontFactors);
            frontFactors = this.frontFactors;
            
        % function end
        end            
        
                
        
        % 
        function [rearFactors, pattern] = calcRearFlat(this)
            
            nFactors = numel(this.frontFactors);
            rearFactors = cell(1,nFactors); % initialize
            for ii = 1:nFactors
                thisStateFront = this.frontFactors{ii};
                thisFacType = this.factors{ii}.type;
                thisStateFT = doFT(thisStateFront,thisFacType); % take FT of each factor
                rearFactors{ nFactors + 1 - ii } = flipud(thisStateFT); % reverse rank order, also reverse individual factor.
            end
            pattern = this.calcDirectProduct(rearFactors);
            
        % function end
        end           
      
        
        
        %
        function stateIndex = indexFromVal(this, iFactor, thisVal)
            
            allValues = this.factors{iFactor}.values;
            stateIndex = find( allValues==thisVal, 1, 'first');
            
        % function end
        end            
        
        
         
        % 
        function pattern = calcDirectProduct(this, factorArray)

            nFacs = numel(factorArray);
            pattern = 1;
            for ii = 1:nFacs % for each factor...
                if ( this.showArrayOnly && (ii==4) ) % only for grating, 4th factor
                    continue
                end
                thisFacVec = factorArray{ii}(:);
                pattern = reshape(pattern * thisFacVec.', length(thisFacVec)*length(pattern), 1); % flatten
            end            
            
        % function end
        end            
        
                    
    % end of methods           
    end

% end of class       
end

