classdef calcLive < handle
    
    properties
        staticSizes
        staticTypes
        liveSizes
        liveTypes
        reportNewSprouts = false
        allowedErrorFromUnity = 1e-9
    end

    
    methods
        
        % constructor
        function this = calcLive()
            % 
        % constructor end
        end 


        function calcLiveAtZ(this,targetZ)
            
            % validate inputs
            if ~( numel(this.staticSizes)==numel(this.staticTypes) )
                error('fac size vectors and fac type vectors must have the same dimensions!');
            end            
            if ( targetZ > prod(cell2mat(this.staticSizes)) )
                error('z is larger than total space size! increase factor d.');
            end
            if ( targetZ < 1 )
                error('z can not be less than 1!');
            end

            % initialize 
            subchainProduct = 1;
            iFactor = 1;
            newSprout = false;            
            if ( targetZ == 1 ) % this breaks the expected flow of the algorithm
                iFactor = 1;
                newSprout = true;
            end
            
            while( subchainProduct < targetZ )       
                
                leftToGo = (targetZ / subchainProduct); % how much more is needed
                if ( abs(1-leftToGo) < this.allowedErrorFromUnity )
                    break;
                end
                thisStaticSize = this.staticSizes{iFactor};
                if ( thisStaticSize < leftToGo )
                    newLinkSize = thisStaticSize; % if you can include the whole factor, do it
                elseif ( (thisStaticSize==leftToGo) && this.reportNewSprouts )
                    newLinkSize = thisStaticSize;
                    newSprout = true;
                else 
                    newLinkSize = leftToGo; % otherwise, just take a sub-factor
                end
                
                % build a list of factors, according to static order
                subchainSizes{iFactor} = newLinkSize;
                subchainTypes(iFactor) = this.staticTypes(iFactor); 
                
                % update product
                subchainProduct = subchainProduct * newLinkSize;
                iFactor = iFactor + 1; % go to next factor
                
            end
            
            % add a new-sprouted factor, if applicable
            if ( newSprout && (iFactor <= numel(this.staticSizes) ) )
                subchainSizes{iFactor} = 1;
                subchainTypes(iFactor) = this.staticTypes(iFactor); 
            end
            
            % reverse rank chain, invert type
            this.liveSizes = fliplr(subchainSizes);
            this.liveTypes = fliplr( invertFacType(subchainTypes));
            
        end        

  
        
    % end of methods           
    end

% end of class       
end

