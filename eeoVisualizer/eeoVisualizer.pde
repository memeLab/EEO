// serial
import processing.serial.*;
Serial myPort;
int counter, vermelho, verde, azul, opacidade;
int tempMax, tempMin, p1max, p1min, p2max, p2min, p3max, p3min;


void setup() {
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
  
  //size(displayWidth, displayHeight);
  size(640, 480);
  
  noStroke();
  //strokeWeight(5);
  background(0);
  counter = 0;
  vermelho = verde = azul = opacidade = 0;
  
  tempMin = 1;
  tempMax = 100;
  p1min = 101;
  p1max = 200;
  p2min = 201;
  p2max = 300;
  p3min = 301;
  p3max = 400;
  
  smooth();
}


void draw() {
    
  // get the input
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    int inByte = int(inString);
    if (inByte > 100) println(inByte);
    
    // put the input in the right variable
    if (inByte >= tempMin && inByte <= tempMax) {
      opacidade = int(map(inByte, tempMin, tempMax, 0, 255));
      //println("Temp out: " + opacidade);
    } else if (inByte >= p1min && inByte <= p1max) {
      vermelho = int(map(inByte, p1min, p1max, 0, 255));
      //println("P1 out:   " + vermelho);
    } else if (inByte >= p2min && inByte <= p2max) {
      verde = int(map(inByte, p2min, p2max, 0, 255));
      //println("P2 out:   " + verde);     
    } else if (inByte >= p3min && inByte <= p3max) {
      azul = int(map(inByte, p3min, p3max, 0, 255));
      //println("P3 out:   " + azul);       
    }
  }
  
  // draw the data
  //stroke(vermelho/2, verde/2, azul/2, opacidade);
  fill(vermelho, verde, azul, opacidade);
  ellipse(width/2, height/2, (height-80)*sin(counter), (height-80)*sin(counter));
  counter++;
  vermelho--;
  verde--;
  azul--;
  opacidade--;
}
