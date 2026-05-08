#define __SFR_OFFSET 0x00
#include <avr/io.h>

.global main

main:
    ; inisialisasi Stack Pointer
    ldi r16, hi8(RAMEND)
    out SPH, r16
    ldi r16, lo8(RAMEND)
    out SPL, r16

    ; init I/O
    sbi DDRB, 3 ; PB3 (Pin 11): Output LED (OC2A)
    cbi DDRC, 0 ; PC0 (A0): Input ADC

    ; init PWM (Timer 2)
    ldi r16, (1<<COM2A1) | (1<<WGM21) | (1<<WGM20)
    sts TCCR2A, r16
    ldi r16, (1<<CS21)
    sts TCCR2B, r16

    ; init ADC (A0)
    ldi r16, (1<<REFS0) | (1<<ADLAR)
    sts ADMUX, r16
    ; enable ADC & Prescaler /128
    ldi r16, (1<<ADEN) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0)
    sts ADCSRA, r16

loop:
    ; konversi ADC
    lds r16, ADCSRA
    ori r16, (1<<ADSC) ; konversi
    sts ADCSRA, r16

wait_adc:
    lds r16, ADCSRA
    sbrc r16, ADSC        
    rjmp wait_adc

    ; update brightness LED
    lds r17, ADCH  ; ambil nilai cahaya (8-bit tertinggi)
    
    ; invertion logic: makin gelap (r17 kecil), LED makin terang (OCR besar)
    ldi r18, 255
    sub r18, r17  ; r18 = 255 - r17
    
    sts OCR2A, r18          

    rjmp loop