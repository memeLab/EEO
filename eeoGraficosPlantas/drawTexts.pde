// draw the title of the current plot
void drawTitle() {
  fill(0);
  textSize(20);
  textAlign(LEFT);
  String title = "Experimentações Eletro-Orgânicas";
  text(title, plotX1, plotY1 - 10);
}


// draw the labels for the axis
void drawAxisLabels() {
  fill(0);
  textSize(13);
  textLeading(15);
  
  textAlign(CENTER, CENTER);
  text("Intensidade\n(%)", labelX, (plotY1 + plotY2) / 2);
  
  textAlign(CENTER);
  text("Tempo", (plotX1 + plotX2) / 2, labelY);
}


// draw the labels for the volumes
void drawVolumeLabels () {
  fill(0);
  textSize(10);
  
  stroke(128);
  strokeWeight(1);
  
  for (float v = intensityMin; v <= intensityMax; v += intensityIntervalMinor) {
    float y = map(v, intensityMin, intensityMax, plotY2, plotY1);
    if (v % intensityInterval == 0) { // if a major tick mark
      if (v == intensityMin) {
        textAlign(RIGHT); // align by the bottom
      } else if (v == intensityMax) {
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
