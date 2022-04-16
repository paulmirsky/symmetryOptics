classdef drawGratingSpatial < handle
    
    properties
        ax
        axWidth % the width of the region that is displayed in the axes, given in patches
        brightColor = [0 0.8 0]
        darkColor = [0 0 0]
        heightFrac = 0.8
        borderWidth = 0.5
        minBarWidth = 1e-2 % in patches
        centeringMode = 'centerAll' % centerAll, centerBright
        hideScale = true
        
    end
    
    
    methods
        
        % constructor
        function this = drawGratingSpatial()
        % constructor end
        end 
        
        
        
        
        % 
        function draw(this, areaA, areaB, areaC)
            
            cla(this.ax);
            this.ax.Color = this.darkColor;
            
            leftmostLight = inf;
            rightmostLight = 0;
            for ii = 1:ceil(areaC)
                
                thisX = ii*areaA*areaB;
                if (ii==ceil(areaC))
                    if ( areaC==ceil(areaC) )
                        periodFraction = 1;
                    else
                        periodFraction = areaC - floor(areaC);
                    end
                    slitFraction = min([1, periodFraction*areaB]);
                    finalBarWidth = slitFraction * areaA;
                else
                    finalBarWidth = areaA;
                end
                
                if (finalBarWidth > this.minBarWidth)
                    posVec = [thisX, -this.heightFrac, finalBarWidth, 2*this.heightFrac];
                    rectangle('parent', this.ax, 'position', posVec,'FaceColor',this.brightColor,...
                        'EdgeColor', 'none');
                    % keep a running tally of the left and right extremes
                    % of the bright region
                    leftmostLight = min( [leftmostLight, posVec(1)] );
                    rightmostLight = max( [rightmostLight, posVec(1)+posVec(3)] );
                end
                
            end
            
            % set limits, format, etc.
            if strcmp( this.centeringMode, 'centerBright' )
                xOffset = (leftmostLight + rightmostLight)/2;
            elseif strcmp( this.centeringMode, 'centerAll' )
                overallSize = areaA * areaB * areaC;
                xOffset = 0.5 * overallSize;
            end
            xLimits = [-0.5 0.5]*this.axWidth + xOffset;
            this.ax.XLim = xLimits;
            this.ax.YLim = [-1 1];
            this.ax.YTick = [];
            if this.hideScale
                this.ax.XTick = [];
            end

            % draw border
            xMin = this.ax.XLim(1);
            xMax = this.ax.XLim(2);
            yMin = this.ax.YLim(1);
            yMax = this.ax.YLim(2);
            line([xMin, xMax], [yMin, yMin], 'Color', [0 0 0], 'LineWidth', this.borderWidth, 'parent', this.ax );
            line([xMax, xMax], [yMin, yMax], 'Color', [0 0 0], 'LineWidth', this.borderWidth, 'parent', this.ax );
            line([xMin, xMax], [yMax, yMax], 'Color', [0 0 0], 'LineWidth', this.borderWidth, 'parent', this.ax );
            line([xMin, xMin], [yMin, yMax], 'Color', [0 0 0], 'LineWidth', this.borderWidth, 'parent', this.ax );            
        
        % function end
        end

        
               
    % end of methods           
    end

% end of class       
end

