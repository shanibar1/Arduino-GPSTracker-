#include <SPI.h>
#include <IRremote.h>
#include <MFRC522.h>
#include <Servo.h>
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2); // Format -> (Address, Width, Height)
#define SS_PIN 10
#define RST_PIN 9
#define LED_G 6 // Green LED pin
#define LED_R 7 // Red LED pin
#define servoPin 4
#define buzzerPin 8 // Connect the buzzer to this pin
Servo myServo;
MFRC522 mfrc522(SS_PIN, RST_PIN); // Declare the MFRC522 object globally

void setup() {
  Serial.begin(9600);
  SPI.begin();
  myServo.attach(servoPin);
  pinMode(LED_G, OUTPUT);
  pinMode(LED_R, OUTPUT);
  pinMode(buzzerPin, OUTPUT); // Set the buzzer pin as OUTPUT
  mfrc522.PCD_Init(); // Initialize MFRC522 here
  Serial.println("Put your card to the reader...");
  Serial.println();
  lcd.init();
  lcd.backlight();
}

void loop() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Hello");
  lcd.setCursor(0, 1);
  lcd.print("Place Your card");
  delay(1000);
  lcd.clear();

  // Look for new cards
  if (!mfrc522.PICC_IsNewCardPresent()) {
    return;
  }

  // Select one of the cards
  if (!mfrc522.PICC_ReadCardSerial()) {
    return;
  }

  // Show UID on the serial monitor
  Serial.print("UID tag: ");
  String content = "";
  for (byte i = 0; i < mfrc522.uid.size; i++) {
    Serial.print(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ");
    Serial.print(mfrc522.uid.uidByte[i], HEX);
    content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
    content.concat(String(mfrc522.uid.uidByte[i], HEX));
  }
  Serial.println();
  Serial.print("Message: ");
  content.toUpperCase();
  
  if (content.substring(1) == "D5 0A 9A 8A") { // Login is approved
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Authorized Access");
    delay(1000);
    lcd.clear();
    Serial.println("Authorized access");
    digitalWrite(LED_G, HIGH);
    myServo.write(180);
    delay(3000);
    myServo.write(0);
    delay(500);
    myServo.write(90);
    digitalWrite(LED_G, LOW);
  } else { // Entry denied
    Serial.println("Access denied");
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Access Denied");
    digitalWrite(LED_R, HIGH);
    digitalWrite(buzzerPin, HIGH); // Activate the buzzer
    delay(1000);
    digitalWrite(buzzerPin, LOW); // Deactivate the buzzer
    digitalWrite(LED_R, LOW);
    myServo.write(90);
    delay(500);
  }
}
