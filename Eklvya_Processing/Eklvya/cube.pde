void drawCube()
{
  pushMatrix(); //saves the current co-ordinate system
  translate(610, 450, 0);
  scale(3,3,3);
  frame();
  rotateZ(radians(-Euler[2]));
  rotateX(radians(-Euler[1]));
  rotateY(radians(-Euler[0]));
  buildBoxShape();
  fill(#ffffff);
  popMatrix();//restores that saved co-ordinate system
}

static long persist;
boolean dileep;

void frame()
{
  if ((millis() - persist) >= 100)
  {
  persist = millis();
  dileep = !dileep;
  CalcEuler();
  //print("dileep   ");
  //println(dileep);
  }
} 

void CalcEuler() 
{
  if(!dileep)
  {
  Euler[0] = Euler2[0]; // psi - heading
  //println(Euler[0]);
  Euler[1] = Euler2[1]; // theta - roll
  //println(Euler[1]);
  Euler[2] = Euler2[2]; // phi - pitch
  //println(Euler[2]);
  }
  else
  {
  Euler[0] = Euler1[0]; // psi - heading
  //println(Euler[0]);
  Euler[1] = Euler1[1]; // theta - roll
  //println(Euler[1]);
  Euler[2] = Euler1[2]; // phi - pitch
  //println(Euler[2]);
  }
 }


void buildBoxShape() 
{
  noStroke();
  beginShape(QUADS);
  
  //Z+ (to the drawing area)
  fill(#00ffff);  
  vertex(-30, -5, 20);
  vertex(30, -5, 20);
  vertex(30, 5, 20);
  vertex(-30, 5, 20);
  
  //Z-
  fill(#0000ff);
  vertex(-30, -5, -20);
  vertex(30, -5, -20);
  vertex(30, 5, -20);
  vertex(-30, 5, -20);
  
  //X-
  fill(#ffff00);
  vertex(-30, -5, -20);
  vertex(-30, -5, 20);
  vertex(-30, 5, 20);
  vertex(-30, 5, -20);
  
  //X+
  fill(#ff00ff);  
  vertex(30, -5, -20);
  vertex(30, -5, 20);
  vertex(30, 5, 20);
  vertex(30, 5, -20);
  
  //Y-
  fill(#00ff00);
  vertex(-30, -5, -20);
  vertex(30, -5, -20);
  vertex(30, -5, 20);
  vertex(-30, -5, 20);
  
  //Y+
  fill(#ff0000);
  vertex(-30, 5, -20);
  vertex(30, 5, -20);
  vertex(30, 5, 20);
  vertex(-30, 5, 20);
  
  endShape();
}