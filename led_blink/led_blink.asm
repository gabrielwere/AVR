sbi DDRD,2

REPEAT:
sbi PORTD,2
call DELAY
cbi PORTD,2
call DELAY
rjmp REPEAT


;create a delay of ~1sec
DELAY:
ldi r16,50

L1:
ldi r17,255

L2:
ldi r18,255

L3:
nop
nop
dec r18
brne L3

dec r17
brne L2

dec r16
brne L1

ret
