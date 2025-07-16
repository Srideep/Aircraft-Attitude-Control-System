# System Requirements Specification (SRS)

## Aircraft Attitude Control System 

**Document ID**: ACS‑SRS‑001

**Version**: 1.1

**Date**: 07/16/2025

**Author**: Srideep Maulik

**Status**: Released for Implementation

---

## 1  Introduction

### 1.1 Purpose
This System Requirements Specification (SRS) defines the requirements for an **Aircraft Attitude Control System (ACS)** intended for educational and hobby experimentation. The system provides automated attitude stabilisation and pilot‑commanded attitude changes while preserving basic flight‑envelope protection.

### 1.2 Scope
The ACS encompasses:

* Attitude state estimation using low‑cost MEMS sensors (IMU/AHRS)
* Cascaded PID control laws for roll, pitch and yaw stabilisation
* Supervisory envelope‑protection logic
* Pilot interface for attitude commands (RC transmitter, joystick or keyboard)
* Real‑time simulation at ≥ 100 Hz in Simulink
* **Toolchain limited to MATLAB®, Simulink® and Stateflow® running under a MATLAB Home licence**

### 1.3 Definitions & Acronyms

* **ACS** – Aircraft Attitude Control System
* **PID** – Proportional‑Integral‑Derivative
* **IMU** – Inertial Measurement Unit
* **AHRS** – Attitude & Heading Reference System
* **SIL** – Software‑in‑the‑Loop (desktop) simulation

### 1.4 References (informative)
(Professional certification standards such as DO‑178C are **out‑of‑scope** for hobby use.)

---

## 2 System Overview

### 2.1 System Context
The ACS runs on a laptop/desktop PC (Windows/macOS/Linux) executing Simulink models in real time. It interfaces with:

* Pilot input devices (RC transmitter via USB, joystick or keyboard)
* MEMS IMU/AHRS via serial/USB
* Optional RC‑servo driver board for small‑scale UAV demonstrations

### 2.2 Major Functions

1. **Attitude Measurement** – sensor fusion to estimate roll, pitch, yaw
2. **Command Processing** – interpret pilot attitude commands
3. **Control‑Law Execution** – PID loops compute required control‑surface or thruster commands
4. **Safety Monitoring** – Stateflow supervisor limits commands to safe bounds
5. **Actuator Command** – send PWM/PPM signals to servos (if hardware‑in‑the‑loop) or to a flight‑sim API

### 2.3 User Characteristics
Enthusiasts with basic MATLAB/Simulink knowledge and RC or flight‑sim experience.

### 2.4 Operational Environment
Desktop‑class computer; optional micro‑UAV test‑bed in benign outdoor conditions (< 400 ft AGL).

---

## 3 Functional Requirements

### 3.1 Attitude Control Requirements

|  ID       | Requirement                                                                | Verification          |
| --------- | -------------------------------------------------------------------------- | --------------------- |
|  SR‑001.1 | Roll angle tracking ≤ ±2 deg steady‑state for commands up to ±60 deg       | SIL test              |
|  SR‑001.2 | Pitch angle tracking ≤ ±2 deg steady‑state for commands –15 deg to +30 deg | SIL test              |
|  SR‑002.1 | 90 % roll response within 3 s for 10 deg step                              | Simulation log review |
|  SR‑002.2 | 90 % pitch response within 4 s for 5 deg step                              | Simulation log review |
|  SR‑002.3 | Overshoot < 15 % for any step                                              | Simulation            |

### 3.2 Safety Requirements

|  ID       | Requirement                                                  | Verification         |
| --------- | ------------------------------------------------------------ | -------------------- |
|  SR‑003.1 | Limit bank angle to ±60 deg                                  | Stateflow test       |
|  SR‑003.2 | Limit pitch angle to +30 / –15 deg                           | Stateflow test       |
|  SR‑003.3 | Detect IMU data dropout within 0.1 s and revert to safe mode | Fault‑injection test |

### 3.3 Interface Requirements

|  ID       | Requirement                                              | Verification       |
| --------- | -------------------------------------------------------- | ------------------ |
|  SR‑005.1 | Accept pilot commands via joystick/RC at ≥ 50 Hz         | Bench test         |
|  SR‑006.1 | Read attitude data from IMU at ≥ 100 Hz, accuracy ±1 deg | Bench test         |
|  SR‑007.1 | Output PWM signals 1–2 ms at up to 100 Hz                | Oscilloscope check |

---

## 4 Performance Requirements

|  ID       | Requirement                                    | Verification      |
| --------- | ---------------------------------------------- | ----------------- |
|  PR‑001.1 | Control loop executes at 100 Hz ±1 %           | CPU profiler      |
|  PR‑001.2 | End‑to‑end latency (sensor → actuator) ≤ 15 ms | Scope measurement |
|  PR‑002.1 | CPU utilisation < 80 % of one core             | Profiler          |
|  PR‑002.2 | Model RAM usage < 512 MB                       | Task manager      |

---

## 5 Reliability & Safety Policy (Hobby Context)
The project follows best‑effort practices (version control, unit tests, peer review) but **does not claim airworthiness certification**. Operation is restricted to simulation or sub‑250 g UAVs under visual line‑of‑sight.

---

## 6 Design Constraints

### 6.1 Toolchain Constraint
**DC‑001 – Development Environment**
Development shall be carried out exclusively with **MATLAB R2025a, Simulink and Stateflow** under the MATLAB Home licence. Automatic code generation and proprietary add‑ons are not used.

### 6.2 Target Platform Constraint
**DC‑002 – Execution Platform**
Primary target is the host PC running Simulink in external/normal mode. Optional deployment to microcontrollers is outside the scope of this SRS.

### 6.3 Standards Compliance (Informative)
Industry standards such as DO‑178C/DO‑254 are acknowledged but **not applicable** to this hobby implementation.

---

## 7 Verification & Validation Strategy

* **Software‑in‑the‑Loop (SIL)** tests scripted in MATLAB to log response metrics.
* **Model coverage** checked via Simulink Coverage (licence‑included with Stateflow).
* **Peer review** of Simulink and Stateflow models via Simulink Project comparison.

---

## 8 Traceability Matrix (Excerpt)

|  Requirement  | Verification Artefact                         |
| ------------- | --------------------------------------------- |
|  SR‑001.1     | tRollTrack.m test script                      |
|  SR‑002.1     | Simulink Test case ‘Roll\_Step\_10deg’        |
|  SR‑003.1     | Stateflow chart ‘EnvelopeProtection’ SIL test |
|  PR‑001.1     | Simulink profiler report                      |

---

## 9 Appendices

### A. Change Log

|  Ver | Date        | Description                                                           | Author    |
| ---- | ----------- | --------------------------------------------------------------------- | --------- |
|  1.0 | 11 Jul 2025 | Initial professional edition                                          | S. Maulik |
|  1.1 | 16 Jul 2025 | Adapted for hobby use; toolchain limited to MATLAB/Simulink/Stateflow | S. Maulik |

### B. Glossary
See §1.3.
