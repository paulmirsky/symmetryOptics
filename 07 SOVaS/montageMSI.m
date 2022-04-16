classdef montageMSI  < handle
    
    properties
        % input values
        a
        b
        c
        d
        fLens = inf % in wavelengths
        plotAx
        coincidence
        % calc and plot objects
        drawSTG
        calcLiveOb
        STG
        drawScreenPattern
        % misc values
        zeroCutoff = 1
        infCutoff = 1e20
        darkColor
        brightColor
        specifiedWidth
        % options
        showXAxis = true
        useLens = false
        useSpecifiedWidth = false
        centerOdd = true
        unitStripeCoincs = true
        % calc results
        screenPattFacSizes
        lensDemag
        coincMag
        coincidenceCalcFailed
        % output
        zImage % if using lens, where the image lies
        
    end
    
    
    methods
        
        % constructor
        function this = montageMSI()

            colors = colorKit();
            this.darkColor = colors.darkSpaceColor;
            this.brightColor = colors.get('red');
            
            % set up objects
            this.calcLiveOb = calcLive();

            this.STG = sourceTargetGrid();

            this.drawScreenPattern = drawContinuousFeaturesSpatial();
            
            this.drawSTG = drawDiscreteSpatial();
            this.drawSTG.markerHeightFrac = 1;
            this.drawSTG.markerWidthFrac = 1;
            this.drawSTG.centerPattern = true;
            this.drawSTG.drawDark = false;
            this.drawSTG.centerByWholePatch = false;
            
        % constructor end
        end 
        
        
        
        % 
        function calcScreenPatt(this, Z)
            
            % initialize
            this.lensDemag = 1;
            this.coincMag = 1;
            this.coincidenceCalcFailed = false;
            
            if ( Z < this.zeroCutoff )
                % in this case, the pattern is the pattern at the flat
                this.screenPattFacSizes = { this.a, this.b, this.c, this.d };
            elseif ( ( Z > this.infCutoff ) && this.useLens )
                % use reverse-rank, invert-type rule
                % types are not explicitly calculated, they are assumed as {p,s,p,s}
                d_effective = this.fLens / (this.a*this.b*this.c);
                if ( d_effective < 1 )
                    error('fLens must be larger than array!');
                end                
                this.screenPattFacSizes = { d_effective, this.c, this.b, this.a };
            else
                % calculate live
                staticSizes = { this.a, this.b, this.c, this.d };
                staticTypes = { 'plenary', 'singular', 'plenary', 'singular' };
                this.calcLiveOb.staticSizes = staticSizes;
                this.calcLiveOb.staticTypes = staticTypes;
                this.calcLiveOb.calcLiveAtZ(Z);

                % discrete-factor model
                this.coincidenceCalcFailed = false;
                if (this.coincidence)
                    try
                        if this.unitStripeCoincs % calculate live differently
                            staticSizesUnitStripe = staticSizes;
                            staticSizesUnitStripe{1} = 1; % set a = 1
                            calcLiveUnitStripe = calcLive();                            
                            calcLiveUnitStripe.staticSizes = staticSizesUnitStripe;
                            calcLiveUnitStripe.staticTypes = staticTypes;
                            Z_for_coinc = Z / this.a^2; % change Z
                            calcLiveUnitStripe.calcLiveAtZ(Z_for_coinc);
                            this.coincMag = this.a; % magnify by a later
                            staticPattern = patternFromFacs( staticSizesUnitStripe(1:3), staticTypes(1:3) ); % only 1:3 cause non-integer d breaks it
                            livePattern = patternFromFacs( calcLiveUnitStripe.liveSizes, calcLiveUnitStripe.liveTypes );
                        else
                            staticPattern = patternFromFacs( staticSizes, staticTypes );
                            livePattern = patternFromFacs( this.calcLiveOb.liveSizes, this.calcLiveOb.liveTypes );
                        end
                        this.STG.staticPattern = staticPattern;
                        this.STG.livePattern = livePattern;
                        this.STG.calc();
                    catch
                        this.coincidenceCalcFailed = true;
                    end
                end

                % continuous-factor model
                if (~this.coincidence || this.coincidenceCalcFailed)
                    % calculate ceiling widths from factor chain sizes
                    staticCeilings = cumprod( cell2mat(staticSizes) );
                    liveCeilings = cumprod( cell2mat(this.calcLiveOb.liveSizes) );

                    % split the chains
                    splitLive = splitFacChain();
                    splitLive.sizesIn = this.calcLiveOb.liveSizes;
                    splitLive.typesIn = this.calcLiveOb.liveTypes;
                    splitLive.breakpoints = staticCeilings;
                    splitLive.split();
                    splitStatic = splitFacChain();
                    splitStatic.sizesIn = staticSizes;
                    splitStatic.typesIn = staticTypes;
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
                    this.screenPattFacSizes = synthCalcChain.screenPattSizes;
                end
                
                % get lens correction
                if ( ( Z > this.fLens ) && this.useLens )
                    % calculate with thin-lens formula.  assume lens is located at fLens, i.e its front focal plane is at 0
                    a_dist = this.fLens - Z;
                    denom = (1/this.fLens) - (1/a_dist);
                    b_dist = 1 / denom;
                    this.zImage = this.fLens + b_dist;
                    this.lensDemag = -1 * b_dist / a_dist;
                end
                
            end
            
        % function end
        end
        
        
        
        % 
        function draw(this)
            
            % plot
            if (this.coincidence && ~this.coincidenceCalcFailed)
                this.plotAx.Color = this.darkColor;
                this.drawSTG.axObj = this.plotAx;
                this.drawSTG.trimDark = true;
                this.drawSTG.showXAxis = this.showXAxis;
                this.drawSTG.patchScale = this.lensDemag * this.coincMag;
                this.drawSTG.drawPattern(this.STG.screenPattern, 0, this.brightColor);                
            else
                % draw spatial screen pattern
                this.drawScreenPattern.a = this.screenPattFacSizes{1} * this.lensDemag;
                this.drawScreenPattern.b = this.screenPattFacSizes{2};
                if (numel(this.screenPattFacSizes) > 2)
                    this.drawScreenPattern.c = this.screenPattFacSizes{3};
                    this.drawScreenPattern.d = this.screenPattFacSizes{4};
                    this.drawScreenPattern.centerOdd = this.centerOdd;
                else
                    this.drawScreenPattern.centerOdd = true;
                end
                this.drawScreenPattern.ax = this.plotAx;
                this.drawScreenPattern.showXAxis = this.showXAxis;
                this.drawScreenPattern.clipExcessDark = false;
                this.drawScreenPattern.brightColor = this.brightColor;
                this.drawScreenPattern.darkColor = this.darkColor;
                this.drawScreenPattern.drawIt();                
            end
            
            if this.useSpecifiedWidth
                wideLimit = this.specifiedWidth;
            elseif this.useLens
                wideLimit = this.fLens;
            else
                wideLimit = this.a * this.b * this.c * this.d;
            end
            this.plotAx.XLim = 0.5 * [-1 1] * wideLimit;
            this.plotAx.YColor = 'none';            
            
        end
        
               
    % end of methods           
    end

% end of class       
end

