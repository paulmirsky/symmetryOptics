classdef gaussianGrating  < handle
    
    properties

        % feature size params, all in meters
        wavelength
        stripe
        period % give it an approx val, code changes it to exact.  
        array
        lensFL % give it an approx val, code changes it to exact
        
        % input state
        arrayAngle = 0
        stripeAngle = 0
        arrayShift = 0
        stripeShift = 0
        
        % objects
        plotFig
        magInAx
        magOutAx
        phaseInAx
        phaseOutAx
        
        % data
        xVals
        stateFrontFlat
        stateRearFlat
        xMax
        arrayIn
        stripeIn
        arrayOut
        stripeOut
        
        % misc params
        nSigmaForArray = 3
        sizeToSigma = sqrt(2)/4
        
        % display params
        figLLCornerXY = [100 100] % in px
        figSizeXY = [1400 800] % in px
        showPhaseCutoff = .001
        scaleArrayCutoff = .001
        peakHeightRatio = 0.95
        arrayColor = 0.7*[1 1 1]
        magColor = [1 0 0]
        phaseColor = [45 135 240]/255
        lensColor = [91 155 213]/255
        arrayLineWidth = 2
        phaseLineWidth = 2
        shiftLineWidth = 1
        lensEdge = 0.85 % at 1, it covers none of the lens        
%         labelXFactor = 0.96
%         labelYFactor = 0.82
%         labelColor = 0.6*[1 1 1]
        fontSize = 12
        labelXmax = true 

    end

    
    methods
        
        % constructor
        function this = gaussianGrating()
            
            % just a constructor.  gives user the opportunity to set values
            % that are different from default
            
        % constructor end
        end 
        
        
        
        % calculates the stateFrontFlat from the parameters that were already set
        function calcFrontFlat(this)
            
            % get exact vals, integral nPatches
            nPatchesPerPeriod = round( this.period/this.wavelength );
            this.period = nPatchesPerPeriod * this.wavelength;
            nPatchesTotal = round( this.lensFL/this.wavelength );
            this.lensFL = nPatchesTotal * this.wavelength;
            
            % create array
            this.xVals = this.wavelength * ( (1:nPatchesTotal).' - floor(nPatchesTotal/2) );                   
            arraySigma = this.array * this.sizeToSigma;
            this.arrayIn = exp( -1*( (this.xVals-this.arrayShift).^2) / (2*(arraySigma^2)) ) / sqrt(2*pi*arraySigma^2);
            
            % create stripe
            nSmallsPerSide = ceil( this.nSigmaForArray * arraySigma / this.period );
            stripeSigma = this.stripe * this.sizeToSigma;
            stripeFunction = zeros([nPatchesTotal,1]);
            for ii = (-1*nSmallsPerSide):nSmallsPerSide                
                thisCenter = ii * this.period;                
                theseXVals = this.xVals - thisCenter - this.stripeShift;    
                stripeAmp =  exp( -1*(theseXVals.^2)/(2*(stripeSigma^2)) ) / sqrt(2*pi*stripeSigma^2);                
                stripePhase = exp( this.stripeAngle * 1i * theseXVals  / this.wavelength  );
                thisTerm = stripeAmp .* stripePhase;
                if ii==0
                    this.stripeIn = thisTerm;
                end
                % add contribution from array
                discreteArrayPhase = exp( this.arrayAngle * 1i * (thisCenter-this.arrayShift) / this.wavelength );
                thisTerm = thisTerm * discreteArrayPhase;
                stripeFunction = stripeFunction + thisTerm;
            end

            % combine stripe and array
            this.stateFrontFlat = this.arrayIn .* stripeFunction; 
            
        % function end
        end        
      


        % 
        function calcRearFlat(this)

            % get the FT
            stateOut = ifftshift( this.stateFrontFlat );
            stateOut = fft(stateOut);
            this.stateRearFlat = flipud(fftshift(stateOut));     
            
            % FT for stripe and array
            stripeOut = ifftshift(this.arrayIn);
            stripeOut = fft(stripeOut);
            this.stripeOut = flipud(fftshift(stripeOut));     
                        
            arrayOut = ifftshift(this.stripeIn);
            arrayOut = fft(arrayOut);
            this.arrayOut = flipud(fftshift(arrayOut));     
            
        % function end
        end        

           

        % 
        function startFig(this)
        
            % create figure
            this.plotFig = figure('Position',[ this.figLLCornerXY, this.figSizeXY ],'Color','white');  
            
            % create axes
            this.magInAx = subplot(5,1,5,'parent',this.plotFig);
            this.phaseInAx = subplot(5,1,4,'parent',this.plotFig);
            this.magOutAx = subplot(5,1,2,'parent',this.plotFig);
            this.phaseOutAx = subplot(5,1,1,'parent',this.plotFig);
            
            % draw the lens
            lensAx = subplot(5,1,3,'parent',this.plotFig);
            rectangle('position',[-1 -1 2 2],'parent',lensAx,'FaceColor',this.lensColor,'Curvature',[1 1],...
                'EdgeColor','none');
            rectangle('position',[-1 -1 (1-this.lensEdge) 2],'parent',lensAx,'FaceColor',[1 1 1],'EdgeColor','none');
            rectangle('position',[this.lensEdge -1 (1-this.lensEdge) 2],'parent',lensAx,'FaceColor',[1 1 1],'EdgeColor','none');
            set(lensAx,'XLim',[-3 3],'YLim',[-3 3],'XColor',[1 1 1],'YColor',[1 1 1]);
            
        % function end
        end
        
        
        
        % 
        function draw(this, state, planeTag)
        
            % handle which plane it is
            if strcmp(lower(planeTag),'front')
                magAx = this.magInAx;
                phaseAx = this.phaseInAx;
                xLims = this.xMax * [-1 1];
                array = this.arrayIn;
            elseif strcmp(lower(planeTag),'rear')
                magAx = this.magOutAx;
                phaseAx = this.phaseOutAx;
                xLims = this.xMax * [-1 1];
                array = this.arrayOut;
            end            

            % get mag and array
            signal = abs(state).^2;
            array = abs(array).^2;
            % scale it
            badOnes = array < max(array)*this.scaleArrayCutoff; % find the invalid points
            theRatio = signal./array;
            theRatio(badOnes) = 0;
            scaleFac = max(theRatio);
            array = array * scaleFac;
            
            % find good phases
            phases = angle(state);
            signalCutoff = max(signal) * this.showPhaseCutoff;
            phaseValid = signal >= signalCutoff;
            validPhaseXs = this.xVals;
            validPhaseXs(~phaseValid) = nan;
            validPhases = phases;
            validPhases(~phaseValid) = nan;
            phaseJumps = (diff(validPhases) > 6) | (diff(validPhases) < -6);
            phaseJumps = [false; phaseJumps];
            validPhases(phaseJumps) = nan;
            
            % plot the mag and array
            plot( this.xVals, array, 'parent', magAx, 'Color', this.arrayColor,... 
                'LineWidth', this.arrayLineWidth );
            hold(magAx,'on')
            set(magAx,'fontSize',this.fontSize);
            area(magAx,this.xVals,signal,'FaceColor', this.magColor,'EdgeColor','none')
            title(magAx, [planeTag,' flat, magnitude'],'fontSize',this.fontSize);
            
            % scale etc.
            if isempty(xLims)
                xLims = magAx.XLim;
            end
            set(magAx,'XLim',xLims,'YTick',[] );
            if this.labelXmax
                set(magAx,'XTick',[ xLims(1), 0, xLims(2)]);
            else
                set(magAx,'XTick',[]);
            end
            plotPeak = max(array) / this.peakHeightRatio;
            line( [0 0], [0 plotPeak], 'parent', magAx, 'Color', 'black',... 
                'LineWidth', this.shiftLineWidth );
            magAx.YLim(2) = plotPeak;
            hold(magAx,'off')
            
            % plot the phase
            plot( validPhaseXs, validPhases, 'parent', phaseAx, 'Color', this.phaseColor,... 
                'LineWidth', this.phaseLineWidth );
            set(phaseAx,'YLim',pi*[-1 1],'XTick',[],'YTick',[-1 0 1]*pi,'YTickLabel',...
                {'-\pi','0','\pi'},'XLim',xLims);
            set(phaseAx,'fontSize',this.fontSize);
            title(phaseAx, [planeTag,' flat, phase'],'fontSize',this.fontSize);
            
        % function end
        end
         

        
    % end of methods           
    end

    
% end of class       
end

