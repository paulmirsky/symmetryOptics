classdef drawChainPair  < handle
    
    properties        
        axObj
        staticSizes 
        staticTypes
        staticColors
        drawStatic
        liveSizes
        liveTypes
        liveColors
        drawLive
        unit = 1
        barWidth = 0.5
        floorExtra = 0.2 % how far the floor extends past the bar
        barSeparation = 1 % between bar centers
        factorGap = 0.5
        floorThk = 1.3
        floorColor = 0.35*[1 1 1]
        separatorDot = true
    end
    
    
    methods
        
        % constructor
        function this = drawChainPair()
            
            colorsObj = colorKit();
            this.staticColors = repmat({colorsObj.sourceColor},[1 4]);
            this.liveColors = { colorsObj.get('yellow'), colorsObj.get('green'),... 
                colorsObj.get('red'), colorsObj.get('blue') };
            this.drawStatic = drawFac;
            this.drawLive = drawFac;
            
            
        % constructor end
        end 
        
        
        
        % 
        function draw(this, thisZ)

            this.drawStatic.axObj = this.axObj;
            this.drawStatic.facSizes = this.staticSizes; 
            this.drawStatic.facTypes = this.staticTypes;
            this.drawStatic.facColors = this.staticColors;
            this.drawStatic.barWidth = this.unit*this.barWidth;
            this.drawStatic.yPlot = thisZ - this.unit * this.barSeparation / 2;
            this.drawStatic.fac2facGap = this.factorGap;
            this.drawStatic.separatorDot = this.separatorDot;

            this.drawLive.axObj = this.axObj;
            this.drawLive.facSizes = this.liveSizes; 
            this.drawLive.facTypes = this.liveTypes;
            this.drawLive.facColors = this.liveColors;
            this.drawLive.barWidth = this.unit*this.barWidth;
            this.drawLive.yPlot = thisZ + this.unit * this.barSeparation / 2;
            this.drawLive.fac2facGap = this.factorGap;
            this.drawLive.separatorDot = this.separatorDot;
            
            this.drawStatic.draw();
            this.drawLive.draw();
            
        % function end
        end
        
        
        % 
        function drawCommonFloors(this, thisZ)
            
            liveWidths = cumprod( cell2mat(this.drawLive.facSizes) );
            liveWidths = [ 1, liveWidths ];
            staticWidths = cumprod( cell2mat(this.drawStatic.facSizes) );
            staticWidths = [ 1, staticWidths ];            
            commonWidths = intersect( liveWidths, staticWidths);
            
            floorHalfwidth = this.unit * ( 0.5*(this.barWidth + this.barSeparation) + this.floorExtra );
            
            for ii = 1:numel(commonWidths)
                thisWidth = commonWidths(ii);
                iStatic = find( staticWidths==thisWidth, 1, 'first' );
                iLive = find( liveWidths==thisWidth, 1, 'first' );
                xStatic = this.drawStatic.floorXs(iStatic);
                xLive = this.drawLive.floorXs(iLive);
                line( [xStatic, xLive], [thisZ thisZ], 'parent', this.axObj, 'color', this.floorColor, 'lineWidth', this.floorThk ); % draw centerline
                line( [xStatic, xStatic], [thisZ thisZ-floorHalfwidth ], 'parent', this.axObj, 'color', this.floorColor, 'lineWidth', this.floorThk ); % connect static to centerline
                line( [xLive, xLive], [thisZ thisZ+floorHalfwidth ], 'parent', this.axObj, 'color', this.floorColor, 'lineWidth', this.floorThk ); % connect live to centerline
            end
            

        % function end
        end
        
        
%         
%         
%         % 
%         function FUNCTIONNAME(this, inputArguments)
%         
%         
%         % function end
%         end
        
               
    % end of methods           
    end

% end of class       
end

