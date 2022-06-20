classdef parityCalc < handle
    
    properties
        % note, all values are in wavelengths!
        fLens
        wFlat % width of the static stripe, in patches (wavelengths)
        lensLimited = true
    end
    
    
    methods
        
        % constructor
        function this = parityCalc()
        % constructor end
        end 
        

        % note, z is given in wavelengths!
        function parity = getParity(this, z)

            % validate inputs
            if ( isempty(this.wFlat) || (this.lensLimited && isempty(this.fLens)) )
                error('A necessary value is empty!');
            end
            if (z < 0)
                error('Z can not be less than zero!');
            end
            if ( this.lensLimited && (z > 2*this.fLens) )
                error('Z must be before the rear flat!');
            end

            % if it's at the rear flat, special case
            if ( this.lensLimited && (z == 2*this.fLens) ) 
                parity = 0;
                return;
            % if it passes the lens, convert to equivalent z    
            elseif ( this.lensLimited && (z > this.fLens) ) 
                zFromRearFlat = 2*this.fLens - z;
                lensRatio = zFromRearFlat / this.fLens;
                zEquiv = this.fLens / lensRatio; % assign equivalent Z
            else
                zEquiv = z;
            end
                
            zElbow = this.wFlat^2;
            if (zEquiv <= zElbow) 
                % near field
                parity = zEquiv / zElbow;
            else
                % far field
                parity = zElbow / zEquiv;
            end
        
        % function end
        end
               
               
    % end of methods           
    end

% end of class       
end

