
//=======================BPM
float average = 0.0;
unsigned char BPM_atas;
unsigned char BPM_bawah = 60;
int normal;

//Variables used to measure heart rate
unsigned long oldtime = 0;
unsigned long newtime = 0;
int beat_time = 0;
float BPM_new = 0.0;
float BPM_old = 0.0;
boolean new_beat = 0;
int high_value = 400;
float BPM = 0.0;
int num1_old = 10;
int num2_old = 10;
int num3_old = 10;
int num1_new = 0;
int num2_new = 0;
int num3_new = 0;
int send1 = 10;
int send2 = 10;
int send3 = 10;

#include "Ublox.h"

//KELAS ALIAS
Ublox M8_Gps;
float gpsArray[6] = {0, 0, 0, 0, 0};


#include <SoftwareSerial.h>


String inputString = "";         // a string to hold incoming data
boolean stringComplete = false;  // whether the string is complete

unsigned long previousMillis = 0;        // will store last time LED was updated

//=======================================VARIABEL SETTING
const long interval = 5000;
#define PTT 2

//SoftwareSerial mySerial(RX,TX);
SoftwareSerial mySerial(9, 10); //GPS

//======================================
void setup()
{
  pinMode(PTT, OUTPUT);
  Serial.begin(600);
  mySerial.begin(9600);

  Serial.print("#_99");
  Serial.println("");
}
char inChar;
bool flag_kirim = true;

unsigned char jam, menit, detik;
String inputString1 = "";
void loop()
{
  baca_serial_markas();
  //=============================KIRIM RUTIN
  if (flag_kirim == true)
  {
    unsigned long currentMillis = millis();
    if (currentMillis - previousMillis >= interval)
    {
      previousMillis = currentMillis;
      kirim_data();
    }
  }
  baca_gps_rtc();
  baca_ad();
}

void kirim_data()
{
  PTT_ON();
  Serial.print("#_01_");
  Serial.print(gpsArray[0], 6); Serial.print("_");  //LAT
  Serial.print(gpsArray[1], 6); Serial.print("_");  //LONG
  Serial.print(gpsArray[2], 0); Serial.print("_");  //SAT

  //      Serial.print(jam); Serial.print("_");
  //      Serial.print(menit); Serial.print("_");
  //      Serial.print(detik); Serial.print("_");

  // 0 = NORMAL
  // 1 = TIDAK NORMAL

//  Serial.print(BPM_bawah); Serial.print("_");
//  Serial.print(BPM_atas); Serial.print("_");
  //Serial.print(BPM,0); Serial.print("_");
  Serial.print(normal); Serial.print("_");
  Serial.println("");
  PTT_OFF();
}
void baca_serial_markas()
{
  if (stringComplete)
  {
    if (inChar == 'C')
    {
      flag_kirim = true;
    }
    else if (inChar == 'D')
    {
      flag_kirim = false;
    }
  }
  stringComplete = false;
  inChar = '0';
}


float lat_sekarang, long_sekarang;
void baca_gps_rtc()
{
  if (!mySerial.available())
    return;

  while (mySerial.available())
  {
    char c = mySerial.read();
    if (M8_Gps.encode(c)) //TRUE
    {
      //gpsArray[0] = M8_Gps.altitude;
      //==========================MENYIMPAN LAT_LONG TERAKHIR JIKA GPS TIBA2 MATI
      lat_sekarang = M8_Gps.latitude;
      if (lat_sekarang != 0 )
        gpsArray[0] = lat_sekarang;

      long_sekarang = M8_Gps.longitude;
      if (long_sekarang != 0 )
        gpsArray[1] = long_sekarang; // 95-141

      gpsArray[2] = M8_Gps.sats_in_use;

      //===========================RTC GPS
      inputString1 = M8_Gps.inputString;
    }
  }

  //================PENENTUAN WAKTU BERDASARKAN LONGITUDE
  jam = (inputString1[0] - 48) * 10 + inputString1[1] - 48;
  //if (gpsArray[1] >= 95 && gpsArray[1] <= 110 )
  if (gpsArray[1] <= 110 ) // DEFAULT WIB
    jam += 7;
  else if (gpsArray[1] >= 111 && gpsArray[1] <= 125 )
    jam += 8;
  else if (gpsArray[1] >= 126 && gpsArray[1] <= 141 )
    jam += 9;
  menit = (inputString1[2] - 48) * 10 + inputString1[3] - 48;
  detik = (inputString1[3] - 48) * 10 + inputString1[4] - 48;

  //==================PENENTUAN BPM
  if (jam > 6 && jam < 22)
  {
    BPM_atas = 100;
  }
  else // jam 22 - 6
  {
    BPM_atas = 80;
  }
}
//=======================================SERIAL EVENT MARKAS
void serialEvent()
{
  while (Serial.available())
  {
    inChar = (char)Serial.read();
    stringComplete = true;
  }
}

void PTT_ON()
{
  digitalWrite(PTT, HIGH);
  delay(1000);
}

void PTT_OFF()
{
  delay(1500);
  digitalWrite(PTT, LOW);

}
