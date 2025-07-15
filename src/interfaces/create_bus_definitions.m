%% create_bus_definitions.m
% Define all bus objects for the ACS system

function create_bus_definitions()
    
    % Aircraft State Bus
    clear elems;
    elems(1) = Simulink.BusElement;
    elems(1).Name = 'roll_rad';
    elems(1).Dimensions = 1;
    elems(1).DataType = 'double';
    elems(1).Min = -pi;
    elems(1).Max = pi;
    
    elems(2) = Simulink.BusElement;
    elems(2).Name = 'pitch_rad';
    elems(2).Dimensions = 1;
    elems(2).DataType = 'double';
    elems(2).Min = -pi/2;
    elems(2).Max = pi/2;
    
    elems(3) = Simulink.BusElement;
    elems(3).Name = 'yaw_rad';
    elems(3).Dimensions = 1;
    elems(3).DataType = 'double';
    elems(3).Min = -pi;
    elems(3).Max = pi;
    
    elems(4) = Simulink.BusElement;
    elems(4).Name = 'p_rps';
    elems(4).Dimensions = 1;
    elems(4).DataType = 'double';
    elems(4).Min = -deg2rad(300);
    elems(4).Max = deg2rad(300);
    
    elems(5) = Simulink.BusElement;
    elems(5).Name = 'q_rps';
    elems(5).Dimensions = 1;
    elems(5).DataType = 'double';
    elems(5).Min = -deg2rad(300);
    elems(5).Max = deg2rad(300);
    
    elems(6) = Simulink.BusElement;
    elems(6).Name = 'r_rps';
    elems(6).Dimensions = 1;
    elems(6).DataType = 'double';
    elems(6).Min = -deg2rad(300);
    elems(6).Max = deg2rad(300);
    
    elems(7) = Simulink.BusElement;
    elems(7).Name = 'valid';
    elems(7).Dimensions = 1;
    elems(7).DataType = 'boolean';
    
    AircraftState = Simulink.Bus;
    AircraftState.Elements = elems;
    assignin('base', 'AircraftState', AircraftState);
    
    % Control Command Bus
    clear elems;
    elems(1) = Simulink.BusElement;
    elems(1).Name = 'elevator_rad';
    elems(1).Dimensions = 1;
    elems(1).DataType = 'double';
    elems(1).Min = -deg2rad(15);
    elems(1).Max = deg2rad(15);
    
    elems(2) = Simulink.BusElement;
    elems(2).Name = 'aileron_rad';
    elems(2).Dimensions = 1;
    elems(2).DataType = 'double';
    elems(2).Min = -deg2rad(20);
    elems(2).Max = deg2rad(20);
    
    elems(3) = Simulink.BusElement;
    elems(3).Name = 'rudder_rad';
    elems(3).Dimensions = 1;
    elems(3).DataType = 'double';
    elems(3).Min = -deg2rad(25);
    elems(3).Max = deg2rad(25);
    
    ControlCommand = Simulink.Bus;
    ControlCommand.Elements = elems;
    assignin('base', 'ControlCommand', ControlCommand);
    
    fprintf('Bus objects created successfully.\n');

    % Determine the project root based on the location of this script and
    % construct the path to the data folder. This keeps the output
    % location valid regardless of where the project is cloned.
    scriptDir = fileparts(mfilename('fullpath'));
    projectRoot = fileparts(fileparts(scriptDir));
    outputFolder = fullfile(projectRoot, 'data/parameters');

    % Create the output folder if it doesn't exist
    if ~exist(outputFolder, 'dir')
       mkdir(outputFolder)
    end
    
    filePath = fullfile(outputFolder, 'aircraft_attitude_control_system_bus.mat');
    save(filePath);
    % Add the newly created file to the project
    if ~isempty(currentProject)
        addFile(currentProject, filePath);
    end    
    fprintf('Bus definitions saved to %s\n', filePath);
end