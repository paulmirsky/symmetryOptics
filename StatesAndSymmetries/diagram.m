classdef diagram  < handle
    
    properties
        axObj
        tickWidth = 2
        yLimitWidth = 1
        markerHeight = 2*pi
        widthFrac = 0.8
        endBarsOffset = 0.0
        roundoffQty = 1e-6;
        piHigh = true % whether pi is plotted on top; if not, on bottom
        tickColor = 0.2 * [1 1 1]
        brightColor = [255 0 0]/255
        darkColor = [195 217 239]/255
        yLimitColor = 0.8 * [1 1 1]
        drawZeroPhaseLine
        
    end


    
    methods
        
        % constructor
        function this = diagram()
            % 
        % constructor end
        end 

        
        
        % xVal is the leftmost side of the region allotted
        function draw(this, xVal, stateVec)
            
            for ii = 1:numel( stateVec )
                thisZ = xVal + 0.5 + (ii-1);
                this.markPatch(thisZ, stateVec(ii));
            end
            hLimits = xVal + [ -this.endBarsOffset, numel(stateVec)+this.endBarsOffset ];
            for thisTick = hLimits
                line( thisTick*[1 1], [-pi pi], 'parent', this.axObj,'LineWidth',this.tickWidth,'Color',this.tickColor)
            end
            
        % function end
        end
        
        
        
        % draws a point
        function markPatch(this, zVal, patchVal)
        
                % choose params
                if ( abs(patchVal) < this.roundoffQty ) % dark patches
                    thisColor = this.darkColor;  
                    thisPhase = 0;
                else % bright patches
                    tieBreaker = -1*(this.piHigh-0.5)*this.roundoffQty;  % treating piHigh as a 0 or 1 number, not a boolean
                    thisPhase = mod(angle(patchVal) + pi + tieBreaker, 2*pi) - pi;                    
                    thisColor = this.brightColor;
                end
            
            % each patch is 1 unit wide on the axis
            posVec = [ [ zVal - 0.5*this.widthFrac, thisPhase - 0.5*this.markerHeight ], this.widthFrac, this.markerHeight ];
            rectangle('parent',this.axObj,'position',posVec,'FaceColor',thisColor,'EdgeColor', 'none');
            
            if this.drawZeroPhaseLine
                line(zVal + [-.5, 0.5], [thisPhase,thisPhase],'parent',this.axObj,'Color',this.tickColor);
            end
            
        % function end
        end
        
        
        
        function setLimits(this, patternLength, maxPointSize)
        
            % set y limits 
            this.axObj.YLim = [-1 1] * ( pi + 0.5*this.markerHeight );
            
            % set visible width
            maxLengthNoScaling = 1 / maxPointSize;
            if ( patternLength > maxLengthNoScaling )
                horizontalLimit = patternLength * 0.5 * [-1 1];
            else
                horizontalLimit = maxLengthNoScaling * 0.5 * [-1 1];
            end
            this.axObj.XLim = horizontalLimit;
            
            yLimits = (pi + 0.5*this.markerHeight) * [-1 1];
            for thisLimit = yLimits
                line( horizontalLimit, thisLimit*[1 1], 'parent', this.axObj,'LineWidth',this.yLimitWidth,'Color',this.yLimitColor)
            end           
            
        % function end
        end
        
        

        % 
        function setLabels(this,allLabelXs,allLabels)
            
            this.axObj.XTick = allLabelXs;
            this.axObj.XTickLabel = allLabels;
            
            this.axObj.YTick = [-pi 0 pi];
            this.axObj.YTickLabel = {'-\pi','0','\pi'};
            
        % function end
        end
            

        
    % end of methods           
    end

% end of class       
end

