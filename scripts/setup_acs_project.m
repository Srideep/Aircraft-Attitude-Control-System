% setup_acs_project.m
% Initializes the ACS project: Adds paths, loads buses and configs.
% Run this script at the start of each MATLAB session.
% Ties into SADD modularity and SRS requirements.
% MATLAB Online compatible: Uses relative paths and handles manual config file.

clear all; close all; clc;

% Define project root (assuming this script is in scripts/)
projectRoot = fileparts(fileparts(mfilename('fullpath')));  % Go up two levels to root
if isempty(projectRoot)
    projectRoot = pwd;  % Fallback for MATLAB Online if paths are flat
end
disp(['Project root set to: ' projectRoot]);

% Add all subfolders to MATLAB path
addpath(genpath(projectRoot));  % Includes src/, sim/, tests/, etc.
disp('Project paths added.');

% Load bus definitions (from create_bus_definitions.m)
busFile = fullfile(projectRoot, 'data', 'navigation_buses.mat');
if exist(busFile, 'file')
    load(busFile);
    disp('Bus definitions loaded into workspace.');
else
    disp('Bus definitions not found. Run create_bus_definitions.m first.');
end

% Load configuration set (from manual simConfigSet.m)
configFile = fullfile(projectRoot, 'config', 'simConfigSet.m');
if exist(configFile, 'file')
    try
        run(configFile);  % Runs the .m to create 'cs' in workspace
        disp('Configuration set loaded from simConfigSet.m.');
        
        % Optionally attach to attitude_control.slx if loaded (uncomment to enable)
        % if bdIsLoaded('attitude_control')
        %     attachConfigSet('attitude_control', cs, true);
        %     setActiveConfigSet('attitude_control', cs.Name);
        %     disp('Config set attached to attitude_control.slx');
        % end
    catch ME
        disp('Error loading config:');
        disp(ME.message);
    end
else
    disp('Configuration set not found. Create config/simConfigSet.m manually.');
end

% Open key models (optional - uncomment to auto-open a placeholder)
% modelPath = fullfile(projectRoot, 'src', 'models', 'attitude_control.slx');
% if exist(modelPath, 'file')
%     open_system(modelPath);
%     disp('Opened attitude_control.slx');
% else
%     disp('attitude_control.slx not found. Create it in src/models/ first.');
% end

% Display setup complete
disp('ACS project setup complete. Ready to simulate or generate code.');
disp('Next steps: Run run_simulation.m or generate_code.m');