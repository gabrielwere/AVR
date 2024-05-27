;sends the character 'X' via SPI to an SPI device

.include "m328Pdef.inc"
.org 0x0000;jump away from interrupt vector table
jmp MAIN

.org 0x0022
jmp SPI_TRANSFER_COMPLETE;jump to ISR

.org 0x100
MAIN:

.equ MOSI = 3
.equ SS = 2
.equ SCK = 5
.equ DATA = 'X'

ldi r16,((1 << MOSI) | (1 << SS) | (1 << SCK))
out DDRB,r16

;enable spi and spi interrupts,master mode,fosc/16
ldi r17,((1 << SPIE) | (1 << SPE) | (1 << MSTR) | (1 << SPR0))
out SPCR,r17

;global interrupt enable
sei

;pull SS pin low
cbi PORTB,SS

;start transfer
ldi r18,DATA
out SPDR,r18

HERE:;simulate the CPU doing something else
rjmp HERE

SPI_TRANSFER_COMPLETE:

;pull SS pin HIGH
sbi PORTB,SS
reti
