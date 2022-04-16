classdef facPlotY  < handle
    
    properties
        barWidth
        gap
    end
    
    methods
        
        % constructor
        function this = facPlotY()            
        % constructor end
        end 
        
        

        % 
        function yPlot = getY(this, yPlane, aspect)
            
            if (isempty(this.barWidth) || isempty(this.gap))
                error('barWidth or gap is empty!');
            end
            
            if strcmp(aspect,'static')
                aspectFactor = -1;
            elseif strcmp(aspect,'live')
                aspectFactor = 1;
            else
                error('invalid aspect type!');
            end
            
            yPlot = yPlane + aspectFactor*(this.barWidth + this.gap)/2;            
            
        % function end
        end

        
        
    % end of methods           
    end

% end of class       
end

