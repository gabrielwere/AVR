/*toggles an LED connected to digital pin 7 on the arduino(PD7)
every time a LOW to HIGH pulse is sent to the digital pin 2(PD2)*/

#include <avr/io.h>
#include <avr/interrupt.h>

#define LED_PIN 7
#define INT0_PIN 2

int main(void){

	DDRD |= (1 << LED_PIN);
	
	PORTD |= (1 << INT0_PIN);//activate pull up
	
	EICRA = 0x02;
	EIMSK |= (1 << INT0);
	sei();	
	
	//simulate the CPU doing something else
	while(1)
		;
	
	return 0;
}

ISR(INT0_vect){
	
	PORTD ^= (1 << LED_PIN);
}
