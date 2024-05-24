/*converts voltage connected to pin A0(PORTC 0) on the arduino to a digital signal
writes out the lower 8 bits to PORTD and the upper 2 bits to PORTB*/

#include <avr/io.h>

#define ADC_PIN 0

int main(void){
	
	
	DDRC &= ~(1 << ADC_PIN);
	
	DDRD = 0xff;
	DDRB = 0xff;
	
	//enable ADC,set a prescaler value of 128 which gives us a 125kHz frequency(50 - 200kHz recommended)
	ADCSRA = 0x87;
	
	//use AVCC and select ADC0 for use
	ADMUX = 0x40;
	
	//start conversion
	ADCSRA |= (1 << ADSC);
	
	//poll conversion
	while(!(ADCSRA & (1 << ADIF)))
		;
	
	PORTD = ADCL;
	PORTB = ADCH;

	return 0;
}
