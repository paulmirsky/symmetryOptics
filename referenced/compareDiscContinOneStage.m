classdef compareDiscContinOneStage < handle
    
    properties
        a
        b
        c
        stageStartZ
        zIncreases
        plotAx
        maxRoundness = []
        distribPlotHeight = 0.4
        maxRoundnessLastDraw % check this *after drawing
        farLimitExtra = 1.1 % 1.1, it needs this at far limit when a = 1
    end
    
    
    methods
        
        % constructor
        function this = compareDiscContinOneStage()
        % constructor end
        end 
        
        
        
        % 
        function drawAll(this)

            staticSizesContin = { this.a, this.b, this.c, this.a*this.b*this.c*this.farLimitExtra }; 
            staticSizesDisc = { this.a, this.b, this.c, 1 };
            staticTypes = { 'plenary', 'singular', 'plenary', 'singular' };
            staticCeilings = cumprod( cell2mat(staticSizesContin) );

            if isempty( this.maxRoundness )
                maxRound = this.a * this.c;
            else
                maxRound = this.maxRoundness;
            end
            inPlaneScale = this.stageStartZ * this.distribPlotHeight / maxRound;
            this.maxRoundnessLastDraw = 0;
            
            % screen figures / axes
            colors = colorKit();
            drawDistribs = drawDiscreteSpatial;
            drawDistribs.axObj = this.plotAx;
            drawDistribs.markerWidthFrac = 0.70;
            drawDistribs.markerHeightFrac = 0.85;
            drawDistribs.centerPattern = true;
            drawDistribs.trimDark = true;
            drawDistribs.centerByWholePatch = false;
            drawDistribs.inPlaneScale = inPlaneScale;

            % set up live calc
            calcLiveObj = calcLive();
            calcLiveObj.staticSizes = staticSizesContin;
            calcLiveObj.staticTypes = staticTypes;
            
            % set up the STG
            stg = sourceTargetGrid();
            staticPattern = patternFromFacs( staticSizesDisc, staticTypes );
            stg.staticPattern = staticPattern;
            drawDistribs.drawPattern(staticPattern, 0, colors.sourceColor);
            
            % set up split objects
            splitLive = splitFacChain();
            splitLive.breakpoints = staticCeilings;
            splitStatic = splitFacChain();
            splitStatic.sizesIn = staticSizesContin;
            splitStatic.typesIn = staticTypes;
            
            for ii = 1:numel(this.zIncreases)

                thisIncrease = this.zIncreases(ii);
                thisZ = thisIncrease * this.stageStartZ;
                calcLiveObj.calcLiveAtZ(thisZ);   
                if ~allEntriesAreIntegers(cell2mat(calcLiveObj.liveSizes),1e-9)
                    disp('can not calculate pattern! not all factor sizes are integers');
                    continue
                end
                
                % draw discrete pattern
                livePattern = patternFromFacs( calcLiveObj.liveSizes, calcLiveObj.liveTypes );
                stg.livePattern = livePattern;
                stg.calc();
                drawDistribs.invertDirection = false;
                drawDistribs.drawPattern(stg.distribution, thisZ+inPlaneScale/2, colors.get('red'));
                               
                % draw continuous pattern

                % split the chains
                splitLive.sizesIn = calcLiveObj.liveSizes;
                splitLive.typesIn = calcLiveObj.liveTypes;
                splitLive.split();
                liveCeilings = cumprod( cell2mat(calcLiveObj.liveSizes) );
                splitStatic.breakpoints = liveCeilings;
                splitStatic.split();

                % calculate screen pattern and roundness
                synthCalcChain = continuousDistribFromChains();
                synthCalcChain.staticSizes = splitStatic.splitSizes;
                synthCalcChain.staticTypes = splitStatic.splitTypes;
                synthCalcChain.liveSizes = splitLive.splitSizes;
                synthCalcChain.liveTypes = splitLive.splitTypes;
                synthCalcChain.synthesize();
                synthCalcChain.combineRepeated(); % recombine screen pattern
                
                % synthesize distribution
                if ( numel(synthCalcChain.screenPattSizes)==4 ) % most planes
                    facSizeChain = synthCalcChain.screenPattSizes(1:3);
                    facTypeChain = synthCalcChain.screenPattTypes(1:3);
                else % for core start and core end
                    facSizeChain = synthCalcChain.screenPattSizes(1);
                    facTypeChain = synthCalcChain.screenPattTypes(1);
                end
                if ~allEntriesAreIntegers(cell2mat(facSizeChain),1e-9)
                    disp('can not calculate pattern! not all factor sizes are integers');
                    continue
                end                
                if ~allEntriesAreIntegers(synthCalcChain.roundness,1e-9)
                    disp('can not calculate pattern! not all factor sizes are integers');
                    continue
                end                
                distribution = this.synthesizeDistrib(facSizeChain, facTypeChain, synthCalcChain.roundness);
                drawDistribs.invertDirection = true;
                drawDistribs.drawPattern(distribution, thisZ-inPlaneScale/2, colors.get('green'));
                
                % tally max roundness, to let you plot it better the next time
                this.maxRoundnessLastDraw = max( this.maxRoundnessLastDraw, synthCalcChain.roundness);
                
            end

            % fix up limits, tick marks, etc.
            allZs = [ 0, this.stageStartZ * this.zIncreases ];
            this.plotAx.YTick = allZs;
            edgeThk = maxRound*inPlaneScale;
            this.plotAx.YLim = [ 0-edgeThk, allZs(end) + edgeThk ];
            
        % function end
        end
        
               
        
        function distribution = synthesizeDistrib(~, facSizeChain, facTypeChain, roundness)

            areaPattern = patternFromFacs( facSizeChain, facTypeChain );
            roundPattern = patternFromFacs( { roundness }, {'plenary'} );
            distribution = areaPattern * roundPattern.';
        
        % function end
        end             
        
        
    % end of methods           
    end

% end of class       
end

