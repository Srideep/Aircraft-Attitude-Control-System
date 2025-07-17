%% makeConfSet.m — create /config/simConfigSet.ssc for R2025a
mkdir('config'); % ignore "already exists" warning
cs = Simulink.ConfigSet; % start from factory defaults

% ── Solver (100 Hz discrete) ──────────────────────────────────────────
cs.set_param('SolverType', 'Fixed-step');
cs.set_param('Solver', 'FixedStepDiscrete');
cs.set_param('FixedStep', '0.01'); % 100 Hz

% ── Diagnostics ───────────────────────────────────────────────────────
cs.set_param('AlgebraicLoopMsg', 'error');
%cs.set_param('InconsistentSampleTimesMsg', 'error'); % blocks with mismatched Ts
cs.set_param('SigSpecEnsureSampleTimeMsg', 'error'); % signals that *should* have Ts
cs.set_param('SFTemporalDelaySmallerThanSampleTimeDiag','error');
cs.set_param('UnconnectedInputMsg', 'warning');

% ── Data Import / Export ──────────────────────────────────────────────
cs.set_param('SignalLoggingSaveFormat','Dataset');
cs.set_param('SaveFinalState','off');

% ── Coverage (optional for Home) ──────────────────────────────────────
cs.set_param('CovEnable','on');
%cs.set_param('CovScope','TopModel');

% ── Export to .ssc ────────────────────────────────────────────────────

destPath = 'config/simConfigSet.ssc';
proj =  matlab.project.currentProject;

save(destPath);
addFile(proj, destPath);
fprintf('✅ simConfigSet.ssc saved under /config\n');