classdef sourceTargetGrid  < handle
    
    properties        
        staticPattern
        livePattern
        stg
        screenPattern
        distribution
    end

    
    methods
        
        % constructor
        function this = sourceTargetGrid()
            % 
        % constructor end
        end 

        
        
        
        % 
        function calc(this)
            
            % create STG.  for each source patch, place an entire instance of live           
            nStaticPatches = numel(this.staticPattern);
            nLivePatches = numel(this.livePattern);
            nTargetPoints = nStaticPatches + nLivePatches - 1;
            xSources = find( this.staticPattern );
            nSources = numel( xSources );
            this.stg = zeros([nTargetPoints,nSources]);
            for ii = 1:nSources    
                liveStart = xSources(ii);
                liveEnd = liveStart + numel(this.livePattern) - 1;
                this.stg(liveStart:liveEnd,ii) = this.livePattern;     
            end

            % reduce to area pattern
            this.screenPattern = ( sum(this.stg,2) >= 1 );
            
            % create the areaRoundnessGrid
            roundness = sum(this.stg,2);
            maxRoundness = max(roundness);
            this.distribution = zeros([ size(this.stg,1), maxRoundness ]);
            for jj = 1:size(this.distribution,1)
                roundPoints = 1:roundness(jj);
                this.distribution(jj, roundPoints ) = 1;               
            end            
            
        % function end
        end
        
        
               
    % end of methods           
    end

% end of class       
end

