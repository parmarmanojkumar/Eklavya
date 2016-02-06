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
String EklvyaData; // Serial data received
int EklvyaBaudRate = 115200; // port baud rate
float[] Calib1 = new float[3]; // Frame 1 Acccalib, Magcalib, GyroCalib
float[] Calib2 = new float[3]; // Frame 1 Acccalib, Magcalib, GyroCalib
float[] linAcc1 = new float[3]; // Frame 1 LinAccX, LinAccY, LinAccZ
float[] linAcc2 = new float[3]; // Frame 2 LinAccX, LinAccY, LinAccZ
float[] gravAcc1 = new float[3]; //Frame 1 GravAccX, GravAccY, GravAccZ
float[] gravAcc2 = new float[3]; //Frame 2 GravAccX, GravAccY, GravAccZ
float[] Euler1 = new float[3]; //Frame 1 EulerX, EulerY, EulerZ
float[] Euler2 = new float[3]; //Frame 1 EulerX, EulerY, EulerZ
float[] Euler = new float[3]; //Frame animation
PImage imgR ; //image received from R
int validSyncSignal = 0;
boolean toggle = false;
float trigger_type;
 


//Initial set up 
//1. set up serial port
//2. R connection set up
void setup()
{
  size(800, 600, OPENGL);
  background(0);
  // Serial Port Setup
  println (Serial.list()); // To figure out the serial port 
  String portname = Serial.list()[2]; // assigning  usbmodem1421- original
  EklvyaPort = new Serial(this, portname, EklvyaBaudRate); // Assigning port with baud rate
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
}

// Main function

int ppmcount = 0;
int ppmcountmmax = 0;
void draw()
{
  //UI
  fill(#ffffff);


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
      String[] EklvyaParsedData = split(EklvyaData.trim(), ','); // Trim to remove white space & separate data at ,
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

  drawCube();

  //Step 2 : R connection
  if (validframe == 1 ) // If frame is valid then only process it
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
      // Evaluating scatter Plot
      //c.parseAndEval("updateplot3(LinAccX,LinAccY,LinAccZ,1);dev.off()");
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
      //ppmcount = c.parseAndEval("length(Finalppm)").asDouble();
      //println(ppmcount);
      ppmcount = c.parseAndEval("punchperminutout()").asInteger();
      //println(ppmcount);
      ppmcountmmax = c.parseAndEval("punchperminutemax()").asInteger();
      //println(ppmmax);

      // Store data
      c.serverEval("updateLinAcc("+linAcc1[0] +","+linAcc1[1] +","+linAcc1[2] +","+linAcc2[0] +","+linAcc2[1] +","+linAcc2[2]+")");
      // close RConnection, we're done
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
    image(imgR, 0, 50);
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
  text(trigger_type, 650, 160);
  if ((trigger_list=="Sport_Regime") && (trigger_type==0))
  {
    text("Punches Per Minute", 510, 200);
    text(ppmcount, 510, 220);
    text("Punches Per Minute Max", 510, 240);
    text(ppmcountmmax, 510, 260);

  }
  else if((trigger_list=="Sport_Regime") && (trigger_type==1))
  {
    text("Punch Evaluation", 510, 200);
  
  }
  else
  {
  //draw nothing
  }
}