;converts voltage connected to pin A0(PORTC 0) on the arduino to a digital signal
;writes out the lower 8 bits to PORTD and the upper 2 bits to PORTB(using interrupts)
.include "m328Pdef.inc"

;jump away from interrupt vector table
.org 0x0000
jmp MAIN

;jump to adc complete isr
.org 0x002A
jmp ADC_COMPLETE_ISR

.org 0x100
MAIN:

cbi DDRC,0

ldi r16,0xff
out DDRD,r16
out DDRB,r16

;enable ADC,turn on ADC interrupts
;set a prescaler value of 128 which gives us a 125kHz frequency(50 - 200kHz recommended)
ldi r17,0x8f
sts ADCSRA,r17

;global interrupt enable
sei

;use AVCC and select ADC0 for use
ldi r18,0x40
sts ADMUX,r18

;start conversion
lds r19,ADCSRA
ori r19,(1 << ADSC)
sts ADCSRA,r19

;simulate the CPU doing something else
HERE:
rjmp HERE


ADC_COMPLETE_ISR:
lds r20,ADCL
out PORTD,r20
lds r21,ADCH
out PORTB,r21
reti
