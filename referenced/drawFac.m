classdef drawFac  < handle
    
    properties
        axObj
        % inputs to draw function
        facSizes
        facTypes
        facColors
        yPlot = 0 % the y value at which the (horizontal) chain of facs is drawn
        facSpecialXs % optional.  Used for formatting, to make facs line up
        facXs % output, not input. starting Zs for each fac, used for formatting
        floorXs % output, not input. starting Zs for each fac, used for formatting
        % appearance
        middlePatchBiasRight = true
        barWidth = 0.3 % full ax thickness is 1
        dOddOutline = 2
        paneSpacing = 0.2
        fac2facGap = 1
        showXaxis = false
        drawBelowMinSize = true
        minSizeToDraw = .01
        % separators
        separatorDot = true
        dSeparatorDot = 12 % point for round separator    
        separatorDotColor = 0.35 * [1 1 1]

    end
    properties (Access = 'private')
    
    end

    
    methods
        
        % constructor
        function this = drawFac()            
        % constructor end
        end 
        
        

        % 
        function draw(this)
            
            facSpecSizes = [ numel(this.facSizes), numel(this.facTypes) ];
            if ~isempty(this.facSpecialXs)
                facSpecSizes(end+1) = numel(this.facSpecialXs);
            end
            if ~all(facSpecSizes==facSpecSizes(1))
                error('fac spec components must all be the same size!');
            end
            if ( numel(this.facSizes) > numel(this.facColors) )
                error('number of facs cannot exceed number of colors!');
            end

            iStartColor = numel(this.facColors) + 1 - numel(this.facSizes);
            trimmedFacColors = this.facColors(iStartColor:end);
            baseHeight = this.yPlot - this.barWidth/2;
            
            cumulativeX = 0;
            cumulativeSize = 1;
            for ii = 1:numel(this.facSizes)
                if ( ~isempty(this.facSpecialXs) && ~isnan(this.facSpecialXs{ii}) )
                    cumulativeX = this.facSpecialXs{ii};
                end
                this.facXs(ii,1) = cumulativeX; % keeping track so that other code can use it later
                this.drawFacBoxes( this.facSizes{ii}, this.facTypes{ii}, trimmedFacColors{ii}, cumulativeX, baseHeight );
                cumulativeX = cumulativeX + this.facSizes{ii} + (ceil(this.facSizes{ii}-1)*this.paneSpacing );
                cumulativeSize = cumulativeSize * this.facSizes{ii};
                hold(this.axObj, 'on');
                floorX = cumulativeX + 0.5*this.fac2facGap;
                this.floorXs(ii,1) = floorX; % keeping track so that other code can use it later
                if (ii ~= numel(this.facSizes))
                    if this.separatorDot
                        plot( floorX, baseHeight+0.5*this.barWidth, 'Marker', '.', 'parent', this.axObj, ...
                            'MarkerSize', this.dSeparatorDot, 'MarkerEdgeColor', this.separatorDotColor );
                    end
                end                     
                cumulativeX = cumulativeX + this.fac2facGap;
            end            
            
            % add a floor *before the first factor
            this.floorXs = [ -0.5*this.fac2facGap ; this.floorXs ];
            
            % format axes
            if ~this.showXaxis
                this.axObj.XColor = 'none';
            end
            
        % function end
        end


        
        %
        function drawFacBoxes(this, fullFacSize, type, color, baseZ, baseHeight)

            allZBars = unique( [ 0:floor(fullFacSize), fullFacSize ] );
            if this.middlePatchBiasRight
                iFilledPoint = floor(fullFacSize/2)+1;
            else
                iFilledPoint = ceil(fullFacSize/2);
            end
               
            for ii = 1:( numel(allZBars) - 1)
                thisZBar = allZBars(ii) * (1 + this.paneSpacing);
                paneCornerXY = [baseZ + thisZBar, baseHeight];
                paneWidth = allZBars(ii+1) - allZBars(ii);
                panePosVec = [paneCornerXY,paneWidth,this.barWidth]; 
                if ( (ii==iFilledPoint) || strcmp(type,'plenary') )
                    faceColor = color;
                else
                    faceColor = 'none';
                end
                if all( panePosVec([3 4]) > 0 )
                    if(~this.drawBelowMinSize && (paneWidth<this.minSizeToDraw))
                        % do nothing
                    else
                        rectangle( 'parent', this.axObj, 'position',panePosVec,'curvature',[0,0],'FaceColor', faceColor,...
                            'EdgeColor', color, 'LineWidth', this.dOddOutline, 'parent',this.axObj );
                    end
                end                                
            end
                
        % function end
        end

        
                   
        % 
        function clearBorder(this)
        
            if ishandle(this.axObj)
                this.axObj.XColor = 'none';
                this.axObj.YColor = 'none';
            end         
        
        % function end
        end        

        
        
        %
        function output = hangingZ(this, hangingSize, zCeiling)
        
            output = zCeiling - hangingSize - (ceil(hangingSize)-1)*this.paneSpacing - this.fac2facGap;                        
        
        % function end
        end

        
        
    % end of methods           
    end

% end of class       
end

