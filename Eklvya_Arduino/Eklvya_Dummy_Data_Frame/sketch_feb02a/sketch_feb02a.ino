int count = 0;
int countinc = 7;
int incmod = 13;
int mod1 = 73;
int mod2 = 11;
int mod3 = 51;
int del = 100;
float xy = 3.2;


void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  

}

void loop() {
  // put your main code here, to run repeatedly:
  countinc ++;
  countinc = countinc % incmod;
  count += countinc;  
  char tbs[36];
  sprintf(tbs, "EX %04d EY %04d EZ %04d", (float(count % mod1)), float(count % mod2), float(count % mod3));
  //Serial.print("%3d", float(count % mod1));
  //Serial.print("%3d", float(count % mod2));
  //Serial.println("%3d", float(count % mod3));
  //Serial.println(tbs);
  //Serial.println(char(float(float(count % mod1))));
  //F1
  Serial.print("F1,");
  //acc calib
  Serial.print (float(float(count % mod1)));
  Serial.print (",");
  //mag calib
  Serial.print (float(count % mod2));
  Serial.print (",");
  //gyro calib
  Serial.print (float(count % mod3));
  Serial.print (",");
  //lin x
  Serial.print (float(count % mod1));
  Serial.print (",");
  //lin y
  Serial.print (float(count % mod2));
  Serial.print (",");
  //lin z
  Serial.print (float(count % mod3));
  Serial.print (",");
  //grav x
  Serial.print (float(count % mod1));
  Serial.print (",");
  //grav y
  Serial.print (float(count % mod2));
  Serial.print (",");
  //grav z
  Serial.print (float(count % mod3));
  Serial.print (",");
  //euler x
  Serial.print (float(count % mod1));
  Serial.print (",");
  //euler y
  Serial.print (float(count % mod2));
  Serial.print (",");
  //euler z
  Serial.print (float(count % mod3));
  Serial.print (",");
  //F2
  Serial.print("F2,");
  //acc calib
  Serial.print (float(count % mod1));
  Serial.print (",");
  //mag calib
  Serial.print (float(count % mod2));
  Serial.print (",");
  //gyro calib
  Serial.print (float(count % mod3));
  Serial.print (",");
  //lin x
  Serial.print (float(count % mod1));
  Serial.print (",");
  //lin y
  Serial.print (float(count % mod2));
  Serial.print (",");
  //lin z
  Serial.print (float(count % mod3));
  Serial.print (",");
  //grav x
  Serial.print (float(count % mod1));
  Serial.print (",");
  //grav y
  Serial.print (float(count % mod2));
  Serial.print (",");
  //grav z
  Serial.print (float(count % mod3));
  Serial.print (",");
  //euler x
  Serial.print (float(count % mod1));
  Serial.print (",");
  //euler y
  Serial.print (float(count % mod2));
  Serial.print (",");
  //euler z
  Serial.print (float(count % mod3));
  //Serial.print (",");
  
  Serial.println();
  delay(del);

}
