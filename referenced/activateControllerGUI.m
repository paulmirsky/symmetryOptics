function activateControllerGUI(varargin)

    % gets the controller that is managing this button
    uicontrolClient = varargin{1};
    userDataLO = get(uicontrolClient, 'UserData');
    controller = userDataLO{1};

    % gets the name (string) of the function in the controller that it starts
    functionName = userDataLO{2};

    % command the controller to run the function (using a weird syntax w/ strings)
    controller.(functionName)(varargin{1});

end
