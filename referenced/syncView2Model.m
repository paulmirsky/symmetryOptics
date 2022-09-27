classdef syncView2Model  < handle
    
    properties
        figure
        figChildren
        uic % user-interface controller, aka controller object
        responseList
        % defines responses to buttons pushed in figure
        % format for one row is { buttonTag, controllerMethodName }
        syncList
        % sets up sync between the model and the screen
        % format for one row is { controlTag, controlField, conversionMode, variableToSyncTo }               
        % conversionMode 'stringToNumber' means that it's a string in the screen object, and a
        % number in the model.  Gets reversed when you're syncing the other way.  
        % Options are: 'stringToNumber', 'stringAsString', 'numberAsNumber' (which includes t/f)        
        
    end
    
    
    methods
        
        % constructor
        function this = syncView2Model()
        % constructor end
        end 
        
        
        
        % this connects the gui buttons to the controller
        function connect(this)
            
            nResponses = size(this.responseList, 1);
            this.figChildren = get(this.figure, 'Children');
            for m = 1:nResponses
                controlTag = this.responseList{m,1};
                actionName = this.responseList{m,2};
                buttonHandle = findobj(this.figChildren,'Tag', controlTag);
                set(buttonHandle, 'UserData', {this.uic, actionName});
                set(buttonHandle, 'Callback', {'activateControllerGUI'});  
            end 
            
            % sets up a callback to 'fig2uic' for each response action, adds it to the button
            nItemsInList = size(this.syncList, 1);
            for ii = 1:nItemsInList
                controlTag = this.syncList{ii,1};
                buttonHandle = findobj(this.figChildren, 'Tag', controlTag);
                set(buttonHandle, 'UserData', {this, 'fig2uic'});
                set(buttonHandle, 'Callback', {'activateController04'});  
            end                            
            
        % function end
        end
        

                    
        % 
        function uic2fig(this)

            iTargets = 1:size(this.syncList,1);
            for ii = iTargets
                thisControlTag = this.syncList{ii,1};
                thisControlHandle = findobj(this.figChildren,'Tag', thisControlTag); 
                targetField = this.syncList{ii,2};
                newValueEvalString = ['this.uic.',this.syncList{ii,4}];
                newValue = eval(newValueEvalString);
                % remember that the conversionMode names are backwards,
                % cause we are now syncing *from model *to screen!
                switch this.syncList{ii,3} % this specifies the conversionMode
                    case 'stringToNumber'
                        newValue = num2str(newValue);
                    case 'stringAsString'
                        % do nothing
                    case 'numberAsNumber'
                        % do nothing
                    otherwise
                        error('invalid conversion info in syncDataList!');
                end
                set(thisControlHandle, targetField, newValue);
            end
        
        % function end
        end        
        
                    
                    
        %
        function fig2uic(this, callerHandle)
            
            % find out which object called this function, and find it in the syncDataList
            callerTag = get(callerHandle, 'Tag');
            iCaller = find( strcmp( this.syncList(:,1), callerTag ) );
            
            callerField = this.syncList{iCaller,2};
            newValue = get(callerHandle, callerField);
            
            % convert the data to a string to go into eval, in various ways
            switch this.syncList{iCaller,3} % this specifies the conversionMode
                case 'stringToNumber'
                    newValAsNumber = str2double(newValue);
                    if isequal(size(newValAsNumber),[1 1]) % if it's actually the string for a number
                        newValueString = newValue;
                    else
                        error('input has to be the string of a number!');
                    end
                case 'stringAsString'
                    newValueString = ['''', newValue, ''''];
                case 'numberAsNumber'
                    newValueString = num2str(newValue);
                otherwise
                    error('invalid conversion info in syncDataList!');
            end
            
            modelUpdateCommand = [ 'this.uic.', this.syncList{iCaller,4}, ' = ', newValueString, ';' ];
            eval(modelUpdateCommand);            
        
        % function end
        end
        
                                  
    % end of methods           
    end

% end of class       
end

