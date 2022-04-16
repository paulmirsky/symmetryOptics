classdef continuousDistribFromChains < handle
    
    properties
        staticSizes
        staticTypes = {}
        liveSizes
        liveTypes = {}
        screenPattSizes % these are also the round sizes
        screenPattTypes = {}
        roundSizes = {}
        roundTypes = {}
        roundness
        
        
    end
    
    
    methods
        
        % constructor
        function this = continuousDistribFromChains()
        % constructor end
        end 
        
        
        

        %
        function synthesize(this)              

            % validate inputs
            if ( numel(this.staticSizes) < numel(this.liveSizes) )
                error('static chain must have at least as many links as the live chain!');
            end
            if ~isequal( this.liveSizes, this.staticSizes(1:numel(this.liveSizes)) )
                error('static and live chains must have the same (split) breakpoints!');
            end
            
            this.screenPattSizes = this.staticSizes;
            this.roundSizes = this.staticSizes;

            for ii = 1:numel(this.staticSizes)
                
                % count plenary factors at this rank
                nPlenaryThisRank = 0;
                if strcmp( this.staticTypes{ii}, 'plenary' )
                    nPlenaryThisRank = nPlenaryThisRank + 1;
                end
                if ( ii <= numel(this.liveTypes) )
                    if strcmp( this.liveTypes{ii}, 'plenary' )
                        nPlenaryThisRank = nPlenaryThisRank + 1;
                    end
                end
                % determine type accordingly
                if ( nPlenaryThisRank==0 )
                    this.screenPattTypes{ii} = 'singular';
                    this.roundTypes{ii} = 'singular';
                elseif ( nPlenaryThisRank==1 )
                    this.screenPattTypes{ii} = 'plenary';
                    this.roundTypes{ii} = 'singular';
                elseif ( nPlenaryThisRank==2 )
                    this.screenPattTypes{ii} = 'plenary';
                    this.roundTypes{ii} = 'plenary';
                else
                    error('invalid case!');
                end
                
            end
            
            % calculate roundness
            roundIsEven = ismember(this.roundTypes,'plenary');
            roundSizesMat = cell2mat(this.screenPattSizes); % factor sizes are the same
            this.roundness = prod(roundSizesMat(roundIsEven));            
            
        % function end
        end    


        
        % 
        function combineRepeated(this)
        
            [ this.screenPattSizes, this.screenPattTypes ] =...
                this.mergeAdjacent( this.screenPattSizes, this.screenPattTypes );
            [ this.roundSizes, this.roundTypes ] = this.mergeAdjacent( this.roundSizes, this.roundTypes );
            
        % function end
        end  
            
        
        
        % 
        function [mergedSizes, mergedTypes] = mergeAdjacent(this, sizesIn, typesIn)
        
            % combine repeated types
            newTypes = {};
            newSizes = {};
            previousType = typesIn{1};
            cumulativeSize = 1;
            for ii = 1:numel(typesIn)
                if ~strcmp( typesIn{ii}, previousType )
                    newTypes{end+1} = previousType;
                    newSizes{end+1} = cumulativeSize;
                    previousType = typesIn{ii};
                    cumulativeSize = sizesIn{ii};
                else
                    cumulativeSize = cumulativeSize * sizesIn{ii};
                end
            end
            newTypes{end+1} = previousType;
            newSizes{end+1} = cumulativeSize;
            mergedTypes = newTypes;
            mergedSizes = newSizes;
       
        % function end
        end  
            
        
        
        
        
        
        
        

        
        
    % end of methods           
    end

% end of class       
end

