
//sends the character 'X' via SPI to an SPI device

#include <avr/io.h>

#define MOSI 3
#define SCK 5
#define DATA 'X'

int main(void){
	
	DDRB |= (( 1< MOSI) | (1 << SCK));
	
	SPCR |= ((1 << SPE) | (1 << MSTR) | (1 << SPR0));
	
	SPDR = DATA;
	
	while(!(SPSR & (1 << SPIF)))
		;
	
	return 0;
}
