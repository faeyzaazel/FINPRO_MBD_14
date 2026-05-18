#define __SFR_OFFSET 0x00
#include <avr/io.h>

.global main_asm
.global __vector_1

; Variabel Aman di SRAM
.section .data
fase: .byte 0           ; 0 = 25s, 1 = 5s
detik_skrg: .byte 0
alarm_status: .byte 0

.section .text
main_asm:
    ; Stack Pointer Setup
    ldi r16, 0x08
    out 0x3E, r16       ; SPH
    ldi r16, 0xFF
    out 0x3D, r16       ; SPL

    ; I/O Setup
    sbi 0x04, 5         ; DDRB, 5 (Pin 13 Buzzer)
    sbi 0x04, 3         ; DDRB, 3 (Pin 11 LED PWM)
    cbi 0x09, 2         ; DDRD, 2 (Pin 2 Input Tombol)
    sbi 0x0B, 2         ; PORTD, 2 (Pull-up ON)

    ; USART 115200
    ldi r16, 8
    sts 0xC4, r16       ; UBRR0L
    ldi r16, 0x08       ; TXEN0
    sts 0xC1, r16       ; UCSR0B

    ; Timer 2 (PWM LED Pin 11)
    ldi r16, 0xA3
    sts 0xB0, r16       ; TCCR2A
    ldi r16, 0x04
    sts 0xB1, r16       ; TCCR2B

    ; Timer 1 (1 Detik Akurat)
    ldi r16, 0
    sts 0x80, r16       ; TCCR1A = 0 (Matikan PWM siluman bawaan Arduino)
    
    ldi r16, 0x3D
    sts 0x89, r16       ; OCR1AH
    ldi r16, 0x08
    sts 0x88, r16       ; OCR1AL
    ldi r16, 0x0D       ; WGM12 | CS12 | CS10
    sts 0x81, r16       ; TCCR1B

    ; ADC Setup (LDR)
    ldi r16, 0x60
    sts 0x7C, r16       ; ADMUX
    ldi r16, 0x87
    sts 0x7A, r16       ; ADCSRA

    ; Reset Variabel di SRAM
    ldi r16, 0
    sts fase, r16
    sts detik_skrg, r16
    sts alarm_status, r16
    
    ; External Interrupt Setup (Tombol)
    ldi r16, 0x02       ; ISC01 = 1 (Falling Edge)
    sts 0x69, r16       ; EICRA
    ldi r16, 0x01
    out 0x1D, r16       ; EIMSK (Aktifkan INT0)
    
    sei                 ; Menyalakan Interupsi Global

loop:
    ; Kendali LDR
    lds r16, 0x7A       ; ADCSRA
    ori r16, 0x40       ; Set bit ADSC
    sts 0x7A, r16
wait_adc:
    lds r16, 0x7A
    sbrc r16, 6         ; Tunggu konversi selesai
    rjmp wait_adc
    lds r17, 0x79       ; Ambil ADCH
    ldi r18, 255
    sub r18, r17        ; Invert nilai
    sts 0xB3, r18       ; Update LED (OCR2A)

    ; Logika 1 Detik
    lds r16, 0x36       ; TIFR1
    sbrs r16, 1         ; Cek OCF1A
    rjmp cek_buzzer
    
    ldi r16, 0x02
    sts 0x36, r16       ; Mengosongkan bendera timer

    ; Tidak menghitung kalau alarm nyala
    lds r16, alarm_status
    tst r16
    brne cek_buzzer 

    ; Menentukan Target Fase
    lds r17, fase
    cpi r17, 1
    breq target_rest
    ldi r23, 25         ; Target 25 detik
    rjmp proses_hitungan
target_rest:
    ldi r23, 5          ; Target 5 detik

proses_hitungan:
    lds r16, detik_skrg
    
    cp r16, r23
    brsh set_alarm

    mov r18, r23
    sub r18, r16        ; Menghitung sisa waktu
    rcall print_val     ; Mencetak sisa waktu

    inc r16
    sts detik_skrg, r16
    rjmp cek_buzzer

set_alarm:
    ldi r16, 1
    sts alarm_status, r16

cek_buzzer:
    lds r16, alarm_status
    tst r16
    breq silent
    rcall pattern_chill
    rjmp loop

silent:
    cbi 0x05, 5         ; Mematikan PORTB5 (Buzzer)
    rjmp loop


; ISR & SUBROUTINES
__vector_1:             ; Fungsi Interupsi Tombol (INT0)
    push r16
    in r16, 0x3F        ; Simpan SREG
    push r16

    ; Mematikan Alarm & Nolkan Detik
    ldi r16, 0
    sts alarm_status, r16
    sts detik_skrg, r16
    
    ; Toggle Fase (Pindah 0 <-> 1)
    lds r16, fase
    cpi r16, 0
    breq ke_1
    ldi r16, 0
    rjmp simpan_f
ke_1:
    ldi r16, 1
simpan_f:
    sts fase, r16

    pop r16
    out 0x3F, r16       ; Kembalikan SREG
    pop r16
    reti

pattern_chill:
    ldi r19, 3
bp_loop:
    lds r16, alarm_status
    tst r16
    breq bp_exit
    sbi 0x05, 5         ; Buzzer ON
    rcall delay_50ms
    cbi 0x05, 5         ; Buzzer OFF
    rcall delay_50ms
    dec r19
    brne bp_loop
    rcall delay_1s
bp_exit:
    ret

print_val:
    push r16
    push r24
    mov r26, r18
    ldi r24, '0'
d10: cpi r26, 10
    brlo p_ok
    subi r26, 10
    inc r24
    rjmp d10
p_ok:
    rcall tx_char
    mov r24, r26
    subi r24, -'0'
    rcall tx_char
    ldi r24, '\r'
    rcall tx_char
    ldi r24, '\n'
    rcall tx_char
    pop r24
    pop r16
    ret

tx_char:
    lds r25, 0xC0       ; UCSR0A
    sbrs r25, 5         ; Tunggu UDRE0
    rjmp tx_char
    sts 0xC6, r24       ; UDR0
    ret

delay_1s:
    push r24
    ldi r24, 60
la: ldi r25, 255
lb: lds r16, alarm_status
    tst r16
    breq ld_exit        ; Keluar kalau alarm dimatikan
    dec r25
    brne lb
    dec r24
    brne la
ld_exit:
    pop r24
    ret

delay_50ms:
    push r24
    push r25
    push r26
    ldi r24, 4
d1: ldi r25, 255
d2: ldi r26, 255
d3: dec r26
    brne d3
    dec r25
    brne d2
    dec r24
    brne d1
    pop r26
    pop r25
    pop r24
    ret

