classdef SnS_controller < handle
    
    properties        
        % component objects
        model
        view        
        sync
        tabletop
        
        % synced params from screen
        sizeA = 1
        sizeB = 1
        sizeC = 1
        sizeD = 1
        showRearFlat = false
        showArrayOnly = false
        showPattern = false
        auxSelection = 1

        % misc
        nActiveFactors        
        figPosVec = [1 1 1000 600]
        factorNames = {'A','B','C','D'}
        tabletopFilename = 'SnS_auxCode.m'
        
    end
    properties (Access = 'private')
    end

    
    methods
        
        % constructor
        function this = SnS_controller( )
        % constructor end
        end 
        
        
        
        % 
        function initialize(this, ~)
            
            % create the figure, put in the right location
            this.view = SnS_view();
            this.view.figPosVec = this.figPosVec;
            this.view.controller = this;
            this.view.initialize;
            
            this.model = SnS_model();
            
            % define responses to buttons pushed in view.figure
            this.sync = syncView2Model();      
            this.sync.uic = this;
            this.sync.figure = this.view.fig;         
            this.sync.responseList = {... % format for one row is { buttonTag, controllerMethodName }
                'tiltA', 'tilt';
                'tiltB', 'tilt';
                'tiltC', 'tilt';
                'tiltD', 'tilt';
                'slideA', 'slide';
                'slideB', 'slide';
                'slideC', 'slide';
                'slideD', 'slide';
                'phaseA', 'phase';
                'phaseB', 'phase';
                'phaseC', 'phase';
                'phaseD', 'phase';
                'reset', 'reset';
                'aux', 'aux';
                'regenerate', 'regenerate';
                'valA', 'applyVals';
                'valB', 'applyVals';
                'valC', 'applyVals';
                'valD', 'applyVals';
                };
            this.sync.syncList = {... % format for one row is { controlTag, controlField, conversionMode, variableToSyncTo }
                'sizeA', 'String', 'stringToNumber', 'sizeA';
                'sizeB', 'String', 'stringToNumber', 'sizeB';
                'sizeC', 'String', 'stringToNumber', 'sizeC';
                'sizeD', 'String', 'stringToNumber', 'sizeD';
                'auxSelection', 'String', 'stringToNumber', 'auxSelection';
                'showRearFlat', 'Value', 'numberAsNumber', 'showRearFlat';
                'showArrayOnly', 'Value', 'numberAsNumber', 'showArrayOnly';
                'showPattern', 'Value', 'numberAsNumber', 'showPattern';
            };

            this.sync.connect();       
            this.sync.uic2fig(); % populate the view with data            
            this.tabletop = auxManager(this.tabletopFilename, this); % create aux code                
            this.regenerate();
            
            this.view.postStatus('App is initialized');
            
        % function end
        end            
       
        
        
        % 
        function regenerate(this, ~)
            
            this.view.postStatus('Regenerating...');
            this.view.clearAxes(this.view.rearPattern);
            this.view.clearAxes(this.view.rearFactors);
            this.view.clearAxes(this.view.frontPattern);
            this.view.clearAxes(this.view.frontFactors);
            drawnow;
            
            % enable the controls needed for this mode
            activeArchetype = this.view.archetypeGroup.SelectedObject.Tag;
            activeControlMode = this.view.controlModeGroup.SelectedObject.Tag;
            this.view.setButtonsEnabled(activeArchetype, activeControlMode)

            % create factors, each with a set of basis vectors
            if strcmp(activeArchetype,'positionFactor')
                this.nActiveFactors = 1;
                allTypes = {'position'};
            elseif strcmp(activeArchetype,'angleFactor')
                this.nActiveFactors = 1;
                allTypes = {'angle'};
            elseif strcmp(activeArchetype,'beam')
                this.nActiveFactors = 2;
                allTypes = {'angle', 'position'};
            elseif strcmp(activeArchetype,'grating')
                this.nActiveFactors = 4;
                allTypes = {'angle', 'position', 'angle', 'position'};
            else
                error('invalid nFactors selection!');
            end        
            allSizes = { this.sizeA, this.sizeB, this.sizeC, this.sizeD };
            if ~this.validateAllIndices( allSizes(1:this.nActiveFactors) )
                this.view.postStatus('Error while calculating new pattern! Invalid factor sizes');
                return;
            end
            
            this.model.clearObject();
            indexPopups = { this.view.valA, this.view.valB,... 
                this.view.valC, this.view.valD };
            for ii = 1:this.nActiveFactors
                this.model.addFactorAndXform( allSizes{ii}, allTypes{ii} );
                indexPopups{ii}.Value = 1; % temporarily set to this, cause it can't break
                % the actual value returned by the popup is the *index
                % (starts at 1) but the values that are visible on the
                % control are the values
                allVals = this.model.factors{ii}.values;
                menuChoices = cell(size(allVals));
                for jj = 1:numel(allVals)
                    menuChoices{jj} = num2str( allVals(jj) );
                end
                indexPopups{ii}.String = menuChoices;
            end
            
            this.reset();
            this.view.postStatus('All factors have been generated.');

        % function end
        end            
        
                
       
        % buttons are called tiltA, tiltB, slideA, etc., and *must* use this
        % convention, so you can get the factor from the last letter
        function iFactor = getFactorFromHandle(~, callerHandle)
            
            if (callerHandle.Tag(end)=='A')
                iFactor = 1;
            elseif (callerHandle.Tag(end)=='B')
                iFactor = 2;
            elseif (callerHandle.Tag(end)=='C')
                iFactor = 3;
            elseif (callerHandle.Tag(end)=='D')
                iFactor = 4;
            end
            
        % function end
        end
        
        
        
        function applyVals(this, ~)
            
            this.view.postStatus('Calculating new pattern...');
            drawnow;
            
            % these values can't be synced, because the menu is already
            % set to trigger a command
            indexA = this.view.valA.Value;
            indexB = this.view.valB.Value;
            indexC = this.view.valC.Value;
            indexD = this.view.valD.Value;

            allIndices = { indexA, indexB, indexC, indexD };
            allIndices = allIndices(1:this.nActiveFactors);
            
            this.model.setFrontFactorState( allIndices );
            this.calcAndShowFacsPatterns();
            
        % function end
        end           

        
                
        function allAreValid = validateAllIndices(~, indexArray )
            
            allAreValid = true;
            
            for thisVal = cell2mat(indexArray);
                if ~allEntriesAreIntegers(thisVal,1e-9)
                    allAreValid = false;
                end
                if (thisVal<1)
                    allAreValid = false;
                end
                if isempty(thisVal)
                    allAreValid = false;
                end
            end
            
        % function end
        end           

        
        
        function calcAndShowFacsPatterns(this, ~)
            
            this.view.setFormat(this.showRearFlat, this.showPattern);
            
            this.model.showArrayOnly = this.showArrayOnly;
            [factorsFront, patternFront] = this.model.calcFrontFlat();
            this.view.drawFactorChain('frontFlat', factorsFront );
            if this.showPattern
                this.view.drawPattern('frontFlat', patternFront );
            end
            
            if this.showRearFlat
                [factorsRear, patternRear] = this.model.calcRearFlat();
                this.view.drawFactorChain('rearFlat', factorsRear );
                frontTitle = 'FRONT';
                rearTitle = 'REAR';
                if this.showPattern
                    this.view.drawPattern('rearFlat', patternRear );
                    title(this.view.frontPattern, frontTitle, 'Color', this.view.axesTitleColor);
                    title(this.view.rearPattern, rearTitle, 'Color', this.view.axesTitleColor);
                else
                    title(this.view.frontFactors, frontTitle, 'Color', this.view.axesTitleColor);
                    title(this.view.rearFactors, rearTitle, 'Color', this.view.axesTitleColor);
                end
            else
                this.view.clearAxes(this.view.rearPattern);
                this.view.clearAxes(this.view.rearFactors);
            end
            
            this.view.postStatus('Pattern is complete.');
            
        % function end
        end           
        
        
               
        function reset(this, ~)
            
            this.view.valA.Value = this.model.indexFromVal(1, 0);
            
            if (this.nActiveFactors > 1)
                this.view.valB.Value = this.model.indexFromVal(2, 0);
            end

            if (this.nActiveFactors==4)
                this.view.valC.Value = this.model.indexFromVal(3, 0);
                this.view.valD.Value = this.model.indexFromVal(4, 0);
            end
            
            this.applyVals();

        % function end
        end                      
           
        
            
        function aux(this, ~)
            
            this.tabletop.executeSection(this.auxSelection); 
            
        % function end
        end           
        
        
        
        % 
        function tilt(this, callerHandle)
            
            iFactor = this.getFactorFromHandle(callerHandle);
            this.model.applyXform('tilt',iFactor);
            this.calcAndShowFacsPatterns();
            this.view.postStatus(['Tilt applied on factor ',this.factorNames{iFactor}]);
            
        % function end
        end            
        
        
        
        %
        function slide(this, callerHandle)
            
            iFactor = this.getFactorFromHandle(callerHandle);
            this.model.applyXform('slide',iFactor);
            this.calcAndShowFacsPatterns();
            this.view.postStatus(['Slide applied on factor ',this.factorNames{iFactor}]);
            
        % function end
        end            
                        
        
        
        %
        function phase(this, callerHandle)
            
            iFactor = this.getFactorFromHandle(callerHandle);
            this.model.applyXform('phase',iFactor);
            this.calcAndShowFacsPatterns();
            this.view.postStatus(['Phase applied on factor ',this.factorNames{iFactor}]);
            
        % function end
        end            
 
        
    % end of methods           
    end

% end of class       
end

