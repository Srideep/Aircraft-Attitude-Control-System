# System Definition Document (SDD)

## Aircraft Attitude Control System 

**Document ID**: ACS‑SDD‑001‑H\
**Version**: 1.1\
**Date**: 07/16/2025\
**Author**: Srideep Maulik\
**Status**: Draft for Implementation

---

## 1 Executive Summary 
The Aircraft Attitude Control System (ACS) is a *software‑only* flight‑control experiment built in MATLAB®, Simulink® and Stateflow® under a MATLAB Home licence. It provides automated attitude stabilisation, basic envelope protection and pilot‑commanded attitude changes for desktop simulation and small sub‑250 g UAV demonstrations.

Key design goals are ease‑of‑learning, transparency of control logic and affordability; formal airworthiness certification is **out of scope**.

---

## 2 System Definition

### 2.1 System Purpose

- **Primary Function** – Maintain commanded roll, pitch and yaw attitudes.
- **Safety Function** – Prevent excursions beyond hobby‑safe flight envelope (±60 ° bank, +30 / –15 ° pitch).
- **Learning Function** – Demonstrate model‑based design workflow (requirements → model → test) in a self‑contained Simulink project.

### 2.2 System Boundaries

#### 2.2.1 Included

- Attitude estimation (sensor fusion of low‑cost IMU/AHRS)
- Cascaded PID control laws
- Stateflow‑based envelope‑protection supervisor
- Pilot command interface (joystick, RC Tx over USB, or keyboard)
- PWM/PPM signal generation for optional micro‑UAV servos
- Built‑in self‑test and basic fault detection

#### 2.2.2 Excluded

- Physical sensors and actuators (procured separately)
- Real‑time operating systems, embedded processors, code‑generation artefacts
- Navigation / autopilot modes (altitude hold, GPS Waypoint)
- Professional certification artefacts (DO‑178C, DO‑160G, etc.)

### 2.3 System Context Diagram

```
┌──────────────┐   USB/Serial   ┌──────────────┐     PWM/PPM    ┌──────────────┐
│  Pilot Input │───────────────▶│              │───────────────▶│   Servos /   │
│ (Joystick/RC)│               │   Simulink   │                │  ESC Driver   │
└──────────────┘               │    ACS       │                └──────────────┘
       ▲                       │   Model      │                        ▲
       │                       │ (Running on  │                        │
   Status / HUD                │   Laptop)    │   Optional Telemetry   │
       │                       └──────────────┘───────────────▶ Flight‑Sim /  
       │                                                        Ground Station
┌──────────────┐  IMU data                                        software    
│  IMU / AHRS  │───────────────▶                                                 
└──────────────┘                                                               
```

---

## 3 Operational Concepts

### 3.1 Operational Modes

| Mode            | Description                                                                                     |
| --------------- | ----------------------------------------------------------------------------------------------- |
| **Standby**     | Model loaded, sensors streaming, control outputs disabled. Used for taxi or sim pause.          |
| **Normal**      | Full‑authority attitude control with envelope protection active.                                |
| **Degraded**    | Reduced authority if sensor dropout or saturation detected; envelope protection still enforced. |
| **Maintenance** | Offline mode for parameter tuning, playback of logged data and automated tests.                 |

### 3.2 Mode Transitions A simple Stateflow chart handles transitions: **Power‑On → Standby → Normal** when engaged; **Normal → Degraded** on fault; **any → Standby** on pilot disengage.

 ### 3.3 Typical Scenarios

1. **Desktop Flight Simulation** – ACS model runs in Simulink; joystick commands; IMU is replaced by simulated aircraft state.
2. **Micro‑UAV Field Test** – Laptop runs ACS; USB IMU on airframe streams data; PWM sent via USB servo board; pilot uses RC Tx for backup.
3. **Fault‑Injection Study** – Maintenance mode replays flight logs with injected dropouts to validate safety logic.

---

 ## 4 System Capabilities & Constraints

 ### 4.1 Functional Capability Targets (aligned with SRS)

| Capability         | Target Value               | Basis               |
| ------------------ | -------------------------- | ------------------- |
| Roll range         | ±60 °                      | SR‑001.1 / SR‑003.1 |
| Pitch range        | +30 ° / –15 °              | SR‑001.2 / SR‑003.2 |
| Steady‑state error | ≤ ±2 °                     | SR‑001.x            |
| 90 % response      | ≤ 3 s (roll) / 4 s (pitch) | SR‑002.x            |
| IMU dropout detect | ≤ 0.1 s                    | SR‑003.3            |

 ### 4.2 Performance Constraints

| Metric             | Target             | Rationale                               |
| ------------------ | ------------------ | --------------------------------------- |
| Control‑loop rate  | 100 Hz ±1 %        | Matches PR‑001.1                        |
| End‑to‑end latency | ≤ 15 ms            | Matches PR‑001.2                        |
| CPU utilisation    | < 80 % of one core | Allows background OS tasks on hobby PCs |
| RAM usage          | < 512 MB           | Fits 8 GB laptops                       |

 ### 4.3 Environmental Constraints

- **Operating Temperature** (bench / field) – 0 °C to +40 °C typical hobby electronics.
- **Operating Altitude** – 0 – 400 ft AGL (per FAA Part 107 recreational limit).
- **Power Budget** – < 5 W USB devices (IMU + servo board) plus laptop.

---

 ## 5 External Interfaces

### 5.1 Input Interfaces

| Interface      | Medium                                        | Rate     | Notes                      |
| -------------- | --------------------------------------------- | -------- | -------------------------- |
| Pilot Commands | HID joystick (USB) or SBUS/PPM via USB dongle | ≥ 50 Hz  | Configurable axis mapping  |
| IMU / AHRS     | Serial (USB CDC or UART‑to‑USB)               | ≥ 100 Hz | Quaternion or Euler packet |

### 5.2 Output Interfaces

| Interface      | Medium                           | Rate      | Notes                                |
| -------------- | -------------------------------- | --------- | ------------------------------------ |
| Servo Commands | PWM/PPM via USB servo controller | 50–100 Hz | 1–2 ms pulse width                   |
| Telemetry      | UDP or serial                    | 10 Hz     | For FlightGear/X‑Plane or custom HUD |

---

## 6 Software Architecture The ACS is implemented as a single Simulink model partitioned into:

1. **Sensors\_I/F** (MATLAB Function & Rate Transition)
2. **Command\_Processing** (Gain & Saturation blocks)
3. **Attitude\_Control** (PID Controller blocks)
4. **Envelope\_Protection** (Stateflow chart)
5. **Actuator\_I/F** (MATLAB Function emitting PWM duty cycle)

A *project* file (.prj) tracks dependencies, test harnesses and documentation.

---

## 7 System Deployment

### 7.1 Primary Deployment

- **Host**: Laptop / desktop PC running MATLAB R2025a (Home).
- **OS**: Windows 10+ / macOS 13+ / Ubuntu 22.04+.
- **Execution**: Simulink Normal or External mode (no real‑time kernel).
- **Connections**: USB‑IMU and USB servo board via virtual COM ports.

### 7.2 Optional Micro‑controller Port Learners may hand‑translate the tuned PID gains into an Arduino or PX4 stack. This is *out of scope* for formal documentation but a reference sketch is provided in the repository.

---

## 8 Success Criteria

| Category    | Criterion                                                        |
| ----------- | ---------------------------------------------------------------- |
| Technical   | Meets all SRS functional & performance reqs in SIL tests.        |
| Educational | Users can trace requirement → model → test in one session.       |
| Operational | Stable 5‑minute hover of micro‑UAV in calm air with ACS engaged. |

---

## 9 Risk Considerations

| Risk                             | Likelihood | Impact                | Mitigation                            |
| -------------------------------- | ---------- | --------------------- | ------------------------------------- |
| Sensor dropout                   | Medium     | Loss of stabilisation | SR‑003.3 logic; redundant RC link     |
| High CPU load on low‑end laptops | Low        | Control lag           | Use Accelerator mode; reduce graphics |
| Pilot disorientation             | Medium     | Crash                 | HUD overlay + pilot training          |

---

## Appendices

### A Acronyms See SRS §1.3.

### B Change Log

| Ver | Date        | Change                                                                      | Author    |
| --- | ----------- | --------------------------------------------------------------------------- | --------- |
| 1.0 | 11 Jul 2025 | Initial professional edition                                                | S. Maulik |
| 1.1 | 16 Jul 2025 | Adapted to hobby context; removed certification & embedded platform content | S. Maulik |

