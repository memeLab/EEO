// serial
import processing.serial.*;
Serial myPort;
int counter, tempOut, vermelho, azul;
int inc = 5;
float tempIn, tempMax, tempMin, tempMedia, diferenca;

PFont plotFont;
String txt1, txt2, txt3, txt4;


void setup() {
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
  
  size(displayWidth, displayHeight);
  //size(640, 480);
  
  //noStroke();
  strokeWeight(20);
  tempOut = counter = 0;
  vermelho = azul = 128;
  
  tempMedia = tempMin = 100;
  tempIn = tempMax = 1;
  
  plotFont = createFont("Free Monospaced", 10);
  textFont(plotFont);
  textSize(10);
  
  smooth();
  background(0);
  frameRate(10);
}

void draw() {
  
  // get the input
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    tempIn = float(inString);
    
    // calcula a temperatura mínima e máxima
    if ((tempIn > 10) && (tempIn < 30)) {
      if (tempIn < tempMin) {
        tempMin = tempIn;
      } else if (tempIn > tempMax) {
        tempMax = tempIn;
      }
    }
    
    // put the input in the right variable
    tempOut = int(map(tempIn, tempMin, tempMax, 0, 255));
    tempMedia = (tempMin + tempMax) / 2;
    if (tempIn > tempMedia) {
      vermelho = tempOut;
      //vermelho = vermelho + inc;
      //azul = azul - inc;
    } else if (tempIn <= tempMedia) {
      azul = tempOut * 2;
      //vermelho = vermelho - inc;
      //azul = azul + inc;
    }
    diferenca = tempIn - tempMedia;
    
    // create strings from the numbers
    txt1 = nf(tempIn, 2,2);
    txt2 = nf(tempMedia, 2,2);
    txt3 = nf(diferenca, 2,2);
    txt4 = nf(tempOut, 2);
    
    // print the data
    //println(tempIn + "\t" + tempMedia + "\t" + tempOut);
    println(vermelho + "\t" + azul);
  }
  
  // draw circle
  stroke(0, 0, 0, 150);
  fill(vermelho, 20, azul, 100);
  //fill(255, 150);
  //stroke(vermelho, 20, azul, 100);
  ellipse(width/2, height/2, (height-80)*sin(counter), (height-80)*sin(counter));
  counter++;
  
  // draw black rectangle
  fill(0);
  noStroke();
  rect(0,0,120,80);
  
  // draw text
  fill(255);
  textAlign(LEFT);
  text("Temp in:\nTemp media:\nDiff:\nRed:\nBlue:", 5, 15);
  textAlign(RIGHT);
  text(nf(tempIn,2,2) +"\n"+ nf(tempMedia,2,2) +"\n"+ nf(diferenca,2,2) +"\n"+ nf(vermelho,2) +"\n"+ nf(azul,2), 110, 15);
  
}
