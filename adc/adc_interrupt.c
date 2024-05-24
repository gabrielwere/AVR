/*converts voltage connected to pin A0(PORTC 0) on the arduino to a digital signal
writes out the lower 8 bits to PORTD and the upper 2 bits to PORTB(using interrupts)*/

#include <avr/io.h>
#include <avr/interrupt.h>

#define ADC_PIN 0

ISR(ADC_vect){
	
	PORTD = ADCL;
	PORTB = ADCH;
	
}
int main(void){
	
	DDRC &= ~(1 << ADC_PIN);
	
	DDRD = 0xff;
	DDRB = 0xff;
	
	//enable ADC,enable ADC interrupt
	//set a prescaler value of 128 which gives us a 125kHz frequency(50 - 200kHz recommended)
	ADCSRA = 0x8f;
	
	//global interrupt enable
	sei();
	
	//use AVCC and set ADC0
	ADMUX = 0x40;
	
	//start conversion
	ADCSRA |= (1 << ADSC);
	
	//simulate the CPU doing something else
	while(1)
		;
	return 0;
}
