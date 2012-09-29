// serial
import processing.serial.*;
Serial myPort;

int intensityMin, intensityMax;
int intensityInterval = 10, intensityIntervalMinor = 5;
int dataMin, dataMax;

float plotX1, plotX2, plotY1, plotY2;
float labelX, labelY;
PFont plotFont;

int[] temp, p1, p2, p3;
int time, timeMax, tempMax, tempMin, p1max, p1min, p2max, p2min, p3max, p3min, diff;

void setup() {
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
  
  size(displayWidth, displayHeight);
  frameRate(600);
  
  intensityMin = 0;
  intensityMax = 100;
  
  dataMin = 0;
  dataMax = 100;
  
  diff = 50;
  tempMin = 1;
  tempMax = tempMin + diff;
  p1min = 101;
  p1max = p1min + diff;
  p2min = 201;
  p2max = p2min + diff;
  p3min = 301;
  p3max = p3min + diff;
  
  // corners of the plotted time series
  plotX1 = 10;
  plotX2 = width - 10;
  plotY1 = 50;
  plotY2 = height - 100;
  
  // initial time is 1px after begining of plot start
  time = int(plotX1);
  timeMax = int(plotX2);
  temp = new int[timeMax];
  p1 = new int[timeMax];
  p2 = new int[timeMax];
  p3 = new int[timeMax];
  for (int x = 0; x < timeMax; x++) {
    temp[x] = p1[x] = p2[x] = p3[x] = int(plotY2 / 2);
  }
  
  smooth();
}


void draw() {
  background(0);
    
  // get the input
  input();
  
  // draw the data
  drawData();
}
