<h1 align="center">STUDY-BUDDY FOCUS LAMP</h1>

<p align="center">
Study-Buddy Focus Lamp merupakan sistem smart desk lamp berbasis mikrokontroler ATmega328P yang diprogram menggunakan AVR Assembly. Sistem ini dirancang untuk meningkatkan produktivitas belajar melalui integrasi fitur auto-dimming dan Pomodoro Timer.
</p>

---

# Group Members

- Ayesha Zelene Faeyza - 2406359166
- Vanesa Kayla Zahra - 2306161901
- Eugenia Huwaida Imtinan - 2406421384
- Diandra Pramesti Wicaksono - 2406342360

---

<details>
<summary><b>Table of Contents</b></summary>

<br>

1. [Introduction](#1-introduction)

2. [Hardware Design and Implementation](#2-hardware-design-and-implementation)

3. [Software Implementation](#3-software-implementation)

4. [Testing and Performance Evaluation](#4-testing-and-performance-evaluation)

5. [Conclusion and Future Work](#5-conclusion-and-future-work)

</details>

---

# 1. Introduction

## 1.1 Problem Statement
Mahasiswa sering menghabiskan waktu belajar dalam durasi yang panjang dengan kondisi pencahayaan yang kurang memadai. Hal ini dapat menyebabkan kelelahan mata, rasa lelah, dan penurunan konsentrasi. Lampu meja konvensional masih memerlukan pengaturan manual dan tidak mampu menyesuaikan tingkat pencahayaan secara otomatis terhadap kondisi lingkungan sekitar.

Selain itu, mahasiswa juga sering kehilangan kontrol terhadap waktu belajar dan lupa untuk mengambil waktu istirahat secara berkala. Kondisi tersebut dapat menurunkan produktivitas dan berdampak buruk terhadap kesehatan fisik. Oleh karena itu, dibutuhkan sebuah sistem otomatis yang mampu menggabungkan pencahayaan adaptif dan dukungan produktivitas untuk menciptakan lingkungan belajar yang lebih nyaman dan efisien.

Perkembangan teknologi embedded system dan mikrokontroler memungkinkan pengembangan smart desk lamp yang dapat menyesuaikan tingkat kecerahan secara dinamis sekaligus mengintegrasikan fitur manajemen waktu berbasis metode Pomodoro.

## 1.2 Proposed Solution
Pada proyek ini, kami merancang **Study-Buddy Focus Lamp**, sebuah sistem smart lamp berbasis mikrokontroler ATmega328P yang diprogram sepenuhnya menggunakan bahasa AVR Assembly.

Sistem ini mampu mengatur tingkat kecerahan LED secara otomatis berdasarkan intensitas cahaya lingkungan yang dideteksi oleh sensor LDR. Selain itu, sistem juga dilengkapi dengan mekanisme Pomodoro Timer yang dapat berpindah antara fase fokus dan istirahat menggunakan interupsi eksternal.

Komponen utama yang digunakan pada sistem ini meliputi:

- **LDR (Photoresistor):** Mendeteksi intensitas cahaya lingkungan secara real-time.
- **Kontrol PWM pada LED:** Mengatur kecerahan LED secara otomatis menggunakan Fast PWM.
- **Push Button:** Digunakan untuk mengganti fase Pomodoro menggunakan interrupt eksternal INT0.
- **Buzzer Alarm:** Memberikan notifikasi suara saat terjadi perpindahan fase Pomodoro.
- **Timer Module:** Mengatur durasi sesi fokus dan istirahat.
- **ATmega328P (Arduino Uno):** Memproses seluruh logika sistem dan input sensor.

Sistem ini dirancang untuk meningkatkan produktivitas belajar sekaligus menjaga kenyamanan mata melalui otomatisasi dan kontrol hardware yang efisien.

---

# 2. Hardware Design and Implementation

## 2.1 System Architecture
Untuk memenuhi kriteria proyek akhir Praktikum Sistem Embedded, software dikembangkan sepenuhnya menggunakan bahasa AVR Assembly agar dapat melakukan kontrol hardware tingkat rendah secara efisien.

Sistem menggunakan Arduino Uno dengan mikrokontroler ATmega328P sebagai pusat kendali utama. Sensor LDR membaca intensitas cahaya lingkungan melalui modul ADC. Berdasarkan nilai ADC tersebut, mikrokontroler akan menyesuaikan tingkat kecerahan LED menggunakan PWM yang dihasilkan oleh Timer2.

Fitur Pomodoro diimplementasikan menggunakan timer dan interrupt eksternal melalui push button yang terhubung ke pin INT0. Buzzer digunakan sebagai indikator alarm saat perpindahan antara sesi fokus dan sesi istirahat.

Secara keseluruhan, sistem dirancang untuk bekerja secara otomatis namun tetap mendukung interaksi pengguna melalui mekanisme interrupt.

---

## 2.2 Circuit Design

### Physical Hardware Implementation

<p align="center">
  <img src="https://github.com/user-attachments/assets/766197e5-ebef-4189-835c-fe6f28a50765" width="75%">
</p>

Gambar di atas menunjukkan implementasi rangkaian fisik Study-Buddy Focus Lamp menggunakan Arduino Uno, sensor LDR, LED, push button, dan buzzer pada breadboard.

### Proteus Simulation Design

<p align="center">
  <img src="https://github.com/user-attachments/assets/01f09bf3-0019-4af8-bdd9-22185def0fc6" width="75%">
</p>

Gambar di atas menunjukkan desain rangkaian menggunakan Proteus yang digunakan untuk simulasi dan verifikasi sistem sebelum implementasi hardware dilakukan.

---

## 2.3 Wiring Table

| Komponen | Kaki / Pin Komponen | Sambungan ke Arduino | Keterangan |
|---|---|---|---|
| **Buzzer** | Kaki Positif (+) | Digital Pin 13 | Output suara alarm Pomodoro |
| | Kaki Negatif (-) | GND | |
| **LED** | Kaki Positif (Anoda) | Digital Pin 11 | Output PWM (kecerahan otomatis) |
| | Kaki Negatif (Katoda) | GND (lewat resistor 220Ω) | |
| **Push Button** | Terminal 1 | Digital Pin 2 (INT0) | Input interrupt untuk toggle fase 25s/5s |
| | Terminal 2 | GND | Pull-up internal aktif pada kode |
| **LDR (Sensor)** | Kaki 1 | 5V | |
| | Kaki 2 | Analog Pin A0 (ADC0) | Terhubung juga ke resistor 10kΩ menuju GND (voltage divider) |

---

## 2.4 Components List

- 1x Arduino Uno R3 (ATmega328P)
- 1x Push Button (Tactile Switch)
- 1x Sensor Cahaya (LDR / Photoresistor)
- 1x Resistor 10kΩ (Voltage Divider untuk LDR)
- 1x LED
- 1x Resistor 220Ω atau 330Ω (Current Limiting Resistor untuk LED)
- 1x Active Buzzer

---

# 3. Software Implementation

## 3.1 Programming Approach
Software dikembangkan sepenuhnya menggunakan bahasa AVR Assembly untuk mendapatkan akses hardware secara langsung dan eksekusi yang efisien pada mikrokontroler ATmega328P.

Beberapa modul peripheral AVR yang digunakan dalam sistem meliputi ADC, PWM, Timer, Interrupt, dan Basic I/O. Seluruh peripheral tersebut bekerja bersama untuk menyediakan kontrol pencahayaan adaptif dan dukungan produktivitas berbasis Pomodoro.

Program secara terus-menerus membaca intensitas cahaya menggunakan modul ADC dan memetakan nilai sensor menjadi duty cycle PWM untuk menghasilkan perubahan kecerahan LED yang halus. Secara bersamaan, timer dan interrupt digunakan untuk mengatur perpindahan fase Pomodoro dan notifikasi buzzer.

## 3.2 Key Functions

### ADC Initialization
Menginisialisasi modul ADC untuk membaca tegangan analog dari sensor LDR yang terhubung pada ADC0.

### LDR Reading
Membaca intensitas cahaya lingkungan secara kontinu dan mengubah sinyal analog menjadi nilai digital ADC.

### PWM Control
Menggunakan Timer2 Fast PWM untuk mengatur tingkat kecerahan LED secara dinamis dan halus.

### Auto-Dimming Logic
Menerapkan logika inverse brightness dimana LED akan semakin terang ketika lingkungan sekitar semakin gelap.

### Timer Management
Mengatur countdown Pomodoro untuk sesi fokus dan sesi istirahat.

### Interrupt Handling
Menggunakan interrupt eksternal INT0 untuk mendeteksi tekanan push button dan mengganti fase Pomodoro.

### Buzzer Alarm
Mengaktifkan buzzer saat terjadi perpindahan fase Pomodoro untuk memberikan notifikasi kepada pengguna.

### Basic I/O Initialization
Menginisialisasi seluruh pin input dan output yang digunakan oleh sensor, tombol, LED, dan buzzer.

---

# 4. Testing and Performance Evaluation

## 4.1 Testing Methodology
Setelah hardware dan software terintegrasi, sistem diuji pada berbagai kondisi pencahayaan lingkungan dan skenario interaksi pengguna.

Pengujian difokuskan pada:

- Akurasi pembacaan ADC dari sensor LDR
- Kelancaran perubahan kecerahan LED berbasis PWM
- Respons sistem auto-dimming
- Fungsionalitas push button berbasis interrupt
- Akurasi perpindahan fase Pomodoro
- Aktivasi buzzer saat pergantian fase
- Stabilitas program Assembly selama sistem berjalan

## 4.2 Results
Berdasarkan proses pengujian, sistem berhasil memenuhi tujuan utama proyek.

Sensor LDR mampu mendeteksi perubahan intensitas cahaya dengan baik dan modul ADC berhasil mengonversi sinyal analog menjadi nilai digital secara stabil. LED berbasis PWM juga mampu berubah tingkat kecerahannya dengan halus tanpa flicker yang terlihat.

Logika auto-dimming berjalan sesuai harapan, dimana LED akan semakin terang ketika ruangan gelap dan semakin redup ketika lingkungan terang.

Push button yang terhubung melalui INT0 berhasil melakukan perpindahan fase Pomodoro, sedangkan buzzer memberikan notifikasi suara dengan baik saat terjadi pergantian sesi fokus dan istirahat.

Secara keseluruhan, sistem menunjukkan performa yang stabil dan efisien selama pengujian berlangsung.

## 4.3 Performance Evaluation
Evaluasi performa proyek embedded system ini dapat dilihat dari proses pengembangan maupun hasil implementasi akhir.

Dari sisi pengembangan, proyek berhasil mengintegrasikan berbagai modul peripheral AVR ke dalam satu sistem yang terintegrasi dengan baik. Penggunaan bahasa AVR Assembly juga meningkatkan pemahaman terhadap operasi hardware tingkat rendah, interrupt handling, dan mekanisme timer.

Dari sisi implementasi, proyek berhasil mencapai tujuan utama yaitu menciptakan smart study lamp yang mampu meningkatkan produktivitas sekaligus kenyamanan pengguna. Integrasi modul ADC, PWM, Timer, dan Interrupt berjalan dengan baik dan memenuhi kebutuhan proyek akhir Sistem Embedded.

---

# 5. Conclusion and Future Work

## 5.1 Conclusion
**Study-Buddy Focus Lamp** berhasil mengintegrasikan kontrol pencahayaan adaptif dan fitur produktivitas Pomodoro menggunakan mikrokontroler ATmega328P yang diprogram sepenuhnya menggunakan AVR Assembly.

Sistem ini menunjukkan bagaimana embedded system dapat digunakan untuk meningkatkan kenyamanan dan produktivitas pengguna melalui pemanfaatan peripheral ADC, PWM, Timer, dan Interrupt secara efisien. Mekanisme auto-dimming dan fitur Pomodoro yang diimplementasikan juga berjalan dengan stabil selama proses pengujian.

Proyek ini berhasil memenuhi tujuan utama proyek akhir Sistem Embedded sekaligus memberikan implementasi yang relevan untuk kebutuhan belajar mahasiswa.

## 5.2 Future Work

Sebagai pengembangan selanjutnya, kami menyarankan:

- Menambahkan OLED atau LCD display untuk visualisasi timer dan status sistem.
- Mengimplementasikan penyimpanan EEPROM untuk menyimpan status Pomodoro setelah listrik mati.
- Menambahkan beberapa mode pencahayaan tambahan.
- Mengintegrasikan komunikasi serial untuk logging sesi belajar.
- Meningkatkan presisi timer dan kustomisasi durasi Pomodoro.
- Mengintegrasikan fitur IoT untuk monitoring dan kontrol jarak jauh.
