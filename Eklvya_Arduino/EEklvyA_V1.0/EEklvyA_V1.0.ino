#include "NAxisMotion.h"        //Contains the bridge code between the API and the Arduino Environment
#include <Wire.h>

NAxisMotion EEklvyA;         //Object that for the sensor 
unsigned long lastStream10 = 0;     //To store the last streamed time stamp
unsigned long lastStream50 = 0;     //To store the last streamed time stamp
unsigned long lastStream100 = 0;     //To store the last streamed time stamp
unsigned long lastStream200 = 0;     //To store the last streamed time stamp
unsigned long lastStream500 = 0;     //To store the last streamed time stamp

#define Proc10ms   10
#define Proc50ms   50
#define Proc100ms 100
#define Proc200ms 200
#define Proc500ms 500

int count10,count50,count100,count200,count500;
char str[256];
String str1;
String str2;
char cmd;
const int Buzzer1 = 3;
const int Buzzer2 = 4;
const int led =  13; 
float EulerRoll=0, EulerHeading=0, EulerPitch=0, AccelCalib=0, MagCalib=0, GyroCalib=0;
float LinX=0, LinY=0, LinZ=0, GrvX=0, GrvY=0, GrvZ=0;
bool frame=0;

void setup() //This code is executed once
{
  Serial.begin(115200);           //Initialize the Serial Port to view information on the Serial Monitor
  I2C.begin();                    //Initialize I2C communication to the let the library communicate with the sensor.
  //Sensor Initialization
  EEklvyA.initSensor();          //The I2C Address can be changed here inside this function in the library
  EEklvyA.setOperationMode(OPERATION_MODE_NDOF);   //Can be configured to other operation modes as desired
  EEklvyA.setUpdateMode(MANUAL);	//The default is AUTO. Changing to MANUAL requires calling the relevant update functions prior to calling the read functions
  //Setting to MANUAL requires fewer reads to the sensor  

  proc_ini();
}


void loop() //This code is looped forever
{
   if ((millis() - lastStream10) >= Proc10ms)
  {
    lastStream10 = millis();
    count10++;
    proc_10ms();
    if((millis() - lastStream50) >= Proc50ms)
    {
      lastStream50 = millis();
      count50++;
      proc_50ms();
      if ((millis() - lastStream100) >= Proc100ms)
      {
        lastStream100 = millis();
        count100++;
        proc_100ms();
      }
      if ((millis() - lastStream200) >= Proc200ms)
      {
        lastStream200 = millis();
        count200++;
        proc_200ms();
        if ((millis() - lastStream500) >= Proc500ms)
        {
          lastStream500 = millis();
          count500++;
          proc_500ms();
        }
      }
    }
  }
}
