% make_config_set.m
% Creates a Simulink configuration set for ACS simulations and exports as .m file.
% Based on SRS (100 Hz update rate) and SADD (deterministic, floating-point).
% MATLAB Online adjustments: Creates 'config' folder if missing, uses full paths,
% and enhanced error handling for Drive permissions.
% Run this in MATLAB Online with project as working folder.

clear all; close all;

% Define paths relative to current working directory (project root)
configFolder = 'config';
configFile = fullfile(configFolder, 'simConfigSet.m');
tempModel = 'temp_config_model';  % Temp model name (in current folder)

% Create config folder if it doesn't exist (MATLAB Online safe)
if ~exist(configFolder, 'dir')
    [status, msg] = mkdir(configFolder);
    if status == 0
        error('Failed to create config folder: %s', msg);
    end
    disp('Created config/ folder.');
end

% Create a temporary model to attach the config set (avoids export errors)
new_system(tempModel);
open_system(tempModel);

% Get the active config set from the temp model and copy it
cs = getActiveConfigSet(tempModel);
cs = cs.copy;  % Copy to modify

% Set solver parameters for fixed-step, real-time simulation (100 Hz = 0.01s step)
set_param(cs, 'SolverType', 'Fixed-step');
set_param(cs, 'Solver', 'ode4');  % Runge-Kutta for accuracy in custom 6-DOF dynamics
set_param(cs, 'FixedStep', '0.01');  % 100 Hz per SRS
set_param(cs, 'StartTime', '0');
set_param(cs, 'StopTime', '10');  % Default sim time; override in run_simulation.m

% Hardware/execution settings (floating-point per SADD rationale)
set_param(cs, 'HardwareBoard', 'None');  % Custom or none for simulation
set_param(cs, 'ProdHWDeviceType', 'Generic->Custom');  % For code gen to PowerPC later
set_param(cs, 'TargetLang', 'C');  % ANSI C99 per SADD
set_param(cs, 'TargetLangStandard', 'C99 (ISO)');

% Code generation settings (for Embedded Coder integration)
set_param(cs, 'GenCodeOnly', 'off');  % Generate and build
set_param(cs, 'PackageGeneratedCodeAndArtifacts', 'off');

% Diagnostics and logging (for safety monitoring per SDD)
set_param(cs, 'SaveState', 'on');
set_param(cs, 'StateSaveName', 'xout');
set_param(cs, 'SaveOutput', 'on');
set_param(cs, 'OutputSaveName', 'yout');
set_param(cs, 'SignalLogging', 'on');
set_param(cs, 'SignalLoggingName', 'logsout');

% Attach the modified config to the temp model
attachConfigSet(tempModel, cs, true);
setActiveConfigSet(tempModel, cs.Name);

% Export the config set as an .m file
try
    % Preferred method (R2019a+)
    Simulink.exportToVersion(tempModel, configFile, 'R2019a', 'BreakUserLinks', true);
catch ME
    % Fallback for MATLAB Online or permissions issues: Generate script manually
    try
        h = fopen(configFile, 'w');
        if h == -1
            error('Could not write to %s. Check: 1) MATLAB Drive permissions, 2) Space available, 3) Folder exists.', configFile);
        end
        fprintf(h, '%% simConfigSet.m - Generated config set script\n');
        fprintf(h, 'cs = Simulink.ConfigSet;\n');
        fprintf(h, '%s\n', cs.get_param_script);  % Writes all set_param commands
        fclose(h);
        disp('Fallback used: Config set script generated manually.');
    catch innerME
        disp('Export failed. Error details:');
        disp(ME.message);
        disp('Inner error:');
        disp(innerME.message);
        error('Manual fix needed: Create config/simConfigSet.m manually or check Drive access.');
    end
end

% Clean up: Close the temp model (don't delete in MATLAB Online—do it manually via Files pane if needed)
bdclose(tempModel);

disp(['Configuration set created and exported to ' configFile]);