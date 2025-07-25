# System Architecture Design Document (SADD)

## Aircraft Attitude Control System 

**Document ID**: ACS‑SADD‑001‑H

**Version**: 1.1

**Date**: 07/16/2025

**Author**: Srideep Maulik

**Status**: Draft for Implementation

---

## 1 Introduction

### 1.1 Purpose

This System Architecture Design Document (SADD) captures the high‑level structure, component breakdown and key design decisions for the **Aircraft Attitude Control System (ACS) – Hobby Edition**.&#x20;

It realises the requirements in *ACS‑SRS‑001‑H* and the rationale in *ACS‑RRD‑001‑H* using only **MATLAB®, Simulink® and Stateflow®** under a MATLAB Home licence.

### 1.2 Scope

* Software architecture of the Simulink model and supporting MATLAB scripts
* Interfaces between major functional blocks
* Data flow, control flow and timing assumptions
* Design constraints imposed by the Home‑licence toolchain (no code generation, no RTOS)

### 1.3 Architecture Principles

* **Simplicity first** – one Simulink model, clear block hierarchy
* **Transparency** – every requirement traceable to a model element
* **Fail‑safe** – envelope protection overrides all other commands
* **Learning oriented** – architecture easy to read, modify and test on a laptop

---

## 2 High‑Level Architecture

### 2.1 Layered View

```
┌─────────────────────────────────────────────────────────────┐
│                   External Interfaces                       │
├─────────────────────────────────────────────────────────────┤
│                    Interface Layer                          │
│  ┌────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Pilot I/F  │  │  IMU I/F     │  │  Servo I/F   │         │
│  └────────────┘  └──────────────┘  └──────────────┘         │
├─────────────────────────────────────────────────────────────┤
│                   Application Layer                         │
│  ┌────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Command    │  │  Attitude    │  │ Safety &     │         │
│  │ Processing │  │  Controller  │  │ EnvelopeProt │         │
│  └────────────┘  └──────────────┘  └──────────────┘         │
├─────────────────────────────────────────────────────────────┤
│                    Support Layer                            │
│  ┌────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ State      │  │ Parameter    │  │ Diagnostics   │         │
│  │ Estimation │  │ Management   │  │ & Logging     │         │
│  └────────────┘  └──────────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────────┘
```

*All layers reside in a single Simulink model – the distinction is logical, not physical.*

### 2.2 Component Map

| ID    | Component                    | Simulink Realisation                           | Key Responsibilities                             |
| ----- | ---------------------------- | ---------------------------------------------- | ------------------------------------------------ |
| IF‑1  | Pilot Interface              | `Joystick Input` MATLAB Function               | Read axis/button data, apply dead‑band & scaling |
| IF‑2  | IMU Interface                | Serial Read block + MATLAB parser              | Decode quaternion/Euler packets at ≥ 100 Hz      |
| IF‑3  | Servo Interface              | MATLAB Function → USB servo board API          | Convert surface commands to PWM duty‑cycle       |
| APP‑1 | Command Processing           | Gain, Saturation & Rate Limiter blocks         | Shape pilot commands, filter noise               |
| APP‑2 | Attitude Controller          | Cascaded `PID Controller` blocks               | Compute rate & surface demands                   |
| APP‑3 | Safety / Envelope Protection | Stateflow chart                                | Limit bank, pitch, load factor; fault flagging   |
| SUP‑1 | State Estimation             | MATLAB Function (complementary filter)         | Fuse IMU data, output Euler angles & rates       |
| SUP‑2 | Parameter Mgmt               | MATLAB base workspace + mask dialogs           | Centralise tunable gains & limits                |
| SUP‑3 | Diagnostics & Logging        | `To Workspace` + `Data Store` + MATLAB scripts | Log key signals, generate reports                |

---

## 3 Control & Data Flow

### 3.1 Primary Loops

1. **Sensor Loop (100 Hz)** – IMU data → State Estimation → global `Bus` signal `AircraftState`
2. **Command Loop (50 Hz)** – Pilot input → Command Processing → attitude set‑points
3. **Control Loop (100 Hz)** – Attitude Controller → Safety chart → Servo Interface

### 3.2 Data Buses

| Bus Name        | Fields                                         | Producer → Consumer  |
| --------------- | ---------------------------------------------- | -------------------- |
| `AircraftState` | roll, pitch, yaw, rates, timestamp, validFlags | SUP‑1 → APP‑2, APP‑3 |
| `PilotCmd`      | rollCmd, pitchCmd, yawCmd, modeSwitch          | IF‑1 → APP‑1         |
| `ActuatorCmd`   | ail, elev, rud, throttle, limitsActive         | APP‑3 → IF‑3         |

All buses are defined in `define_navigation_buses.m` for consistency across models.

---

## 4 Timing & Execution

| Task                                                                    | Rate   | Simulink Setting        | Worst‑Case Exec (ms) |
| ----------------------------------------------------------------------- | ------ | ----------------------- | -------------------- |
| Sensor Read & Parse                                                     | 100 Hz | Function‑Call Subsystem | 1.0                  |
| State Estimation                                                        | 100 Hz | Atomic Subsystem        | 0.8                  |
| Command Processing                                                      | 50 Hz  | Atomic Subsystem        | 0.3                  |
| Attitude Control                                                        | 100 Hz | Atomic Subsystem        | 1.2                  |
| Safety Monitor                                                          | 100 Hz | Stateflow               | 0.4                  |
| Servo Output                                                            | 100 Hz | Function‑Call           | 0.5                  |
| *Total 100 Hz frame budget: 4.2 ms < 10 ms period (ample margin).*      |        |                         |                      |
| Timing measured with Simulink Profiler on a mid‑2020 laptop (Intel i5). |        |                         |                      |

---

## 5 External Interfaces

| ID    | Direction | Protocol              | Notes                                           |
| ----- | --------- | --------------------- | ----------------------------------------------- |
| EXT‑A | IN        | USB HID               | Joystick, gamepad, or RC transmitter via dongle |
| EXT‑B | IN        | USB CDC (115 200 bps) | IMU quaternion/Euler packet @ 100 Hz            |
| EXT‑C | OUT       | USB → Servo board     | PWM 50–100 Hz, 1–2 ms pulses                    |
| EXT‑D | OUT       | UDP                   | Optional telemetry to FlightGear / HUD          |

---

## 6 Design Decisions & Rationale

| # | Decision                                 | Alternatives                                | Rationale                                                                 |
| - | ---------------------------------------- | ------------------------------------------- | ------------------------------------------------------------------------- |
| 1 | **Single Simulink model** vs multi‑model | Multi‑model                                 | Easier distribution, no model referencing overhead on Home licence        |
| 2 | **Complementary filter** vs EKF          | EKF via Sensor Fusion Toolbox (not in Home) | Complementary filter meets ±2 deg spec, runs fast, uses base MATLAB       |
| 3 | **PID control** vs LQR/MPC               | LQR (Control System Toolbox), MPC Toolbox   | PID is licence‑included, intuitive to tune, sufficient for hobby dynamics |
| 4 | **Desktop SIL** vs code‑gen to MCU       | Embedded Coder not in Home                  | Keep within toolchain constraint; optional hand‑porting left to user      |

---

## 7 Verification Plan (Architecture‑Level)

* **Model Advisor > Architecture Checks** – enforce atomic subsystems, bus usage, sample times
* **Simulink Coverage** – ensure 100 % decision coverage in Stateflow envelope chart
* **Stress Test** – 5 min Monte‑Carlo gusts + random transmitter inputs; validate no limit violations
* **Profiler Regression** – timing budget re‑measured after each commit

---

## 8 Change Log

| Ver | Date        | Change                                                                               | Author    |
| --- | ----------- | ------------------------------------------------------------------------------------ | --------- |
| 1.0 | 11 Jul 2025 | Initial professional edition                                                         | S. Maulik |
| 1.1 | 16 Jul 2025 | Hobby edition: removed RTOS, code‑gen, embedded HW; aligned with Home‑only toolchain | S. Maulik |
