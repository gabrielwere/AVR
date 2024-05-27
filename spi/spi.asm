;sends the character 'X' via SPI to an SPI device
.include "m328Pdef.inc"

.equ MOSI = 3
.equ SS = 2
.equ SCK = 5
.equ DATA = 'X'


;set MOSI,SS and SCK pin to outputs
ldi r16,((1 << MOSI) | (1 << SS) | (1 << SCK))
out DDRB,r16

;enable spi,master mode,fosc/16
ldi r17,((1 << SPE) | (1 << MSTR) | (1 << SPR0))
out SPCR,r17

;pull SS pin low
cbi PORTB,SS

;start transmission
ldi r18,DATA
out SPDR,r18

POLL_TRANSMISSION:
in r19,SPSR
sbrs r19,SPIF
rjmp POLL_TRANSMISSION

;set SS pin high to end communication
sbi PORTD,SS

;stay here after transmission
HERE:
rjmp HERE
