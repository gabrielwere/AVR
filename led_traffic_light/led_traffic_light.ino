//Traffic lights simulator that blinks 3 LEDs each with a different delay time
//An RGB LED can also be used instead of 3 separate LEDs

int red_pin = 2;
int yellow_pin = 3;
int green_pin = 4;

void setup() {
  pinMode(red_pin,OUTPUT);
  pinMode(green_pin,OUTPUT);
  pinMode(yellow_pin,OUTPUT);

}

void loop() {

  //red LED will stay on for 3 seconds
  digitalWrite(red_pin,HIGH);
  delay(3000);
  digitalWrite(red_pin,LOW);

  //yellow LED will stay on for 2 seconds
  digitalWrite(yellow_pin,HIGH);
  delay(2000);
  digitalWrite(yellow_pin,LOW);

  //green LED will stay on for 1 second
  digitalWrite(green_pin,HIGH);
  delay(1000);
  digitalWrite(green_pin,LOW);  
}

