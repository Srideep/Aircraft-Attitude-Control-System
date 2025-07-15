# Interface Control Document (ICD)
## Aircraft Attitude Control System

**Document ID**: ACS-ICD-001  
**Version**: 1.0  
**Date**: 7/15/2025  
**Author**: Srideep Maulik 

**Status**: Released for Implementation  
---

## 1. Introduction

### 1.1 Purpose
This Interface Control Document (ICD) defines all external and internal interfaces for the Aircraft Attitude Control System (ACS). It provides detailed specifications for signal characteristics, timing requirements, and communication protocols.

### 1.2 Scope
This document covers:
- External interfaces to aircraft systems
- Internal interfaces between ACS components
- Signal specifications and characteristics
- Timing diagrams and requirements
- Message formats and protocols
- Pin assignments and connector specifications

### 1.3 Interface Hierarchy
```
ACS System Interfaces
├── External Interfaces
│   ├── Pilot Input Interface
│   ├── AHRS Interface
│   ├── Air Data Interface
│   ├── Power Interface
│   └── Actuator Output Interface
└── Internal Interfaces
    ├── Module Communication Bus
    ├── Diagnostic Interface
    └── Configuration Interface
```

---

## 2. External Interface Specifications

### 2.1 Pilot Input Interface (PII)

#### 2.1.1 Control Stick Interface
**Interface Type**: Analog voltage input  
**Connector**: 15-pin D-sub male (J1)  
**Update Rate**: 100 Hz minimum  

**Signal Specifications:**
| Pin | Signal Name | Range | Resolution | Impedance |
|-----|-------------|-------|------------|-----------|
| 1 | ROLL_CMD_P | ±5.0V | 12-bit | >10kΩ |
| 2 | ROLL_CMD_RTN | 0V | - | <1Ω |
| 3 | PITCH_CMD_P | ±5.0V | 12-bit | >10kΩ |
| 4 | PITCH_CMD_RTN | 0V | - | <1Ω |
| 5 | STICK_VALID | 0/5V | Digital | >10kΩ |

**Transfer Function:**
```
Roll Command (deg) = (ROLL_CMD_P / 5.0) × 60.0
Pitch Command (deg) = (PITCH_CMD_P / 5.0) × 30.0
```

**Timing Requirements:**
- Maximum latency from stick movement to ACS input: 5ms
- Signal settling time: <1ms after step input
- Noise specification: <50mV RMS

#### 2.1.2 Rudder Pedal Interface
**Interface Type**: Analog voltage input  
**Connector**: 9-pin D-sub male (J2)  

**Signal Specifications:**
| Pin | Signal Name | Range | Function |
|-----|-------------|-------|----------|
| 1 | YAW_CMD_P | ±3.0V | Yaw command |
| 2 | YAW_CMD_RTN | 0V | Return |
| 3 | RUDDER_VALID | 0/5V | Validity flag |

### 2.2 AHRS Interface (AHRS-I)

#### 2.2.1 ARINC 429 Interface
**Interface Type**: ARINC 429 digital bus  
**Connector**: Triaxial coax (J3)  
**Data Rate**: 100 kbps  
**Update Rate**: 100 Hz  

**Message Format:**
```
ARINC 429 Word Structure (32 bits):
[31:29] SSM - Sign/Status Matrix
[28:11] Data - 18-bit data field
[10:9]  SDI - Source/Destination Identifier  
[8:1]   Label - Message identifier
[0]     Parity - Odd parity bit
```

**Label Definitions:**
| Label (Octal) | Parameter | Range | Units | Resolution |
|---------------|-----------|-------|-------|------------|
| 103 | Roll Angle | ±180 | deg | 0.044 |
| 104 | Pitch Angle | ±90 | deg | 0.022 |
| 105 | True Heading | 0-360 | deg | 0.088 |
| 112 | Roll Rate | ±300 | deg/s | 0.15 |
| 113 | Pitch Rate | ±300 | deg/s | 0.15 |
| 114 | Yaw Rate | ±300 | deg/s | 0.15 |
| 115 | Accelerometer X | ±5 | g | 0.0012 |
| 116 | Accelerometer Y | ±5 | g | 0.0012 |
| 117 | Accelerometer Z | ±5 | g | 0.0012 |

**SSM Definitions:**
- 00: Normal Operation
- 01: No Computed Data
- 10: Functional Test
- 11: Failure Warning

#### 2.2.2 Signal Characteristics
**Electrical:**
- Voltage levels: ARINC 429 standard (±10V differential)
- Rise/fall time: 1.5μs ±0.5μs
- Bit rate: 100 kHz ±1%

**Timing:**
- Maximum age of data: 20ms
- Maximum jitter: ±2ms
- Word transmission time: 320μs

### 2.3 Air Data Interface (ADI)

#### 2.3.1 Analog Air Data Signals
**Interface Type**: Analog voltage  
**Connector**: 25-pin D-sub male (J4)  

**Signal Specifications:**
| Pin | Signal Name | Range | Parameter | Resolution |
|-----|-------------|-------|-----------|------------|
| 1 | AIRSPEED_P | 0-5V | 0-200 kts | 0.05 kts |
| 2 | AIRSPEED_RTN | 0V | Return | - |
| 3 | ALTITUDE_P | 0-5V | 0-50k ft | 12.5 ft |
| 4 | ALTITUDE_RTN | 0V | Return | - |
| 5 | AOA_P | ±2.5V | ±25 deg | 0.012 deg |
| 6 | AOA_RTN | 0V | Return | - |
| 7 | BETA_P | ±2.5V | ±25 deg | 0.012 deg |
| 8 | BETA_RTN | 0V | Return | - |

#### 2.3.2 Digital Air Data (ARINC 429)
**Transmitted Labels:**
| Label | Parameter | Rate | Priority |
|-------|-----------|------|----------|
| 203 | Computed Airspeed | 10 Hz | Normal |
| 204 | True Airspeed | 5 Hz | Normal |
| 211 | Barometric Altitude | 20 Hz | High |
| 221 | Angle of Attack | 50 Hz | High |
| 222 | Sideslip Angle | 50 Hz | Normal |

### 2.4 Actuator Output Interface (AOI)

#### 2.4.1 Servo Command Outputs
**Interface Type**: Analog voltage output  
**Connector**: 15-pin D-sub female (J5)  
**Update Rate**: 100 Hz  

**Signal Specifications:**
| Pin | Signal Name | Range | Surface | Max Rate |
|-----|-------------|-------|---------|----------|
| 1 | ELEV_CMD_P | ±10V | Elevator ±15° | 30°/s |
| 2 | ELEV_CMD_RTN | 0V | Return | - |
| 3 | AIL_CMD_P | ±10V | Aileron ±20° | 60°/s |
| 4 | AIL_CMD_RTN | 0V | Return | - |
| 5 | RUD_CMD_P | ±10V | Rudder ±25° | 45°/s |
| 6 | RUD_CMD_RTN | 0V | Return | - |
| 7 | SERVO_ENABLE | 0/5V | Enable signal | - |

**Command Scaling:**
```
Elevator: Position (deg) = (ELEV_CMD_P / 10.0) × 15.0
Aileron:  Position (deg) = (AIL_CMD_P / 10.0) × 20.0  
Rudder:   Position (deg) = (RUD_CMD_P / 10.0) × 25.0
```

#### 2.4.2 Position Feedback
**Interface Type**: Analog voltage input  
**Connector**: 15-pin D-sub male (J6)  

**Feedback Signals:**
| Pin | Signal Name | Range | Accuracy |
|-----|-------------|-------|----------|
| 8 | ELEV_POS_P | ±10V | ±0.5° |
| 9 | ELEV_POS_RTN | 0V | - |
| 10 | AIL_POS_P | ±10V | ±0.5° |
| 11 | AIL_POS_RTN | 0V | - |
| 12 | RUD_POS_P | ±10V | ±0.5° |
| 13 | RUD_POS_RTN | 0V | - |

### 2.5 Power Interface (PWR)

#### 2.5.1 Primary Power
**Interface Type**: DC power input  
**Connector**: 3-pin circular (J7)  

**Power Requirements:**
| Pin | Signal | Voltage | Current | Ripple |
|-----|--------|---------|---------|--------|
| A | +28V_PRIMARY | 22-32V | 5A max | <2% |
| B | POWER_RTN | 0V | - | - |
| C | CHASSIS_GND | Chassis | - | - |

**Power Quality:**
- Transient immunity: DO-160G Category Z
- Voltage regulation: ±10%
- Holdup time: >50ms at full load

---

## 3. Internal Interface Specifications

### 3.1 Module Communication Bus (MCB)

#### 3.1.1 Internal CAN Bus
**Interface Type**: CAN 2.0B  
**Baud Rate**: 1 Mbps  
**Topology**: Linear bus with termination  

**Message Format:**
```
Standard CAN Frame:
- Identifier: 11 bits (0x000-0x7FF)
- RTR: Remote Transmission Request
- DLC: Data Length Code (0-8 bytes)
- Data: 0-64 bits
- CRC: 15-bit cyclic redundancy check
```

**Message Priority Scheme:**
| Priority | ID Range | Message Type | Rate |
|----------|----------|--------------|------|
| 0 (High) | 0x000-0x0FF | Safety critical | 100 Hz |
| 1 | 0x100-0x1FF | Control data | 100 Hz |
| 2 | 0x200-0x2FF | Status data | 50 Hz |
| 3 (Low) | 0x300-0x3FF | Diagnostic | 10 Hz |

#### 3.1.2 Message Definitions

**Safety Critical Messages (0x000-0x0FF):**
```
ID: 0x001 - Flight Envelope Status
Byte 0: Bank angle limit flags
Byte 1: Pitch angle limit flags  
Byte 2: Load factor limit flags
Byte 3: System status flags
Bytes 4-7: Reserved
Rate: 100 Hz
```

**Control Data Messages (0x100-0x1FF):**
```
ID: 0x101 - Attitude Commands
Bytes 0-1: Roll command (signed 16-bit, 0.01 deg resolution)
Bytes 2-3: Pitch command (signed 16-bit, 0.01 deg resolution)
Bytes 4-5: Yaw command (signed 16-bit, 0.01 deg resolution)
Byte 6: Command validity flags
Byte 7: Sequence counter
Rate: 100 Hz

ID: 0x102 - Aircraft State
Bytes 0-1: Roll angle (signed 16-bit, 0.01 deg resolution)
Bytes 2-3: Pitch angle (signed 16-bit, 0.01 deg resolution)
Bytes 4-5: Yaw angle (signed 16-bit, 0.01 deg resolution)
Byte 6: State validity flags
Byte 7: Timestamp (LSB)
Rate: 100 Hz
```

### 3.2 Diagnostic Interface (DIAG)

#### 3.2.1 Serial Debug Interface
**Interface Type**: RS-232  
**Connector**: 9-pin D-sub male (J8)  
**Configuration**: 115200 baud, 8N1  

**Protocol**: ASCII command/response
```
Command Format: <CMD> [PARAM1] [PARAM2] <CR><LF>
Response Format: <STATUS> <DATA> <CR><LF>

Example Commands:
- STATUS: Get system status
- RESET: Reset system
- PARAM GET <name>: Get parameter value
- PARAM SET <name> <value>: Set parameter value
- LOG START: Start data logging
- LOG STOP: Stop data logging
```

#### 3.2.2 Built-In Test Interface
**Test Categories:**
1. **Power-On Self Test (POST)**
   - Memory test (RAM/ROM)
   - I/O connectivity test
   - Sensor calibration check

2. **Initiated Built-In Test (IBIT)**
   - Control loop validation
   - Safety system verification
   - Communication link test

3. **Continuous Built-In Test (CBIT)**
   - Real-time monitoring
   - Performance trending
   - Fault detection

---

## 4. Timing Diagrams

### 4.1 System Timing Overview

```
System Clock: 100 Hz (10ms period)

0ms    2ms    4ms    6ms    8ms    10ms
 |      |      |      |      |      |
 |<-Sensors->|      |      |      |
        |<-State->|  |      |      |
              |<-Control->| |      |
                    |<-Output->|   |
                          |<-Diag>|

Legend:
- Sensors: Sensor data acquisition
- State: State estimation and processing  
- Control: Control law execution
- Output: Actuator command generation
- Diag: Diagnostics and monitoring
```

### 4.2 AHRS Data Flow Timing

```
AHRS Transmission Timing (100 Hz):

AHRS     ─┐    ─┐    ─┐    ─┐    ─┐
Device    │ L103│ L104│ L105│ L112│ L113 ...
          └─────└─────└─────└─────└─────

ACS      ──────┐              ┌─────────
Reception       │ Validation   │ Process
                └──────────────┘

Timing:
- Label transmission: 320μs each
- Reception latency: <100μs
- Validation time: <500μs
- Processing delay: <1ms
- Total latency: <2ms
```

### 4.3 Control Loop Timing

```
Control Loop Execution (100 Hz):

Sensor    ┌─┐     ┌─┐     ┌─┐     ┌─┐
Data      └─┘     └─┘     └─┘     └─┘
          0ms    10ms    20ms    30ms

State       ┌──┐    ┌──┐    ┌──┐
Estimation  └──┘    └──┘    └──┘
            1ms    11ms    21ms

Control       ┌───┐  ┌───┐  ┌───┐
Laws          └───┘  └───┘  └───┘
              3ms   13ms   23ms

Actuator        ┌─┐    ┌─┐    ┌─┐
Commands        └─┘    └─┘    └─┘
                6ms   16ms   26ms

Maximum end-to-end latency: 6ms
```

---

## 5. Signal Quality Requirements

### 5.1 Analog Signal Specifications

#### 5.1.1 Input Signals
**Common Requirements:**
- Input impedance: >10kΩ
- Common mode rejection: >60dB
- Noise immunity: >40dB at 1kHz
- Bandwidth: DC to 50Hz (-3dB)
- Settling time: <1ms to 0.1%

#### 5.1.2 Output Signals  
**Actuator Commands:**
- Output impedance: <10Ω
- Drive capability: ±20mA
- Ripple: <10mV RMS
- Bandwidth: DC to 100Hz
- Slew rate: >5V/μs

### 5.2 Digital Signal Specifications

#### 5.2.1 ARINC 429 Characteristics
**Electrical:**
- Differential voltage: 10V ±1V (HI state)
- Differential voltage: 0V ±1V (LO state)
- Common mode voltage: 0V ±7.5V
- Input threshold: 2.5V ±0.5V

**Timing:**
- Bit rate: 100kHz ±0.1%
- Rise time: 1.5μs ±0.5μs (10%-90%)
- Fall time: 1.5μs ±0.5μs (90%-10%)
- Gap between words: >4 bit times

### 5.3 Environmental Requirements

#### 5.3.1 Operating Conditions
- Temperature: -40°C to +85°C
- Humidity: 0% to 95% non-condensing
- Vibration: 7.7g RMS (5-2000 Hz)
- Shock: 100g, 6ms duration
- Altitude: -1000 to 70,000 ft

#### 5.3.2 EMI/EMC Compliance
- Radiated emissions: DO-160G Category M
- Conducted emissions: DO-160G Category P
- Radiated susceptibility: DO-160G Category W
- Conducted susceptibility: DO-160G Category P

---

## 6. Interface Testing Requirements

### 6.1 Signal Integrity Testing

#### 6.1.1 Test Procedures
1. **DC Accuracy Test**
   - Apply known reference voltages
   - Measure and record all channels
   - Verify accuracy within ±0.1% of full scale

2. **Frequency Response Test**
   - Apply sine wave inputs 0.1Hz to 100Hz
   - Measure amplitude and phase response
   - Verify -3dB bandwidth >50Hz

3. **Noise Immunity Test**
   - Apply common mode noise up to 5V RMS
   - Verify signal accuracy maintained
   - Check for no false triggers

#### 6.1.2 Digital Interface Testing
1. **Protocol Compliance**
   - Verify ARINC 429 electrical levels
   - Check message format compliance
   - Validate timing parameters

2. **Data Integrity**
   - Inject known test patterns
   - Verify correct reception
   - Check parity and CRC validation

### 6.2 Timing Verification

#### 6.2.1 Latency Measurement
- Input stimulus application
- Output response measurement
- Statistical analysis of delays
- Verification against requirements

#### 6.2.2 Jitter Analysis
- Clock stability measurement
- Data transmission timing
- System response variability
- Worst-case scenario testing

---

## 7. Interface Monitoring and Diagnostics

### 7.1 Real-Time Monitoring

#### 7.1.1 Signal Health Monitoring
```c
typedef struct {
    float signal_value;      // Current signal value
    float min_value;         // Minimum valid value
    float max_value;         // Maximum valid value
    uint32_t error_count;    // Cumulative error count
    uint32_t last_valid_time; // Timestamp of last valid data
    uint8_t status;          // Signal status flags
} SignalMonitor_T;

// Status flags
#define SIGNAL_VALID      0x01
#define SIGNAL_RANGE_ERR  0x02
#define SIGNAL_STALE      0x04
#define SIGNAL_NOISY      0x08
```

#### 7.1.2 Communication Monitoring
- Message reception rates
- Error frame detection
- Bus utilization tracking
- Node health monitoring

### 7.2 Fault Detection and Isolation

#### 7.2.1 Input Signal Faults
- **Range Check**: Signal within expected bounds
- **Rate Check**: Change rate within limits
- **Consistency Check**: Multiple sensor correlation
- **Staleness Check**: Data age monitoring

#### 7.2.2 Output Signal Faults
- **Command Feedback**: Compare command vs. actual
- **Actuator Response**: Verify proper response time
- **Position Accuracy**: Check steady-state error
- **Authority Limits**: Ensure within safe bounds

---

## 8. Configuration Management

### 8.1 Interface Version Control

#### 8.1.1 Interface Identification
- Interface version numbers
- Compatibility matrices
- Change documentation
- Impact assessments

#### 8.1.2 Parameter Management
```c
typedef struct {
    char name[32];           // Parameter name
    float default_value;     // Factory default
    float current_value;     // Current setting
    float min_limit;         // Minimum allowed value
    float max_limit;         // Maximum allowed value
    uint8_t access_level;    // Read/write permissions
} ConfigParam_T;
```

### 8.2 Calibration Requirements

#### 8.2.1 Sensor Calibration
- Zero offset correction
- Gain adjustment
- Linearity compensation
- Temperature compensation

#### 8.2.2 Actuator Calibration
- Position feedback scaling
- Command authority limits
- Rate limiting parameters
- Dead-band compensation

---

## 9. Interface Change Control

### 9.1 Change Request Process
1. **Change Identification**
   - Technical justification
   - Impact analysis
   - Risk assessment

2. **Design Review**
   - Interface design update
   - Compatibility verification
   - Test plan modification

3. **Implementation**
   - Hardware/software updates
   - Documentation revision
   - Verification testing

### 9.2 Backward Compatibility
- Legacy interface support
- Migration procedures
- Version negotiation
- Fallback mechanisms

---

## 10. Appendices

### Appendix A1: Connector Pin-Out Diagrams
[Detailed mechanical drawings of all connectors with pin assignments, wire gauges, and mating connector specifications]

### Appendix A2: Cable Specifications
[Wire specifications, shield requirements, connector types, and cable assembly drawings]

### Appendix A3: Test Procedures
[Detailed step-by-step procedures for interface verification and validation testing]

### Appendix A4: Troubleshooting Guide
[Common interface problems, diagnostic procedures, and resolution steps]

---

**Document Control:**
- This document is controlled and distributed electronically
- Latest version available from configuration management system
- Changes require approval through engineering change process
- All users must verify they have current revision

