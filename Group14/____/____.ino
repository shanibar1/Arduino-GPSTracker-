#include <Servo.h>

#define servoPin 4
Servo servo;
int angle = 0;
int speed = 0; // Added missing semicolon
bool Direction = true;

void setup() {
  servo.attach(servoPin);
}

void loop() {
  if (Direction) {
    angle += 1;
    speed = 180;
  } else {
    angle -= 1;
    speed = 0; // Corrected variable name from Speed to speed
  }

  servo.write(angle); // Corrected to write angle instead of speed
  delay(15);

  if (angle == 180)
    Direction = false;
  if (angle == 0)
    Direction = true;
}
