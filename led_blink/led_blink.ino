//Blinks an led with a delay of 1s

void setup() {

  pinMode(2,OUTPUT);
  
}

void loop() {

  digitalWrite(2,HIGH);
  delay(1000);
  digitalWrite(2,LOW);
  delay(1000);
 
}
