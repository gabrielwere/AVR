.include "m328Pdef.inc" ; include file for the ATMega328p chip

sbi DDRD,2

REPEAT:
sbi PORTD,2
call DELAY
cbi PORTD,2
call DELAY
rjmp REPEAT

;create a delay of ~ 1 sec
DELAY:
ldi r16,HIGH(65536-62500); or could be 0x85
sts TCNT1H,r16
ldi r17,LOW(65536-62500);or could be 0xee
sts TCNT1L,r17
ldi r18,0x00
sts TCCR1A,r18
ldi r19,0x04
sts TCCR1B,r19;pre-scaler of 256,normal mode

AGAIN:
sbis TIFR1,TOV1
rjmp AGAIN
ldi r20,0x00
sts TCCR1B,r20
sts TCCR1A,r20
sbi TIFR1,TOV1
ret
