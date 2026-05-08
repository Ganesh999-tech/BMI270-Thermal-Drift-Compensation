# BMI270 Thermal Drift Compensation & Calibration
### 🚀 STM32H7 Firmware | MATLAB Data Analytics | MEMS Packaging Physics

This repository contains a full-stack engineering solution for mitigating thermal drift in the **Bosch BMI270 IMU**. By correlating internal die temperature with sensor bias, I implemented a real-time compensation algorithm on an **STM32H743ZI** to ensure navigation stability across a 37°C thermal gradient.

---

## 📌 Project Overview
MEMS (Micro-Electro-Mechanical Systems) sensors are inherently sensitive to environmental temperature. This project maps physical hardware deformations to mathematical models to "zero out" sensor errors in real-time.

### Key Engineering Challenges
* **Thermomechanical Stress:** **CTE (Coefficient of Thermal Expansion) mismatch** between the silicon die, the adhesive, and the breakout board package causes structural warping.
* **Zero-Rate Output (ZRO) Drift:** Temperature-induced shifts in the **Young’s Modulus** (mechanical stiffness) of the internal silicon comb structures.
* **Sensitivity Shift:** Variations in accelerometer gain (Scale Factor) due to thermal expansion affecting capacitive gaps.

---

## 🛠️ Hardware Setup
* **Microcontroller:** Nucleo-H743ZI2 (ARM Cortex-M7 @ 480MHz)
* **Sensor:** BMI270 6-Axis IMU (Chinese Breakout Board)
* **Interface:** SPI Protocol
* **Thermal Testbeds:** * 🔥 **Heat:** Forced convection via laptop exhaust during high-load gaming (~50°C).
    * ❄️ **Cooling:** Active cooling via DIY Thermoelectric Peltier Module (~13°C).

---

## 📊 Results & Analysis
Telemetry was logged via **PuTTY** and processed through a custom **MATLAB** robust-filtering pipeline.

### 1. Gyroscope Thermal Bias Drift
We identified a strong linear correlation between temperature and bias ($y = mx + c$).
* **Gyro X Coefficient:** `0.019127 dps/°C`
* **Gyro Y Coefficient:** `0.012860 dps/°C`
* **Gyro Z Coefficient:** `-0.001489 dps/°C` (Most Stable axis)

### 2. Accelerometer Validation
Using **Vector Magnitude ($G_{tot}$)**, sensor integrity was validated across different physical orientations to isolate thermal sensitivity from positional gravity.
* **Thermal Sensitivity Shift:** `1.99%`
* **Range Verification:** Confirmed ±8g default initialization (4096 LSB/g).

---

## 📂 Repository Structure
```text
├── Core/       # STM32 source code, SPI driver, and compensation logic.
├── Debug/      # BMI
├── Drivers/      #CMSIS, STM32H7_Hal_driver 
├── Results & VALIDATION/        # High-resolution colourful plots and setup photographs.
├── Documentation/  # Datasheets, RM0433, PM0253, and MEMS Packaging research notes.
└── README.md       # Project documentation.
