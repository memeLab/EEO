// serial
import processing.serial.*;
Serial myPort;

int data, dataMin, dataMax;

void setup() {
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
  
  size(640, 480);
  
  dataMin = 100000;
  dataMax = 0;
  
  smooth();
}


void draw() {
  background(0);
    
  // get the input
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    float inByte = float(inString);
    data = int(inByte);
    
    // calcula o mínimo e máximo
    if (data < dataMin) {
      dataMin = data;
    } else if (data > dataMax) {
      dataMax = data;
    }
  }
  
  // draw the data
  textAlign(CENTER);
  textSize(30);
  text("In: " + data, width/2, height/3);
  text("Min: " + dataMin, width/2, height/2);
  text("Max: " + dataMax, width/2, height/3*2);
}
