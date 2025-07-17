% create_bus_definitions.m
% Defines Simulink bus objects for ACS data structures (based on SADD Section 4.1.2).
% These match AircraftState_T, ControlCommand_T, and SystemStatus_T.
% Run this script to create the buses in the base workspace.

clear all;  % Clear workspace to avoid conflicts

%% Helper function to create a bus element
function elem = createBusElement(name, dataType, dims)
    elem = Simulink.BusElement;
    elem.Name = name;
    elem.DataType = dataType;
    elem.Dimensions = dims;
    elem.SampleTime = -1;  % Inherited
    elem.Complexity = 'real';
    elem.SamplingMode = 'Sample based';
end

%% AircraftState_T Bus (attitude, rates, etc. - from SADD)
aircraftStateElems = [
    createBusElement('roll', 'single', 1);          % [rad]
    createBusElement('pitch', 'single', 1);         % [rad]
    createBusElement('yaw', 'single', 1);           % [rad]
    createBusElement('roll_rate', 'single', 1);     % [rad/s]
    createBusElement('pitch_rate', 'single', 1);    % [rad/s]
    createBusElement('yaw_rate', 'single', 1);      % [rad/s]
    createBusElement('airspeed', 'single', 1);      % [m/s]
    createBusElement('altitude', 'single', 1);      % [m]
    createBusElement('aoa', 'single', 1);           % Angle of attack [rad]
    createBusElement('ax', 'single', 1);            % Accelerations [m/s²]
    createBusElement('ay', 'single', 1);
    createBusElement('az', 'single', 1);
    createBusElement('timestamp', 'uint32', 1);     % [ms]
    createBusElement('valid_flags', 'uint16', 1)    % Bit flags for validity
];

AircraftState_T = Simulink.Bus;
AircraftState_T.HeaderFile = '';
AircraftState_T.Description = 'Aircraft State Structure (SADD)';
AircraftState_T.Elements = aircraftStateElems;

%% ControlCommand_T Bus (commands - from SADD)
controlCommandElems = [
    createBusElement('roll_cmd', 'single', 1);      % [rad]
    createBusElement('pitch_cmd', 'single', 1);     % [rad]
    createBusElement('elevator_cmd', 'single', 1);  % [rad]
    createBusElement('aileron_cmd', 'single', 1);   % [rad]
    createBusElement('rudder_cmd', 'single', 1);    % [rad]
    createBusElement('mode', 'uint8', 1);           % Operating mode
    createBusElement('limits_active', 'uint8', 1)   % Flags for active limits
];

ControlCommand_T = Simulink.Bus;
ControlCommand_T.HeaderFile = '';
ControlCommand_T.Description = 'Control Command Structure (SADD)';
ControlCommand_T.Elements = controlCommandElems;

%% SystemStatus_T Bus (status and health - from SADD)
systemStatusElems = [
    createBusElement('current_mode', 'uint8', 1);   % Enum for modes (Normal=1, Degraded=2, etc.)
    createBusElement('fault_flags', 'uint32', 1);
    createBusElement('warning_flags', 'uint32', 1);
    createBusElement('cpu_usage', 'single', 1);     % [%] - <80% per RRD
    createBusElement('control_error_rms', 'single', 1);  % RMS error
    createBusElement('active_limits', 'uint8', [1 10]);  % Array of active safety limits (up to 10)
    createBusElement('num_active_limits', 'uint8', 1)
];

SystemStatus_T = Simulink.Bus;
SystemStatus_T.HeaderFile = '';
SystemStatus_T.Description = 'System Status Structure (SADD)';
SystemStatus_T.Elements = systemStatusElems;

%% Assign to base workspace and save (for use in Simulink models)
assignin('base', 'AircraftState_T', AircraftState_T);
assignin('base', 'ControlCommand_T', ControlCommand_T);
assignin('base', 'SystemStatus_T', SystemStatus_T);

save('data/navigation_buses.mat', 'AircraftState_T', 'ControlCommand_T', 'SystemStatus_T');

disp('Bus definitions created and saved to data/navigation_buses.mat');