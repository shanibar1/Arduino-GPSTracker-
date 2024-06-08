#define PIN_SINYAL A0

unsigned int average_value[60];
int i = 0;
int no_pulse_counter = 0;
int beat_acquiring_counter = 0; //counter for adjusting screen saver
int change_number_counter = 0;
int heart_counter = 0;


int amount = 1500;
unsigned int a_read = 0;
float sum = 0.0;

long lastDebounceTime = 0;
long debounceDelay = 1500;

boolean no_pulse_latch = 1;
boolean acq_pulse_latch = 0;
boolean beat_pulse_latch = 0;
boolean beat_latch = 0;
byte state = B0;
byte state_new;
byte state_old = B1111;

void setup_ad()
{
  pinMode(12, INPUT); // Setup for leads off detection LO +
  pinMode(11, INPUT); // Setup for leads off detection LO -
  digitalWrite(12, LOW);
  digitalWrite(11, LOW);
}

void baca_ad()
{
  float sum = 0.0;
  //=====================SENSOR LEPAS
//  if ((digitalRead(11) == 1) || (digitalRead(12) == 1))
//  {
//    normal = 1;
//  }
//  //=====================SENSOR TERPASANG
//  else
//  {
    if  ((millis() - lastDebounceTime) > debounceDelay)
    {
      acquiring();
      measure_beat();

      average=average-40;
      //========KONDISI NORMAL dan TIDAK NORMAL // Dan LEPAS
      // DILEPAS 101 93 97
      if (average >= BPM_bawah && average <= BPM_atas)
      { 
       normal = 0;
      }
      else if (average <= 55)
      {
        normal=1;
      }
      else
      {
        normal = average;
//        if ((digitalRead(11) == 1) || (digitalRead(12) == 1))
//        {
//          normal = 1;
//        }
      }
    }
  //}
  //Wait for a bit to keep serial data from saturating
  delay(1);
}

void acquiring()
{
  state = B10;
  sum = 0.0;
  high_value = 400;

  for (i = 0; i <= amount; i++)
  {
    if ( analogRead(A0) < high_value)
    {
      high_value = analogRead(A0);
    }
    sum = sum + analogRead(A0);
    state = B10;
    //t.update();  //For updating timer used with diplaying graphic
    delay(1);
  }

  average = sum / amount;
  //Serial.print("Average value = ");
  //Serial.println(average);
  //Serial.print("high value = ");
  //Serial.println(high_value);

  while (analogRead(A0) <= average + 40)
  {
    if (digitalRead(12) == 1 || digitalRead(11) == 1)
    {
      break;
    }
    //t.update();  //For updating timer used with diplaying graphic
    delay(1);
  }


  beat_time = newtime - oldtime;
  beat_latch = 1;

  debounceDelay = 350;  //prevents multiple beat interruptions (too long and you may miss a beat)

  no_pulse_latch = 0;
  acq_pulse_latch = 0;
  beat_pulse_latch = 1;
  lastDebounceTime = millis();

  change_number_counter = 21;  //improve transition time from acq to measuring beat time
  BPM_old = 0.0;
  new_beat = 0;
}

void measure_beat()
{
  if (beat_latch == 0 && a_read >= (average + 40) && (millis() - lastDebounceTime) > debounceDelay)
  {
    newtime = millis();
    beat_time = newtime - oldtime;
    lastDebounceTime = millis();
    oldtime = newtime;

    BPM_new = 60 / (((float) beat_time) / 1000);

    if (BPM_old < 38)
    { //For first heart beat, only happens once
      //      Serial.print("IF1: ");
      //      Serial.print(BPM_old);
      //      Serial.print(" & ");
      //      Serial.print(BPM_new);
      //      Serial.print(" = ");
      //      Serial.println(BPM);
      BPM_old = BPM_new;
      BPM = 0.0;
    }
    else if (BPM_new >= 38)
    { //detecting actual heartbeat, 38 is minimum BPM
      //      Serial.print("IF2: ");
      //      Serial.print(BPM_old);
      //      Serial.print(" & ");
      //      Serial.print(BPM_new);
      //      Serial.print(" = ");
      //      Serial.println(BPM);
      state = B11;
      BPM = (BPM_old + BPM_new) / 2.0;
      BPM_old = BPM_new;
      beat_latch = 1;
    }
    else
    { //Bad reading, revert to previous BPM
      //      Serial.print("IF3: ");
      //      Serial.print(BPM_old);
      //      Serial.print(" & ");
      //      Serial.print(BPM_new);
      //      Serial.print(" = ");
      //      Serial.println(BPM);
      BPM = BPM_old;
    }
  }
  else if (beat_latch == 1 && a_read < average - 40)
  { //In between beats
    beat_latch = 0;
  }
}
