import serial
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
from collections import deque

# --- CONFIGURATION ---
SERIAL_PORT = 'COM3' 
BAUD_RATE = 38400    
WINDOW_SIZE = 100   

temp_data = deque(maxlen=WINDOW_SIZE)
accel = [deque(maxlen=WINDOW_SIZE) for _ in range(3)] 
gyro = [deque(maxlen=WINDOW_SIZE) for _ in range(3)]  

try:
    ser = serial.Serial(SERIAL_PORT, BAUD_RATE, timeout=0.1)
    ser.flushInput() 
except Exception as e:
    print(f"Error: {e}"); exit()

fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(12, 10))
fig.subplots_adjust(right=0.82, hspace=0.4, left=0.1, top=0.92, bottom=0.08) 
fig.suptitle('BMI270 Thermal Drift - SOFTWARE CORRECTED', fontsize=16)

l_temp, = ax1.plot([], [], color='red', label='Temp (°C)')
l_acc = [ax2.plot([], [], label=n)[0] for n in ['Acc X', 'Acc Y', 'Acc Z']]
l_gyr = [ax3.plot([], [], label=n)[0] for n in ['Gyr X', 'Gyr Y', 'Gyr Z']]

def setup_axes():
    ax2.set_ylim(-1.5, 1.5) 
    ax3.set_ylim(-2, 2)
    for ax in [ax1, ax2, ax3]:
        ax.set_xlim(0, WINDOW_SIZE)
        ax.grid(True, linestyle='--', alpha=0.6)
        ax.legend(loc='center left', bbox_to_anchor=(1, 0.5), fontsize='small')

setup_axes()

def update(frame):
    if ser.in_waiting > 0:
        try:
            line = ser.readline().decode('utf-8', errors='ignore').strip()
            v = [float(x) for x in line.split(',')]
            if len(v) == 7:
                # --- SOFTWARE CORRECTION ---
                # If STM32 sends 0.25, we multiply by 4 to get 1.0
                corrected_acc = [val * 4.0 for val in v[1:4]] 
                
                temp_data.append(v[0])
                for i in range(3):
                    accel[i].append(corrected_acc[i])
                    gyro[i].append(v[i+4])
                
                x = range(len(temp_data))
                l_temp.set_data(x, temp_data)
                for i in range(3):
                    l_acc[i].set_data(x, accel[i])
                    l_gyr[i].set_data(x, gyro[i])
                
                # Auto-scale temperature
                if len(temp_data) > 0:
                    ax1.set_ylim(min(temp_data)-0.1, max(temp_data)+0.1)

        except: pass
    return l_temp, *l_acc, *l_gyr

ani = FuncAnimation(fig, update, blit=False, interval=20)
plt.show()
ser.close()