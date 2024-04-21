#define F_CPU 8000000UL

#include <xc.h>
#include <avr/io.h>
#include <util/delay.h>

int main(void){
	
	DDRD |= 0b00000100;
	
	while(1){
		PORTD |= 0b00000100;
		_delay_ms(1000);
		PORTD &= 0b11111011;
		_delay_ms(1000);
	}
	
	
	
	return 0;
}
