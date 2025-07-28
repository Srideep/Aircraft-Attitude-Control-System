function generate_simConfigSet(outFile)
%GENERATE_SIMCONFIGSET  Build & save the default ACS simulation config (.ssc)
%
%   generate_simConfigSet                       % saves to config/simConfigSet.ssc
%   generate_simConfigSet('myConfig.ssc')       % custom path / filename
%
%   The script creates a Simulink.ConfigSet tuned for the Aircraft Attitude
%   Control System: 100 Hz fixed‑step discrete solver, inline parameter
%   tuning, workspace logging ON, and code‑gen turned OFF (desktop sim).
%
%   After running it once, just execute  setup_project  (or follow the quick
%   steps under “HOW TO RUN” at the bottom) to attach the config to ACS.slx
%   automatically.
%
%──────────────────────────────────────────────────────────────────────────

if nargin<1
    outFile = fullfile('config','simConfigSet.ssc');
end
if ~exist(fileparts(outFile),'dir'); mkdir(fileparts(outFile)); end

%% 1. Create base config ---------------------------------------------------
cs          = Simulink.ConfigSet;
cs.Name     = 'ACS_Config';

%% 2. Solver settings ------------------------------------------------------
set_param(cs, ...
    'SolverType',       'Fixed-step',            ...
    'Solver',           'FixedStepDiscrete',     ...  % no continuous states
    'FixedStep',        '0.01',                  ...  % 100 Hz loop
    'StartTime',        '0',                     ...
    'StopTime',         'inf',                   ...  % run until user stops
    'EnableMultiTasking','off');

%% 3. Data logging ---------------------------------------------------------
set_param(cs, ...
    'SignalLoggingName',      'logsout', ...
    'SignalLogging',          'on',      ...
    'SignalLoggingSaveFormat','Dataset', ...
    'SaveTime',               'on',      ...
    'SaveOutput',             'on',      ...
    'LimitDataPoints',        'on',      ...
    'MaxDataPoints',          '50000');

%% 4. Diagnostics (key ones) ----------------------------------------------
set_param(cs, ...
    'ConsistencyChecking',  'none',   ...  % faster builds
    'SolverConsistencyChecking','none');

%% 5. Hardware & code‑gen (desktop sim only) ------------------------------
set_param(cs, ...
    'SystemTargetFile',      '', ...   % no code generation
    'ProdHWDeviceType',      'MATLAB->PC-Intel x86-64 (Windows64)');

%% 6. Save as .ssc ---------------------------------------------------------
Simulink.saveConfigSet(outFile, cs);
fprintf('[ACS] Config set saved → %s\n', outFile);
end

%──────────────────────────────────────────────────────────────────────────
%% HOW TO RUN (QUICK GUIDE)
%   >> cd path/to/acs-project
%   >> generate_simConfigSet           % builds config/simConfigSet.ssc
%   >> setup_project                   % adds paths, loads buses & config
%   >> open_system('ACS')              % verify config attached (Model > Model Settings)
%   >> sim('ACS','StopTime','10')      % run 10 s desktop simulation
%
%   The  setup_project  script automatically loads the .ssc you just
%   generated and attaches it to ACS.slx, so no manual linking is needed.
