void readTxtData_VERTEX(String[] s, Pts[] p) {
  for(int i=0; i<s.length; i+=3) {
    String[] xVals = splitTokens(s[i], ", ");
    String[] yVals = splitTokens(s[i+1], ", ");
    String[] zVals = splitTokens(s[i+2], ", ");

    p[i/3]=new Pts();
    for(int j=0; j<xVals.length; j++) {
      float x = float(xVals[j]);
      float y = -1*float(yVals[j]);
      float z = float(zVals[j]);

      p[i/3].add(Anar.Pt(x,y,z));
    }
    p[i/3].stroke(50);
  }
}
