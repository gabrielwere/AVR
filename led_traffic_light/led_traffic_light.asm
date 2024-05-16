.include "m328Pdef.inc" ; include file for the ATMega328p chip

.equ LED_1 = 2
.equ LED_2 = 3
.equ LED_3 = 4

ldi r16,((1 << LED_1) | (1 << LED_2) | (1 << LED_3))
out DDRD,r16

REPEAT:
ldi r29,(1 << LED_1)
out PORTD,r29
call DELAY_3S

ldi r30,(1 << LED_2)
out PORTD,r30
call DELAY_2S

ldi r31,(1 << LED_3)
out PORTD,r31
call DELAY_1S
rjmp REPEAT

;delay of ~ 3s
DELAY_3S:
ldi r16,HIGH(65536-46875)
sts TCNT1H,r16
ldi r17,LOW(65536-46875)
sts TCNT1L,r17
ldi r18,0x00
sts TCCR1A,r18
ldi r19,0x05;pre-scaler of 1024,normal mode
sts TCCR1B,r19

AGAIN_0:
sbis TIFR1,TOV1
rjmp AGAIN_0
ldi r20,0x00
sts TCCR1B,r20
sts TCCR1A,r20
sbi TIFR1,TOV1
ret

;delay of ~2s
DELAY_2S:
ldi r16,HIGH(65536-31250)
sts TCNT1H,r16
ldi r17,LOW(65536-31250)
sts TCNT1L,r17
ldi r18,0x00
sts TCCR1A,r18
ldi r19,0x05
sts TCCR1B,r19;pre-scaler of 1024,normal mode

AGAIN_1:
sbis TIFR1,TOV1
rjmp AGAIN_1
ldi r20,0x00
sts TCCR1B,r20
sts TCCR1A,r20
sbi TIFR1,TOV1
ret

;delay of ~1s
DELAY_1S:
ldi r16,HIGH(65536-62500)
sts TCNT1H,r16
ldi r17,LOW(65536-62500)
sts TCNT1L,r17
ldi r18,0x00
sts TCCR1A,r18
ldi r19,0x04
sts TCCR1B,r19;pre-scaler of 256,normal mode

AGAIN_2:
sbis TIFR1,TOV1
rjmp AGAIN_1
ldi r20,0x00
sts TCCR1B,r20
sts TCCR1A,r20
sbi TIFR1,TOV1
ret
