function con = SnS_getApp(figName)

    allHandles = findall(0);
    appFig = findobj(allHandles, 'FileName', which(figName));
    if (size(appFig)==0)
        errorMsg = ['there is no ', figName, ' avaiable!'];
        error(errorMsg);
    end
    con = appFig.UserData{1}.controller;

end

