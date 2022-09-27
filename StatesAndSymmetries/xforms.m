classdef xforms < handle
    
    properties
        size = 1
        tilt
        slide
        phase
        
    end
    properties (Access = 'private')
    end

    
    methods
        
        % constructor
        function this = xforms()
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

            % make tilt operator
            tiltFac = opFactor();
            tiltFac.type = 'position';
            tiltFac.size = this.size;
            tiltFac.calcAll();
            tiltEigenvalues = tiltFac.unitPhase.^tiltFac.values.';            
            this.tilt = this.makeOperator(tiltFac.states, tiltEigenvalues);
            
            % make slide operator
            slideFac = opFactor();
            slideFac.type = 'angle';
            slideFac.size = this.size;
            slideFac.calcAll();
            slideEigenvalues = slideFac.unitPhase.^slideFac.values.';            
            this.slide = this.makeOperator(slideFac.states, slideEigenvalues);

            % make phase operator
            this.phase = diag( ones([this.size,1])*slideFac.unitPhase );
            
        % function end
        end      



        function operator = makeOperator(this, basis, eigenvalues)

            % make the operator
            accumulator = zeros( this.size );
            for ii = 1:this.size
                % loop over vecs
                normedVector = basis{ii}/norm(basis{ii}); % normalizes the vector to 1, even though it should come in that way
                projector = normedVector*normedVector'; % outer product with conjugate            
                accumulator = accumulator + eigenvalues(ii)*projector;
            end
            operator = accumulator;

        end



    % end of methods           
    end

% end of class       
end

