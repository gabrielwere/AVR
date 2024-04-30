#define F_CPU 8000000UL

#include <avr/io.h>
#include <util/delay.h>

#define LED_1 2
#define LED_2 3
#define LED_3 4

int main(void){
	
	DDRD |= ((1 << LED_1) | (1 << LED_2) | (1 << LED_3));
	
	while(1){
		PORTD = 1 << LED_1;
		_delay_ms(3000);
		PORTD = 1 << LED_2;
		_delay_ms(2000);
		PORTD = 1 << LED_3;
		_delay_ms(1000);
	}
	
	
	
	return 0;
}
