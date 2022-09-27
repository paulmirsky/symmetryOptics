classdef opFactor < handle
    
    properties
        type = 'angle' % default only
        size = 1
        states
        values        
        unitPhase
        
    end
    properties (Access = 'private')
    end

    
    methods
        
        % constructor
        function this = opFactor()
            % constructor only            
        end 
        

        
        % do this to start it up
        function calcAll(this)
            
            % validate inputs
            if isempty(this.size)
                error('factor size is required as input!');
            end
            if ~allEntriesAreIntegers(this.size,1e-9)
                error(['factor size is not an integer, ', num2str(this.size)]);
            end

            % calculate all factor data
            this.unitPhase = exp( 2i*pi / this.size );            
            this.values = indexRange( this.size, 'right' ).';
            
            if ismember(this.type,{'position','singular'})
                for ii = 1:this.size
                    thisState = zeros([this.size,1]);
                    thisState(ii) = 1;
                    this.states{ii,1} = thisState;
                end
            elseif ismember(this.type,{'angle','plenary'})
                for ii = 1:this.size
                    allPositions = this.values; % by semi-coincidence, the positions and set of values are the same. but they mean different things
                    thisState = this.unitPhase.^( -1 * this.values(ii) * allPositions ); 
                    thisState = thisState(:); % make sure it's a column
                    this.states{ii,1} = thisState;
                end
            else
                error('invalid factor type!');
            end
            
        % function end
        end            
        
        
    % end of methods           
    end

% end of class       
end

