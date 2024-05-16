/*toggles an LED connected to digital pin 7 on the arduino(PD7)
every time a LOW to HIGH pulse is sent to the digital pin 3(PD3)*/

#include <avr/io.h>
#include <avr/interrupt.h>

#define LED_PIN 7
#define INT1_PIN 3

int main(void){
	
	DDRD |= (1 << LED_PIN);
	
	PORTD |= (1 << INT1_PIN);//activate pull up
	
	EICRA = 0xc;
	EIMSK |= (1 << INT1);
	sei();	
	
	//simulate the CPU doing something else
	while(1)
		;
	
	return 0;
}

ISR(INT1_vect){
	
	PORTD ^= (1 << LED_PIN);
}
