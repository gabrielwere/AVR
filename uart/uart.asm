;send the word 'HELLO' to a device via uart repeatedly
.include "m328Pdef.inc"

.equ LETTER_1 = 'H'
.equ LETTER_2 = 'E'
.equ LETTER_3 = 'L'
.equ LETTER_4 = 'L'
.equ LETTER_5 = 'O'

;enable transmitter mode
ldi r16,(1 << TXEN0)
sts UCSR0B,r16

;uart mode of operation,no parity bit,one stop bit,8 bit character size
ldi r17,((1 << UCSZ00) | (1 << UCSZ01))
sts UCSR0C,r17

;set a baud rate of 9600
ldi r18,103
sts UBRR0L,r18

SEND_DATA:
ldi r19,LETTER_1
call TRANSMIT

ldi r19,LETTER_2
call TRANSMIT

ldi r19,LETTER_3
call TRANSMIT

ldi r19,LETTER_4
call TRANSMIT

ldi r19,LETTER_5
call TRANSMIT

;transmit repeatedly
rjmp SEND_DATA

;transmit function
;expects to find data to be sent in r19
TRANSMIT:
;check if transmitter data buffer register is empty
lds r30,UCSR0A
sbrs r30,UDRE0
rjmp TRANSMIT
sts UDR0,r19
ret
