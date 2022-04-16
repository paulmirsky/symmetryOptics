classdef drawContinuousFeaturesSpatial < handle
    
    properties
        a
        b
        c
        d
        ax
        brightColor = [ 1 0 0 ]
        darkColor = [ 215 230 245 ] / 255
        heightFrac = 1
        drawBorder = false
        borderWidth = 0.5
        clipExcessDark = false
        useSpecialAxWidth = false
        specialAxWidth
        showXAxis = true
        centerOdd = true % a stripe is always in the middle, at X=0
    end
    
    
    methods
        
        % constructor
        function this = drawContinuousFeaturesSpatial()
        % constructor end
        end 

        
        % 
        function drawIt(this)
            
            % determine mode
            if ( ~any(isempty([this.a, this.b])) && all(isempty([this.c, this.d])) ) % a and b are non-empty, c and d are empty
                % beam
                this.c = 1;
                this.d = 1;
            elseif ~any(isempty([ this.a, this.b, this.c, this.d ])) % a, b, c, d are all non-empty
                % MSI
            else
                error('this function supports only two modes: beam and MSI. factor sizes do not match either format!');
            end
            
            if any( [ this.b, this.c, this.d ] < 1 )
                error('factor sizes b, c, d can not be less than 1!');
            end
            
            
            % get starting and stopping points for all stripes, full periods
            nFullPeriods = ceil(this.c);
            if this.centerOdd
                % if it's an even number, raise it to be odd. this keeps the
                % pattern centered on 0
                if ( mod(nFullPeriods,2)==0 ) 
                    nFullPeriods = nFullPeriods + 1;
                end
            else
                % if it's an odd number, raise it to be even.
                if ( mod(nFullPeriods,2)~=0 ) 
                    nFullPeriods = nFullPeriods + 1;
                end
            end
            iPeriodStarts = ( 0:( nFullPeriods-1 ) ).';
            periodSize = this.a * this.b;
            allPeriodStarts = ( iPeriodStarts - nFullPeriods/2 ) * periodSize;
            xStartInPeriod = this.a * (this.b-1)/2;
            allStripeStarts = allPeriodStarts + xStartInPeriod;
            allStripeEnds = allStripeStarts + this.a;
            % trim full periods
            patternHalfWidth = this.a * this.b * this.c / 2;
            if ( patternHalfWidth <= allStripeStarts(end) )
                allStripeStarts(1) = [];
                allStripeEnds(1) = [];
                allStripeStarts(end) = [];
                allStripeEnds(end) = [];
            elseif ( patternHalfWidth >= allStripeEnds(end) )
                % do nothing
            else
                allStripeStarts(1) = -1*patternHalfWidth;
                allStripeEnds(end) = patternHalfWidth;
            end
            
            % draw stripes
            cla(this.ax);
            this.ax.Color = this.darkColor;
            for ii = 1:numel(allStripeStarts)
                thisWidth = allStripeEnds(ii) - allStripeStarts(ii);
                posVec = [allStripeStarts(ii), -this.heightFrac, thisWidth, 2*this.heightFrac];
                rectangle('parent', this.ax, 'position', posVec,'FaceColor',this.brightColor,...
                    'EdgeColor', 'none');                
            end
            
            % set limits, format, etc.
            if this.useSpecialAxWidth
                activeAxWidth = this.specialAxWidth;
            elseif this.clipExcessDark
                activeAxWidth = this.a * this.b * this.c;
            else
                activeAxWidth = this.a * this.b * this.c * this.d;
            end
            xLimits = [-0.5 0.5]*activeAxWidth;
            this.ax.XLim = xLimits;
            this.ax.YLim = [-1 1];
            this.ax.YTick = [];
            this.ax.YColor = 'none';
            if ~this.showXAxis
                this.ax.XTick = [];
                this.ax.XColor = 'none';
            end

            % draw border
            xMin = this.ax.XLim(1);
            xMax = this.ax.XLim(2);
            yMin = this.ax.YLim(1);
            yMax = this.ax.YLim(2);
            if this.drawBorder
                line([xMin, xMax], [yMin, yMin], 'Color', [0 0 0], 'LineWidth', this.borderWidth, 'parent', this.ax );
                line([xMax, xMax], [yMin, yMax], 'Color', [0 0 0], 'LineWidth', this.borderWidth, 'parent', this.ax );
                line([xMin, xMax], [yMax, yMax], 'Color', [0 0 0], 'LineWidth', this.borderWidth, 'parent', this.ax );
                line([xMin, xMin], [yMin, yMax], 'Color', [0 0 0], 'LineWidth', this.borderWidth, 'parent', this.ax );
            end
        
        % function end
        end
           
               
    % end of methods           
    end

% end of class       
end

