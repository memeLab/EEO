void input() {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    float inByte = float(inString);

    // monitor input
    if (inByte >= tempMin && inByte <= tempMax) {
      println("Temp in: " + inByte);
    } else if (inByte >= p1min && inByte <= p1max) {
      println("P1 in:   " + inByte);
    } else if (inByte >= p2min && inByte <= p2max) {
      println("P2 in:   " + inByte);     
    } else if (inByte >= p3min && inByte <= p3max) {
      println("P3 in:   " + inByte);   
    }     
    
    // move the content to the left
    for (int x = 0; x < timeMax-1; x++) {
      temp[x] = temp[x+1];
      p1[x] = p1[x+1];
      p2[x] = p2[x+1];
      p3[x] = p3[x+1];
    }
    
    // put the input in the right array
    if (inByte >= tempMin && inByte <= tempMax) {
      temp[timeMax-1] = int(map(inByte, tempMin, tempMax, plotY2, plotY1));
      println("Temp out: " + temp[timeMax-1]);
    } else if (inByte >= p1min && inByte <= p1max) {
      p1[timeMax-1] = int(map(inByte, p1min, p1max, plotY2, plotY1));
      println("P1 out:   " + p1[timeMax-1]);
    } else if (inByte >= p2min && inByte <= p2max) {
      p2[timeMax-1] = int(map(inByte, p2min, p2max, plotY2, plotY1));
      println("P2 out:   " + p2[timeMax-1]);     
    } else if (inByte >= p3min && inByte <= p3max) {
      p3[timeMax-1] = int(map(inByte, p3min, p3max, plotY2, plotY1));
      println("P3 out:   " + p3[timeMax-1]);       
    } 
  }
}
