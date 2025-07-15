# Appendix C: Glossary
## Aircraft Attitude Control System

**Document ID**: ACS-GLO-001  
**Version**: 1.0  
**Date**: [Current Date]  
**Author**: [Your Name]  
**Status**: Released for Implementation  

---

## A

**Accelerometer**  
A sensor that measures proper acceleration (acceleration relative to free fall). In the ACS, used to measure aircraft acceleration in three axes for load factor calculation and state estimation.

**ACS (Aircraft Attitude Control System)**  
The complete system designed to automatically control and maintain aircraft attitude through pilot commands and safety envelope protection.

**Actuator**  
A mechanical device that converts electrical signals into physical motion. In the ACS, controls elevator, aileron, and rudder positions.

**ADC (Analog-to-Digital Converter)**  
Electronic circuit that converts continuous analog signals into discrete digital values for processing by digital systems.

**AHRS (Attitude and Heading Reference System)**  
Navigation instrument that provides 3D orientation by integrating gyroscopes, accelerometers, and magnetometers.

**Aileron**  
Primary flight control surface mounted on the trailing edge of wings, used to control roll movement about the longitudinal axis.

**Air Data**  
Atmospheric information including airspeed, altitude, angle of attack, and sideslip angle, typically measured by pitot-static and vane systems.

**Angle of Attack (AOA)**  
The angle between the wing's chord line and the relative wind direction. Critical parameter for stall prevention.

**Anti-windup**  
Control system technique that prevents integral term accumulation when actuator limits are reached, maintaining system stability.

**Architecture**  
The fundamental organization of a system, including its components, relationships, and design principles.

**ARINC 429**  
Aviation industry standard for digital communication buses, providing a specification for data transmission between avionics equipment.

---

## B

**Bank Angle**  
The angle of rotation about the aircraft's longitudinal axis (roll). Positive bank indicates right wing down.

**BIT (Built-In Test)**  
Self-diagnostic capability integrated into avionics systems to detect and isolate faults automatically.

**Bus**  
Communication pathway that allows multiple devices to exchange data. In ACS, refers to both physical connections and logical data pathways.

---

## C

**CAN (Controller Area Network)**  
Robust vehicle bus standard designed for microcontrollers and devices to communicate without a host computer.

**Cascaded Control**  
Control architecture with multiple nested control loops, typically with an outer (slower) loop controlling an inner (faster) loop.

**CBIT (Continuous Built-In Test)**  
Background diagnostic testing that operates during normal system operation to monitor system health.

**Closed-loop Control**  
Control system that uses feedback to compare actual output with desired output and adjust accordingly.

**Command**  
Input signal specifying desired system behavior or output. In ACS, refers to pilot inputs or computed control signals.

**Complementary Filter**  
Signal processing technique that combines high-pass filtered gyroscope data with low-pass filtered accelerometer data for attitude estimation.

**Control Allocation**  
Method of distributing control moments among available control surfaces to achieve desired aircraft response.

**Control Law**  
Mathematical algorithm that determines control surface commands based on pilot inputs and aircraft state.

**Control Surface**  
Moveable airfoil used to control aircraft attitude and flight path (elevator, aileron, rudder).

**CPU (Central Processing Unit)**  
The primary component of a computer that executes instructions and performs calculations.

---

## D

**DAC (Digital-to-Analog Converter)**  
Electronic circuit that converts digital signals into analog voltages or currents for interfacing with analog systems.

**Dead-band**  
Small range around the neutral position where input changes produce no output response, used to reduce sensitivity to noise.

**Derivative Action**  
Component of PID control that responds to the rate of change of error, providing predictive control action.

**DIAG (Diagnostic Interface)**  
System interface used for maintenance, troubleshooting, and system health monitoring.

**DO-178C**  
Software standard for airborne systems, defining processes for developing safety-critical aviation software.

**DO-254**  
Hardware standard for airborne electronic hardware, complementing DO-178C for complete system certification.

**DO-160G**  
Environmental conditions and test procedures for airborne equipment, specifying testing requirements.

---

## E

**Elevator**  
Primary flight control surface attached to the horizontal stabilizer, used to control pitch (nose up/down movement).

**EMC (Electromagnetic Compatibility)**  
Ability of electronic equipment to function correctly in the presence of electromagnetic interference.

**EMI (Electromagnetic Interference)**  
Electromagnetic radiation that can disrupt electronic equipment operation.

**Envelope Protection**  
Automatic flight control system feature that prevents aircraft from exceeding safe operating limits.

**Error Handling**  
Software techniques for detecting, reporting, and recovering from abnormal conditions or failures.

---

## F

**Fail-safe**  
Design principle ensuring that system failures result in a safe condition rather than a hazardous one.

**Fault Detection and Isolation (FDI)**  
Process of detecting when a fault has occurred and identifying its location within the system.

**Feedback**  
Process of routing output back to input to maintain desired system performance.

**Filter**  
Device or algorithm that selectively passes or blocks certain frequencies or characteristics of a signal.

**Fixed-step Solver**  
Numerical integration method that uses constant time steps, ensuring deterministic timing for real-time systems.

**FHA (Functional Hazard Analysis)**  
Safety analysis method that examines potential failures and their effects on aircraft and crew safety.

**FMEA (Failure Modes and Effects Analysis)**  
Systematic method for analyzing potential failure modes and their consequences.

**Fly-by-wire**  
Flight control system where manual controls are replaced by electronic interfaces and computer-controlled actuators.

---

## G

**Gain**  
Proportional relationship between input and output of a control system component.

**Gain Scheduling**  
Control technique that varies controller gains based on operating conditions to maintain performance.

**Gyroscope**  
Sensor that measures angular velocity (rate of rotation) about one or more axes.

---

## H

**Hardware-in-the-loop (HIL)**  
Testing method that connects real hardware components to simulated system models for validation.

**Heading**  
Direction the aircraft nose is pointing, typically measured as degrees from magnetic north.

**HMI (Human-Machine Interface)**  
Interface through which humans interact with machines, including displays, controls, and feedback systems.

---

## I

**IBIT (Initiated Built-In Test)**  
Diagnostic test sequence triggered by pilot or maintenance action to verify system functionality.

**ICD (Interface Control Document)**  
Technical specification defining interfaces between system components or external systems.

**IMU (Inertial Measurement Unit)**  
Device containing accelerometers and gyroscopes to measure acceleration and angular velocity.

**Integral Action**  
Component of PID control that eliminates steady-state error by accumulating error over time.

**Interface**  
Boundary between two systems or components where interaction or communication occurs.

---

## J

**Jitter**  
Small, rapid variations in timing of digital signals, potentially affecting system performance.

---

## K

**Kalman Filter**  
Mathematical algorithm that uses measurements over time to estimate unknown variables, accounting for noise and uncertainty.

---

## L

**Latency**  
Time delay between input stimulus and corresponding output response in a system.

**Load Factor**  
Ratio of lift force to aircraft weight, measured in "g" units. Normal load factor is 1g in level flight.

**Loop**  
Closed path in a control system where output feeds back to influence input.

---

## M

**MC/DC (Modified Condition/Decision Coverage)**  
Software testing criterion requiring that each condition in a decision independently affects the outcome.

**MCB (Module Communication Bus)**  
Internal communication system allowing ACS components to exchange data and status information.

**MTBF (Mean Time Between Failures)**  
Average time between system failures, used as a reliability metric.

**MTTR (Mean Time To Repair)**  
Average time required to repair a failed system and return it to operational status.

---

## N

**Navigation**  
Process of determining aircraft position and directing movement from one location to another.

**Noise**  
Unwanted random variations in signals that can affect system performance and accuracy.

---

## O

**Open-loop Control**  
Control system that operates without feedback, relying only on input commands and system calibration.

**Overshoot**  
Amount by which a system response exceeds its target value during transient conditions.

---

## P

**Parameter**  
Configurable value that affects system behavior, such as control gains or limits.

**PID (Proportional-Integral-Derivative)**  
Control algorithm that uses three terms to minimize error between desired and actual system output.

**Pitch**  
Rotation about the aircraft's lateral axis, causing nose up or nose down movement.

**POST (Power-On Self Test)**  
Automated diagnostic sequence performed when system power is first applied.

**Proportional Action**  
Component of PID control that provides output proportional to current error magnitude.

---

## Q

**Quantization**  
Process of converting continuous analog signals into discrete digital values, introducing small errors.

---

## R

**Rate Control**  
Inner control loop that controls angular velocity (rate) rather than position or attitude.

**Rate Limiting**  
Constraint on how quickly a signal or command can change, used for safety and system protection.

**Real-time System**  
Computer system where correct operation depends not only on logical correctness but also on timing.

**Redundancy**  
Duplication of critical system components to improve reliability and safety.

**Requirements**  
Documented statements of what a system must do or characteristics it must possess.

**Resolution**  
Smallest change in input that produces a detectable change in output.

**Response Time**  
Time required for system output to reach a specified percentage of its final value after input change.

**Roll**  
Rotation about the aircraft's longitudinal axis, causing wing up or wing down movement.

**RTOS (Real-Time Operating System)**  
Operating system designed for real-time applications with deterministic response times.

**Rudder**  
Primary flight control surface attached to the vertical stabilizer, used to control yaw movement.

---

## S

**Safety Monitor**  
System component that continuously monitors aircraft state and prevents exceedance of safe operating limits.

**Sampling Rate**  
Frequency at which analog signals are converted to digital values, affecting system bandwidth and accuracy.

**Saturation**  
Condition where system output reaches maximum or minimum limits and cannot increase further.

**Sensor Fusion**  
Process of combining data from multiple sensors to improve accuracy and reliability of measurements.

**Servo**  
Electromechanical device that precisely controls position, velocity, or acceleration of a mechanical system.

**Settling Time**  
Time required for system response to reach and stay within specified tolerance of final value.

**Sideslip**  
Lateral movement of aircraft through the air, typically measured as sideslip angle.

**Simulink**  
MATLAB-based graphical programming environment for modeling and simulating dynamic systems.

**Software Level**  
Classification system (Level A through Level E) indicating software criticality and required development rigor.

**SSM (Sign/Status Matrix)**  
ARINC 429 field indicating data validity and sign information.

**Stability**  
System property describing tendency to return to equilibrium after disturbance.

**State Estimation**  
Process of determining aircraft position, velocity, and attitude from sensor measurements.

**Steady-state Error**  
Persistent difference between desired and actual output after transient response has ended.

**System**  
Collection of interacting components organized to accomplish specific functions.

---

## T

**Telemetry**  
Remote measurement and transmission of data for monitoring and analysis.

**Time-triggered**  
System architecture where tasks execute at predetermined time intervals.

**Tolerance**  
Acceptable range of variation from nominal or desired value.

**Traceability**  
Ability to trace requirements through design, implementation, and verification phases.

**Transfer Function**  
Mathematical representation of relationship between input and output of a linear system.

**Transient Response**  
System behavior during transition from one steady state to another.

**TSO (Technical Standard Order)**  
FAA standard specifying minimum performance requirements for aviation equipment.

---

## U

**Update Rate**  
Frequency at which system outputs are recalculated and updated.

---

## V

**Validation**  
Process of confirming that system meets intended use requirements and operates correctly in operational environment.

**Verification**  
Process of confirming that system meets specified requirements through testing, analysis, or inspection.

**V-cycle**  
Development model showing relationship between development phases and corresponding verification activities.

---

## W

**Watchdog**  
Monitoring circuit or software that detects system faults and initiates corrective action.

**WCET (Worst-Case Execution Time)**  
Maximum time required to execute a software task or function under any conditions.

**Windup**  
Condition where integral controller accumulates large values when output is saturated, causing poor performance.

---

## Y

**Yaw**  
Rotation about the aircraft's vertical axis, causing nose left or nose right movement.

---

## Z

**Zero-order Hold**  
Method of signal reconstruction that maintains constant output value between sampling instances.

---

## Acronyms and Abbreviations

| Acronym | Full Form |
|---------|-----------|
| ACS | Aircraft Attitude Control System |
| ADC | Analog-to-Digital Converter |
| ADI | Air Data Interface |
| AHRS | Attitude and Heading Reference System |
| AOA | Angle of Attack |
| AOI | Actuator Output Interface |
| API | Application Programming Interface |
| ARINC | Aeronautical Radio Incorporated |
| ATC | Attitude Controller |
| BIT | Built-In Test |
| CAL | Control Algorithms Library |
| CAN | Controller Area Network |
| CBIT | Continuous Built-In Test |
| CPM | Command Processing Module |
| CPU | Central Processing Unit |
| DAC | Digital-to-Analog Converter |
| DIAG | Diagnostic Interface |
| DLS | Data Logging Service |
| DO | RTCA Document |
| EHF | Error Handling Framework |
| EMC | Electromagnetic Compatibility |
| EMI | Electromagnetic Interference |
| FAA | Federal Aviation Administration |
| FAR | Federal Aviation Regulation |
| FDI | Fault Detection and Isolation |
| FHA | Functional Hazard Analysis |
| FMEA | Failure Modes and Effects Analysis |
| GPS | Global Positioning System |
| HIL | Hardware-in-the-Loop |
| HMI | Human-Machine Interface |
| IBIT | Initiated Built-In Test |
| ICD | Interface Control Document |
| IMU | Inertial Measurement Unit |
| MCB | Module Communication Bus |
| MC/DC | Modified Condition/Decision Coverage |
| MTBF | Mean Time Between Failures |
| MTTR | Mean Time To Repair |
| OCI | Output Command Interface |
| PCI | Pilot Command Interface |
| PID | Proportional-Integral-Derivative |
| PII | Pilot Input Interface |
| POST | Power-On Self Test |
| PWR | Power Interface |
| RAM | Random Access Memory |
| ROM | Read-Only Memory |
| RTS | Real-Time Scheduler |
| RTOS | Real-Time Operating System |
| SAE | Society of Automotive Engineers |
| SDM | System Diagnostics Module |
| SEM | State Estimation Module |
| SFM | Safety Monitor |
| SII | Sensor Input Interface |
| SRS | System Requirements Specification |
| SSM | Sign/Status Matrix |
| TSO | Technical Standard Order |
| WCET | Worst-Case Execution Time |

---

## Units and Symbols

| Symbol | Unit | Description |
|--------|------|-------------|
| ° | degrees | Angular measurement |
| °/s | degrees per second | Angular velocity |
| g | gravity units | Acceleration (9.81 m/s²) |
| Hz | hertz | Frequency (cycles per second) |
| V | volts | Electrical potential |
| A | amperes | Electrical current |
| Ω | ohms | Electrical resistance |
| s | seconds | Time |
| ms | milliseconds | Time (10⁻³ seconds) |
| μs | microseconds | Time (10⁻⁶ seconds) |
| kHz | kilohertz | Frequency (10³ Hz) |
| MHz | megahertz | Frequency (10⁶ Hz) |
| KB | kilobytes | Memory size (10³ bytes) |
| MB | megabytes | Memory size (10⁶ bytes) |
| dB | decibels | Logarithmic ratio |
| ft | feet | Distance (aviation standard) |
| kts | knots | Speed (nautical miles per hour) |

---

## Mathematical Notation

| Symbol | Description |
|--------|-------------|
| φ (phi) | Roll angle |
| θ (theta) | Pitch angle |
| ψ (psi) | Yaw angle |
| p | Roll rate |
| q | Pitch rate |
| r | Yaw rate |
| α (alpha) | Angle of attack |
| β (beta) | Sideslip angle |
| δe | Elevator deflection |
| δa | Aileron deflection |
| δr | Rudder deflection |
| Kp | Proportional gain |
| Ki | Integral gain |
| Kd | Derivative gain |
| ωn | Natural frequency |
| ζ (zeta) | Damping ratio |
| τ (tau) | Time constant |

---

## Document References

| Document | Title |
|----------|-------|
| ACS-SRS-001 | System Requirements Specification |
| ACS-SADD-001 | System Architecture Design Document |
| ACS-ICD-001 | Interface Control Document |
| ACS-TRM-001 | Traceability Matrix |
| DO-178C | Software Considerations in Airborne Systems and Equipment Certification |
| DO-254 | Design Assurance Guidance for Airborne Electronic Hardware |
| DO-160G | Environmental Conditions and Test Procedures for Airborne Equipment |
| FAR Part 23 | Airworthiness Standards: Normal Category Airplanes |
| MIL-STD-1797A | Flying Qualities of Piloted Aircraft |
| SAE ARP4754A | Guidelines for Development of Civil Aircraft and Systems |
| ARINC 429 | Digital Information Transfer System |
| IEEE 754 | Standard for Floating-Point Arithmetic |

---

**Usage Notes:**
1. This glossary covers terms specific to the Aircraft Attitude Control System and general aviation/control systems terminology.
2. Terms are defined in the context of their use within the ACS documentation.
3. When terms have multiple meanings, the definition reflects usage within the avionics domain.
4. Cross-references between terms are indicated where helpful for understanding.
5. Units follow aviation industry standards where applicable.

**Maintenance:**
- This glossary is maintained alongside system documentation
- New terms added during development are included in subsequent revisions
- Definitions updated to reflect current system design and terminology
- Regular review ensures consistency across all project documentation

**Document Control:**
- Version controlled with main system documentation
- Changes require approval through configuration management process
- Distributed to all project stakeholders and maintained electronically

---

**Revision History:**
| Version | Date | Description | Author |
|---------|------|-------------|---------|
| 1.0 | [Date] | Initial release | [Your Name] |

**Next Review:** [Date + 6 months]