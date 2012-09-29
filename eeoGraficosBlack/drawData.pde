// draw the data
void drawData() {
  noFill();
  strokeWeight(10);

  // temp (blue)
  stroke(0, 0, 255);
  beginShape();
  for (int x = time; x < timeMax; x++) point(x, temp[x]);
  endShape();

  // p1 (green)
  stroke(0, 255, 0);
  beginShape();
  for (int x = time; x < timeMax; x++) point(x, p1[x]);
  endShape();

  // p2 (yellow)
  stroke(255, 255, 0);
  beginShape();
  for (int x = time; x < timeMax; x++) point(x, p2[x]);
  endShape();

  // p3 (red)
  stroke(255, 0, 0);
  beginShape();
  for (int x = time; x < timeMax; x++) point(x, p3[x]);
  endShape();
}
