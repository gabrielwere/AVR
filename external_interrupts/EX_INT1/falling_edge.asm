;toggles an LED connected to digital pin 7 on the arduino(PD7)
;every time a HIGH to LOW pulse is sent to the digital pin 3(PD3)

.include "m328Pdef.inc"

.org 0x0000
jmp MAIN;jump away from interrupt vector table

.org 0x0004
jmp EX1_ISR

.org 0x100
MAIN:

sbi DDRD,7

ldi r16,0x08
sts EICRA,r16
ldi r17,(1 << INT1)
out EIMSK,r17
sei

HERE:
rjmp HERE;simulate the CPU doing something else

;ISR for external interrupt request 1
EX1_ISR:
in r16,PORTD
ldi r17,(1 << 7)
eor r16,r17
out PORTD,r16
reti

