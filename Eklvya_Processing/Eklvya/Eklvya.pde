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
PImage imgR ; //image received from R

//Initial set up 
//1. set up serial port
//2. R connection set up
void setup()
{
  size(512, 512);

  // Serial Port Setup
  println (Serial.list()); // To figure out the serial port 
  String portname = Serial.list()[3]; // assigning  usbmodem1421
  EklvyaPort = new Serial(this, portname, EklvyaBaudRate); // Assigning port with baud rate

  // R connection set up
  try {

    // connect to Rserve (if the user specified a server at the command line, use it, otherwise connect locally)
    RConnection c = new RConnection();
    c.serverEval("xcor <- 0; ycor <- 0 ; zcor <- 0");
    c.serverEval("require(scatterplot3d); require(Cairo)");
    //c.serverEval("source('~/Documents/Processing/String_Read/code/sqrt3d_file.R')");

    println("Rconnection Established");


    // close RConnection, we're done
    c.close();
  } 
  catch (RserveException rse) { // RserveException (transport layer - e.g. Rserve is not running)
    println(rse);
  } 
  catch(Exception e) { // something else
    println("Something went wrong, but it's not the Rserve: "
      +e.getMessage());
    e.printStackTrace();
  }
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
      //println(EklvyaData);
      // Data Fromat : F1,Acccalib,Magcalib,GyroCalib,LinAccX,LinAccY,LinAccZ,GravAccX,GravAccY,GravAccZ,EulerX,EulerY,EulerZ,F2,Acccalib,Magcalib,GyroCalib,LinAccX,LinAccY,LinAccZ,GravAccX,GravAccY,GravAccZ,EulerX,EulerY,EulerZ,
      String[] EklvyaParsedData = split(EklvyaData.trim(), ','); // Trim to remove white space & separate data at ,
      //println (EklvyaParsedData);
      //println(EklvyaParsedData.length);
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

    /* Frame Printing
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
     */

    // R connection set up
    try {

      // connect to Rserve (if the user specified a server at the command line, use it, otherwise connect locally)
      RConnection c = new RConnection();

      println("Rconnection Established");
      // Create jpeg file
      REXP xp = c.parseAndEval("try(CairoJPEG('test.jpg',quality=90))");
      // Evaluating scatter Plot
      c.parseAndEval("scatterplot3d(xcor, ycor, zcor); dev.off()");
      //Getting path from R for image
      String pathvariable = c.eval("getwd()").asString() + File.separator + "test.jpg";
      //loading image in PImage class for display purpose
      imgR = loadImage(pathvariable);
      //deleting generated file to preserve space on server.
      c.parseAndEval("unlink('test.jpg')");
      
      
      // Store data
      c.serverEval("xcor <- c(xcor," + linAcc1[0] +","+linAcc2[0] +");"+"ycor <-c(ycor,"  + linAcc1[1] +","+linAcc2[1] +");"+"zcor <- c(zcor," +   linAcc1[2] +","+linAcc2[2]  +")" );
      // close RConnection, we're done
      c.close();
    } 
    catch (RserveException rse) { // RserveException (transport layer - e.g. Rserve is not running)
      println(rse);
    } 
    catch(Exception e) { // something else
      println("Something went wrong, but it's not the Rserve: "
        +e.getMessage());
      e.printStackTrace();
    }
    
    image(imgR, 0, 0);
  }
}