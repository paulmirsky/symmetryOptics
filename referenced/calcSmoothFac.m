classdef calcSmoothFac < handle
    
    properties
        staticSizes
        staticTypes = {}
        liveSizes
        liveTypes = {}
        screenSizes
        screenTypes = {}
        roundSizes
        roundTypes = {}
        roundness
        
    end
    
    
    methods
        
        % constructor
        function this = calcSmoothFac()
        % constructor end
        end 
        
        

        %
        function calc(this)              
            
            % break static and live into ranks
            staticBreaks = cumprod( cell2mat(this.staticSizes) );
            liveBreaks = cumprod( cell2mat(this.liveSizes) );
            staticRanks = splitFacChain;
            staticRanks.sizesIn = this.staticSizes;
            staticRanks.typesIn = this.staticTypes;
            staticRanks.breakpoints = liveBreaks;
            staticRanks.split(); 
            liveRanks = splitFacChain;
            liveRanks.sizesIn = this.liveSizes;
            liveRanks.typesIn = this.liveTypes;
            liveRanks.breakpoints = staticBreaks;
            liveRanks.split();             
            % verify that static and live sizes agree.
            trimmedStaticSizes = staticRanks.splitSizes(1:numel(liveRanks.splitSizes));
            if ~isequal( trimmedStaticSizes, liveRanks.splitSizes )
                % if this ever occurs, there is a fragility in the algorithm
                error('static and live ranks do not match!'); 
            end
            this.screenSizes = staticRanks.splitSizes;
            this.roundSizes = staticRanks.splitSizes;
            
            % go through all ranks, and determine plenary / singular for each
            for ii = 1:(numel(staticRanks.splitSizes))
                if ( ii > numel(liveRanks.splitSizes) )
                    this.screenTypes{ii} = staticRanks.splitTypes{ii};
                    this.roundTypes{ii} = 'singular';
                    continue;
                end
                bothTypes = sort({ staticRanks.splitTypes{ii}, liveRanks.splitTypes{ii} });
                if ( strcmp(bothTypes,{'plenary','plenary'}) )
                    this.screenTypes{ii} = 'plenary';
                    this.roundTypes{ii} = 'plenary';
                elseif ( strcmp(bothTypes,{'singular','singular'}) )
                    this.screenTypes{ii} = 'singular';
                    this.roundTypes{ii} = 'singular';
                elseif ( strcmp(bothTypes,{'plenary','singular'}) )
                    this.screenTypes{ii} = 'plenary';
                    this.roundTypes{ii} = 'singular';
                else
                    error('invalid case!');
                end
            end
            
            % calculate roundness
            roundIsEven = ismember(this.roundTypes,'plenary');
            roundSizesMat = cell2mat(this.roundSizes);
            this.roundness = prod(roundSizesMat(roundIsEven));
        
        % function end
        end    



        % 
        function combineRepeated(this)
        
            % combine repeated types
            for ii = 1:2 % 1 is for area, 2 is for roundness
                
                if (ii==1)
                    oldSizes = this.screenSizes;
                    oldTypes = this.screenTypes;
                elseif (ii==2)
                    oldSizes = this.roundSizes;
                    oldTypes = this.roundTypes;
                end

                newTypes = {};
                newSizes = {};
                previousType = oldTypes{1};
                cumulativeSize = 1;
                for jj = 1:numel(oldTypes)
                    if ~strcmp( oldTypes{jj}, previousType )
                        newTypes{end+1} = previousType;
                        newSizes{end+1} = cumulativeSize;
                        previousType = oldTypes{jj};
                        cumulativeSize = oldSizes{jj};
                    else
                        cumulativeSize = cumulativeSize * oldSizes{jj};
                    end
                end
                newTypes{end+1} = previousType;
                newSizes{end+1} = cumulativeSize;
                
                if (ii==1)
                    this.screenSizes = newSizes;
                    this.screenTypes = newTypes;
                elseif (ii==2)
                    this.roundSizes = newSizes;
                    this.roundTypes = newTypes;
                end
                
            end
       
        % function end
        end  
               

        
        
    % end of methods           
    end

% end of class       
end

