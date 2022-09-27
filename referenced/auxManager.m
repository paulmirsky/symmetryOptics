classdef auxManager
    
    properties
        fileName
        controllerHandle
        fileHandle
    end
    
    methods
        
        % construtor
        function this = auxManager(fileNameIA, controllerHandleIA)
            this.fileName = fileNameIA; % store file name
            this.controllerHandle = controllerHandleIA;
            this.fileHandle = str2func(this.stripOffFileExtension(fileNameIA));  
        end

        
        
        % executes one section
        function executeSection(self, sectionToExecute)
            self.fileHandle(sectionToExecute, self.controllerHandle);
        end
        
    
        
        % Give it 'someFileName.mat' and it returns 'someFileName'
        function out = stripOffFileExtension(~, fileName)
            dotPosition = strfind(fileName, '.');
            out = fileName(1:(dotPosition - 1));
        end

        
    end
    
end

