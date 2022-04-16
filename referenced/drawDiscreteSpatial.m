classdef drawDiscreteSpatial  < handle
    
    properties
        axObj
        markerWidthFrac = 0.8 % how wide it is, compared to 1 patch
        markerHeightFrac = 0.8 % how tall it is, compared to inPlaneScale
        inPlaneScale = 1
        patchScale = 1
        drawDark = true
        darkColor
        trimDark = false % trim the highest-rankiing dark factor, to make diagrams more compact
        centerPattern = true
        centerByWholePatch = false
        invertDirection = false
        writeValue = false
        valueFont = 'Arial'
        valueSize = 8
        xOffset = 0
        showXAxis = false
        
    end


    
    methods
        
        % constructor
        function this = drawDiscreteSpatial()
            cl = colorKit();
            this.darkColor = cl.darkSpaceColor;
        % constructor end
        end 
        
    
        
              
        % pattern is a source-target array or similarly-structured table
        % colors is a list of colors, one for each column (emanator) of pattern
        function drawPattern(this, pattern, zPlane, colorList) 
            
            % create figure, if needed
            if isempty(this.axObj)
                error('no axes was set! cannot draw');
            end
            
            hold(this.axObj,'on');     
            if ~this.showXAxis
                this.axObj.XColor = 'none';
            end
                  
            if this.trimDark
                pattern = this.removeDark(pattern);
            end    
            if this.centerPattern
                currentXOffset = this.xOffset + this.getCenterOffset(pattern);
            else
                currentXOffset = this.xOffset;
            end
%             currentXOffset = currentXOffset * this.patchScale;
            if this.invertDirection
                directionFactor = -1;
            else
                directionFactor = 1;
            end
            repeatedColors = this.repeatColors(colorList,size(pattern,2));
            for ii = 1:size(pattern,1)                    
                for jj = 1:size(pattern,2)
                    thisValue = pattern(ii,jj);
                    if pattern(ii,jj)==0
                        % draw dark
                        if this.drawDark
                            this.markPoint( this.axObj, ii+currentXOffset, zPlane +... 
                                directionFactor*(jj-1)*this.inPlaneScale, thisValue, this.darkColor );
                        end
                    elseif pattern(ii,jj)==1
                        % draw bright
                        this.markPoint( this.axObj, ii+currentXOffset, zPlane +... 
                            directionFactor*(jj-1)*this.inPlaneScale, thisValue, repeatedColors(jj,:) );
                    else
                        error('invalid number!');
                    end
                end
            end
           
        % function end
        end
        
        
        
        
        % draws a point
        function markPoint(this, whichAxis, xVal, zVal, thisValue, thisColor)
        
            markerDims = [ this.markerWidthFrac*this.patchScale, this.markerHeightFrac*this.inPlaneScale ];
            posVec = [ [xVal*this.patchScale, zVal] - 0.5*markerDims, abs(markerDims) ];
%             if this.invertDirection
%                 posVec(2) = posVec(2) - this.markerHeightFrac*this.inPlaneScale;
%             end
            rectangle('position',posVec,'curvature',[0],'FaceColor',thisColor,...
                'EdgeColor', 'none', 'parent',whichAxis);
            if this.writeValue
                text(xVal, zVal, num2str(thisValue), 'parent',whichAxis,'fontName',this.valueFont,'fontSize',...
                    this.valueSize,'horizontalAlignment','center','color',0.2*[1 1 1]);
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
        function staggeredPattern = staggerPattern(~, patternIn)
                    
            iBright = find( patternIn );
            staggeredPattern = zeros( [ numel(patternIn), numel(iBright) ]  );
            for ii = 1:numel(iBright)
                staggeredPattern( iBright(ii), ii ) = 1;
            end
        
        % function end
        end        
        
        
        
                    
        % 
        function trimmedPattern = removeDark(~, pattern)
        
            iBright = find( any(pattern,2) );
            iKeep = iBright(1):iBright(end);
            trimmedPattern = pattern(iKeep,:);
            
        % function end
        end
        
        
        
                    
        % get the alignment offset
        function offset = getCenterOffset(this, pattern)
        
            if this.trimDark
                iBright = find( any(pattern,2) );
                if isempty(iBright)
                    offset = 0;
                else
                    offset = -( iBright(1) + iBright(end) )/2;
                end               
            else
                offset = -( 1 + size(pattern,1) )/2;
            end
            
            if this.centerByWholePatch
                offset = round(offset);
            end
            
        % function end
        end
        
        
        
                    
        % get the alignment offset
        function colorsOut = repeatColors(~, colorsIn, nPoints)
        
            nLoops = ceil(nPoints/size(colorsIn,1));
            loopedColorList = repmat(colorsIn,[nLoops,1]);
            colorsOut = loopedColorList(1:nPoints,:);
            
        % function end
        end
        
                    
               
    % end of methods           
    end

% end of class       
end

