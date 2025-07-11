# System Architecture Design Document
## Aircraft Attitude Control System

**Document ID**: ACS-SADD-001  
**Version**: 1.0  
**Date**: 7/11/2025  
**Author**: Srideep Maulik  
**Status**: Released for Implementation  

---

## 1. Introduction

### 1.1 Purpose
This System Architecture Design Document (SADD) describes the architectural design of the Aircraft Attitude Control System (ACS). It defines the system structure, components, interfaces, and design decisions that satisfy the requirements specified in ACS-SRS-001.

### 1.2 Scope
This document covers:
- High-level system architecture
- Component identification and allocation
- Interface definitions
- Data flow and control flow
- Design patterns and principles
- Technology selections and rationale

### 1.3 Design Principles
The architecture follows these key principles:
- **Modularity**: Clear separation of concerns
- **Safety**: Fail-safe design with graceful degradation
- **Determinism**: Predictable real-time behavior
- **Testability**: Observable and controllable interfaces
- **Maintainability**: Clear structure and documentation

---

## 2. System Architecture Overview

### 2.1 Architectural Pattern
The ACS employs a **Layered Architecture** with **Model-View-Controller (MVC)** pattern:
- **Model Layer**: Aircraft dynamics and state management
- **Controller Layer**: Control laws and safety logic
- **View Layer**: Interface adaptation and I/O handling

### 2.2 High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        External Interfaces                        │
├─────────────────────────────────────────────────────────────────┤
│                         Interface Layer                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │Pilot Command │  │Sensor Input  │  │Output Command│         │
│  │  Interface   │  │  Interface   │  │  Interface   │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
├─────────────────────────────────────────────────────────────────┤
│                       Application Layer                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Command    │  │   Attitude   │  │    Safety    │         │
│  │  Processing  │  │  Controller  │  │   Monitor    │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
├─────────────────────────────────────────────────────────────────┤
│                         Service Layer                            │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │    State     │  │   Control    │  │   System     │         │
│  │  Estimation  │  │  Algorithms  │  │  Diagnostics │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
├─────────────────────────────────────────────────────────────────┤
│                      Infrastructure Layer                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │   Real-Time  │  │    Error     │  │    Data      │         │
│  │  Scheduler   │  │   Handling   │  │   Logging    │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Architecture

### 3.1 Component Identification

#### 3.1.1 Interface Layer Components

**Pilot Command Interface (PCI)**
- **Purpose**: Process pilot stick and pedal inputs
- **Responsibilities**:
  - Analog/digital signal conditioning
  - Dead-band and scaling application
  - Command validation and limiting
  - Rate limiting for safety

**Sensor Input Interface (SII)**
- **Purpose**: Acquire and validate sensor data
- **Responsibilities**:
  - AHRS data acquisition and validation
  - Air data processing
  - Accelerometer data processing
  - Sensor fault detection
  - Data time-stamping

**Output Command Interface (OCI)**
- **Purpose**: Generate actuator commands
- **Responsibilities**:
  - Command formatting (analog/PWM)
  - Safety limiting enforcement
  - Actuator position feedback processing
  - Command synchronization

#### 3.1.2 Application Layer Components

**Command Processing Module (CPM)**
- **Purpose**: Transform pilot inputs to attitude commands
- **Responsibilities**:
  - Coordinate system transformation
  - Command shaping and filtering
  - Mode-dependent scaling
  - Turn coordination logic

**Attitude Controller (ATC)**
- **Purpose**: Execute cascaded PID control laws
- **Responsibilities**:
  - Outer loop attitude control
  - Inner loop rate control
  - Anti-windup logic
  - Gain scheduling
  - Control allocation

**Safety Monitor (SFM)**
- **Purpose**: Enforce flight envelope protection
- **Responsibilities**:
  - Bank angle limiting
  - Pitch angle limiting  
  - Load factor monitoring
  - Stall prevention logic
  - Overspeed protection

#### 3.1.3 Service Layer Components

**State Estimation Module (SEM)**
- **Purpose**: Estimate aircraft state from sensors
- **Responsibilities**:
  - Sensor fusion (complementary filter)
  - Bias estimation and removal
  - Noise filtering
  - State propagation
  - Validity monitoring

**Control Algorithms Library (CAL)**
- **Purpose**: Implement control law computations
- **Responsibilities**:
  - PID algorithm implementation
  - Discrete-time integration
  - Derivative filtering
  - Saturation handling
  - Bumpless transfer logic

**System Diagnostics Module (SDM)**
- **Purpose**: Monitor system health
- **Responsibilities**:
  - Built-in test execution
  - Performance monitoring
  - Failure detection and isolation
  - Diagnostic data collection
  - Maintenance reporting

#### 3.1.4 Infrastructure Layer Components

**Real-Time Scheduler (RTS)**
- **Purpose**: Ensure deterministic execution
- **Responsibilities**:
  - Task scheduling (100 Hz primary)
  - Priority management
  - Timing monitoring
  - Overrun detection
  - CPU usage monitoring

**Error Handling Framework (EHF)**
- **Purpose**: Centralized error management
- **Responsibilities**:
  - Exception handling
  - Error logging
  - Recovery actions
  - System state preservation
  - Watchdog management

**Data Logging Service (DLS)**
- **Purpose**: Record system operation data
- **Responsibilities**:
  - Circular buffer management
  - Data compression
  - Non-volatile storage
  - Retrieval interface
  - Privacy protection

### 3.2 Component Interaction Diagram

```
     Pilot Commands                 Sensor Data
           │                            │
           ▼                            ▼
    ┌─────────────┐            ┌─────────────┐
    │     PCI     │            │     SII     │
    └──────┬──────┘            └──────┬──────┘
           │                          │
           ▼                          ▼
    ┌─────────────┐            ┌─────────────┐
    │     CPM     │◄───────────│     SEM     │
    └──────┬──────┘            └─────────────┘
           │                          ▲
           ▼                          │
    ┌─────────────┐            ┌─────────────┐
    │     ATC     │◄───────────│     CAL     │
    └──────┬──────┘            └─────────────┘
           │
           ▼
    ┌─────────────┐            ┌─────────────┐
    │     SFM     │───────────▶│     SDM     │
    └──────┬──────┘            └─────────────┘
           │
           ▼
    ┌─────────────┐
    │     OCI     │
    └──────┬──────┘
           │
           ▼
    Actuator Commands
```

---

## 4. Data Architecture

### 4.1 Data Flow Design

#### 4.1.1 Primary Data Flow
```
1. Sensor Data → State Estimation → Control Laws → Actuator Commands
2. Pilot Commands → Command Processing → Control Laws → Actuator Commands
3. All Data → Safety Monitor → Limited Commands → Actuator Commands
```

#### 4.1.2 Data Structures

**Aircraft State Structure**
```c
typedef struct {
    // Attitude angles [rad]
    float roll;
    float pitch;  
    float yaw;
    
    // Angular rates [rad/s]
    float roll_rate;
    float pitch_rate;
    float yaw_rate;
    
    // Linear motion
    float airspeed;     // [m/s]
    float altitude;     // [m]
    float aoa;          // [rad]
    
    // Accelerations [m/s²]
    float ax;
    float ay;
    float az;
    
    // Time stamp
    uint32_t timestamp; // [ms]
    
    // Validity flags
    uint16_t valid_flags;
} AircraftState_T;
```

**Control Command Structure**
```c
typedef struct {
    // Commanded attitudes [rad]
    float roll_cmd;
    float pitch_cmd;
    
    // Control surface commands [rad]
    float elevator_cmd;
    float aileron_cmd;
    float rudder_cmd;
    
    // Status
    uint8_t mode;
    uint8_t limits_active;
} ControlCommand_T;
```

**System Status Structure**
```c
typedef struct {
    // Operating mode
    SystemMode_E current_mode;
    
    // Health status
    uint32_t fault_flags;
    uint32_t warning_flags;
    
    // Performance metrics
    float cpu_usage;
    float control_error_rms;
    
    // Safety status
    SafetyLimit_E active_limits[MAX_LIMITS];
    uint8_t num_active_limits;
} SystemStatus_T;
```

### 4.2 Data Management

#### 4.2.1 Shared Data Access
- **Mechanism**: Protected shared memory regions
- **Synchronization**: Mutex with priority inheritance
- **Update Policy**: Single writer, multiple readers
- **Consistency**: Atomic updates for critical data

#### 4.2.2 Data Persistence
- **Flight Data**: Circular buffer, 30 minutes
- **Configuration**: Non-volatile memory
- **Diagnostics**: Fault log, last 100 events
- **Statistics**: Cumulative operating data

---

## 5. Control Architecture

### 5.1 Control Structure

#### 5.1.1 Cascaded Control Architecture
```
┌─────────────────────────────────────────────────────┐
│                  Outer Loop (Attitude)               │
│  ┌─────────┐     ┌─────────┐     ┌─────────┐      │
│  │ Ref (+) │────▶│   PID   │────▶│Limiters │──┐   │
│  └─────────┘  -  └─────────┘     └─────────┘  │   │
│       ▲                                        ▼   │
│       └────────────────────────────────────────┘   │
│                         │                           │
│                    Rate Commands                    │
│                         ▼                           │
│               Inner Loop (Rate)                     │
│  ┌─────────┐     ┌─────────┐     ┌─────────┐      │
│  │ Ref (+) │────▶│   PID   │────▶│Limiters │──┐   │
│  └─────────┘  -  └─────────┘     └─────────┘  │   │
│       ▲                                        ▼   │
│       └────────────────────────────────────────┘   │
│                         │                           │
│                  Surface Commands                   │
└─────────────────────────┼───────────────────────────┘
                          ▼
                   Control Surfaces
```

#### 5.1.2 Control Law Implementation

**Attitude Control Loop (50 Hz)**
```matlab
function rate_cmd = attitude_controller(att_cmd, att_meas, params)
    % Error calculation
    error = att_cmd - att_meas;
    
    % Proportional term
    P = params.Kp * error;
    
    % Integral term with anti-windup
    I_raw = params.Ki * error * params.dt;
    I = saturate(persistent.integral + I_raw, params.I_limits);
    persistent.integral = I;
    
    % Derivative term with filtering
    D_raw = params.Kd * (error - persistent.last_error) / params.dt;
    D = params.alpha * D_raw + (1-params.alpha) * persistent.last_D;
    persistent.last_error = error;
    persistent.last_D = D;
    
    % Sum and limit
    rate_cmd = saturate(P + I + D, params.rate_limits);
end
```

**Rate Control Loop (100 Hz)**
```matlab
function surf_cmd = rate_controller(rate_cmd, rate_meas, params)
    % Similar PID structure but with faster update
    % and different gains for rate control
end
```

### 5.2 Safety Architecture

#### 5.2.1 Protection Hierarchy
1. **Hard Limits**: Absolute physical constraints
2. **Soft Limits**: Operational envelope with warnings
3. **Dynamic Limits**: Adjusted based on flight condition
4. **Pilot Override**: Ultimate authority retention

#### 5.2.2 Limit Implementation
```matlab
function [limited_cmd, active_limits] = safety_monitor(raw_cmd, state, limits)
    active_limits = [];
    
    % Bank angle protection
    if abs(state.roll) > limits.bank_soft
        limited_cmd.roll = soft_limit(raw_cmd.roll, state.roll, limits.bank_soft);
        active_limits = [active_limits, LIMIT_BANK_SOFT];
    end
    
    if abs(state.roll) > limits.bank_hard
        limited_cmd.roll = hard_limit(raw_cmd.roll, limits.bank_hard);
        active_limits = [active_limits, LIMIT_BANK_HARD];
    end
    
    % Similar for pitch, load factor, etc.
end
```

---

## 6. Interface Design

### 6.1 External Interface Specifications

#### 6.1.1 AHRS Interface Protocol
```
Message Format (ARINC 429):
Label 103: Roll Angle (±180°)
Label 104: Pitch Angle (±90°)
Label 105: True Heading (0-360°)
Label 112: Roll Rate (±300°/s)
Label 113: Pitch Rate (±300°/s)
Label 114: Yaw Rate (±300°/s)

Update Rate: 100 Hz
Latency: < 5 ms
```

#### 6.1.2 Actuator Command Protocol
```
Analog Output Specification:
- Voltage Range: ±10V
- Resolution: 12-bit DAC
- Update Rate: 100 Hz
- Channels:
  - Channel 1: Elevator (-10V = -15°, +10V = +15°)
  - Channel 2: Aileron (-10V = -20°, +10V = +20°)
  - Channel 3: Rudder (-10V = -25°, +10V = +25°)
```

### 6.2 Internal Interface Design

#### 6.2.1 Module Interface Template
```c
// Standard module interface pattern
typedef struct {
    // Initialization
    Status_E (*init)(const Config_T* config);
    
    // Cyclic execution
    Status_E (*execute)(const Input_T* input, Output_T* output);
    
    // Diagnostics
    Status_E (*get_status)(Status_T* status);
    
    // Shutdown
    Status_E (*shutdown)(void);
} ModuleInterface_T;
```

#### 6.2.2 Inter-Module Communication
- **Method**: Function calls with defined interfaces
- **Data Passing**: By reference with const correctness
- **Error Handling**: Return status codes
- **Timing**: Synchronized to scheduler

---

## 7. Performance Design

### 7.1 Timing Architecture

#### 7.1.1 Task Schedule
```
Frame Period: 10ms (100 Hz base rate)

Time  Task
0ms   Read Sensors (SII)
1ms   State Estimation (SEM) 
2ms   Command Processing (CPM)
3ms   Attitude Control (ATC) - 50Hz
4ms   Rate Control (ATC) - 100Hz
5ms   Safety Monitor (SFM)
6ms   Output Commands (OCI)
7ms   Diagnostics (SDM) - 10Hz
8ms   Data Logging (DLS)
9ms   Spare/Margin
```

#### 7.1.2 Worst-Case Execution Time (WCET)
| Module | WCET (μs) | Budget (μs) | Margin |
|--------|-----------|-------------|--------|
| SII | 200 | 500 | 60% |
| SEM | 400 | 800 | 50% |
| CPM | 100 | 300 | 67% |
| ATC | 600 | 1000 | 40% |
| SFM | 300 | 500 | 40% |
| OCI | 150 | 400 | 63% |

### 7.2 Memory Design

#### 7.2.1 Memory Allocation
```
Total RAM Budget: 512 KB

Allocation:
- Code Variables: 64 KB
- State Data: 32 KB
- Control Buffers: 64 KB
- Sensor Buffers: 32 KB
- Command Buffers: 16 KB
- Diagnostic Data: 128 KB
- Data Logger: 128 KB
- Stack/Heap: 48 KB
```

#### 7.2.2 Memory Protection
- **Code Segment**: Read-only, execute
- **Data Segment**: Read-write, no-execute
- **Stack**: Guard pages for overflow detection
- **Critical Data**: ECC protection

---

## 8. Design Patterns and Principles

### 8.1 Applied Design Patterns

#### 8.1.1 State Pattern
Used for system mode management:
```c
typedef struct {
    SystemMode_E mode;
    Status_E (*enter)(void);
    Status_E (*execute)(void);
    Status_E (*exit)(void);
} ModeHandler_T;
```

#### 8.1.2 Observer Pattern
Used for event notification:
```c
typedef struct {
    EventType_E event;
    void (*notify)(EventData_T* data);
} EventObserver_T;
```

#### 8.1.3 Strategy Pattern
Used for control law selection:
```c
typedef struct {
    ControlType_E type;
    void (*calculate)(Input_T* in, Output_T* out);
} ControlStrategy_T;
```

### 8.2 SOLID Principles Application

#### 8.2.1 Single Responsibility
Each module has one clear purpose and reason to change.

#### 8.2.2 Open/Closed
Control laws extensible through strategy pattern without modifying core.

#### 8.2.3 Liskov Substitution
All control strategies interchangeable through common interface.

#### 8.2.4 Interface Segregation
Modules expose only required interfaces, not monolithic APIs.

#### 8.2.5 Dependency Inversion
High-level modules depend on abstractions, not concrete implementations.

---

## 9. Technology Stack

### 9.1 Development Environment
- **Modeling**: MATLAB/Simulink R2023b
- **Code Generation**: Embedded Coder
- **Target Language**: ANSI C99
- **RTOS**: VxWorks 7.0 (optional)

### 9.2 Verification Tools
- **Static Analysis**: Polyspace Code Prover
- **Dynamic Analysis**: Simulink Test
- **Coverage**: Simulink Coverage
- **Requirements**: Simulink Requirements

### 9.3 Target Platform
- **Processor**: PowerPC MPC5566
- **Compiler**: Green Hills MULTI
- **Debugger**: Lauterbach TRACE32

---

## 10. Design Decisions and Rationale

### 10.1 Key Design Decisions

#### Decision 1: Cascaded PID vs. Modern Control
**Choice**: Cascaded PID
**Rationale**: 
- Industry proven for aircraft control
- Easy to tune and verify
- Intuitive for pilots and maintainers
- Meets performance requirements

#### Decision 2: Fixed-Point vs. Floating-Point
**Choice**: Floating-point
**Rationale**:
- Simplifies development and testing
- Reduces scaling errors
- Hardware support available
- Acceptable performance overhead

#### Decision 3: Centralized vs. Distributed Architecture  
**Choice**: Centralized
**Rationale**:
- Simpler for single-channel system
- Easier timing analysis
- Lower complexity
- Sufficient for requirements

### 10.2 Trade-off Analysis

| Aspect | Option A | Option B | Decision |
|--------|----------|----------|----------|
| Control | Classical PID | Model Predictive | PID (simplicity) |
| Scheduling | Time-triggered | Event-driven | Time (determinism) |
| Communication | Shared memory | Message passing | Shared (performance) |
| Language | C | C++ | C (certification) |

---

## 11. Architecture Validation

### 11.1 Architecture Verification
- Requirements coverage analysis
- Interface consistency checking
- Timing analysis validation
- Memory budget verification

### 11.2 Architecture Metrics
- **Coupling**: Low (avg 2.3 dependencies/module)
- **Cohesion**: High (single purpose modules)
- **Complexity**: Moderate (McCabe < 10)
- **Testability**: High (95% controllability)

---

## Appendices

### Appendix A: Interface Control Document
Detailed signal definitions and timing diagrams.

### Appendix B: Traceability Matrix
Requirements to architecture element mapping.

### Appendix C: Glossary
Technical terms and abbreviations used.

### Appendix D: References
1. ACS-SRS-001: System Requirements Specification
2. ACS-SDD-001: System Definition Document
3. ARINC 653: Avionics Application Software Interface
4. DO-297: Integrated Modular Avionics

### Appendix E: Document History
| Version | Date | Changes | Author |
|---------|------|---------|---------|
| 1.0 | [Date] | Initial release | [Your Name] |
