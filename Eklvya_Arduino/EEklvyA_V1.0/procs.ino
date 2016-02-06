void proc_ini()
{
  count10 = count50 = count100 = count200 = count500 = 0;
  pinMode(led, OUTPUT);
  pinMode(Buzzer1, OUTPUT);
  pinMode(Buzzer1, OUTPUT);
  Buzz(led);
  //delay(1000);
  StopBuzz(led);
  Buzz(Buzzer1);
  Buzz(Buzzer2);
  //delay(1000);
  StopBuzz(Buzzer1);
  StopBuzz(Buzzer2);
}

void proc_10ms()
{
  /*
  Serial.println();
  Serial.print("proc_10:  ");
  Serial.print(count10);
  */
}

void proc_50ms()
{
  /*
  count10 = 0;
  Serial.println();
  Serial.print("proc_50:  ");
  Serial.print(count50);
  */

  if (Buzz1req == 1)
  {
    Buzz1Count--;
    Buzz(Buzzer1);
    Serial.println("buzzing1");
    if (Buzz1Count < 1)
    {
      Buzz1req = 0;
      StopBuzz(Buzzer1);
      Serial.println("done on 1");
    }
  }

  if (Buzz2req == 1)
  {
    Buzz2Count--;
    Buzz(Buzzer2);
    Serial.println("buzzing2");
    if (Buzz2Count < 1)
    {
      Buzz2req = 0;
      StopBuzz(Buzzer2);
      Serial.println("done on 2");
    }
  }
}

void proc_100ms()
{
  /*
  count10 = 0;
  count50 = 0;
  Serial.println();
  Serial.print("proc_100:  ");
  Serial.print(count100);
  */

  getSensorData();

  if (!frame)
  {
    str1 = String(AccelCalib);
    str1 += ",";
    str1 += String(MagCalib);
    str1 += ",";
    str1 += String(GyroCalib);
    str1 += ",";
    str1 += String(LinX);
    str1 += ",";
    str1 += String(LinY);
    str1 += ",";
    str1 += String(LinZ);
    str1 += ",";
    str1 += String(GrvX);
    str1 += ",";
    str1 += String(GrvY);
    str1 += ",";
    str1 += String(GrvZ);
    str1 += ",";
    str1 += String(EulerHeading);
    str1 += ",";
    str1 += String(EulerPitch);
    str1 += ",";
    str1 += String(EulerRoll);
  }
  else
  {
    str2 = String(AccelCalib);
    str2 += ",";
    str2 += String(MagCalib);
    str2 += ",";
    str2 += String(GyroCalib);
    str2 += ",";
    str2 += String(LinX);
    str2 += ",";
    str2 += String(LinY);
    str2 += ",";
    str2 += String(LinZ);
    str2 += ",";
    str2 += String(GrvX);
    str2 += ",";
    str2 += String(GrvY);
    str2 += ",";
    str2 += String(GrvZ);
    str2 += ",";
    str2 += String(EulerHeading);
    str2 += ",";
    str2 += String(EulerPitch);
    str2 += ",";
    str2 += String(EulerRoll);
  }
  frame = !frame;
}

void proc_200ms()
{
  /*
  count10 = 0;
  count50 = 0;
  count100 = 0;
  Serial.println();
  Serial.print("proc_250:  ");
  Serial.print(count250);
  */

  // Serial Framing

  Serial.print("F1,");
  Serial.print(str1);
  Serial.print(",F2,");
  Serial.println(str2);
  str1 = "";
  str2 = "";
  frame = 0;

  // Serial recieving
  if (Serial.available())
  {
    cmd = Serial.read();
    if (cmd == 'a')
    {
      Buzz1req = 1;
      Buzz1Count = 6;
    }
    else if (cmd == 'b')
    {
      Buzz2req = 1;
      Buzz2Count = 6;
    }
  }
}

void proc_500ms()
{
  /*
  count10 = 0;
  count50 = 0;
  count100 = 0;
  Serial.println();
  Serial.print("proc_500:  ");
  Serial.print(count500);
  */
}
