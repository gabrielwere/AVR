/*prints 'Hello' on the first line of a 16x2 LCD
moves the cursor to the second line then prints 'World'*/
#define F_CPU 16000000UL


#include <avr/io.h>
#include <util/delay.h>

 #define PIN_RS 0x01
 #define PIN_RW 0x02
 #define PIN_EN 0x04
 #define PIN_P3 0x08
 #define PIN_DB4 0x10
 #define PIN_DB5 0x20
 #define PIN_DB6 0x40
 #define PIN_DB7 0x80

 #define SEND_DATA 1
 #define SEND_COMMAND 0

 #define LCD_ADDRESS 0x27

void TWI_INIT(void);
void TWI_START(void);
void TWI_SEND(unsigned char data);
void TWI_STOP(void);
void send_4_bit_command(unsigned char data);
void send_8_bit_command(unsigned char data);
void send_8_bit_data(unsigned char data);
void lcd_pulse(unsigned char data,int status);

int main(void){

	//boot delay
	//should be greater than 15ms
	_delay_ms(17);
	TWI_INIT();
	TWI_START();

	//SLA + W
	TWI_SEND(LCD_ADDRESS << 1);


	send_4_bit_command(0x30);
	//should be greater than 4.1ms
	_delay_ms(6);

	send_4_bit_command(0x30);
	//should be greater than 100us
	_delay_us(120);

	send_4_bit_command(0x30);
	_delay_us(120);

	send_4_bit_command(0x20);
	_delay_us(120);

	send_8_bit_command(0x28);
	_delay_us(120);

	//clear screen command
	send_8_bit_command(0x01);
	_delay_us(120);

	//cursor home command
	send_8_bit_command(0x02);

	//display on,cursor off
	send_8_bit_command(0x0e);

	unsigned char str1[] = "Hello";
	unsigned char str2[] = "World!";

	unsigned char i = 0;
	unsigned char j = 0;

	while(str1[i] != '\0'){
		send_8_bit_data(str1[i]);
		i++;
	}

	//force cursor to beginning of second row
	send_8_bit_command(0xc0);

	while(str2[j] != '\0'){
		send_8_bit_data(str2[j]);
		j++;
	}


	TWI_STOP();
	return 0;
}

//TWI functions
void TWI_INIT(void){

	TWSR = 0x00;
	TWBR = 72;//gives us a clock frequency of 100kHz
	TWCR = (1 << TWEN);
}

void TWI_START(void){
	TWCR = ((1 << TWINT) | (1 << TWEN) | (1 << TWSTA));

	while(!(TWCR & (1 << TWINT)))
		;
}

void TWI_SEND(unsigned char data){

	TWDR = data;
	TWCR = ((1 << TWINT) | (1 << TWEN));

	while(!(TWCR & (1 << TWINT)))
		;
}

void TWI_STOP(void){
	TWCR = ((1 << TWEN) | (1 << TWSTO));
}

//LCD functions

//send upper nibble of the command
void send_4_bit_command(unsigned char data){

	data &= 0xf0;
	TWI_SEND(data);
	lcd_pulse(data,SEND_COMMAND);
}

void send_8_bit_command(unsigned char data){

	unsigned char upper_nibble = (data & 0xf0);
	unsigned char lower_nibble = (data << 4) & 0xf0;

	TWI_SEND(upper_nibble);
	lcd_pulse(upper_nibble,SEND_COMMAND);

	TWI_SEND(lower_nibble);
	lcd_pulse(lower_nibble,SEND_COMMAND);
}

void send_8_bit_data(unsigned char data){

	unsigned char upper_nibble = (data & 0xf0);
	unsigned char lower_nibble = (data << 4) & 0xf0;

	TWI_SEND(upper_nibble | (PIN_RS | PIN_P3));
	lcd_pulse(upper_nibble,SEND_DATA);

	TWI_SEND(lower_nibble | (PIN_RS | PIN_P3));
	lcd_pulse(lower_nibble,SEND_DATA);
}

//turn enable pin high to low,with a delay > 450ns in between
void lcd_pulse(unsigned char data,int status){

	//if sending a command do not turn on RS pin
	if(status == SEND_COMMAND){

		TWI_SEND(data | PIN_EN);
		_delay_us(0.5);

		//make sure enable pin,rs pin and r/w pin are off because we are sending a command
		data &= ~(PIN_EN | PIN_RS | PIN_RW);
		TWI_SEND(data);
		_delay_us(0.5);

	}else if(status == SEND_DATA){

		TWI_SEND(data | (PIN_EN | PIN_RS | PIN_P3));
		_delay_ms(0.5);

		//turn off enable and r/w pin
		data &= ~(PIN_EN | PIN_RW);
		//turn on rs pin because we are sending data
		data |= (PIN_RS | PIN_P3);
		TWI_SEND(data);
		_delay_ms(0.5);

	}
}
