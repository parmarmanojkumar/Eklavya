import processing.serial.*;
import org.jfree.*;
import org.rosuda.REngine.Rserve.*;
import org.rosuda.REngine.*;
import processing.opengl.*;
import controlP5.*;

//UI related parameters
ControlP5 cp5; //control pbject for dropdown boxes
DropdownList d1, d2;
PFont font ;
int cnt;

Serial EklvyaPort; // Serial port
Serial EklvyaPort1;
String EklvyaData; // Serial data received
String EklvyaData1; // Serial data received
int EklvyaBaudRate = 115200; // port baud rate
float[] Calib1 = new float[3]; // Frame 1 Acccalib, Magcalib, GyroCalib
float[] Calib2 = new float[3]; // Frame 1 Acccalib, Magcalib, GyroCalib
float[] linAcc1 = new float[3]; // Frame 1 LinAccX, LinAccY, LinAccZ
float[] linAcc2 = new float[3]; // Frame 2 LinAccX, LinAccY, LinAccZ
float[] gravAcc1 = new float[3]; //Frame 1 GravAccX, GravAccY, GravAccZ
float[] gravAcc2 = new float[3]; //Frame 2 GravAccX, GravAccY, GravAccZ
float[] Euler1 = new float[3]; //Frame 1 EulerX, EulerY, EulerZ
float[] Euler2 = new float[3]; //Frame 1 EulerX, EulerY, EulerZ

float[] Calib11 = new float[3]; // Frame 1 Acccalib, Magcalib, GyroCalib
float[] Calib21 = new float[3]; // Frame 1 Acccalib, Magcalib, GyroCalib
float[] linAcc11 = new float[3]; // Frame 1 LinAccX, LinAccY, LinAccZ
float[] linAcc21 = new float[3]; // Frame 2 LinAccX, LinAccY, LinAccZ
float[] gravAcc11 = new float[3]; //Frame 1 GravAccX, GravAccY, GravAccZ
float[] gravAcc21 = new float[3]; //Frame 2 GravAccX, GravAccY, GravAccZ
float[] Euler11 = new float[3]; //Frame 1 EulerX, EulerY, EulerZ
float[] Euler21 = new float[3]; //Frame 1 EulerX, EulerY, EulerZ

float[] Euler = new float[3]; //Frame animation
PImage imgR  ; //image received from R
int validSyncSignal = 0;
boolean toggle = false;
float boxing_trigger_type = 0; //
float Target;



//Initial set up 
//1. set up serial port
//2. R connection set up
void setup()
{
  size(800, 600, OPENGL);
  background(0);
  // Serial Port Setup
  println (Serial.list()); // To figure out the serial port 
  String portname = Serial.list()[1]; // assigning  usbmodem1421- original
  EklvyaPort = new Serial(this, portname, EklvyaBaudRate); // Assigning port with baud rate
  portname = Serial.list()[3]; // assigning  usbmodem1421- original
  EklvyaPort1 = new Serial(this, portname, EklvyaBaudRate); // Assigning port with baud rate
  draw_UI();
  // R connection set up
  try {

    // connect to Rserve (if the user specified a server at the command line, use it, otherwise connect locally)
    RConnection c = new RConnection(); // R connection
    c.serverEval("require(scatterplot3d); require(Cairo); require(dplyr)");
    c.serverEval("source('/Users/VirKrupa/Documents/99_hackathon/Eklvya_Repo/Eklvya_R/Functions_Server.R')");

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
  imgR  = loadImage("test1.jpg");
}

// Main function

int ppmcount = 0;
int ppmcountmmax = 0;
int intensitycount = 0;
int intensitymax = 0;
float UpCutErr = 0;
int UpCutCount = 0;
int xcor, ycor, zcor = 0;
void draw()
{
  //UI
  fill(#ffffff);
  background(0);


  // Step 1 : Data import from Arduino

  int validframe = 0; // to check valiity of frame
  if (EklvyaPort.available() > 0) // If data  is avilable on serial
  { 
    EklvyaData = EklvyaPort.readStringUntil('\n'); // Read data from serial
    if (EklvyaData != null) // to check real data is available 
    {
      println("SerialPort BT");
      println(EklvyaData);
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

  int validframe1 = 0; // to check valiity of frame
  if (EklvyaPort1.available() > 0) // If data  is avilable on serial
  { 
    EklvyaData1 = EklvyaPort1.readStringUntil('\n'); // Read data from serial
    if (EklvyaData1 != null) // to check real data is available 
    {
      println("SerialPort USB");
      println(EklvyaData1);
      // Data Fromat : F1,Acccalib,Magcalib,GyroCalib,LinAccX,LinAccY,LinAccZ,GravAccX,GravAccY,GravAccZ,EulerX,EulerY,EulerZ,F2,Acccalib,Magcalib,GyroCalib,LinAccX,LinAccY,LinAccZ,GravAccX,GravAccY,GravAccZ,EulerX,EulerY,EulerZ,
      String[] EklvyaParsedData1 = split(EklvyaData1.trim(), ','); // Trim to remove white space & separate data at ,
      //println (EklvyaParsedData1);
      //println(EklvyaParsedData1.length);
      if (EklvyaParsedData1.length == 26) // To check for valid frame
      {
        Calib11 = StringParseFloat (EklvyaParsedData1, 1); // Frame1 Calib data extraction
        linAcc11 = StringParseFloat (EklvyaParsedData1, 4); // Frame1 LinAcc data extraction
        gravAcc11 = StringParseFloat (EklvyaParsedData1, 7);// Frame1 GravAcc data extraction
        Euler11 = StringParseFloat (EklvyaParsedData1, 10); // Frame1 Euler data extraction
        Calib21 = StringParseFloat (EklvyaParsedData1, 14); // Frame2 Calib data extraction
        linAcc21 = StringParseFloat (EklvyaParsedData1, 17); // Frame2 LinAcc data extraction
        gravAcc21 = StringParseFloat (EklvyaParsedData1, 20); // Frame2 GravAcc data extraction
        Euler21 = StringParseFloat (EklvyaParsedData1, 23); // Frame2 Euler data extraction
        validframe1 = int(sumFloatArray(Calib11, 3) > 3  && sumFloatArray(Calib21, 3) > 3); // Valid frame is received and parsed
      }
    }
  }
  drawCube();


  //Step 2 : R connection for single device
  if ((validframe == 1) && (boxing_trigger_type!=3)) // If frame is valid then only process it
  {

    //validSyncSignal = validSyncSignal + 1;
    println(validSyncSignal, millis(), toggle);
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

      println("Rconnection ReEstablished");
      String device = "CairoJPEG";
      // Create jpeg file
      REXP xp = c.parseAndEval("try(CairoJPEG('test.jpg',quality=90))");
      if (xp.inherits("try-error")) { // if the result is of the class try-error then there was a problem
        System.err.println("Can't open "+device+" graphics device:\n"+xp.asString());
        // this is analogous to 'warnings', but for us it's sufficient to get just the 1st warning
        REXP w = c.eval("if (exists('last.warning') && length(last.warning)>0) names(last.warning)[1] else 0");
        if (w.isString()) System.err.println(w.asString());
        return;
      }
      println("Debug1");
      //Intensity regime for boxing for PPM
      if (boxing_trigger_type == 0 )
      {
        // Evaluating scatter Plot
        c.parseAndEval("punchperminutecalc(LinAccX,LinAccY,LinAccZ);dev.off()");
        //c.parseAndEval("write.table(data.frame(LinAccX,LinAccY,LinAccZ), file='/Users/VirKrupa/Documents/99_hackathon/Eklvya_Repo/Eklvya_R/data.txt' )");
        println("Debug2");
        //Getting path from R for image
        String pathvariable = c.eval("getwd()").asString() + File.separator + "test.jpg";
        //println(pathvariable);
        //loading image in PImage class for display purpose
        imgR = loadImage(pathvariable);
        //deleting generated file to preserve space on server.
        c.parseAndEval("unlink('test.jpg')");

        c.serverEval("punchperminutecount()");
        ppmcount = c.parseAndEval("punchperminutout()").asInteger();
        ppmcountmmax = c.parseAndEval("punchperminutemax()").asInteger();

        // Store data
        c.serverEval("updateLinAcc("+linAcc1[0] +","+linAcc1[1] +","+linAcc1[2] +","+linAcc2[0] +","+linAcc2[1] +","+linAcc2[2]+")");
      }
      // Intensity regime with punch force
      if (boxing_trigger_type == 1 )
      {
        // Evaluating scatter Plot
        c.parseAndEval("intensitycalc(LinAccX,LinAccY,LinAccZ);dev.off()");
        println("Debug2");
        //Getting path from R for image
        String pathvariable = c.eval("getwd()").asString() + File.separator + "test.jpg";
        //println(pathvariable);
        //loading image in PImage class for display purpose
        imgR = loadImage(pathvariable);
        //deleting generated file to preserve space on server.
        c.parseAndEval("unlink('test.jpg')");
        c.serverEval("intensitycount()");
        intensitycount = c.parseAndEval("lastintenistyout()").asInteger();
        intensitymax = c.parseAndEval("intensitymax()").asInteger();
        // Store data
        c.serverEval("updateLinAcc("+linAcc1[0] +","+linAcc1[1] +","+linAcc1[2] +","+linAcc2[0] +","+linAcc2[1] +","+linAcc2[2]+")");
      }
      // Uppercut Regime
      if (boxing_trigger_type == 2 )
      {
        // Evaluating scatter Plot
        c.parseAndEval("accuracyregime();dev.off()");
        println("Debug2");
        //Getting path from R for image
        String pathvariable = c.eval("getwd()").asString() + File.separator + "test.jpg";
        //println(pathvariable);
        //loading image in PImage class for display purpose
        imgR = loadImage(pathvariable);
        //deleting generated file to preserve space on server.
        c.parseAndEval("unlink('test.jpg')");
        c.serverEval("accuracyregimeerror()");
        UpCutErr = c.parseAndEval("upcuterrorout()").asInteger();
        UpCutCount = c.parseAndEval("upcutcount()").asInteger();
        // Store data
        c.serverEval("updateLinAcc("+linAcc1[0] +","+linAcc1[1] +","+linAcc1[2] +","+linAcc2[0] +","+linAcc2[1] +","+linAcc2[2]+")");
      }
      // Uppercut Regime Not working
      if (boxing_trigger_type == 30 )
      {
        // Evaluating scatter Plot
        c.serverEval("positioncalcxyz(LinAccX,LinAccY,LinAccZ)");
        println("Debug2");
        xcor = c.parseAndEval("positionxout()").asInteger();
        ycor = c.parseAndEval("positionyout()").asInteger();
        zcor = c.parseAndEval("positionzout()").asInteger();
        print("xcor    "); 
        println(xcor/100);
        print("ycor    "); 
        println(ycor/100);
        print("zcor    "); 
        println(zcor/100);
        // Store data
        c.serverEval("updateLinAcc("+linAcc1[0] +","+linAcc1[1] +","+linAcc1[2] +","+linAcc2[0] +","+linAcc2[1] +","+linAcc2[2]+")");
      }

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

    //Syncronisation
    if (validframe == 1 && validframe1 == 1 && boxing_trigger_type == 3)
    {
      // R connection set up
      try {

        // connect to Rserve (if the user specified a server at the command line, use it, otherwise connect locally)
        RConnection c = new RConnection();

        println("Rconnection ReEstablished");
        String device = "CairoJPEG";
        // Create jpeg file
        REXP xp = c.parseAndEval("try(CairoJPEG('test.jpg',quality=90))");
        if (xp.inherits("try-error")) { // if the result is of the class try-error then there was a problem
          System.err.println("Can't open "+device+" graphics device:\n"+xp.asString());
          // this is analogous to 'warnings', but for us it's sufficient to get just the 1st warning
          REXP w = c.eval("if (exists('last.warning') && length(last.warning)>0) names(last.warning)[1] else 0");
          if (w.isString()) System.err.println(w.asString());
          return;
        }
        println("Debug1");
        
        // Evaluating scatter Plot
        c.parseAndEval("updateEuler3(EulerX,EulerY,EulerZ,EulerX1,EulerY1,EulerZ1);dev.off()");
        //c.parseAndEval("write.table(data.frame(LinAccX,LinAccY,LinAccZ), file='/Users/VirKrupa/Documents/99_hackathon/Eklvya_Repo/Eklvya_R/data.txt' )");
        println("Debug2");
        //Getting path from R for image
        String pathvariable = c.eval("getwd()").asString() + File.separator + "test.jpg";
        //println(pathvariable);
        //loading image in PImage class for display purpose
        imgR = loadImage(pathvariable);
        //deleting generated file to preserve space on server.
        c.parseAndEval("unlink('test.jpg')");
        c.serverEval("updateEuler("+Euler1[0] +","+Euler1[1] +","+Euler1[2] +","+Euler2[0] +","+Euler2[1] +","+Euler2[2]+")");
        c.serverEval("updateEuler1("+Euler11[0] +","+Euler11[1] +","+Euler11[2] +","+Euler21[0] +","+Euler21[1] +","+Euler21[2]+")");
        
        
        
        //c.close();
      } 
      catch (RserveException rse) { // RserveException (transport layer - e.g. Rserve is not running)
        println(rse);
      } 
      catch(Exception e) { // something else
        println("Something went wrong, but it's not the Rserve: "
          +e.getMessage());
        e.printStackTrace();
      } 

      //image(imgR, 0, 0);
    }
    if (validframe == 1) {
      if (EklvyaPort.available() == 0) {
        validSyncSignal += 1;
        if (validSyncSignal%10 == 0)
        {
          validSyncSignal = 0;
          EklvyaPort.write('n');

          if (toggle)
          {

            EklvyaPort.write('n');
            //toggle = !toggle;
          } else
          {
            EklvyaPort.write('h');
          }
          toggle = !toggle;
        }
      }
    }

    //  textAlign(LEFT, TOP);
    text("EnggEklvyA", 20, 20);

    text(trigger_list, 510, 160);
    text(boxing_trigger_type, 650, 160);
    if ((trigger_list=="Target PPM"))
    {
      Target = boxing_trigger_type;
    }
    if ((trigger_list=="Sport_Regime") && (boxing_trigger_type==0))
    {
      text("Punches Per Minute", 510, 200);
      text(ppmcount, 510, 220);
      text("Punches Per Minute Max", 510, 240);
      text(ppmcountmmax, 510, 260);
      image(imgR, 0, 50);
      if ((ppmcount > Target) && (validframe == 1))
      {
        EklvyaPort.write('a');
      }
    } else if ((trigger_list=="Sport_Regime") && (boxing_trigger_type==1))
    {
      text("Punch Intensity Evaluation : ", 510, 200);
      text("Last punch Intensity :", 510, 220);
      text(intensitycount, 510, 240);
      text("Max intenisty : ", 510, 260);
      text(intensitymax, 510, 280);
      image(imgR, 0, 50);
    } else if ((trigger_list=="Sport_Regime") && (boxing_trigger_type==2))
    {
      text("Upper Cut Evaluation: ", 510, 200);
      text("Error : ", 510, 220);
      text(UpCutErr/100, 510, 240);
      text("Best Punches : ", 510, 260);
      text(UpCutCount, 510, 280);

      image(imgR, 0, 50);
    } else if ((trigger_list=="Sport_Regime") && (boxing_trigger_type==3))
    {
      text("Synchronisation: ", 510, 200);

      image(imgR, 0, 50);
    } else
    {
      text("Select Sport Regime After gyro calibration", 510, 200);
      imgR  = loadImage("test1.jpg");
      image(imgR, 0, 50);
    }
  }