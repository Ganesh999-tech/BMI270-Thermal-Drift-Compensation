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
* ** Hardware Connection
* stm32h743zi---BMI270 IMU Sensor Breakout board
   * PA5	I/O	SPI1_SCK
   * PA6	I/O	SPI1_MISO
   * PA7	I/O	SPI1_MOSI
   * PB1	Output	GPIO_Output(BMI270_CS)
   * Vcc -- 3.3V
   * Gnd -- Gnd
* ** Usb serial interface data
   * PD8	I/O	USART3_TX
   * PD9	I/O	USART3_RX

## 📝 Implementation Procedure

### 1. STM32CubeMX Configuration
* **Clock Configuration:** Set HCLK to 480 MHz for maximum performance on the Cortex-M7 core.
* **SPI1 Setup:** * Mode: Full-Duplex Master.
    * Hardware CS: Disabled (Software Chip Select handled via PB1).
    * Data Size: 8 Bits | First Bit: MSB First.
    * Prescaler: Adjusted for a stable baud rate (Target: 10-20 MBits/s).
* **USART3 Setup:** Asynchronous mode configured for high-speed telemetry data logging.
* **GPIO Setup:** Set PB1 as GPIO_Output (Pull-up, High by default) to act as the SPI Slave Select.

### 2. STM32CubeIDE Development
* **Driver Implementation:** Developed a custom low-level SPI driver to initialize the BMI270 into Normal Mode and verify Chip ID.
* **Range Configuration:** Configured Accelerometer to ±8g and Gyroscope to 2000 dps for high-dynamic range testing.
* **Telemetry Loop:** * Read Raw Hex data from sensor registers.
    * Convert raw bits to float values using LSB sensitivity constants.
    * Apply Linear Regression coefficients (y = mx + c) directly to the raw stream in firmware.
    * Transmit processed data via HAL_UART_Transmit to the serial interface.

### 3. MATLAB Analysis
* **Data Collection:** Logged raw telemetry via PuTTY into .csv files during "BMI_270_cold_test_" (~50°C) and "BMI_270_hot_test_" (~13°C) sessions.
* **Characterization:** Ran MATLAB scripts in the `/Results & VALIDATION` folder to perform linear regression on the bias-vs-temperature data.
* **Calibration:** Extracted the slope (m) and offset (c) values and updated the STM32 firmware coefficients to achieve real-time thermal resilience.
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
