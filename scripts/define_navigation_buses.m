function define_navigation_buses()
%DEFINE_NAVIGATION_BUSES  Create & register core Simulink bus objects for ACS
%
%   This script (re)builds the three buses described in the Developer Guide
%   Listing 2 plus the optional Altitude‑Hold signals.  Run it once after
%   cloning the repo or whenever you modify a bus definition.
%
%   The buses are saved to  data/navigation_buses.mat  and pushed into the
%   base workspace so Simulink models can resolve them immediately.
%
%   Buses created
%   ──────────────
%     • Bus_AircraftState  – aircraft attitude & rates
%     • Bus_PilotCmd       – pilot stick / mode commands
%     • Bus_ActuatorCmd    – surface‑deflection commands & safety flag
%
%   Example
%   ▸  define_navigation_buses;         % (re)create the bus objects
%   ▸  open_system('ACS');              % confirm no Bus object errors
%
%   See also:  setup_project.m, ACS.slx
%
%──────────────────────────────────────────────────────────────────────────

% Ensure Simulink is loaded ------------------------------------------------
if ~bdIsLoaded('simulink')
    load_system('simulink');
end

%% ────────────────────────────────
%  1. Bus_AircraftState            
%─────────────────────────────────
BA_e = [];
BA_e(end+1) = buildElem('roll_deg',     'double', 1, 'Roll angle (deg)');
BA_e(end+1) = buildElem('pitch_deg',    'double', 1, 'Pitch angle (deg)');
BA_e(end+1) = buildElem('yaw_deg',      'double', 1, 'Yaw angle (deg)');
BA_e(end+1) = buildElem('p_deg_s',      'double', 1, 'Roll rate (deg/s)');
BA_e(end+1) = buildElem('q_deg_s',      'double', 1, 'Pitch rate (deg/s)');
BA_e(end+1) = buildElem('r_deg_s',      'double', 1, 'Yaw rate (deg/s)');
BA_e(end+1) = buildElem('timestamp_s',  'double', 1, 'Sample timestamp (s)');
BA_e(end+1) = buildElem('validFlags',   'boolean',1, 'Sensor valid flags');
Bus_AircraftState = Simulink.Bus('Elements',BA_e); %#ok<NASGU>

%% ────────────────────────────────
%  2. Bus_PilotCmd                 
%─────────────────────────────────
BP_e = [];
BP_e(end+1) = buildElem('rollCmd_deg',     'double', 1, 'Desired roll (deg)');
BP_e(end+1) = buildElem('pitchCmd_deg',    'double', 1, 'Desired pitch (deg)');
BP_e(end+1) = buildElem('yawCmd_deg',      'double', 1, 'Desired yaw (deg)');
BP_e(end+1) = buildElem('modeSwitch',      'uint8',  1, '0=MANUAL,1=STAB,...');
% Altitude‑hold (optional extension)
BP_e(end+1) = buildElem('altHoldCmd_ft',   'double', 1, 'Desired altitude (ft)');
BP_e(end+1) = buildElem('altHoldEnable',   'boolean',1, 'Altitude‑hold enable');
Bus_PilotCmd = Simulink.Bus('Elements',BP_e); %#ok<NASGU>

%% ────────────────────────────────
%  3. Bus_ActuatorCmd              
%─────────────────────────────────
BC_e = [];
BC_e(end+1) = buildElem('aileron_pct',  'double', 1, 'Aileron command (‑100–100)');
BC_e(end+1) = buildElem('elevator_pct', 'double', 1, 'Elevator command');
BC_e(end+1) = buildElem('rudder_pct',   'double', 1, 'Rudder command');
BC_e(end+1) = buildElem('limitsActive', 'boolean',1, 'True when safety limiting');
Bus_ActuatorCmd = Simulink.Bus('Elements',BC_e); %#ok<NASGU>

%% Save & report -----------------------------------------------------------
if ~exist('data','dir'); mkdir('data'); end
save(fullfile('data','navigation_buses.mat'), 'Bus_AircraftState','Bus_PilotCmd','Bus_ActuatorCmd');
assignin('base','Bus_AircraftState',Bus_AircraftState);
assignin('base','Bus_PilotCmd',     Bus_PilotCmd);
assignin('base','Bus_ActuatorCmd',  Bus_ActuatorCmd);

fprintf('[ACS] Bus objects created & saved to data/navigation_buses.mat\n');

end  % define_navigation_buses

%% ------------------------------------------------------------------------
function elem = buildElem(name, type, dims, descr)
% Helper – create a Simulink.BusElement with standard settings.
  elem               = Simulink.BusElement;
  elem.Name          = name;
  elem.Dimensions    = dims;
  elem.DataType      = type;
  elem.SampleTime    = -1;     % inherited
  elem.Complexity    = 'real';
  elem.Description   = descr;
end
