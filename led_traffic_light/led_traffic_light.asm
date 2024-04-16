sbi DDRD,2
sbi DDRD,3
sbi DDRD,4

REPEAT:
sbi PORTD,2
call DELAY_3S
cbi PORTD,2

sbi PORTD,3
call DELAY_2S
cbi PORTD,3

sbi PORTD,4
call DELAY_1S
cbi PORTD,4
rjmp REPEAT

;create a delay of ~1s
DELAY_1S:
ldi r16,30

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

;create a delay of ~2s
DELAY_2S:
ldi r16,45

L4:
ldi r17,255

L5:
ldi r18,255

L6:
nop
nop
dec r18
brne L6

dec r17
brne L5

dec r16
brne L4
ret

;create a delay of ~3s
DELAY_3S:
ldi r16,65

L7:
ldi r17,255

L8:
ldi r18,255

L9:
nop
nop
dec r18
brne L9

dec r17
brne L8

dec r16
brne L7
ret
