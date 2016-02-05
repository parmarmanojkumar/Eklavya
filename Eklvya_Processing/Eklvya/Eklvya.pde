import processing.serial.*;
import org.jfree.*;
import org.rosuda.REngine.Rserve.*;
import org.rosuda.REngine.*;

Serial EklvyaPort; // Serial port
String EklvyaData; // Serial data received
int EklvyaBaudRate = 9600; // port baud rate
float[] Calib1 = new float[3]; // Frame 1 Acccalib, Magcalib, GyroCalib
float[] Calib2 = new float[3]; // Frame 1 Acccalib, Magcalib, GyroCalib
float[] linAcc1 = new float[3]; // Frame 1 LinAccX, LinAccY, LinAccZ
float[] linAcc2 = new float[3]; // Frame 2 LinAccX, LinAccY, LinAccZ
float[] gravAcc1 = new float[3]; //Frame 1 GravAccX, GravAccY, GravAccZ
float[] gravAcc2 = new float[3]; //Frame 2 GravAccX, GravAccY, GravAccZ
float[] Euler1 = new float[3]; //Frame 1 EulerX, EulerY, EulerZ
float[] Euler2 = new float[3]; //Frame 1 EulerX, EulerY, EulerZ

//Initial set up 
//1. set up serial port
void setup()
{
  size(512,512);
  print (Serial.list()); // To figure out the serial port 
  String portname = Serial.list()[3]; // assigning  usbmodem1421
  EklvyaPort = new Serial(this, portname, EklvyaBaudRate); // Assigning port with baud rate  
}

// Main function

void draw()
{
  
  // Step 1 : Data import from Arduino
  
  int validframe = 0; // to check valiity of frame
  int start, end ; // for string parsing
  if (EklvyaPort.available() > 0) // If data  is avilable on serial
  { 
    EklvyaData = EklvyaPort.readStringUntil('\n'); // Read data from serial
    if (EklvyaData != null) // to check real data is available 
    {
      println(EklvyaData);
      // Data Fromat : F1,Acccalib,Magcalib,GyroCalib,LinAccX,LinAccY,LinAccZ,GravAccX,GravAccY,GravAccZ,EulerX,EulerY,EulerZ,F2,Acccalib,Magcalib,GyroCalib,LinAccX,LinAccY,LinAccZ,GravAccX,GravAccY,GravAccZ,EulerX,EulerY,EulerZ,
      String[] EklvyaParsedData = split(EklvyaData.trim(),','); // Trim to remove white space & separate data at ,
      println (EklvyaParsedData);
      println(EklvyaParsedData.length);
      if (EklvyaParsedData.length == 26) // To check for valid frame
      {
        Calib1 = StringParseFloat (EklvyaParsedData, 1); // Frame1 Calib data extraction
        linAcc1 = StringParseFloat (EklvyaParsedData, 4); // Frame1 LinAcc data extraction
        gravAcc1 = StringParseFloat (EklvyaParsedData, 7);// Frame1 GravAcc data extraction
        Euler1 = StringParseFloat (EklvyaParsedData, 10); // Frame1 Euler data extraction
        Calib2 = StringParseFloat (EklvyaParsedData, 14); // Frame2 Calib data extraction
        linAcc2 = StringParseFloat (EklvyaParsedData, 17); // Frame2 LinAcc data extraction
        gravAcc2 = StringParseFloat (EklvyaParsedData, 20); // Frame2 GravAcc data extraction
        Euler2 = StringParseFloat (EklvyaParsedData, 23); // Frame2 Euler data extraction
        validframe = int(sumFloatArray(Calib1, 3) > 3  && sumFloatArray(Calib2, 3) > 3); // Valid frame is received and parsed
      }
    }
  }
  
  //Step 2 : R connection
  if (validframe == 1 ) // If frame is valid then only process it
  {
        println(Calib1);
        println(linAcc1);
        println(gravAcc1);
        println(Euler1);
        println(Calib2);
        println(linAcc2);
        println(gravAcc2);
        println(Euler2);
        println(sumFloatArray(Calib1, 3));
        println(sumFloatArray(Calib2, 3));
        
  }
  
}