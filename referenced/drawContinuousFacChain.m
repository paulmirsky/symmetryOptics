classdef drawContinuousFacChain < handle
    
    properties
        axObj
        sizes
        types
        colors
        yPlot
        maxZ
        frameThickPx = 3
        frameHeight = 1
        barWidth = 1.2 % relative to the size of the pattern, approx
        oddCenterFraction = 0.7
        canvasColor = [1 1 1]        
    end

    
    methods
        
        % constructor
        function this = drawContinuousFacChain()
            % 
        % constructor end
        end 

        

        function draw(this)
            
            % use only the last colors in the list
            iStartColor = numel(this.colors) + 1 - numel(this.sizes);
            trimmedColors = this.colors(iStartColor:end);
            
            % get the start points for plotting
            startPoints = cumprod(cell2mat(this.sizes));
            startPoints(end) = [];
            startPoints = [ 1, startPoints ];
            startPoints = log(startPoints);
            
            % this is for cosmetic reasons only. plot singulars last, so
            % you can see the line
            iPlenaries = find( ismember(this.types,'plenary') );
            iSingulars = find( ismember(this.types,'singular') );
            sortOrder = [ iPlenaries, iSingulars ];
            sortedSizes = this.sizes(sortOrder);
            sortedTypes = this.types(sortOrder);
            sortedColors = trimmedColors(sortOrder);
            sortedStartPoints = startPoints(sortOrder);
            
            for ii = 1:numel(this.sizes)
                this.drawFac( sortedSizes{ii}, sortedTypes{ii}, sortedColors{ii},... 
                    sortedStartPoints(ii), this.yPlot );
            end
            
            % format axes
            this.axObj.XLim = [ 0, log( this.maxZ ) ];
            this.axObj.XColor = 'none';
            this.axObj.YColor = 'none';
            
        % function end
        end
        


        %
        function drawFac(this, size, type, facColor, baseZ, centerY)

            cornerXY = [baseZ, centerY - 0.5*this.barWidth];
            rectXY = [log( size ), this.barWidth];
            outerPosVec = [cornerXY,rectXY];
            
            if strcmp(type,'singular')
                fillColor = this.canvasColor;
            elseif strcmp(type,'plenary')
                fillColor = facColor;
            else
                error('invalid factor type!');
            end            
            
            rectangle('position',outerPosVec,'curvature',[0,0],'FaceColor',fillColor,...
                'EdgeColor', facColor, 'parent',this.axObj, 'lineWidth', this.frameThickPx );
            
            % draw tick
            if strcmp(type,'singular')
                centerZ = baseZ + 0.5*log(size);
                centerLength = this.oddCenterFraction * this.barWidth;
                centerYends = centerY + 0.5*[-1 1]*centerLength;
                line( [centerZ centerZ], centerYends, 'Color', facColor,... 
                    'parent', this.axObj, 'LineWidth', this.frameThickPx );                   
            end
            
        % function end
        end

       
        
        
        

%         function xxx(this,thisZ)
%         % function end
%         end
        
        
               
    % end of methods           
    end

% end of class       
end

