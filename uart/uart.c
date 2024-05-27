//send the word 'HELLO' to a device via uart repeatedly

#include <avr/io.h>

void uart_init(void);
void uart_transmit(unsigned char data);

int main(void){
	
	uart_init();
	
	unsigned char data[]="HELLO";
	unsigned char i = 0;
	
	while(1){
		while(data[i] != '\0'){
			uart_transmit(data[i]);
			i++;
		}
		i = 0;
	}
	return 0;
}

void uart_init(void){
	
	//transmitter mode
	UCSR0B = (1 << TXEN0);
	
	//uart mode,no parity mode,one stop bit,8 bit data size
	UCSR0C = ((1 << UCSZ00) | (1 << UCSZ01));
	
	//baud rate of 9600
	UBRR0L = 103;
}

void uart_transmit(unsigned char data){
	
	//check if transmitter data buffer register is empty
	while(!(UCSR0A & (1 << UDRE0)))
		;
		
	UDR0 = data;
}

