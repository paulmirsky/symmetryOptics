function out = SnS_auxCode(sectionToExecute, this)
% 'this' is the handle of the controller

switch sectionToExecute
        
    case 1  
        this.view.postStatus('Look at the aux code!');
        keyboard
        % you can add code into this file, and save it, and run it, 
        % without restarting the whole app
        
    case 2
        this.view.valA.Value = 1;
        this.applyEvals();
               
    case 3
        
       
        
        
    otherwise
        this.view.postStatus('No such section to execute!');
end

% required just to end it.
out = 'SnS_auxCode is closed';

end

