//  INDEXED MESH TYPE (verticesIN, indicesIN, coordinatesOUT, face-vertex indicesOUT)
void  readTxtData_ARRAYONLY(String[] v, String[] n, float[][] coords, ArrayList[] ndx) {
  //       EACH LINE OF v SPECIFIES COORDINATE VALUES FOR A VERTEX
  for(int i=0; i<v.length; i++) {
    //    GET POINT COORDINATES OF INDEXED VERTEX
    String[] vVals = splitTokens(v[i], ", ");
    //    ADD VALUES TO coords[]
    coords[i][0]= float(vVals[0]) ;
    coords[i][1]=  -float(vVals[1]);
    coords[i][2]=  float(vVals[2])*2;
  }

  //-----CREATE FACES FROM POINTS-----
  //       EACH LINE OF n SPECIFIES INDEX VALUES FOR A FACE
  for(int i=0; i<n.length; i++) {
    //     GET INDIVIDUAL INDEX VALUES
    String[] nVals = splitTokens(n[i], ", ");
    ndx[i]=new ArrayList();
    for(int j=0; j<nVals.length; j++) {
      //ADD INDEX TO ARRAYLIST (NOT ARRAY TO ALLOW MIX OF FACE POLYGONS)
      ndx[i].add(int(nVals[j]));
    }
  }
}
