# Study-Buddy Focus Lamp 

---

## Group 14

Ayesha Zelene Faeyza - 2406359166  
Vanesa Kayla Zahra - 2306161901  
Eugenia Huwaida Imtinan - 2406421384  
Diandra Pramesti Wicaksono - 2406342360

---

A smart desktop companion designed to enhance productivity and eye comfort for students.

## 1. Introduction
The **Study-Buddy Focus Lamp** addresses the common issue of eye strain and loss of focus during long study sessions. This system provides an automated lighting solution that adjusts brightness based on ambient light levels and incorporates a **Pomodoro Timer** to encourage regular breaks. By combining sensor-driven automation with time-management techniques, it aims to create an optimal learning environment.

## 2. Hardware Design and Implementation
The system is built using the **ATmega328P** (Arduino Uno) and programmed entirely in **AVR Assembly** to ensure high efficiency and direct hardware control.

### Components Used:
* **LDR (Photoresistor)**: Acts as the primary input sensor to detect ambient light levels.
* **LED**: Serves as the adaptive light source.
* **Resistors**: 220 Ω for the LED and 10k Ω for the LDR voltage divider circuit.
* **Arduino Uno**: The central processing unit.

### Wiring Details:
* **LDR**: Connected to **Pin A0** (ADC0) using a voltage divider configuration.
* **LED**: Connected to **Pin 11** (PB3) using Timer2 for PWM control.

## 3. Software Implementation
The software is implemented using several AVR modules to satisfy the project criteria:

* **Modul 8 (ADC)**: Used to read the analog signal from the LDR and convert it into an 8-bit digital value.
* **Modul 7 (PWM)**: Utilizes Timer2 (Fast PWM mode) to control the LED brightness smoothly.
* **Modul 2 (Basic I/O)**: Manages the initialization of input and output pins.
* **Modul 3 (USART)**: *(Planned)* For logging study sessions to the Serial Monitor.
* **Modul 5 (Timer)**: *(Planned)* For the Pomodoro countdown and alarm.
* **Modul 6 (Interrupt)**: *(Planned)* To handle the physical reset/dismiss button.

## 4. Test Results and Performance Evaluation
Initial testing of the core features was successful:
* **ADC Reliability**: The LDR accurately detects light changes, confirmed via Serial Monitor testing.
* **PWM Smoothness**: The LED transitions between brightness levels without flickering.
* **Auto-Dimming Logic**: The "Inverting Logic" correctly brightens the LED as the room gets darker, providing a seamless user experience.

## 5. Conclusion and Future Work
The project successfully integrates ambient light sensing with adaptive LED control using Assembly language. 

**Future Work includes:**
* Adding a **Buzzer** for auditory break alerts.
* Implementing a **Push Button** for user interaction.
* Saving session data to **EEPROM** to maintain state after power cycles.

---
