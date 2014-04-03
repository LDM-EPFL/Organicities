//IMPORT TEXT FILES

//****************
//  INDEXED MESH TYPE (verticesIN, indicesIN, coordinatesOUT, face-vertex indicesOUT)
  void  ReadTxtData_ARRAYONLY(String[] v, String[] n, float[][] coords, ArrayList[] ndx){
  //       EACH LINE OF v SPECIFIES COORDINATE VALUES FOR A VERTEX
  for(int i=0; i<v.length; i++){
     //    GET POINT COORDINATES OF INDEXED VERTEX
     String[] vVals = splitTokens(v[i], ", ");
     //    ADD VALUES TO coords[]
     coords[i][0]= float(vVals[0]) ;
     coords[i][1]=  -float(vVals[1]);
     coords[i][2]=  float(vVals[2])*1;
  }
  
  //-----CREATE FACES FROM POINTS-----
  //       EACH LINE OF n SPECIFIES INDEX VALUES FOR A FACE
  for(int i=0; i<n.length; i++){
    //     GET INDIVIDUAL INDEX VALUES
    String[] nVals = splitTokens(n[i], ", ");
   ndx[i]=new ArrayList();
   for(int j=0; j<nVals.length; j++){
       //ADD INDEX TO ARRAYLIST (NOT ARRAY TO ALLOW MIX OF FACE POLYGONS)
       ndx[i].add(int(nVals[j]));
   }
  }
  
  }
  
//****************  
//IMPORT POLYLINE ARRRAYS
    void ReadTxtData_VERTEX(String[] s, Obj p){
  for(int i=1; i<s.length; i+=3){
   String[] xVals = splitTokens(s[i], ", ");
   String[] yVals = splitTokens(s[i+1], ", ");
   String[] zVals = splitTokens(s[i+2], ", ");
   
   Pts pTmp=new Pts();
   for(int j=0; j<xVals.length; j++){
     float x = float(xVals[j]);
     float y = -float(yVals[j]);
     float z = float(zVals[j]);

     pTmp.add(Anar.Pt(x,y,z));
   }
   p.add(pTmp);
   
  }
  }
  
  
  
//****************
//  ANNUAL SOLAR POSITIONS(stringIN, coordinatesOUT)
  void readTxtData_SOLARVEC(String[] s, float[][] coords){
    //       EACH LINE OF s SPECIFIES COORDINATE VALUES FOR HALFHOUR
    for(int i=0; i<s.length; i++){
     //    GET POINT COORDINATES OF INDEXED VERTEX
     String[] sVals = splitTokens(s[i], ", ");
     //    ADD VALUES TO coords[]
     coords[i][0]= float(sVals[2]);
     coords[i][1]=  float(sVals[3])*-1;
     coords[i][2]=  float(sVals[4]);
  }
  }
 
  

//****************
//  ANNUAL WIND DATA(stringIN, coordinatesOUT)
  void readTxtData_WINDVEC(String[] w, float[][] coords){
    //       EACH LINE OF s SPECIFIES COORDINATE VALUES FOR HALFHOUR
    for(int i=0; i<w.length; i++){
     //    GET POINT COORDINATES OF INDEXED VERTEX
     String[] wVals = splitTokens(w[i], ", ");
     //    ADD VALUES TO coords[]
     coords[i][0]=  float(wVals[4]);
     coords[i][1]=  float(wVals[5]);
     coords[i][2]=  float(wVals[6]);
     coords[i][3]=  float(wVals[7]);
  }
  }
  
  
//**************
// MONTHLY WIND DATA OVER 9 YEARS

void readTxtData_WINDMONTHVEC(String[] wm, float[][] coords){
    //       EACH LINE OF s SPECIFIES COORDINATE VALUES FOR HALFHOUR
    for(int i=0; i<wm.length; i++){
     //    GET POINT COORDINATES OF INDEXED VERTEX
     String[] wmVals = splitTokens(wm[i], ", ");
     //    ADD VALUES TO coords[]
     coords[i][0]= int(wmVals[0]);
     coords[i][1]=  float(wmVals[1]);
     coords[i][2]=  int(wmVals[2]);
    
  }
  }
