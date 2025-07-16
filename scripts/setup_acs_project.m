% Quick fix - create directories manually
proj = currentProject;  % Get current project
projectRoot = proj.RootFolder;
fprintf('=== Aircraft Attitude Control System Setup ===\n');
% Create missing directories
    directories = {
            'models', 'models/subsystems', 'models/libraries',...
            'src', 'src/controllers', 'src/monitors', 'src/interfaces',...
            'test', 'test/unit', 'test/integration', 'test/system',...
            'data', 'data/parameters', 'data/results', 'data/requirements',...
            'docs', 'utilities'
    };
for i = 1:length(directories)
    dirPath = fullfile(projectRoot, directories{i});
    if ~exist(dirPath, 'dir')
        mkdir(dirPath);
        fprintf('Created: %s\n', directories{i});
    end
end

% Now add paths
addPath(proj, fullfile(projectRoot, 'models'));
addPath(proj, fullfile(projectRoot, 'models/subsystems'));

    
fprintf('Setup complete! Project ready for implementation.\n');