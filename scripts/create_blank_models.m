% create_blank_models.m
% Creates blank Simulink models (.slx files) in src/models/ folder.
% Based on SADD architecture: Top-level model and subsystems for components/layers.
% Skips existing files to avoid overwriting.
% Run from project root or after setup_acs_project.m.
% MATLAB Online compatible: Creates folders if needed, uses relative paths.

clear all; clc;

% Define project root (fallback for MATLAB Online)
projectRoot = pwd;  % Assume current directory is root; adjust if needed

% Define models folder
modelsFolder = fullfile(projectRoot, 'src', 'models');



% List of models to create (from project structure and SADD components)
modelNames = {
    'attitude_control',         % Top-level: Integrates all subsystems
    'custom_dynamics',          % 6-DOF dynamics (quaternions, integrators)
    'state_estimation',         % Sensor fusion (e.g., Kalman filter)
    'control_algorithms',       % Cascaded PID controllers
    'safety_monitor',           % Envelope protection and limits
    'command_processing',       % Pilot input handling
    'interface_layer',          % I/O and data interfaces
    'infrastructure_layer'      % Scheduler, logging, and infrastructure
};

% Create each blank model
for i = 1:length(modelNames)
    modelName = modelNames{i};
    fullPath = fullfile(modelsFolder, [modelName '.slx']);
    
    if exist(fullPath, 'file')
        disp(['Skipping existing model: ' fullPath]);
        continue;
    end
    
    % Create new blank system
    new_system(modelName);
    
    % Optional: Add a note or basic subsystem (uncomment if desired)
    % add_block('simulink/Commonly Used Blocks/Subsystem', [modelName '/BlankSubsystem']);
    % set_param([modelName '/BlankSubsystem'], 'Position', [100 100 200 150]);
    
    % Save the model
    save_system(modelName, fullPath);
    bdclose(modelName);  % Close to keep workspace clean
    
    disp(['Created blank model: ' fullPath]);
end

disp('All blank models created. Next: Open and add blocks (e.g., open_system(''src/models/attitude_control.slx''))');