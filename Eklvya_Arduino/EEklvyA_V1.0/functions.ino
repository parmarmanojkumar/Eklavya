/*
void getSensorData()

This function updates all the data necessary for a frame
If the sensor update more is AUTO, then the update functions in the first 4 lines are called for every subsequent read functions.
If the sensor has frozen, adding this function can delay the time procs infinitely.
*/
void getSensorData()
{
  EEklvyA.updateEuler();        //Update the Euler data into the structure of the object
  EEklvyA.updateCalibStatus();  //Update the Calibration Status
  EEklvyA.updateLinearAccel();
  EEklvyA.updateGravAccel();
  EulerRoll     = EEklvyA.readEulerRoll();
  EulerHeading  = EEklvyA.readEulerHeading();
  EulerPitch    = EEklvyA.readEulerPitch();
  AccelCalib    = EEklvyA.readAccelCalibStatus();
  MagCalib      = EEklvyA.readMagCalibStatus();
  GyroCalib     = EEklvyA.readGyroCalibStatus();
  LinX          = EEklvyA.readLinearAccelX();
  LinY          = EEklvyA.readLinearAccelY();
  LinZ          = EEklvyA.readLinearAccelZ();
  GrvX          = EEklvyA.readGravAccelX();
  GrvY          = EEklvyA.readGravAccelY();
  GrvZ          = EEklvyA.readGravAccelZ();
}

void Buzz(int posi)        //to start the buzzer
{
  if (posi != led)
  {
    digitalWrite(posi, LOW);
  }
  else
  {
    digitalWrite(posi, HIGH);
  }
}

void StopBuzz(int posi)    //to stop the buzzer
{
  if (posi != led)
  {
    digitalWrite(posi, HIGH);
  }
  else
  {
    digitalWrite(posi, LOW);
  }
}
