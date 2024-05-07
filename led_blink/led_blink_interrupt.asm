;blinks an LED but uses interrupts instead of polling

.include "m328Pdef.inc" ; include file for the ATMega328p chip

.ORG 0X000
jmp MAIN;skip interrupt vector table

.ORG 0x001A
jmp T1_OV_ISR;redirect to ISR


MAIN:
sbi DDRD,2

ldi r16,(1 << TOIE1)
sts TIMSK1,r16
sei;global interrupt enable 

ldi r17,HIGH(65536-31250)
sts TCNT1H,r17
ldi r18,LOW(65536-31250)
sts TCNT1L,r18

ldi r19,0x00
sts TCCR1A,r19
ldi r20,0x04;normal mode,pre-scaler of 256
sts TCCR1B,r20

HERE:
rjmp HERE;simulate the CPU doing something else

T1_OV_ISR:
in r16,PORTD
ldi r17,0x04
eor r16,r17
out PORTD,r16

ldi r17,HIGH(65536-31250)
sts TCNT1H,r17
ldi r18,LOW(65536-31250)
sts TCNT1L,r18
reti
