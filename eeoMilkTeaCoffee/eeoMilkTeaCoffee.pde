// serial
import processing.serial.*;
Serial myPort;

FloatTable data;
float dataMin, dataMax;

float plotX1, plotX2, plotY1, plotY2;
float labelX, labelY;

int currentColumn = 0, columnCount, rowCount;
int volumeInterval = 10, volumeIntervalMinor = 5;

int yearMin, yearMax, yearInterval = 10;
int[] years;

float[] tabLeft, tabRight;
float tabTop, tabBottom;
float tabPad = 10;

Integrator[] interpolators;

PFont plotFont;




void setup() {
  size(720,405);
  
  data = new FloatTable("milk-tea-coffee.tsv");
  columnCount = data.getColumnCount();
  rowCount = data.getRowCount();
  
  years = int(data.getRowNames());
  yearMin = years[0];
  yearMax = years[years.length - 1];
  
  dataMin = 0;
  dataMax = ceil(data.getTableMax() / volumeInterval) * volumeInterval;
  
  interpolators = new Integrator[rowCount];
  for (int row = 0; row < rowCount; row++) {
    float initialValue = data.getFloat(row, 0);
    interpolators[row] = new Integrator(initialValue);
    interpolators[row].attraction = 0.1; // set lower than the default
  }
  
  // corners of the plotted time series
  plotX1 = 120;
  plotX2 = width - 80;
  plotY1 = 60;
  plotY2 = height - 70;
  
  // labels positions
  labelX = 50;
  labelY = height - 25;
  
  plotFont = createFont("SansSerif", 20);
  textFont(plotFont);
  
  smooth();
  

}


void draw () {
  background(224);
  
  // show the plot area as a light box
  fill(255);
  rectMode(CORNERS);
  noStroke();
  rect(plotX1, plotY1, plotX2, plotY2);
  
  for (int row = 0; row < rowCount; row++) {
    interpolators[row].update();
  }
  
  // draw the texts
  drawTitleTabs();
  //drawTitle();
  drawAxisLabels();
  drawYearLabels();
  drawVolumeLabels();
  
  // draw the data for the current column
  stroke(#5679C1);
  strokeWeight(3);
  //drawDataPoints(currentColumn);
  drawDataLine(currentColumn);
  

}


// draw the title of the current plot
void drawTitle() {
  fill(0);
  textSize(20);
  textAlign(LEFT);
  String title = data.getColumnName(currentColumn);
  text(title, plotX1, plotY1 - 10);
}

// draw interactive title tabs

void drawTitleTabs() {
  rectMode(CORNERS);
  noStroke();
  textSize(20);
  textAlign(LEFT);
  
  // on first use of this method, allocate space for an array
  // to store the values for the left and the right edges of the tabs.
  if (tabLeft == null) {
    tabLeft = new float[columnCount];
    tabRight = new float[columnCount];
  }
  
  float runningX = plotX1;
  tabTop = plotY1 - textAscent() - 15;
  tabBottom = plotY1;
  
  for (int col = 0; col < columnCount; col++) {
    String title = data.getColumnName(col);
    tabLeft[col] = runningX;
    float titleWidth = textWidth(title);
    tabRight[col] = tabLeft[col] + tabPad + titleWidth + tabPad;
    
    // if the current tab, set it's background white; otherwise use pale gray
    fill(col == currentColumn ? 255 : 224);
    rect(tabLeft[col], tabTop, tabRight[col], tabBottom);
    
    // if the current tab, use black for the text; otherwise use pale gray
    fill(col == currentColumn ? 0 : 64);
    text(title, runningX + tabPad, plotY1 - 10);
    
    runningX = tabRight[col];
  }
}

// draw the labels for the axis
void drawAxisLabels() {
  fill(0);
  textSize(13);
  textLeading(15);
  
  textAlign(CENTER, CENTER);
  text("Gallons\nconsumed\nper capita", labelX, (plotY1 + plotY2) / 2);
  
  textAlign(CENTER);
  text("Year", (plotX1 + plotX2) / 2, labelY);
}


// draw the labels for the years
void drawYearLabels () {
  fill(0);
  textSize(10);
  textAlign(CENTER, TOP);
  
  // use thin grey lines to draw the grid
  stroke(224);
  strokeWeight(1);
  
  for (int row = 0; row < rowCount; row++) {
    if (years[row] % yearInterval == 0) {
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      text(years[row], x, plotY2 + 10);
      line(x, plotY1, x, plotY2);
    }
  }
}


// draw the labels for the volumes
void drawVolumeLabels () {
  fill(0);
  textSize(10);
  //
  stroke(128);
  strokeWeight(1);
  
  for (float v = dataMin; v <= dataMax; v += volumeIntervalMinor) {
    float y = map(v, dataMin, dataMax, plotY2, plotY1);
    if (v % volumeInterval == 0) { // if a major tick mark
      if (v == dataMin) {
        textAlign(RIGHT); // align by the bottom
      } else if (v == dataMax) {
        textAlign(RIGHT, TOP); // align to the top
      } else {
        textAlign(RIGHT, CENTER); // center vertically
      }
      text(floor(v), plotX1 - 10, y);
      line(plotX1 - 4, y, plotX1, y); // draw major tick
    } else {
      line(plotX1 - 2, y, plotX1, y); // draw major tick
    }
  }
}


// draw the data as a series of points
void drawDataPoints(int col) {
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      //float value = data.getFloat(row, col);
      float value = interpolators[row].value;
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      point(x, y);
    }
  }
}


// draw the data as a line
void drawDataLine(int col) {
  noFill();
  beginShape();
  for (int row = 0; row < rowCount; row++) {
    if (data.isValid(row, col)) {
      //float value = data.getFloat(row, col);
      float value = interpolators[row].value;
      float x = map(years[row], yearMin, yearMax, plotX1, plotX2);
      float y = map(value, dataMin, dataMax, plotY2, plotY1);
      curveVertex(x, y);
    }
  }
  endShape();
}


// change between graphs
void keyPressed() {
  if (key == '[') {
    currentColumn--;
    if (currentColumn < 0) {
      currentColumn = columnCount - 1;
    }
  } else if (key == ']') {
    currentColumn++;
    if (currentColumn == columnCount) {
      currentColumn = 0;
    }
  }
}

void mousePressed() {
  if (mouseY > tabTop && mouseY < tabBottom) {
    for (int col = 0; col < columnCount; col++) {
      if (mouseX > tabLeft[col] && mouseX < tabRight[col]) {
        setColumn(col);
      }
    }
  }
}

void setColumn(int col) {
  if (col != currentColumn) {
    currentColumn = col;
  }
  for (int row = 0; row < rowCount; row++) {
    interpolators[row].target(data.getFloat(row, col));
  }
}

