classdef grabFacsAndPatterns  < handle
    
    properties
        appFig
        appName
        saveFolder
        saveName
        borderSize_norm_V = .035
        borderSize_norm_H = .08
        
    end
    
    
    methods
        
        % constructor
        function this = grabFacsAndPatterns()
        % constructor end
        end 
        
        
        
        % 
        function initializeApp(this)
            
            allHandles = findall(0);
            this.appFig = findobj(allHandles, 'FileName', which(this.appName));
            if (size(this.appFig)==0)
                error('start the app first');
            end
            disp('found app!');            
            
        % constructor end
        end 
        
        
        


        % if lowerAxesName is 'all', then it grabs the whole window
        % otherwise, lowerAxesName and upperAxesName define the two (or
        % one) axes that form the lower and upper limts of the grabbed
        % region
        function grabPlane(this, lowerAxesName, upperAxesName, tag)
            
            figChildrenList = get(this.appFig, 'Children');
            lowerAxes = findobj(figChildrenList,'Tag', lowerAxesName);
            upperAxes = findobj(figChildrenList,'Tag', upperAxesName);
            
            % grab the image
            frameObj = getframe( this.appFig );
            imageArray = frame2im(frameObj);

            if ~strcmp(lowerAxesName,'all')
                [nPixY, nPixX, ~] = size(imageArray);
                % get clip region
                [ clipCornerXY, clipSizeXY ] = this.getClipInfo(lowerAxes, upperAxes);
                clipRegionX_px = ( clipCornerXY(1)*nPixX ) : (( clipCornerXY(1) + clipSizeXY(1) )*nPixX);
                clipRegionY_px = ( clipCornerXY(2)*nPixY ) : (( clipCornerXY(2) + clipSizeXY(2) )*nPixY);
                % trim if too large or small
                clipRegionX_px = clipRegionX_px( clipRegionX_px <= nPixX );
                clipRegionY_px = clipRegionY_px( clipRegionY_px <= nPixY );
                clipRegionX_px = clipRegionX_px( clipRegionX_px >= 1 );
                clipRegionY_px = clipRegionY_px( clipRegionY_px >= 1 );
                % round cause it 
                clipRegionX_px = round( clipRegionX_px );
                clipRegionY_px = round( clipRegionY_px );
                % flip upside-down cause the way of specifying is different
                clipRegionY_px = fliplr( nPixY - clipRegionY_px ) + 1;
                imageArray = imageArray( clipRegionY_px, clipRegionX_px,:);                
            end

            % get the name
            savePath = [ this.saveFolder, this.saveName, tag, '.bmp' ];
            imwrite(imageArray,savePath)                
            
        % function end
        end
        
               

        
        % 
        function [ clipCornerXY, clipSizeXY ] = getClipInfo(this, lowerAxes, upperAxes)
           
            clipCornerXY = lowerAxes.Position(1:2) - [ this.borderSize_norm_H, this.borderSize_norm_V ];
            clipSizeXY(1) = lowerAxes.Position(3) + 2*this.borderSize_norm_H;
            upperTopY = upperAxes.Position(2) + upperAxes.Position(4);
            lowerBottomY = lowerAxes.Position(2);
            clipSizeXY(2) = upperTopY - lowerBottomY + 2*this.borderSize_norm_V;
        
        % function end
        end
        
        

        
        % 
        function FUNCTIONNAME(this, inputArguments)
        
        
        % function end
        end
        
        
        
        
               
    % end of methods           
    end

% end of class       
end

