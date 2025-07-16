# Traceability Matrix (TRM)

## Aircraft Attitude Control System 

**Document ID**: ACS‑TRM‑001‑H

**Version**: 1.0

**Date**: 07/16/2025

**Author**: Srideep Maulik

**Status**: Draft – Bidirectional Traceability Baseline

---

## 1 Purpose
This Traceability Matrix establishes and maintains **bidirectional traceability** between:

* **System Requirements** (*ACS‑SRS‑001‑H*)
* **Architectural Elements** (*ACS‑SADD‑001‑H*)
* **Design Components / Model Subsystems** (*ACS‑SMS‑001‑H*)
* **Verification & Validation Artefacts** (tests, analyses, reviews)

The matrix ensures every requirement is realised in the model and properly verified—and that every model element can be traced back to a requirement.

---

## 2 Legend

| Abbrev.           | Meaning                                                     |
| ----------------- | ----------------------------------------------------------- |
| **Arch ID**       | Architectural component from SADD §2.2 (IF‑#, APP‑#, SUP‑#) |
| **Design ID**     | Model subsystem from SMS §2.1                               |
| **V\&V Artefact** | Test case, script, or review activity                       |

---

## 3 Traceability Table — Requirements → Architecture → Design → V\&V

| Req ID       | Requirement Summary        | Arch ID(s)                       | Design ID(s)                           | V\&V Artefact(s)             |
| ------------ | -------------------------- | -------------------------------- | -------------------------------------- | ---------------------------- |
| **SR‑001.1** | Roll ≤ ±2 ° SS error       | APP‑2 (Attitude\_Controller)     | *Attitude\_Control* (PID\_Roll)        | `tRollTrack` (Simulink Test) |
| **SR‑001.2** | Pitch ≤ ±2 ° SS error      | APP‑2                            | *Attitude\_Control* (PID\_Pitch)       | `tPitchTrack`                |
| **SR‑002.1** | Roll step 90 % ≤ 3 s       | APP‑2                            | *Attitude\_Control* (PID\_Roll)        | `tRollStep` harness          |
| **SR‑002.2** | Pitch step 90 % ≤ 4 s      | APP‑2                            | *Attitude\_Control* (PID\_Pitch)       | `tPitchStep`                 |
| **SR‑002.3** | Overshoot < 15 %           | APP‑2                            | *Attitude\_Control*                    | Same step tests, KPI check   |
| **SR‑003.1** | Bank limit ±60 °           | APP‑3 (Envelope\_Protection)     | *Envelope\_Protection* Stateflow       | `limBankTest` fault‑inject   |
| **SR‑003.2** | Pitch limit +30/‑15 °      | APP‑3                            | *Envelope\_Protection*                 | `limPitchTest`               |
| **SR‑003.3** | IMU dropout detect ≤ 0.1 s | APP‑3, SUP‑1 (State\_Estimation) | *Envelope\_Protection*, *Sensors\_I/F* | `tIMUDrop` harness           |
| **SR‑005.1** | Pilot cmd ≥ 50 Hz          | IF‑1 (Pilot I/F)                 | *Command\_Processing* + Joystick block | Bench test w/ HID profiler   |
| **SR‑006.1** | IMU rate ≥ 100 Hz          | IF‑2 (IMU I/F)                   | *Sensors\_I/F*                         | Oscilloscope serial capture  |
| **SR‑007.1** | PWM 1–2 ms @ 100 Hz        | IF‑3 (Servo I/F)                 | *Actuator\_I/F*                        | `scopePWM` hardware test     |
| **PR‑001.1** | Loop rate 100 Hz ±1 %      | Global scheduler                 | Root model (rate‑group)                | Profiler report              |
| **PR‑001.2** | Latency ≤ 15 ms            | Whole chain                      | All subsystems                         | `checkTiming` script         |
| **PR‑002.1** | CPU < 80 % core            | N/A                              | Full model                             | Profiler report              |
| **PR‑002.2** | RAM < 512 MB               | N/A                              | Full model                             | Task manager log             |
| **DC‑001**   | MATLAB Home toolchain      | Whole arch                       | Config set `simConfigSet.ssc`          | Model Advisor licence check  |

---

## 4 Reverse Trace — Design Element → Requirement(s)
(The following excerpt demonstrates that each subsystem maps back to at least one requirement.)

| Design ID              | Parent Subsystem | Linked Requirement(s)         |
| ---------------------- | ---------------- | ----------------------------- |
| *Sensors\_I/F*         | IF‑2             | SR‑006.1, SR‑003.3            |
| *Command\_Processing*  | APP‑1            | SR‑005.1                      |
| *Attitude\_Control*    | APP‑2            | SR‑001.1, SR‑001.2, SR‑002. x |
| *Envelope\_Protection* | APP‑3            | SR‑003.1, SR‑003.2, SR‑003.3  |
| *Actuator\_I/F*        | IF‑3             | SR‑007.1                      |
| *Diagnostics*          | SUP‑3            | PR‑001.2, PR‑002. x           |

---

## 5 Maintenance Procedure

1. **Add new requirement:** Assign unique Req ID; update SRS.
2. **Update architecture/design:** Link new Req ID in *Arch ID* & *Design ID* columns.
3. **Create V\&V artefact:** Develop test or analysis; record in matrix.
4. **Run Model Advisor check** *“Unlinked requirement blocks”* to ensure completeness.
5. **Version control:** Increment document version; commit with tag `acs_trm_v<ver>`.

---

## 6 Change Log

| Ver | Date        | Change                                      | Author    |
| --- | ----------- | ------------------------------------------- | --------- |
| 1.0 | 16 Jul 2025 | Initial hobby‑edition traceability baseline | S. Maulik |

---

*End of Document*
