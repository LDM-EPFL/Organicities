void readTxtData_POINTS(String[] s, Pt[] p) {
  for(int i=0; i<s.length; i++) {
    String[] vals = splitTokens(s[i], ", ");
    float x = float(vals[0]);
    float y = -1*float(vals[1]);
    float z = float(vals[2]);
    p[i]= Anar.Pt(x,y,z);
  }
}
