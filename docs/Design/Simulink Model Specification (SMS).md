# Simulink Model Specification (SMS)

## Aircraft Attitude Control System 

**Document ID**: ACS‑SMS‑001‑H

**Version**: 1.0

**Date**: 07/16/2025

**Author**: Srideep Maulik

**Status**: Draft for Modeling

---

## 1 Introduction

### 1.1 Purpose

This Simulink Model Specification (SMS) defines the **detailed implementation rules** for the Aircraft Attitude Control System (ACS) model developed in MATLAB®/Simulink®/Stateflow® under a MATLAB Home licence. It establishes *modeling guidelines, subsystem‑level block specifications and configuration parameters* so that the model is:

* **Consistent** – common naming, data typing and hierarchy conventions
* **Verifiable** – amenable to automated Advisor checks, test harnesses and coverage
* **(Optionally) Certifiable** – structured to align with MAAB v3.0 and MISRA SL SIL recommendations should a future professional upgrade be pursued.

 ### 1.2 Scope
Applies to the single top‑level model `ACS.slx`, its supporting MATLAB scripts and project files. Hardware deployment and embedded code generation are *out of scope* (Home licence restriction).

 ### 1.3 Related Documents

* *ACS‑SRS‑001‑H* — System Requirements Specification
* *ACS‑SADD‑001‑H* — System Architecture Design Document
* *ACS‑RRD‑001‑H* — Requirements Rationale Document

---

## 2 Model Overview

### 2.1 Model Hierarchy

| Level | Subsystem (ID)               | Library / Contents                            | Notes                          |
| ----- | ---------------------------- | --------------------------------------------- | ------------------------------ |
| 0     | **ACS**                      | rate‑group scheduler, bus creators            | Fixed‑step 100 Hz base rate    |
| 1     | Sensors\_I/F (IF‑2)          | Serial Configuration, MATLAB Fcn `parseIMU.m` | Function‑call from 100 Hz task |
| 1     | Command\_Processing (APP‑1)  | Dead‑band, gains, saturations                 | Triggered at 50 Hz             |
| 1     | Attitude\_Control (APP‑2)    | Roll/Pitch PID blocks, rate limiters          | Atomic                         |
| 1     | Envelope\_Protection (APP‑3) | Stateflow chart `EnvelopeProt`                | Highest priority               |
| 1     | Actuator\_I/F (IF‑3)         | MATLAB Fcn `servoPwm.m`, USB blocks           | Output 100 Hz                  |
| 1     | Param\_Mgmt (SUP‑2)          | Constant blocks, Mask dialogs                 | Global tuning                  |
| 1     | Diagnostics (SUP‑3)          | To Workspace, Triggered Subsys                | Logging rate 10 Hz             |

### 2.2 Naming Conventions

* **Models**: `ACS.slx` (e.g., `ACS.slx`)
* **Subsystems**: `<Layer>_<Function>` camel case (`Attitude_Control`)
* **Signals**: `<noun>_<unit>` (`roll_deg`, `xBody_m`)
* **Buses**: `Bus_<Concept>` (`Bus_AircraftState`)
* **Parameters**: `p_<category>_<name>` (`p_ctrl_kpRoll`)

---

## 3 Modeling Guidelines

### 3.1 General Rules

1. **Depth ≤ 3** hierarchical levels from root to algorithm block.
2. Each algorithmic subsystem set to **Atomic**; sample time inherited from rate‑group.
3. No implicit signal resolution; set *Signal Resolution = Explicit only*.
4. Enable *Strongly Typed Data Store Memory*; data stores must use `Bus` types.
5. Disable nonvirtual buses at inports/outports for traceability.

### 3.2 Signal Routing & Bus Usage

* Use a single top‑level **Simulink.Bus** (`Bus_AircraftState`) for attitude states; defined in `define_navigation_buses.m`.
* Avoid `Goto/From`; prefer direct lines or **Bus Selector**.
* Global constants through `Constant` blocks stored in `Param_Mgmt`.

### 3.3 Data Typing & Units

* Default **Base Type** = `double` for hobby performance margin.
* Enumerations (`Enum_Mode`, `Enum_Fault`) defined in `types` package for Stateflow.
* Specify physical units in block *Signal Attributes* (`deg`, `deg/s`, `s`).

### 3.4 Stateflow Practices

* One **state chart** only (`EnvelopeProt`).
* States named *VerbNoun* (“LimitCheck”).
* All transitions guarded; no *after()* temporal logic to keep fixed step determinism.
* Model Explorer: *Update method = INHERITED*; event broadcasting disabled.

### 3.5 Reuse & Libraries

* Custom utility functions in `/libs/acs_utils.slx`; referenced via **Library Link**.
* Third‑party blocks prohibited (Home licence portability).
* Every MATLAB‐level algorithm placed in a MATLAB Function block with **%#codegen** directive to retain future code‑gen option.

---

## 4 Block Specifications

| Subsystem                | Interface Ports                            | Sample Time | Main Blocks / Algorithms                           | Key Parameters                   |
| ------------------------ | ------------------------------------------ | ----------- | -------------------------------------------------- | -------------------------------- |
| **Sensors\_I/F**         | `imuRaw[vector]` IN, `AircraftState` OUT   | 100 Hz      | MATLAB Fn `parseIMU`, Quaternion→Euler             | `p_filt_alpha = 0.02`            |
| **Command\_Processing**  | `PilotRaw` IN, `CmdBus` OUT                | 50 Hz       | Gains, Saturation, Rate Limiter                    | `p_cmdRateLim = 30 deg/s`        |
| **Attitude\_Control**    | `CmdBus`, `AircraftState` → `CtrlSurfCmd`  | 100 Hz      | `PID Controller` (2 DOF) x3                        | `Kp, Ki, Kd` tunable via mask    |
| **Envelope\_Protection** | `CtrlSurfCmd`, `AircraftState` → `SafeCmd` | 100 Hz      | Stateflow chart with `LIMIT`, `FAULT` super‑states | Bank limit 60°, Pitch limit ±30° |
| **Actuator\_I/F**        | `SafeCmd` IN → `PWM_out`                   | 100 Hz      | MATLAB Fn `servoPwm` → Serial Write                | Min 1000 µs, Max 2000 µs         |
| **Diagnostics**          | Various buses → `logStruct`                | 10 Hz       | `To Workspace` (structure)                         | Log on sim stop                  |

---

## 5 Configuration Parameters

| Category               | Setting                                   | Value                         |
| ---------------------- | ----------------------------------------- | ----------------------------- |
| **Solver**             | Type                                      | Fixed‑step, Discrete          |
|                        | Fixed step size                           | 0.01 s (100 Hz)               |
|                        | Treat discrete rates as multiples of base | **On**                        |
| **Data Import/Export** | Signal logging format                     | Dataset                       |
|                        | Save Final state                          | **Off**                       |
| **Diagnostics**        | Algebraic loop                            | Error                         |
|                        | Sample‑time checks                        | Error                         |
|                        | Unconnected lines/blocks                  | Warning                       |
| **Code Generation**    | System target file                        | `grt.tlc` (inactive)          |
|                        | Generate code only                        | **Off** (Home licence)        |
| **Coverage**           | Record coverage for                       | Model, Subsystems & Stateflow |

All configuration is stored in `simConfigSet.ssc` and attached to the model via **Model > Configuration References**.

---

## 6 Verification & Validation

| Stage                | Tool / Script                                                 | Criteria                                   |
| -------------------- | ------------------------------------------------------------- | ------------------------------------------ |
| **Static Checks**    | *Model Advisor* with MAAB & User Checks                       | 0 violations of *High* severity            |
| **Simulation Tests** | Simulink Test harnesses `tRollStep`, `tPitchStep`, `tIMUDrop` | Pass/fail metrics meet SRS                 |
| **Coverage**         | Simulink Coverage                                             | ≥ 95 % decision coverage in `EnvelopeProt` |
| **Performance**      | Profiler script `checkTiming.m`                               | CPU < 80 %, frame time < 10 ms             |

Results auto‑exported to `reports/` folder with time‑stamped HTML.

---

## 7 Change Control & Versioning

* **Git** repository with *Git LFS* for large `.slx` files.
* Each commit must reference JIRA ticket or GitHub issue mapped to requirement ID.
* Model version tag pattern: `acs_sms_v<major>.<minor>`.

---

## Appendix A — Bus Definition Summary

```matlab
% Bus_AircraftState
%   roll_deg          double
%   pitch_deg         double
%   yaw_deg           double
%   p_deg_s           double  % roll rate
%   q_deg_s           double  % pitch rate
%   r_deg_s           double  % yaw rate
%   timestamp_s       double
%   validFlags        uint8
```

Bus objects serialised to `data/navigation_buses.mat` by script `define_navigation_buses.m`.

---

## Appendix B — Reference Configuration Set (`simConfigSet.ssc`)
A reference Simulink configuration set is provided in `/config` and must be attached when new branched models are created to avoid drift.

---

*End of Document*
