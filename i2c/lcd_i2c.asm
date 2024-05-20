;prints 'Hello' on the first line of a 16x2 LCD
;moves the cursor to the second line then prints 'World'
.include "m328Pdef.inc"

;pin mapping TWI interface
.equ PIN_RS = 0x01  ;register select
.equ PIN_RW = 0x02  ;read-write 
.equ PIN_EN = 0x04  ;enable
.equ PIN_P3 = 0x08  ;backlight
.equ PIN_DB4 = 0x10 ;data bit
.equ PIN_DB5 = 0x20 ;data bit
.equ PIN_DB6 = 0x40 ;data bit
.equ PIN_DB7 = 0x80 ;data bit

.equ LETTER_1 = 'H'
.equ LETTER_2 = 'e'
.equ LETTER_3 = 'l'
.equ LETTER_4 = 'l'
.equ LETTER_5 = 'o'
.equ LETTER_6 = 'W'
.equ LETTER_7 = 'o'
.equ LETTER_8 = 'r'
.equ LETTER_9 = 'l'
.equ LETTER_10 = 'd'
.equ LETTER_11 = '!'


call BOOT_DELAY

call TWI_INIT
call TWI_START

;send address of the slave device + R/W bit
;in this case the address is 0x27(39) and we want to write to the LCD
;so SLA + W = 0x27 + 0
ldi r25,0b01001110
call TWI_SEND

;we should initialse the LCD to operate in 4 bit mode
;we does this be sending 0x30,0x30,0x30,0x20 and 0x28
;with appropriate intervals as per the HD44780 LCD datasheet
ldi r16,0x30
call LCD_SEND_4_BITS
call DELAY_6ms

ldi r16,0x30
call LCD_SEND_4_BITS
call DELAY_200us

ldi r16,0x30
call LCD_SEND_4_BITS
call DELAY_200us

ldi r16,0x20
call LCD_SEND_4_BITS
call DELAY_200us

ldi r16,0x28
call LCD_SEND_8_BITS
call DELAY_200us

ldi r16,0x01
call LCD_SEND_8_BITS
call DELAY_200us

ldi r16,0x02
call LCD_SEND_8_BITS


ldi r16,0x0e
call LCD_SEND_8_BITS

;print hello
ldi r16,LETTER_1
call LCD_SEND_DATA

ldi r16,LETTER_2
call LCD_SEND_DATA

ldi r16,LETTER_3
call LCD_SEND_DATA

ldi r16,LETTER_4
call LCD_SEND_DATA

ldi r16,LETTER_5
call LCD_SEND_DATA

ldi r16,0xc0;send cursor to beginning to next line
call LCD_SEND_8_BITS

;print world
ldi r16,LETTER_6
call LCD_SEND_DATA

ldi r16,LETTER_7
call LCD_SEND_DATA

ldi r16,LETTER_8
call LCD_SEND_DATA

ldi r16,LETTER_9
call LCD_SEND_DATA

ldi r16,LETTER_10
call LCD_SEND_DATA

ldi r16,LETTER_11
call LCD_SEND_DATA



call TWI_STOP

;stay here when communication is done
HERE:
rjmp HERE


;;;;;;;
;LCD FUNCTIONS
;;;;;;;

;function to send a 4 bit command to the LCD
;sends the upper nibble 
;expects to find data to be sent in r16
LCD_SEND_4_BITS:
mov r17,r16
andi r17,0xf0
mov r25,r17
call TWI_SEND
mov r20,r17
ldi r31,0x00
call LCD_PULSE
ret

;function to send an 8 bit command to the LCD
;sends the upper nibble then the lower nibble
;expects to find data to be sent in r16
LCD_SEND_8_BITS:
mov r17,r16
andi r17,0xf0
mov r25,r17
call TWI_SEND;send the upper nibble
mov r20,r17
ldi r31,0x00
call LCD_PULSE

swap r16
mov r17,r16
andi r17,0xf0
mov r25,r17
call TWI_SEND;send the lower nibble
mov r20,r17
ldi r31,0x00
call LCD_PULSE
ret

;function to send 8 bit data
;set the Register select pin to enable sending of data
;also set the backlight pin
;expects to find the data to be sent in r16
LCD_SEND_DATA:
mov r17,r16
andi r17,0xf0
ori r17,(PIN_RS | PIN_P3)
mov r25,r17
call TWI_SEND;send the upper nibble
mov r20,r17
ldi r31,(PIN_RS | PIN_P3)
call LCD_PULSE

swap r16
mov r17,r16
andi r17,0xf0
ori r17,(PIN_RS | PIN_P3)
mov r25,r17
call TWI_SEND;send the lower nibble
mov r20,r17
ldi r31,(PIN_RS | PIN_P3)
call LCD_PULSE
ret

;function send a high to low to the enable pin
;this allows the data to latch onto the data pins
;expects to find the data to be sent in r20
;expects to find status of RS pin and Backlight in r31
LCD_PULSE:
mov r21,r20
ori r21,PIN_EN
or r21,r31
mov r25,r21
call TWI_SEND
call DATA_LATCH_DELAY

mov r21,r20
andi r21,0xf0
or r21,r31
mov r25,r21
call TWI_SEND
call DATA_LATCH_DELAY
ret

;;;;;;;
;TWI FUNCTIONS
;;;;;;;

;INIT FUNCTION
TWI_INIT:
ldi r25,72;gives us a clock frequency of 100kHz
sts TWBR,r25
ldi r26,0x00
sts TWSR,r26
ldi r27,(1 << TWEN)
sts TWCR,r27
ret

;SEND START CONDITION
TWI_START:
ldi r25,((1 << TWINT) | (1 << TWSTA) | (1 << TWEN))
sts TWCR,r25

CHECK:
lds r26,TWCR
sbrs r26,TWINT
rjmp CHECK
ret

;SEND TWI DATA
;expects to find data to be sent in r25
TWI_SEND:
sts TWDR,r25
ldi r26,((1 << TWINT) | ( 1 << TWEN))
sts TWCR,r26

CHECK_2:
lds r27,TWCR
sbrs r27,TWINT
rjmp CHECK_2
ret

;SEND TWI STOP CONDITION
TWI_STOP:
ldi r25,((1 << TWSTO) | (1 << TWEN) | (1 << TWINT))
sts TWCR,r25
ret


;;;;;;;
;DELAY FUNCTIONS
;;;;;;;

;delay to enable data to latch onto the pins
;should be greater than 450ns
;this function give us about 0.125us
DATA_LATCH_DELAY:
nop
nop
ret

;allows for the lcd to boot
;should be greater than 15ms
;this function gives us about 17ms;
BOOT_DELAY:
ldi r25,HIGH(65536-4250)
sts TCNT1H,r25
ldi r26,LOW(65536-4250)
sts TCNT1L,r26
ldi r27,0x00
sts TCCR1A,r27
ldi r27,0x03
sts TCCR1B,r27

CHECK_3:
sbis TIFR1,TOV1
rjmp CHECK_3
ldi r28,0x00
sts TCCR1A,r28
sts TCCR1B,r28
sbi TIFR1,TOV1
ret

;delay of 6 milliseconds
DELAY_6ms:
ldi r25,(256 - 94)
out TCNT0,r25
ldi r26,0x05
out TCCR0B,r26

CHECK_4:
sbis TIFR0,TOV0
rjmp CHECK_4
ldi r27,0x00
out TCCR0B,r27
sbi TIFR0,TOV0
ret

;delay of 200 microseconds
DELAY_200us:
ldi r25,(256 - 50)
out TCNT0,r25
ldi r26,0x03
out TCCR0B,r26

CHECK_5:
sbis TIFR0,TOV0
rjmp CHECK_5
ldi r27,0x00
out TCCR0B,r27
sbi TIFR0,TOV0
ret
