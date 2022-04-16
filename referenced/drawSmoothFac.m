classdef drawSmoothFac < handle
    
    properties
        axObj
        facSizes
        facTypes
        facColors % make these something by default
        yPlot
        maxZ
        frameThickPx = 3
        frameWidth
        frameHeight
        barWidth = 0.3 % relative to the size of the pattern, approx
        oddCenterWidth = 2.5
        oddCenterGapRel = 0.3
        canvasColor = [1 1 1]        
    end

    
    methods
        
        % constructor
        function this = drawSmoothFac()
            % 
        % constructor end
        end 


        

        function draw(this)
            
            % calculate border width
            this.axObj.Units = 'pixels';
            axesWidthPx = this.axObj.Position(3);
            axesWidthUnits = log( this.maxZ );
            this.frameWidth = ( this.frameThickPx / axesWidthPx ) * axesWidthUnits;
            
            % use only the last colors in the list
            iStartColor = numel(this.facColors) + 1 - numel(this.facSizes);
            trimmedFacColors = this.facColors(iStartColor:end);
            
            % for each level of the plane spec, draw the features
            cumulativeZ = 0;
            for ii = 1:numel(this.facSizes)
                
                this.drawFac( this.facSizes{ii}, this.facTypes{ii}, trimmedFacColors{ii}, cumulativeZ, this.yPlot );
                cumulativeZ = cumulativeZ + log( this.facSizes{ii} );
            end
            
            % format axes
            this.axObj.XLim(2) = log(this.maxZ);
            this.axObj.XColor = 'none';
            
        % function end
        end
        
        

        %
        function drawFac(this, size, type, color, baseZ, centerY)

            cornerXY = [baseZ, centerY - 0.5*this.barWidth];
            rectXY = [log( size ), this.barWidth];
            
            outerPosVec = [cornerXY,rectXY];
            rectangle('position',outerPosVec,'curvature',[0,0],'FaceColor',color,...
                'EdgeColor', 'none', 'parent',this.axObj );
            
            if strcmp(type,'singular')
                posOffset = [this.frameWidth this.frameHeight -2*this.frameWidth -2*this.frameHeight];
                innerPosVec = outerPosVec + posOffset;
                if all( innerPosVec([3 4]) > 0 )
                    rectangle('position',innerPosVec,'curvature',[0,0],'FaceColor', this.canvasColor,...
                        'EdgeColor', 'none', 'parent',this.axObj );
                    centerZ = baseZ + 0.5*log(size);
                    centerLength = this.barWidth - 2*( this.frameHeight + this.oddCenterGapRel*this.barWidth );
                    centerYends = centerY + 0.5*[-1 1]*centerLength;
                    line( [centerZ centerZ], centerYends, 'Color', color,... 
                        'parent', this.axObj, 'LineWidth', this.oddCenterWidth );                
                end
            end
            
        % function end
        end

%         
%         
%         %
%         function drawSeparators(this, zSeparators)
%             
%             for ii = 1:numel(zSeparators)
%                 thisZ = zSeparators(ii);
%                 line( [thisZ thisZ], 0.5*[-1 1], 'Color', this.separatorColor,... 
%                     'parent', this.axObj, 'LineWidth', this.separatorWidth );                
%             end
%             
%         % function end
%         end
%                      
        
        
        

%         function xxx(this,thisZ)
%         % function end
%         end
        
        
               
    % end of methods           
    end

% end of class       
end

