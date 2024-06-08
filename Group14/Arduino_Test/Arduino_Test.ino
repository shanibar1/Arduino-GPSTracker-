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
Servo myServo;
int receiver = 3;
IRrecv IR(receiver);
MFRC522 mfrc522(SS_PIN, RST_PIN); // Declare the MFRC522 object globally
decode_results results;

void setup() {
  Serial.begin(9600);
  SPI.begin();
  myServo.attach(servoPin);
  IR.enableIRIn();
  pinMode(LED_G, OUTPUT);
  pinMode(LED_R, OUTPUT);
  mfrc522.PCD_Init(); // Initialize MFRC522 here
  Serial.println("Put your card to the reader...");
  Serial.println();
  lcd.init();
  lcd.backlight();
}

void handleIRRemote() {
  if (IR.decode(&results)) {
    switch (results.value) {
      case 0xFF30CF: // Replace with your IR remote code for simulating card placement
        lcd.clear();
        lcd.setCursor(0, 0);
        lcd.print("Authorized Access");
        digitalWrite(LED_G, HIGH);
        myServo.write(180); // Rotate in one direction
        delay(3000);        // Wait for 3 seconds
        myServo.write(0);   // Stop rotation
        delay(500);
        myServo.write(90); // Stop servo for denied access
        digitalWrite(LED_G, LOW);
        break;
      // Add more cases for different IR remote codes if needed
    }
    IR.resume();
  }
}

void loop() {
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Hello");
  lcd.setCursor(0,1);
  lcd.print("Place Your card");
  delay(1000);
  lcd.clear();

  // Handle IR remote
  handleIRRemote();

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
    myServo.write(180); // Rotate in one direction
    delay(3000);        // Wait for 3 seconds
    myServo.write(0);   // Stop rotation
    delay(500);
    myServo.write(90); // Stop servo for denied access
    digitalWrite(LED_G, LOW);
  } 
    else { // Entry denied
    Serial.p rintln("Access denied");
    lcd.clear();
    lcd.setCursor(0, 0);
    lcd.print("Access Denied");
    digitalWrite(LED_R, HIGH);
    delay(1000);
    digitalWrite(LED_R, LOW);
    myServo.write(90); // Stop servo for denied access
    delay(500);
  }
}
