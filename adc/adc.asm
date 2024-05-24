;converts voltage connected to pin A0(PORTC 0) on the arduino to a digital signal
;writes out the lower 8 bits to PORTD and the upper 2 bits to PORTB
.include "m328Pdef.inc"

cbi DDRC,0

ldi r16,0xff
out DDRB,r16
out DDRD,r16

;enable ADC,set a prescaler value of 128 which gives us a 125kHz frequency(50 - 200kHz recommended)
ldi r17,0x87
sts ADCSRA,r17

;use AVCC and select ADC0 for use
ldi r18,0x40
sts ADMUX,r17

;start conversion
lds r19,ADCSRA
ori r19,(1 << ADSC)
sts ADCSRA,r19

POLL_CONVERSION:
lds r20,ADCSRA
sbrs r20,ADIF
rjmp POLL_CONVERSION

;turn off ADIF flag
lds r21,ADCSRA
ori r21,(1 << ADIF)
sts ADCSRA,r21

;write data to PORTD AND PORTB
lds r22,ADCL
out PORTD,r22
lds r23,ADCH
out PORTB,r23 

