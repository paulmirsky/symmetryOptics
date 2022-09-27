classdef SnS_view < handle
    
    properties
        
        % objects
        controller % so you can get the controller from external programs        
        fig
        status
        rearPattern
        rearFactors
        frontPattern
        frontFactors            
        archetypeGroup
        controlModeGroup
        valA
        valB
        valC
        valD
        tiltA
        tiltB
        tiltC
        tiltD
        slideA
        slideB
        slideC
        slideD
        phaseA
        phaseB
        phaseC
        phaseD
        positionFactor
        angleFactor
        beam
        grating
        byValue
        byXform
        reset
        aux
        regenerate
        showRearFlat
        showPattern
        showArrayOnly
        auxSelection
        sizeA
        sizeB
        sizeC
        sizeD
        factorA
        factorB
        factorC
        factorD
        canvasDivider
        canvasFloor_normFig % this variable is is set at initialization. normed to vertical fig size

        % parameters
        factorSpacing = 2
        patternPatchColor = [255, 0, 0]/255 % red
        factorPointColor = [165, 75, 205]/255 % purple
        axesColor = [0, 0, 0]
        axesTitleColor = 0.2 * [1 1 1]
        drawZeroPhaseLine = false
      
        % screen- and model-dependent parameters
        figPosVec = [1 1 1000 600]
        font = 'Calibri'
        fontSize = 12
        defaultAxesWidth_normed = 0.7
        maxPatternPatchDrawnSize = .01 % in axis-widths.  May get smaller if the axis isn't wide enough
        maxFactorPointDrawnSize = .02 % in axis-widths.  May get smaller if the axis isn't wide enough
 
    end

    methods
  
        % class constructor
        function this = SnS_view() 
            % constructor
        end      

        
        % 
        function initialize(this)
            
            % create view
            allHandles = findall(0);
            existingFig = findobj(allHandles, 'FileName', which('SnS_Fig.fig'));
            if (size(existingFig)>0)
                close(existingFig);
            end
            
            % position figure
            this.fig = SnS_Fig('visible','off');
            this.fig.Units = 'pixels';
            this.fig.Position = this.figPosVec;
            this.fig.Visible = 'on';
            
            % gives the view the info re: how to close
            set(this.fig, 'UserData', {this, 'closefig'}); 
            set(this.fig, 'CloseRequestFcn', {'activateControllerGUI'});  
            
            % get objects that are part of the figure
            figChildrenList = get(this.fig, 'Children');
            this.status = findobj(figChildrenList,'Tag', 'status'); 
            this.rearPattern = findobj(figChildrenList,'Tag', 'rearPattern');
            this.rearFactors = findobj(figChildrenList,'Tag', 'rearFactors');
            this.frontPattern = findobj(figChildrenList,'Tag', 'frontPattern');
            this.frontFactors = findobj(figChildrenList,'Tag', 'frontFactors');
            this.archetypeGroup = findobj(figChildrenList,'Tag', 'archetypeGroup');
            this.controlModeGroup = findobj(figChildrenList,'Tag', 'controlModeGroup');
            this.valA = findobj(figChildrenList,'Tag', 'valA');
            this.valB = findobj(figChildrenList,'Tag', 'valB');
            this.valC = findobj(figChildrenList,'Tag', 'valC');
            this.valD = findobj(figChildrenList,'Tag', 'valD');
            this.tiltA = findobj(figChildrenList,'Tag', 'tiltA');
            this.tiltB = findobj(figChildrenList,'Tag', 'tiltB');
            this.tiltC = findobj(figChildrenList,'Tag', 'tiltC');
            this.tiltD = findobj(figChildrenList,'Tag', 'tiltD');
            this.slideA = findobj(figChildrenList,'Tag', 'slideA');
            this.slideB = findobj(figChildrenList,'Tag', 'slideB');
            this.slideC = findobj(figChildrenList,'Tag', 'slideC');
            this.slideD = findobj(figChildrenList,'Tag', 'slideD');
            this.phaseA = findobj(figChildrenList,'Tag', 'phaseA');
            this.phaseB = findobj(figChildrenList,'Tag', 'phaseB');
            this.phaseC = findobj(figChildrenList,'Tag', 'phaseC');
            this.phaseD = findobj(figChildrenList,'Tag', 'phaseD');
            this.positionFactor = findobj(figChildrenList,'Tag', 'positionFactor');
            this.angleFactor = findobj(figChildrenList,'Tag', 'angleFactor');
            this.beam = findobj(figChildrenList,'Tag', 'beam');
            this.grating = findobj(figChildrenList,'Tag', 'grating');
            this.byValue = findobj(figChildrenList,'Tag', 'byValue');
            this.byXform = findobj(figChildrenList,'Tag', 'byXform');
            this.reset = findobj(figChildrenList,'Tag', 'reset');
            this.aux = findobj(figChildrenList,'Tag', 'aux');
            this.regenerate = findobj(figChildrenList,'Tag', 'regenerate');
            this.showRearFlat = findobj(figChildrenList,'Tag', 'showRearFlat');
            this.showPattern = findobj(figChildrenList,'Tag', 'showPattern');
            this.showArrayOnly = findobj(figChildrenList,'Tag', 'showArrayOnly');
            this.auxSelection = findobj(figChildrenList,'Tag', 'auxSelection');
            this.sizeA = findobj(figChildrenList,'Tag', 'sizeA');
            this.sizeB = findobj(figChildrenList,'Tag', 'sizeB');
            this.sizeC = findobj(figChildrenList,'Tag', 'sizeC');
            this.sizeD = findobj(figChildrenList,'Tag', 'sizeD');
            this.factorA = findobj(figChildrenList,'Tag', 'factorA');
            this.factorB = findobj(figChildrenList,'Tag', 'factorB');
            this.factorC = findobj(figChildrenList,'Tag', 'factorC');
            this.factorD = findobj(figChildrenList,'Tag', 'factorD');
            this.canvasDivider = findobj(figChildrenList,'Tag', 'canvasDivider');
            this.canvasDivider.XTick = [];
            this.canvasFloor_normFig = this.canvasDivider.Position(2);
            this.setFont(this.fontSize, this.font);
            this.setAxesWidths(this.defaultAxesWidth_normed);
                        
        % function end
        end        
        
        
        
        % 
        function setButtonsEnabled(this, activeArchetype, activeControlMode)
            
            if strcmp(activeControlMode,'byValue')
                enableVals = 'on';
                enableXforms = 'off';
            elseif strcmp(activeControlMode,'byXform')
                enableVals = 'off';
                enableXforms = 'on';
            else
                error('invalid controlMode selection!');
            end            
            this.valA.Visible = enableVals;
            this.valB.Visible = enableVals;
            this.valC.Visible = enableVals;
            this.valD.Visible = enableVals;
            this.tiltA.Visible = enableXforms;
            this.tiltB.Visible = enableXforms;
            this.tiltC.Visible = enableXforms;
            this.tiltD.Visible = enableXforms;
            this.slideA.Visible = enableXforms;
            this.slideB.Visible = enableXforms;
            this.slideC.Visible = enableXforms;
            this.slideD.Visible = enableXforms;
            this.phaseA.Visible = enableXforms;
            this.phaseB.Visible = enableXforms;
            this.phaseC.Visible = enableXforms;
            this.phaseD.Visible = enableXforms;
            
            if ( strcmp(activeArchetype,'positionFactor') || strcmp(activeArchetype,'angleFactor') )
                enableB = false;
                enableCD = false;
            elseif strcmp(activeArchetype,'beam')
                enableB = true;
                enableCD = false;
            elseif strcmp(activeArchetype,'grating')
                enableB = true;
                enableCD = true;
            else
                error('invalid nFactors selection!');
            end
            if ~enableB
                this.valB.Visible = 'off';
                this.tiltB.Visible = 'off';
                this.slideB.Visible = 'off';
                this.phaseB.Visible = 'off';
            end
            if ~enableCD
                this.valC.Visible = 'off';
                this.valD.Visible = 'off';
                this.tiltC.Visible = 'off';
                this.tiltD.Visible = 'off';
                this.slideC.Visible = 'off';
                this.slideD.Visible = 'off';
                this.phaseC.Visible = 'off';
                this.phaseD.Visible = 'off';            
            end
            
        % function end
        end              
        

        
        % 
        function drawPattern(this, whichFlat, pattern )
            
            if strcmp(whichFlat,'frontFlat')
                thisAx = this.frontPattern;
            elseif strcmp(whichFlat,'rearFlat')
                thisAx = this.rearPattern;
            else
                error('invalid plane tag!');
            end 
            
            cla(thisAx);
            thisAx.XColor = this.axesColor;
            thisAx.YColor = this.axesColor;
            xMin = -1*length(pattern)/2;
            drawFeat = diagram;
            drawFeat.axObj = thisAx;
            drawFeat.brightColor = this.patternPatchColor;
            drawFeat.drawZeroPhaseLine = this.drawZeroPhaseLine;
            drawFeat.draw(xMin, pattern)
            drawFeat.setLimits(length(pattern),this.maxPatternPatchDrawnSize);
            ylabel(thisAx, 'Pattern', 'Color', this.axesTitleColor, 'Rotation', 0,... 
                'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
            drawFeat.setLabels({},[]);
            
        % function end
        end              
        
        
        
        % 
        function drawFactorChain(this, whichFlat, factorArray )
            
            allLabels = {'A','B','C','D'};
            allLabels = allLabels(1:numel(factorArray));
            
            if strcmp(whichFlat,'frontFlat')
                thisAx = this.frontFactors;
            elseif strcmp(whichFlat,'rearFlat')
                thisAx = this.rearFactors;
                allLabels = fliplr(allLabels); % reverse order
            else
                error('invalid plane tag!');
            end
            
            cla(thisAx);
            thisAx.XColor = this.axesColor;
            thisAx.YColor = this.axesColor;
            
            totalLength = this.factorSpacing * (numel(factorArray)-1);
            for ii = 1:numel(factorArray)
                totalLength = totalLength + numel(factorArray{ii});
            end
            
            xNow = -1*totalLength/2;
            drawFeat = diagram;
            drawFeat.axObj = thisAx;
            drawFeat.brightColor = this.factorPointColor;
            drawFeat.drawZeroPhaseLine = this.drawZeroPhaseLine;
            
            for ii = 1:numel(factorArray)
                thisFactor = factorArray{ii};
                drawFeat.draw(xNow, thisFactor);
                allLabelXs(ii) = xNow + numel(thisFactor)/2;
                xNow = xNow + numel(thisFactor) + this.factorSpacing;
            end
            
            drawFeat.setLabels(allLabelXs,allLabels);
            drawFeat.setLimits(totalLength,this.maxFactorPointDrawnSize);
            ylabel(thisAx, 'Factors', 'Color', this.axesTitleColor, 'Rotation', 0,... 
                'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
            
        % function end
        end              

        
        
        %
        function thisAx = getAxes(this, planeTag, typeTag)
            
            if strcmp(planeTag,'frontFlat')
                planeMatches = { this.frontPattern, this.frontFactors };
            elseif strcmp(planeTag,'rearFlat')
                planeMatches = { this.rearPattern, this.rearFactors };
            else
                error('invalid plane tag!');
            end

            if strcmp(typeTag,'pattern')
                typeMatches = { this.frontPattern, this.rearPattern };
            elseif strcmp(typeTag,'factors')
                typeMatches = { this.frontFactors, this.rearFactors };
            else
                error('invalid type tag!');
            end
            
            thisAx = intersect( planeMatches, typeMatches );
            
        % function end
        end
        

        
        % 
        function setFormat(this, showRearFlat, showPattern)
            
            this.clearAxes(this.rearPattern);
            this.clearAxes(this.rearFactors);
            this.clearAxes(this.frontPattern);
            this.clearAxes(this.frontFactors);
            
            if (~showRearFlat && ~showPattern)
                widthPerPlane_normCnvs = .5; % this could be split between factors and pattern, or not
                this.rearPattern.Visible = 'off';
                this.rearFactors.Visible = 'off';
                this.frontPattern.Visible = 'off';
                this.frontFactors.Visible = 'on';
                this.setCanvasToFig(this.frontFactors, -0.5*widthPerPlane_normCnvs, 0.5*widthPerPlane_normCnvs);
            elseif (~showRearFlat && showPattern)
                widthPerPlane_normCnvs = .6;
                this.rearPattern.Visible = 'off';
                this.rearFactors.Visible = 'off';
                this.frontPattern.Visible = 'on';
                this.frontFactors.Visible = 'on';
                this.setCanvasToFig(this.frontPattern, 0, 0.5*widthPerPlane_normCnvs);
                this.setCanvasToFig(this.frontFactors, -0.5*widthPerPlane_normCnvs, 0);
            elseif (showRearFlat && ~showPattern)
                widthPerPlane_normCnvs = .32;
                planeGap_normCnvs = .15;
                this.rearPattern.Visible = 'off';
                this.rearFactors.Visible = 'on';
                this.frontPattern.Visible = 'off';
                this.frontFactors.Visible = 'on';
                frontFigLow = -0.5*planeGap_normCnvs - widthPerPlane_normCnvs;
                frontFigHigh = frontFigLow + widthPerPlane_normCnvs;
                this.setCanvasToFig(this.frontFactors, frontFigLow, frontFigHigh);
                rearFigLow = 0.5*planeGap_normCnvs;
                rearFigHigh = rearFigLow + widthPerPlane_normCnvs;
                this.setCanvasToFig(this.rearFactors, rearFigLow, rearFigHigh);
            elseif (showRearFlat && showPattern)
                widthPerPlane_normCnvs = .33;
                planeGap_normCnvs = .15;
                % turn all on
                this.rearPattern.Visible = 'on';
                this.rearFactors.Visible = 'on';
                this.frontPattern.Visible = 'on';
                this.frontFactors.Visible = 'on';
                % get all starts
                rearPatt = 0.5*planeGap_normCnvs + 0.5*widthPerPlane_normCnvs;
                rearFac = 0.5*planeGap_normCnvs;
                frontPatt = -0.5*planeGap_normCnvs - 0.5*widthPerPlane_normCnvs;
                frontFac = -0.5*planeGap_normCnvs - widthPerPlane_normCnvs;
                % apply starts
                this.setCanvasToFig(this.rearPattern, rearPatt, rearPatt + 0.5*widthPerPlane_normCnvs);
                this.setCanvasToFig(this.rearFactors, rearFac, rearFac + 0.5*widthPerPlane_normCnvs);
                this.setCanvasToFig(this.frontPattern, frontPatt, frontPatt + 0.5*widthPerPlane_normCnvs);
                this.setCanvasToFig(this.frontFactors, frontFac, frontFac + 0.5*widthPerPlane_normCnvs);
            end
            
        % function end
        end              
        
        
        
        function setCanvasToFig(this, ax, minY_normCnvs, maxY_normCnvs)
        
            canvasHt_normFig = 1 - this.canvasFloor_normFig;
            centerline_normFig = this.canvasFloor_normFig + 0.5*canvasHt_normFig;
            axHt_normFig = ( maxY_normCnvs - minY_normCnvs ) * canvasHt_normFig; 
            ax.Position(2) = centerline_normFig + minY_normCnvs*canvasHt_normFig;
            ax.Position(4) = axHt_normFig;
        
        % function end
        end              
        
        
        
        % width goes from 0 to 1 and is the normalized width of the axes,
        % relative to the figure as a whole
        function setAxesWidths(this, width)
            
            if ( (width <= 0) || (width > 1) )
                error('width must be between 0 and 1!');
            end
            
            allAxes = { this.rearPattern, this.rearFactors, this.frontPattern, this.frontFactors, this.canvasDivider };
            for ii = 1:5
                thisAxes = allAxes{ii};
                thisAxes.Position(1) = (1-width)/2;
                thisAxes.Position(3) = width;
            end
            
        % function end
        end              
                
        
             
        % 
        function setFont(this, sizeToSet, fontName)

            this.font = fontName;
            this.fontSize = sizeToSet;
            
            % sizes
            this.status.FontSize = sizeToSet;
            this.rearPattern.FontSize = sizeToSet;
            this.rearFactors.FontSize = sizeToSet;
            this.frontPattern.FontSize = sizeToSet;
            this.frontFactors.FontSize = sizeToSet;
            this.archetypeGroup.FontSize = sizeToSet;
            this.controlModeGroup.FontSize = sizeToSet;
            this.valA.FontSize = sizeToSet;
            this.valB.FontSize = sizeToSet;
            this.valC.FontSize = sizeToSet;
            this.valD.FontSize = sizeToSet;
            this.tiltA.FontSize = sizeToSet;
            this.tiltB.FontSize = sizeToSet;
            this.tiltC.FontSize = sizeToSet;
            this.tiltD.FontSize = sizeToSet;
            this.slideA.FontSize = sizeToSet;
            this.slideB.FontSize = sizeToSet;
            this.slideC.FontSize = sizeToSet;
            this.slideD.FontSize = sizeToSet;
            this.phaseA.FontSize = sizeToSet;
            this.phaseB.FontSize = sizeToSet;
            this.phaseC.FontSize = sizeToSet;
            this.phaseD.FontSize = sizeToSet;
            this.positionFactor.FontSize = sizeToSet;
            this.angleFactor.FontSize = sizeToSet;
            this.beam.FontSize = sizeToSet;
            this.grating.FontSize = sizeToSet;
            this.byValue.FontSize = sizeToSet;
            this.byXform.FontSize = sizeToSet;
            this.reset.FontSize = sizeToSet;
            this.aux.FontSize = sizeToSet;
            this.regenerate.FontSize = sizeToSet;
            this.showRearFlat.FontSize = sizeToSet;
            this.showPattern.FontSize = sizeToSet;
            this.showArrayOnly.FontSize = sizeToSet;
            this.auxSelection.FontSize = sizeToSet;
            this.sizeA.FontSize = sizeToSet;
            this.sizeB.FontSize = sizeToSet;
            this.sizeC.FontSize = sizeToSet;
            this.sizeD.FontSize = sizeToSet;
            this.factorA.FontSize = sizeToSet;
            this.factorB.FontSize = sizeToSet;
            this.factorC.FontSize = sizeToSet;
            this.factorD.FontSize = sizeToSet;
            
            % fonts
            this.status.FontName = fontName;
            this.rearPattern.FontName = fontName;
            this.rearFactors.FontName = fontName;
            this.frontPattern.FontName = fontName;
            this.frontFactors.FontName = fontName;
            this.archetypeGroup.FontName = fontName;
            this.controlModeGroup.FontName = fontName;
            this.valA.FontName = fontName;
            this.valB.FontName = fontName;
            this.valC.FontName = fontName;
            this.valD.FontName = fontName;
            this.tiltA.FontName = fontName;
            this.tiltB.FontName = fontName;
            this.tiltC.FontName = fontName;
            this.tiltD.FontName = fontName;
            this.slideA.FontName = fontName;
            this.slideB.FontName = fontName;
            this.slideC.FontName = fontName;
            this.slideD.FontName = fontName;
            this.phaseA.FontName = fontName;
            this.phaseB.FontName = fontName;
            this.phaseC.FontName = fontName;
            this.phaseD.FontName = fontName;
            this.positionFactor.FontName = fontName;
            this.angleFactor.FontName = fontName;
            this.beam.FontName = fontName;
            this.grating.FontName = fontName;
            this.byValue.FontName = fontName;
            this.byXform.FontName = fontName;
            this.reset.FontName = fontName;
            this.aux.FontName = fontName;
            this.regenerate.FontName = fontName;
            this.showRearFlat.FontName = fontName;
            this.showPattern.FontName = fontName;
            this.showArrayOnly.FontName = fontName;
            this.auxSelection.FontName = fontName;
            this.sizeA.FontName = fontName;
            this.sizeB.FontName = fontName;
            this.sizeC.FontName = fontName;
            this.sizeD.FontName = fontName;
            this.factorA.FontName = fontName;
            this.factorB.FontName = fontName;
            this.factorC.FontName = fontName;
            this.factorD.FontName = fontName;
            
        % function end
        end              
                
        
        
        % 
        function closefig(~, ~)
            
            closereq; % system's normal way of closing the window            
            
        % function end
        end              
        
         
        
        function clearAxes(~, thisAxes)

            cla(thisAxes);
            title(thisAxes,'');
            thisAxes.XColor = 'none';
            thisAxes.YColor = 'none';            
            
        % function end
        end              
                  
       
        
        % 
        function postStatus(this, statusMsg)
            
            this.status.String = statusMsg;
            
        % function end
        end              
        
        
    end
    
end

