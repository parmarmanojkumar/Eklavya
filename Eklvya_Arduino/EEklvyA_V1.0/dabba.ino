/*

    lastStreamTime = millis();    
    EEklvyA.updateEuler();        //Update the Euler data into the structure of the object
    EEklvyA.updateCalibStatus();  //Update the Calibration Status
    
    EulerRoll     = EEklvyA.readEulerRoll();
    EulerHeading  = EEklvyA.readEulerHeading();
    EulerPitch    = EEklvyA.readEulerPitch();
    AccelCalib    = EEklvyA.readAccelCalibStatus();
    MagCalib      = EEklvyA.readMagCalibStatus();
    GyroCalib     = EEklvyA.readGyroCalibStatus();

  Serial.print(EulerRoll);
  Serial.print("                 ");
  Serial.print(EulerHeading);
  Serial.print("                 ");
  Serial.print(EulerPitch);
  Serial.print("                 ");
  Serial.print(AccelCalib);
  Serial.print("                 ");
  Serial.print(MagCalib);
  Serial.print("                 ");
  Serial.print(GyroCalib);
  Serial.println("                 ");



    if(Serial.available()) 
    {
      cmd = Serial.read();
      if(cmd=='v') 
      {
        sprintf(str,"EEklvyATest - in OPERATION_MODE_IMUPLUS");
        Serial.print('\n');
        Serial.print(str);
        Serial.print('\n');
      }
      else if(cmd=='h') 
      {
        digitalWrite(13,HIGH);
        delay(500);
        digitalWrite(13,LOW);
        delay(500);
        digitalWrite(13,HIGH);
      }
      else if(cmd=='n') 
      {
        digitalWrite(13,HIGH);
        delay(500);
        digitalWrite(13,LOW);
        delay(500);
        digitalWrite(13,HIGH);
        delay(500);
        digitalWrite(13,LOW);
        delay(500);
        digitalWrite(13,HIGH);
        delay(500);
        digitalWrite(13,LOW);
      }
      else if(cmd=='r') 
      {
        digitalWrite(13,HIGH);
          uint8_t count = serial_busy_wait();
          EulerRoll     = EEklvyA.readEulerRoll();
          EulerHeading  = EEklvyA.readEulerHeading();
          EulerPitch    = EEklvyA.readEulerPitch();
          AccelCalib    = EEklvyA.readAccelCalibStatus();
          MagCalib      = EEklvyA.readMagCalibStatus();
          GyroCalib     = EEklvyA.readGyroCalibStatus();
          sprintf(str, "%d,%d,%d,%d,%d,%d,", EulerRoll, EulerHeading, EulerPitch, AccelCalib, MagCalib, GyroCalib);
          Serial.print('\n');
          Serial.print(str);
          Serial.print('\n');
      }

    }
    
 
*/
