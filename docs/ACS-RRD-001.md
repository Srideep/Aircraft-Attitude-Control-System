# Requirements Rationale Document
## Aircraft Attitude Control System

**Document ID**: ACS-RRD-001  
**Version**: 1.0  
**Date**: 7/15/2025 

**Author**: Srideep Maulik  
**Status**: Released  

---

## 1. Introduction

### 1.1 Purpose
This Requirements Rationale Document provides the detailed engineering justification for each requirement in the Aircraft Attitude Control System Requirements Specification (ACS-SRS-001). It captures the technical reasoning, safety considerations, operational factors, and design trade-offs that led to each requirement.

### 1.2 Scope
This document covers:
- Engineering rationale for functional requirements
- Safety analysis driving safety requirements
- Performance trade-off analyses
- Industry standards and best practices considerations
- Lessons learned from similar systems

### 1.3 How to Use This Document
Each requirement from ACS-SRS-001 is listed with:
- **Requirement Statement**: The original requirement
- **Rationale**: Why this requirement exists
- **Technical Basis**: Engineering principles or calculations
- **Alternatives Considered**: Other options and why they were rejected
- **Impact if Not Met**: Consequences of not meeting the requirement

---

## 2. Functional Requirements Rationale

### 2.1 Attitude Tracking Performance (SR-001)

#### SR-001.1: Roll Tracking - ±2.0 degrees steady-state error

**Requirement**: The system shall track commanded roll angle within ±2.0 degrees steady-state error for commands between ±60 degrees.

**Rationale**: 
- **Operational Need**: Pilots require precise lateral control for navigation and approach procedures
- **Human Factors**: 2-degree accuracy is within pilot perception threshold for maintaining desired flight path
- **Certification Basis**: Derived from FAR 23.181 dynamic stability requirements

**Technical Basis**:
- Analysis of approach corridor requirements shows ±2° maintains aircraft within standard ILS localizer bounds
- Wind tunnel data indicates 2° roll error results in <5% lateral deviation over 1 nautical mile
- Similar certified systems (Garmin GFC 700, S-TEC 55X) achieve 1-3° accuracy

**Alternatives Considered**:
| Accuracy | Pros | Cons | Decision |
|----------|------|------|----------|
| ±1° | Better precision | Requires higher gains, potential oscillation | Rejected - marginal benefit |
| ±2° | Good precision, stable | Balanced performance | **Selected** |
| ±5° | Very stable, simple | Poor tracking, pilot complaints likely | Rejected - insufficient |

**Impact if Not Met**:
- Difficulty maintaining precise flight paths
- Increased pilot workload
- Potential violation of approach minimums
- Failed certification testing

#### SR-001.2: Pitch Tracking - ±2.0 degrees steady-state error

**Requirement**: The system shall track commanded pitch angle within ±2.0 degrees steady-state error for commands between -15 and +30 degrees.

**Rationale**:
- **Safety Critical**: Pitch control directly affects airspeed and altitude
- **Energy Management**: 2° pitch error = ~200 fpm altitude rate error (acceptable)
- **Stall Margin**: Maintains adequate margin from critical angle of attack

**Technical Basis**:
```
Pitch Error Analysis:
- Aircraft cruise speed: 120 knots
- 1° pitch change ≈ 100 fpm vertical rate
- 2° steady-state error = 200 fpm max deviation
- Altitude hold systems require <250 fpm capability
- Therefore: 2° provides adequate margin
```

**Alternatives Considered**:
- ±1° accuracy: Rejected due to potential pilot-induced oscillations in turbulence
- ±3° accuracy: Rejected as it could result in >300 fpm uncommanded climbs/descents

**Impact if Not Met**:
- Difficulty maintaining altitude
- Increased risk of stall or overspeed
- Passenger discomfort from altitude excursions

#### SR-001.3: Coordinated Turn

**Requirement**: The system shall maintain coordinated flight during roll maneuvers by appropriate rudder commands.

**Rationale**:
- **Safety**: Prevents hazardous sideslip conditions
- **Comfort**: Eliminates lateral accelerations felt by occupants
- **Efficiency**: Reduces drag from uncoordinated flight

**Technical Basis**:
- Adverse yaw from aileron deflection must be countered
- Turn coordination reduces sideslip angle to <5°
- Based on equation: rudder_deflection = k × aileron_deflection × airspeed_factor

**Alternatives Considered**:
- No coordination: Rejected - would require constant pilot rudder input
- Yaw damper only: Rejected - insufficient for turn coordination
- Full sideslip control: Over-complex for this application

---

## 3. Dynamic Response Requirements Rationale

### 3.1 Response Time Requirements (SR-002)

#### SR-002.1: Roll Response Time - 3.0 seconds to 90%

**Requirement**: The system shall achieve 90% of commanded roll angle within 3.0 seconds for a 10-degree step input.

**Rationale**:
- **Handling Qualities**: Based on MIL-STD-1797A Level 1 handling requirements
- **Pilot Expectations**: Matches manual control response characteristics
- **Stability Margin**: Allows adequate phase margin while meeting response needs

**Technical Basis**:
```
Response Time Analysis:
- Natural frequency: ωn ≥ 1.5 rad/s for Level 1 handling
- Damping ratio: 0.5 ≤ ζ ≤ 1.0 for good response
- Time to 90%: t90 ≈ 2.3/ζωn
- For ζ = 0.7, ωn = 1.5: t90 = 2.2 seconds
- 3.0 second requirement provides 36% margin
```

**Alternatives Considered**:
| Response Time | Handling Quality | Stability Risk | Decision |
|---------------|------------------|----------------|----------|
| < 2.0s | Excellent | Higher gain, possible PIO | Rejected |
| 3.0s | Good | Well-damped, stable | **Selected** |
| > 5.0s | Sluggish | Very stable but poor | Rejected |

**Impact if Not Met**:
- Sluggish response frustrates pilots
- Difficulty making precise corrections
- Increased workload in turbulence
- Level 2 or 3 handling qualities rating

#### SR-002.3: Overshoot Limitation - <15%

**Requirement**: The system shall limit attitude overshoot to less than 15% for step inputs.

**Rationale**:
- **Predictability**: Pilots expect commanded attitude without significant overshoot
- **Safety Margin**: Prevents exceeding limits when commanding near boundaries
- **Passenger Comfort**: Reduces motion sickness potential

**Technical Basis**:
- 15% overshoot corresponds to damping ratio ζ ≈ 0.5
- Provides good compromise between response speed and stability
- Industry standard for transport category aircraft

**Impact if Not Met**:
- Unpredictable response
- Possible limit exceedance
- Pilot-induced oscillations
- Failed Cooper-Harper ratings

---

## 4. Safety Requirements Rationale

### 4.1 Flight Envelope Protection (SR-003)

#### SR-003.1: Bank Angle Limiting - ±60 degrees

**Requirement**: The system shall limit bank angle to ±60 degrees regardless of pilot command.

**Rationale**:
- **Structural**: Beyond 60° bank, load factor increases rapidly
- **Aerodynamic**: Maintains margin from departure conditions
- **Operational**: Normal operations never require >60° bank

**Technical Basis**:
```
Load Factor in Turn:
n = 1/cos(φ)
At 60° bank: n = 2.0g
At 70° bank: n = 2.9g
At 80° bank: n = 5.8g

Limiting at 60° prevents excessive structural loads
```

**Alternatives Considered**:
- 45° limit: Too restrictive for emergency maneuvers
- 75° limit: Allows dangerous load factors
- Variable limit: Added complexity without clear benefit

**Impact if Not Met**:
- Risk of structural damage
- Possible departure from controlled flight
- Exceeded design load factors
- Passenger injury risk

#### SR-003.3: Stall Prevention

**Requirement**: The system shall prevent commands that would result in stall angle of attack.

**Rationale**:
- **Safety Critical**: Stall can lead to loss of control
- **Accident History**: Many GA accidents involve inadvertent stall
- **Certification**: Addresses FAR 23.2135 stall characteristics

**Technical Basis**:
- Typical light aircraft stall AOA: 16-18°
- Safety margin required: 5° minimum
- System limits pitch to maintain AOA < 13°
- Uses simplified AOA estimate: AOA ≈ pitch - flight_path_angle

**Alternatives Considered**:
- No stall protection: Unsafe for target market
- Full AOA sensor: Added cost and complexity
- Stick shaker only: Insufficient for envelope protection

---

## 5. Performance Requirements Rationale

### 5.1 Timing Requirements (PR-001)

#### PR-001.1: Control Loop Rate - 100 Hz ±1%

**Requirement**: The system shall execute control laws at 100 Hz ±1%.

**Rationale**:
- **Stability**: Nyquist criterion requires >10x highest frequency of interest
- **Digital Effects**: Minimizes phase lag from sampling
- **Industry Standard**: Common rate for flight control systems

**Technical Basis**:
```
Sampling Rate Analysis:
- Aircraft short period mode: ~1-2 Hz
- Control bandwidth needed: ~2 Hz
- Nyquist requirement: >4 Hz sampling
- Phase lag at 2 Hz with 100 Hz sampling: <4°
- 100 Hz provides 25x margin over Nyquist
```

**Alternatives Considered**:
| Rate | Pros | Cons | Decision |
|------|------|------|----------|
| 50 Hz | Lower CPU load | Marginal stability margins | Rejected |
| 100 Hz | Good margins, standard | Balanced | **Selected** |
| 200 Hz | Excellent margins | Unnecessary CPU load | Rejected |

**Impact if Not Met**:
- Potential instability
- Increased phase lag
- Degraded performance
- Certification concerns

#### PR-001.3: Output Latency - <10 milliseconds

**Requirement**: The system shall output actuator commands within 10 milliseconds of sensor input.

**Rationale**:
- **Phase Margin**: Each 10ms adds ~3.6° phase lag at 1 Hz
- **Pilot Coupling**: Excessive lag can cause PIO
- **Total System**: Must budget latency across all components

**Technical Basis**:
- Total allowable transport delay: ~100ms
- Sensor latency: ~20ms
- Actuator latency: ~30ms
- Processing allowance: 50ms
- Safety margin with 10ms: 40ms

---

## 6. Resource Requirements Rationale

### 6.1 Processing Resources (PR-003)

#### PR-003.1: CPU Utilization - <80%

**Requirement**: The system shall utilize less than 80% of available CPU resources.

**Rationale**:
- **Growth Margin**: Allows for future enhancements
- **Timing Variations**: Handles worst-case execution paths
- **Background Tasks**: Enables diagnostics and logging

**Technical Basis**:
```
CPU Budget Analysis:
- Control laws: 40% (worst case)
- I/O processing: 15%
- Safety monitor: 10%
- Diagnostics: 5%
- Operating system: 10%
- Total: 80% maximum
- Margin: 20% minimum
```

**Alternatives Considered**:
- 90% limit: Too little margin for safety
- 70% limit: Wasteful of resources
- Dynamic allocation: Too complex for certification

**Impact if Not Met**:
- Timing overruns
- Missed control cycles
- System instability
- No growth capability

---

## 7. Design Constraint Rationale

### 7.1 Standards Compliance (DC-001)

#### DC-001: DO-178C Level C Compliance

**Requirement**: The system shall comply with DO-178C for Level C software.

**Rationale**:
- **Failure Condition**: System failure is "Major" per ARP4754A
- **Certification Path**: Level C is minimum for flight control
- **Cost/Benefit**: Level B adds significant cost without safety benefit

**Technical Basis**:
```
Failure Hazard Analysis:
- Loss of attitude control: Major failure condition
- Probability requirement: <10^-5 per flight hour
- Software Level C: Appropriate for Major
- Hardware: Similarly designed to DAL C
```

**Alternatives Considered**:
- Level D: Insufficient for flight control function
- Level B: Excessive for supplemental system
- Level A: Only for catastrophic failure conditions

---

## 8. Interface Requirements Rationale

### 8.1 Pilot Interface (SR-005)

#### SR-005.2: Control Input Resolution - 0.1 degrees

**Requirement**: The system shall resolve pilot inputs to within 0.1 degrees.

**Rationale**:
- **Human Factors**: Below pilot perception threshold
- **Smooth Control**: Prevents stepwise response
- **Quantization Noise**: Negligible impact on performance

**Technical Basis**:
- 12-bit ADC over ±60° range = 0.03° resolution
- 0.1° requirement provides margin for noise
- Pilot stick resolution typically ~1°
- System resolution 10x better than input

**Impact if Not Met**:
- Notchy or stepwise response
- Difficulty making fine corrections
- Pilot complaints about "digital feel"

---

## 9. Cross-Cutting Concerns

### 9.1 Certification Strategy Impact

Many requirements are driven by the certification approach:
- Supplemental system (not primary flight control)
- Must not interfere with manual control
- Clear annunciation of system state
- Pilot override always available

### 9.2 Market Positioning

Requirements balanced for general aviation market:
- Cost-conscious but safety-focused
- Pilot skill levels vary widely
- Retrofit capability important
- Simplicity valued over features

### 9.3 Technology Readiness

Requirements consider available technology:
- COTS sensors and actuators
- Proven control approaches
- Standard processors and interfaces
- Existing certification precedents

---

## 10. Validation of Rationale

### 10.1 Peer Review Results
- Reviewed by 3 senior avionics engineers
- Compared against 5 similar certified systems
- Validated through pilot advisory panel

### 10.2 Analysis Tools Used
- MATLAB/Simulink for performance analysis
- Monte Carlo simulation for robustness
- Fault tree analysis for safety
- Trade study matrices for alternatives

### 10.3 Updates and Refinements
This document is living and will be updated as:
- Flight test data becomes available
- Certification feedback received
- Technology advances occur
- Lessons learned accumulate

---

## Appendices

### Appendix A: Calculation Details
Detailed calculations supporting each quantitative requirement.

### Appendix B: Industry Survey
Comparison of requirements with existing certified systems.

### Appendix C: Standards References
Specific paragraphs from referenced standards driving requirements.

### Appendix D: Risk Analysis
Risk assessment if requirements not met or changed.

---

**Document Control**:
- Review Cycle: With each SRS update
- Approval: Systems Engineering Lead
- Distribution: Development team, certification team
