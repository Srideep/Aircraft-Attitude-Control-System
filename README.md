# Aircraft Attitude Control System (ACS)

A **fly-by-wire** control application that keeps a light general-aviation aircraft safely on the attitude you command, while protecting the flight envelope and detecting failures in real-time.  
The repository bundles MATLAB / Simulink models, control laws, requirements, testbenches and documentation that take the project from concept to code-generation.

> **Document set**  
> * `docs/ACS-SRS-001.pdf` – System Requirements Specification  
> * `docs/ACS-SDD-001.pdf` – System Definition Document  
> * `docs/ACS-SADD-001.pdf` – System Architecture Design  
> Refer back to these originals for the full traceability matrix and design detail.

---

## ✈️  Why this project?

* **Full stack example** – from high-level requirements through layered architecture down to auto-generated C.  
* **Safety built-in** – bank/pitch/load-factor limits, stall & overspeed guards, built-in test, fault accommodation. 
* **Education ready** – clean, modular Simulink models and exhaustive comments aimed at fast onboarding.  
* **DO-178C Level C footing** – artefacts and processes sized for certification-oriented workflows. 

---

## System snapshot  

| Layer | Key components | Responsibilities |
|-------|----------------|------------------|
| **Interface** | Pilot Cmd, Sensor I/F, Output Cmd | Signal conditioning, unit conversion, rate limiting |
| **Application** | Command Processing, Attitude Controller, Safety Monitor | Cascaded PID loops, envelope protection |
| **Service** | State Estimation, Control Algorithms, Diagnostics | Sensor fusion, common math, BIT |
| **Infrastructure** | Real-Time Scheduler, Error Handling, Data Logging | 100 Hz tasking, watchdog, trace buffers | 

A detailed component-and-data-flow diagram is embedded in **ACS-SADD-001**, `Section 3`. 
---

## Repository layout


```text
Aircraft-Attitude-Control-System
├── docs/               # specs & architecture (SRS, SDD, SADD…)
├── models/
│   ├── aircraft/       # 6-DOF dynamics, atmosphere, sensors
│   ├── control/        # Cascaded PID loops, limiters
│   └── safety/         # Flight-envelope monitor & failure logic
├── src/
│   └── auto-code/      # Generated C (Embedded Coder)
├── test/
│   ├── unit/           # MATLAB unit tests for core algorithms
│   └── verification/   # Requirement-to-test trace, MC/DC reports
├── tools/              # Helper scripts (build, plot, coverage)
└── README.md
```
## ✅ Verification & Test

### ⚙️ Performance
- ≤ ±2 ° steady-state roll & pitch error  
- 90 % response within ≤ 3 s

### 🛡️ Safety
- Bank-angle limits: ±60 °  
- Pitch limits: +30 ° / −15 °  
- Load-factor limits: +3.5 g / −1.5 g

### 📈 Reliability
- Mean time between failures (MTBF) > 10 000 flight h

`test/verification/tAutomaticSim.m` runs the scripted test suite, logs coverage, and drops HTML reports to `test/reports/`.

