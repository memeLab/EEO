// serial
import processing.serial.*;
Serial myPort;

int intensityMin, intensityMax, intensityInterval, intensityIntervalMinor;
int dataMin, dataMax;

float plotX1, plotX2, plotY1, plotY2;
float labelX, labelY;
PFont plotFont;

// plantas
int time, timeMax;
int tempMax, tempMin, p1max, p1min, p2max, p2min, p3max, p3min;
int[] temp, p1, p2, p3;

void setup() {
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
  
  size(720,405);
  
  intensityMin = 0;
  intensityMax = 100;
  intensityInterval = 10;
  intensityIntervalMinor = 5;
  
  dataMin = 0;
  dataMax = 100;
  
  tempMin = 1;
  tempMax = 100;
  p1min = 101;
  p1max = 200;
  p2min = 201;
  p2max = 300;
  p3min = 301;
  p3max = 400;
  
  // corners of the plotted time series
  plotX1 = 120;
  plotX2 = width - 80;
  plotY1 = 60;
  plotY2 = height - 70;
  
  // initial time is 1px after begining of plot start
  time = int(plotX1);
  timeMax = int(plotX2);
  temp = new int[timeMax];
  p1 = new int[timeMax];
  p2 = new int[timeMax];
  p3 = new int[timeMax];
  for (int x = 0; x < timeMax; x++) {
    temp[x] = p1[x] = p2[x] = p3[x] = int(plotY2);
  }
  
  // labels
  labelX = 50;
  labelY = height - 25;
  plotFont = createFont("SansSerif", 20);
  textFont(plotFont);
  
  smooth();
}


void draw() {
  background(224);
  
  // show the plot area as a light box
  fill(255);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1, plotY1, plotX2, plotY2);
    
  // draw the texts
  drawTitle();
  drawAxisLabels();
  drawVolumeLabels();
  
  // get the input
  input();
  
  // draw the data
  drawData();
}
