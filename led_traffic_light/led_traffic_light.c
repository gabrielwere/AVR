#define F_CPU 8000000UL

#include <avr/io.h>
#include <util/delay.h>

int main(void){
	
	DDRD |= 0b00011100;
	
	while(1){
		PORTD = 1 << 2;
		_delay_ms(3000);
		PORTD = 1 << 3;
		_delay_ms(2000);
		PORTD = 1 << 4;
		_delay_ms(1000);
	}
	
	
	
	return 0;
}
