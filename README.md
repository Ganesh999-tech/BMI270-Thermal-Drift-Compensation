# BMI270_STM32_Driver
# BMI270 Thermal Calibration & Data Logging

This repository contains an embedded C driver and analysis tools for the **Bosch BMI270** 6-axis IMU, running on the high-performance **STM32H743ZI** (ARM Cortex-M7) platform. 

## 🎯 Current Objective: Thermal Experimentation
The primary goal of this phase is to collect steady-state sensor data across various temperature ranges to analyze **Zero-g Offset** and **Gyroscope Bias** stability. This experimentation is a key component of my studies in the **Analytical Instruments, Measurement, and Sensor Technology (AIMS)** program.

## 🛠 Hardware Stack
*   **MCU:** STM32H743ZI (Nucleo-144) @ 480MHz.
*   **Sensor:** Bosch BMI270 (connected via SPI1).
*   **Interface:** USART3 @ 115200 Baud for data streaming.

## 📊 Data Stream Format
The firmware outputs a CSV-compatible string every 20ms (50Hz) for logging via **PuTTY** or real-time visualization:
`Temperature, Accel_X, Accel_Y, Accel_Z, Gyro_X, Gyro_Y, Gyro_Z`

## 🚀 Experimentation Workflow
1.  **Steady-State Logging:** The sensor is kept stationary to isolate thermal drift from physical motion.
2.  **Data Capture:** Using PuTTY to log the serial stream directly into `.csv` files for post-processing.
3.  **Thermal Analysis:** Observing how the gyroscope noise floor and bias shift as the internal temperature of the BMI270 increases during operation.

## 📂 Project Structure
*   `Core/Src/main.c`: Primary logic for sensor initialization, SPI communication, and CSV streaming.
*   `imu_visualizer.py`: A Python-based 3D digital twin using VPython for real-time orientation monitoring.

## 📈 Future Goals
*   Implement a software-based temperature compensation algorithm.
*   Integrate calibrated sensor fusion into the **Smart Explorer Robot** project.
