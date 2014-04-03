/*************
Mesh Import from .txt file
	http://codequotidien.wordpress.com/2011/10/09/mesh-import/
***************/

/*************
Created by Trevor Patt: http://codequotidien.wordpress.com/

Code licensed under Creative Commons license
any use, alteration, or redistribution is permitted under the following restrictions:
	attribution of the original script may not be misrepresented
	derivative works must be labeled as such
	derivative works must made open under an identical license
Script originally written for MxD Organicités Studio: Ras Al Khaimah: Fall 2010. (0113-11)
	http://design.epfl.ch/organicites/2010b/
***************/

  void  ReadTxtData_INDEXEDMESH(String[] v, String[] n, float[][] coords, ArrayList[] ndx){
  //       EACH LINE OF v SPECIFIES COORDINATE VALUES FOR A VERTEX
  println("# Vertices: "+v.length);
  println("# Faces: "+n.length);
  
  for(int i=0; i<v.length; i++){
     //    GET POINT COORDINATES OF INDEXED VERTEX
     String[] vVals = splitTokens(v[i], ", ");
     //    ADD VALUES TO coords[]
     coords[i][0]= float(vVals[0]) ;
     coords[i][1]=  -float(vVals[1]);
     coords[i][2]=  float(vVals[2]);
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
