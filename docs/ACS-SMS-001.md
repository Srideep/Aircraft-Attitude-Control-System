# Simulink Model Specification
## Aircraft Attitude Control System

**Document ID**: ACS-SMS-001  
**Version**: 1.0  
**Date**: 7/11/2025  
**Author**: Srideep Maulik  
**Status**: Released for Implementation  

---

## 1. Introduction

### 1.1 Purpose
This Simulink Model Specification defines the detailed implementation of the Aircraft Attitude Control System in MATLAB/Simulink. It provides modeling guidelines, block specifications, and configuration requirements to ensure consistent, verifiable, and certifiable model development.

### 1.2 Scope
This document specifies:
- Model architecture and hierarchy
- Block implementation requirements
- Signal definitions and data types
- Configuration parameters
- Modeling standards compliance
- Code generation settings

### 1.3 Model Development Standards
The model shall comply with:
- MAB (MathWorks Automotive Advisory Board) guidelines
- DO-331 Model-Based Development supplement
- MISRA C compatibility for generated code
- Company coding standards

---

## 2. Model Architecture

### 2.1 Top-Level Model Structure

```
aircraft_attitude_control.slx (Top Level)
├── Pilot_Commands (Input Processing)
├── Sensor_Inputs (Sensor Interface) 
├── State_Estimation (Sensor Fusion)
├── Attitude_Controller (Control Laws)
├── Safety_Monitor (Envelope Protection)
├── Actuator_Commands (Output Processing)
└── Diagnostics (System Health)
```

### 2.2 Model Hierarchy

#### Level 0: System Model
```
File: aircraft_attitude_control.slx
Purpose: Top-level integration and scheduling
Update Rate: 100 Hz base rate
Solver: Fixed-step discrete (ode4)
```

#### Level 1: Subsystem Models
```
pilot_commands_subsystem.slx
sensor_inputs_subsystem.slx  
state_estimation_subsystem.slx
attitude_controller_subsystem.slx
safety_monitor_subsystem.slx
actuator_commands_subsystem.slx
diagnostics_subsystem.slx
```

#### Level 2: Component Models
```
pid_controller.slx (reusable)
limiter_with_warning.slx (reusable)
sensor_validation.slx (reusable)
coordinate_transform.slx (reusable)
```

### 2.3 Model Reference Architecture

```matlab
% Model reference configuration
modelRef.ModelName = 'attitude_controller_subsystem';
modelRef.ParameterArgumentNames = {'controller_gains', 'limits'};
modelRef.InheritSampleTime = false;
modelRef.SampleTime = 0.01; % 100 Hz
```

---

## 3. Block Specifications

### 3.1 Input Processing Subsystem

#### 3.1.1 Pilot Command Interface
```
Block Type: Subsystem
Mask: Custom mask with parameter dialog

Inputs:
- stick_roll: double [-1, 1] (normalized)
- stick_pitch: double [-1, 1] (normalized)
- pedal_yaw: double [-1, 1] (normalized)
- mode_select: uint8 [0-3]

Outputs:
- roll_cmd_deg: double [-60, 60] degrees
- pitch_cmd_deg: double [-15, 30] degrees
- yaw_rate_cmd_dps: double [-45, 45] deg/s

Implementation:
1. Apply deadband (±0.02)
2. Scale to commanded angles
3. Apply rate limiting
4. Filter with 2nd order Butterworth (fc = 2 Hz)
```

**Simulink Implementation Details:**
```matlab
% Inside masked subsystem
% Deadband implementation
deadband_value = 0.02;
if abs(u) < deadband_value
    y = 0;
else
    y = sign(u) * (abs(u) - deadband_value) / (1 - deadband_value);
end

% Scaling (use Gain blocks)
roll_scale = 60;    % degrees
pitch_scale_pos = 30;  % degrees
pitch_scale_neg = -15; % degrees

% Rate limiting (use Rate Limiter block)
roll_rate_limit = 30;   % deg/s
pitch_rate_limit = 15;  % deg/s

% Filtering (use Discrete Transfer Fcn)
% 2nd order Butterworth, fc = 2 Hz, Ts = 0.01s
num = [0.0067, 0.0134, 0.0067];
den = [1, -1.4595, 0.6048];
```

### 3.2 Sensor Input Subsystem

#### 3.2.1 AHRS Data Processing
```
Block Type: Enabled Subsystem
Enable: sensor_valid signal

Inputs:
- ahrs_data_bus: AHRS_Bus_Type
  - roll_deg: double
  - pitch_deg: double  
  - yaw_deg: double
  - p_dps: double
  - q_dps: double
  - r_dps: double
  - valid: boolean

Outputs:
- attitude_rad: [3x1] vector
- rates_rps: [3x1] vector
- sensor_valid: boolean

Validation Logic:
1. Range check (±180° roll, ±90° pitch)
2. Rate check (< 300°/s)
3. Timestamp freshness (< 50ms old)
4. Data freeze detection
```

**Bus Object Definition:**
```matlab
% AHRS_Bus_Type definition
AHRS_Bus = Simulink.Bus;
AHRS_Bus.Elements(1) = Simulink.BusElement;
AHRS_Bus.Elements(1).Name = 'roll_deg';
AHRS_Bus.Elements(1).DataType = 'double';
% ... continue for all elements
```

### 3.3 State Estimation Subsystem

#### 3.3.1 Complementary Filter
```
Block Type: MATLAB Function Block
Sample Time: 0.01s (100 Hz)

Function Signature:
function [attitude_est, rates_est, bias_est] = ...
    complementary_filter(accel_meas, gyro_meas, attitude_prev, dt)

Implementation:
% Integrate gyroscope
attitude_gyro = attitude_prev + gyro_meas * dt;

% Calculate attitude from accelerometers  
roll_accel = atan2(accel_meas(2), accel_meas(3));
pitch_accel = atan2(-accel_meas(1), ...
    sqrt(accel_meas(2)^2 + accel_meas(3)^2));

% Complementary filter (alpha = 0.98)
alpha = 0.98;
attitude_est(1) = alpha * attitude_gyro(1) + (1-alpha) * roll_accel;
attitude_est(2) = alpha * attitude_gyro(2) + (1-alpha) * pitch_accel;
```

### 3.4 Attitude Controller Subsystem

#### 3.4.1 Cascaded PID Architecture
```
Model Structure:
attitude_controller_subsystem.slx
├── Attitude_Loop (50 Hz)
│   ├── Roll_PID
│   ├── Pitch_PID
│   └── Turn_Coordination
└── Rate_Loop (100 Hz)
    ├── Roll_Rate_PID
    ├── Pitch_Rate_PID
    └── Yaw_Rate_PID
```

#### 3.4.2 PID Controller Implementation
```
Block: Discrete PID Controller
Configuration:
- Controller: PID
- Form: Parallel
- Time domain: Discrete-time
- Sample time: 0.01 (or 0.02 for outer loop)
- Integrator method: Forward Euler
- Filter method: Forward Euler
- Anti-windup: Clamping
```

**Parameter Configuration:**
```matlab
% Attitude Controller Gains (50 Hz)
attitude_pid.Kp = [2.0, 2.5, 1.5];  % [roll, pitch, yaw]
attitude_pid.Ki = [0.1, 0.2, 0.05];
attitude_pid.Kd = [0.5, 0.8, 0.3];
attitude_pid.N = 10;  % Derivative filter coefficient

% Rate Controller Gains (100 Hz)
rate_pid.Kp = [0.5, 0.7, 0.3];
rate_pid.Ki = [0.05, 0.1, 0.02];
rate_pid.Kd = [0.02, 0.03, 0.01];
rate_pid.N = 20;

% Anti-windup limits
attitude_pid.windup_limit = deg2rad(10);
rate_pid.windup_limit = deg2rad(20);
```

### 3.5 Safety Monitor Subsystem

#### 3.5.1 Envelope Protection Logic
```
Block Type: Stateflow Chart
Execution: Continuous
Sample Time: 0.01s

States:
- Normal_Operation
- Soft_Limit_Active  
- Hard_Limit_Active
- Emergency_Recovery

Transitions:
Normal → Soft_Limit: abs(bank) > 50° OR pitch > 25° OR pitch < -12°
Soft → Hard_Limit: abs(bank) > 58° OR pitch > 28° OR pitch < -14°
Hard → Emergency: pilot_override_button == true
Any → Normal: all_limits_clear && settle_time > 2s
```

**Stateflow Implementation Example:**
```matlab
% In Soft_Limit_Active state
entry:
  warning_flag = uint8(1);
  limit_gain = 0.5;  % Reduce authority

during:
  if abs(roll) > soft_roll_limit
    roll_cmd_limited = soft_limit_function(roll_cmd, roll, soft_roll_limit);
  end
  
% Soft limit function
function out = soft_limit_function(cmd, current, limit)
  error = limit - abs(current);
  gain = max(0, min(1, error / 5));  % Linear reduction near limit
  out = cmd * gain;
end
```

### 3.6 Output Processing Subsystem

#### 3.6.1 Control Allocation
```
Block Type: MATLAB Function Block

Function:
function [elevator, aileron, rudder] = ...
    control_allocation(Mx_cmd, My_cmd, Mz_cmd)

% Simplified allocation matrix
B = [0.8, 0,   0;    % Elevator → Pitch
     0,   1.2, 0.1;  % Aileron → Roll (with adverse yaw)
     0,   0.1, 0.9]; % Rudder → Yaw

% Inverse allocation
u = pinv(B) * [Mx_cmd; My_cmd; Mz_cmd];

% Apply limits
elevator = saturate(u(1), -15, 15);  % degrees
aileron = saturate(u(2), -20, 20);
rudder = saturate(u(3), -25, 25);
```

---

## 4. Signal Definitions

### 4.1 Signal Naming Convention
```
Format: <source>_<signal>_<unit>
Examples:
- pilot_roll_cmd_deg
- ahrs_pitch_rate_dps
- ctrl_elevator_pos_deg
- mon_bank_limit_active
```

### 4.2 Data Type Specifications

| Signal Category | Data Type | Range | Resolution |
|----------------|-----------|-------|------------|
| Angles | double | ±180° | 0.01° |
| Rates | double | ±300°/s | 0.1°/s |
| Commands | double | ±1.0 | 0.001 |
| Discrete | boolean | 0/1 | N/A |
| Status | uint8 | 0-255 | 1 |
| Time | uint32 | 0-2³²-1 | 1 ms |

### 4.3 Bus Definitions

**Control Command Bus:**
```matlab
ControlCmd_Bus = Simulink.Bus;
elements(1).Name = 'roll_cmd_deg';
elements(1).DataType = 'double';
elements(2).Name = 'pitch_cmd_deg';
elements(2).DataType = 'double';
elements(3).Name = 'yaw_rate_cmd_dps';
elements(3).DataType = 'double';
elements(4).Name = 'mode';
elements(4).DataType = 'uint8';
elements(5).Name = 'valid';
elements(5).DataType = 'boolean';
```

---

## 5. Model Configuration

### 5.1 Solver Configuration
```matlab
% Model configuration parameters
set_param(model, 'Solver', 'FixedStepDiscrete');
set_param(model, 'FixedStep', '0.01');
set_param(model, 'StartTime', '0');
set_param(model, 'StopTime', '60');
set_param(model, 'SaveTime', 'on');
set_param(model, 'SaveOutput', 'on');
set_param(model, 'SaveFormat', 'Dataset');
```

### 5.2 Diagnostic Settings
```matlab
% Important diagnostics for code generation
set_param(model, 'AlgebraicLoopMsg', 'error');
set_param(model, 'MinStepSizeMsg', 'error');
set_param(model, 'UnconnectedInputMsg', 'error');
set_param(model, 'UnconnectedOutputMsg', 'error');
set_param(model, 'InvalidFcnCallConnMsg', 'error');
set_param(model, 'SignalRangeChecking', 'error');
set_param(model, 'IntegerOverflowMsg', 'error');
```

### 5.3 Code Generation Settings
```matlab
% Embedded Coder configuration
set_param(model, 'SystemTargetFile', 'ert.tlc');
set_param(model, 'CodeInterfacePackaging', 'Reusable function');
set_param(model, 'GenerateComments', 'on');
set_param(model, 'GenerateReport', 'on');
set_param(model, 'GenerateCodeMetricsReport', 'on');
set_param(model, 'GenerateCodeReplacementReport', 'on');

% Optimization
set_param(model, 'OptimizeBlockIOStorage', 'on');
set_param(model, 'LocalBlockOutputs', 'on');
set_param(model, 'ExpressionFolding', 'on');
set_param(model, 'BufferReuse', 'on');

% Code style
set_param(model, 'ParenthesesLevel', 'Maximum');
set_param(model, 'PreserveExpressionOrder', 'on');
set_param(model, 'PreserveIfCondition', 'on');
```

---

## 6. Model Standards Compliance

### 6.1 MAB Guidelines Compliance

#### 6.1.1 Model Architecture (ar)
- ✓ ar_0001: Partitioning of model hierarchy
- ✓ ar_0002: Consistent subsystem decomposition  
- ✓ ar_0003: Limited hierarchy depth (max 5 levels)

#### 6.1.2 Naming Conventions (jc)
- ✓ jc_0201: Consistent signal naming
- ✓ jc_0211: Meaningful block names
- ✓ jc_0231: No default block names

#### 6.1.3 Model Configuration (jc)
- ✓ jc_0011: Appropriate solver selection
- ✓ jc_0021: Fixed sample times
- ✓ jc_0111: Diagnostic settings for production

### 6.2 DO-331 Compliance

#### 6.2.1 Model Standards
- Unambiguous graphical representation
- Deterministic execution order
- Complete signal/block specifications
- Traceability to requirements

#### 6.2.2 Model Coverage Criteria
- Decision Coverage: 100%
- Condition Coverage: 100%
- Modified Condition/Decision Coverage: 100%
- Signal Range Coverage: Defined

---

## 7. Test Harness Specification

### 7.1 Unit Test Harnesses

#### 7.1.1 PID Controller Test
```matlab
% Test harness: test_pid_controller.slx
% Includes:
- Step response test
- Frequency response test
- Anti-windup test
- Parameter variation test
- Numerical stability test
```

#### 7.1.2 Safety Monitor Test
```matlab
% Test harness: test_safety_monitor.slx
% Includes:
- Limit engagement test
- State transition test
- Hysteresis test
- Override test
- Failure injection test
```

### 7.2 Integration Test Harness
```matlab
% Test harness: test_integrated_system.slx
% Top-level model with:
- Scripted test scenarios
- Requirements verification blocks
- Coverage measurement
- Performance profiling
- Data logging
```

---

## 8. Model Implementation Guidelines

### 8.1 Block Usage Guidelines

#### 8.1.1 Preferred Blocks
- Use Discrete blocks for all dynamic elements
- Use Bus Creator/Selector for structured data
- Use Gain blocks instead of Product for scaling
- Use Saturation blocks for limiting

#### 8.1.2 Avoided Blocks
- No continuous-time blocks
- No variable-step delays
- No algebraic loops
- No MATLAB Function blocks in time-critical paths (when possible)

### 8.2 Signal Routing Guidelines
- Minimize signal line crossings
- Use Goto/From blocks sparingly and locally
- Label all significant signals
- Use bus signals for related data
- Avoid signal line branching > 3

### 8.3 Subsystem Guidelines
- Atomic subsystems for reusable components
- Virtual subsystems for organization only
- Triggered subsystems for event-driven logic
- Enabled subsystems for conditional execution
- Function-call subsystems for explicit scheduling

---

## 9. Model Verification

### 9.1 Static Verification
```matlab
% Model Advisor checks
Simulink.ModelAdvisor.run(model, 'configuration');

% Check categories:
- 'Modeling Standards'
- 'Code Generation'  
- 'DO-178C Compliance'
- 'MISRA C Compliance'
```

### 9.2 Dynamic Verification
```matlab
% Simulation test suite
test_suite = matlab.unittest.TestSuite.fromClass(?ModelTests);
test_runner = matlab.unittest.TestRunner.withTextOutput;
results = test_runner.run(test_suite);

% Coverage collection
cov_settings = Simulink.coverage.ModelCoverage(model);
cov_settings.RecordCoverage = true;
cov_settings.CovMetricSettings = 'dcmtr'; % Decision, condition, MCDC
```

### 9.3 Requirements Traceability
```matlab
% Link requirements to model elements
req_set = slreq.ReqSet('ACS_Requirements');
req_link = slreq.Link;
req_link.source = req_set.find('Name', 'SR-001.1');
req_link.destination = [model '/Attitude_Controller/Roll_PID'];
```

---

## 10. Code Generation Specification

### 10.1 Generated Code Structure
```
aircraft_attitude_control_ert_rtw/
├── aircraft_attitude_control.c     % Main model step function
├── aircraft_attitude_control.h     % Model data structures
├── aircraft_attitude_control_data.c % Parameter definitions
├── attitude_controller.c           % Subsystem functions
├── safety_monitor.c               % Safety functions
├── ert_main.c                     % Example main
└── rtwtypes.h                     % Data type definitions
```

### 10.2 Function Interface
```c
/* Model step function */
void aircraft_attitude_control_step(void)
{
  /* Update sensor inputs */
  sensor_inputs_update();
  
  /* State estimation at 100 Hz */
  state_estimation_step();
  
  /* Attitude control at 50 Hz */  
  if (attitude_SubRate_counter == 0) {
    attitude_controller_step();
  }
  
  /* Safety monitor at 100 Hz */
  safety_monitor_step();
  
  /* Output commands */
  actuator_commands_output();
}
```

### 10.3 Code Metrics Targets
- Cyclomatic Complexity: < 10
- Stack Usage: < 4 KB
- ROM Usage: < 256 KB
- RAM Usage: < 64 KB

---

## Appendices

### Appendix A: Block Parameter Tables
Detailed parameter settings for all configurable blocks.

### Appendix B: Signal Dictionary
Complete list of all signals with descriptions.

### Appendix C: Model Checklist
Pre-release verification checklist.

### Appendix D: Known Limitations
- Maximum update rate: 1000 Hz
- Maximum hierarchy depth: 5 levels
- Bus array size limit: 100 elements

### Appendix E: Document History
| Version | Date  | Changes         | Author         |
|---------|-------|-----------------|----------------|
| 1.0 | 7/15/2025 | Initial release | Srideep Maulik |
