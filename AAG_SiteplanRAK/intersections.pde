
//**************** 
//SOURCE: http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
float[] intersectLINEVEC2D(Pt Pt1, Pt vec, Pt Pt3,  Pt Pt4) {
  //Pt Pt2=Pt1.plus(vec);
  Pt Pt2=Anar.Pt(Pt1.x()+vec.x(), Pt1.y()+vec.y(), Pt1.z()+vec.z());


  float numeratorA= ( (Pt4.x()-Pt3.x()) * (Pt1.y() - Pt3.y()) ) - ( (Pt4.y()-Pt3.y()) * (Pt1.x()-Pt3.x()) );
  float numeratorB= ( (Pt2.x()-Pt1.x()) * (Pt1.y() - Pt3.y()) ) - ( (Pt2.y()-Pt1.y()) * (Pt1.x()-Pt3.x()) );
  float denominator = ( (Pt4.y()-Pt3.y()) * (Pt2.x()-Pt1.x()) ) - ( (Pt4.x()-Pt3.x()) * (Pt2.y()-Pt1.y()) );

  float[] u= {
    -10,-10
  };
  if (denominator != 0) {
    u[0] = numeratorA/denominator; 
    u[1] = numeratorB/denominator;
  }
  return u;
}

//**************** 
//SOURCE: http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
float[] intersectLINELINE2D(Pt Pt1, Pt Pt2, Pt Pt3,  Pt Pt4) {

  float numeratorA= ( (Pt4.x()-Pt3.x()) * (Pt1.y() - Pt3.y()) ) - ( (Pt4.y()-Pt3.y()) * (Pt1.x()-Pt3.x()) );
  float numeratorB= ( (Pt2.x()-Pt1.x()) * (Pt1.y() - Pt3.y()) ) - ( (Pt2.y()-Pt1.y()) * (Pt1.x()-Pt3.x()) );
  float denominator = ( (Pt4.y()-Pt3.y()) * (Pt2.x()-Pt1.x()) ) - ( (Pt4.x()-Pt3.x()) * (Pt2.y()-Pt1.y()) );

  float[] u= {
    -10,-10
  };
  if (denominator != 0) {
    //POSITION ON SEGMENT12
    u[0] = numeratorA/denominator;
    //POSITION ON SEGMENT34
    u[1] = numeratorB/denominator;
  }
  return u;
}



//**************** 
//SOURCE: http://local.wasp.uwa.edu.au/~pbourke/geometry/planeline/
float intersectVECPLANE(Pt Pt1, Pt vec, Pt Pt3, PVector N) {
  //Pt Pt2=Pt1.plus(vec);
  Pt Pt2=Anar.Pt( Pt1.x()+vec.x(), Pt1.y()+vec.y(), Pt1.z()+vec.z() );

  PVector v3=new PVector( Pt3.x()-Pt1.x(), Pt3.y()-Pt1.y(), Pt3.z()-Pt1.z() );
  PVector v2=new PVector( Pt2.x()-Pt1.x(), Pt2.y()-Pt1.y(), Pt2.z()-Pt1.z() ); 
  float numerator = PVector.dot(N,v3);
  float denominator = PVector.dot(N,v2); 

  float u=-10;
  if (denominator != 0) {
    u = numerator/denominator;
  }
  return u;
}


//SOURCE: http://local.wasp.uwa.edu.au/~pbourke/geometry/planeline/
float intersectLINEPLANE(Pt Pt1, Pt Pt2, Pt Pt3, PVector N) {
  PVector v3=new PVector( Pt3.x()-Pt1.x(), Pt3.y()-Pt1.y(), Pt3.z()-Pt1.z() );
  PVector v2=new PVector( Pt2.x()-Pt1.x(), Pt2.y()-Pt1.y(), Pt2.z()-Pt1.z() ); 
  float numerator = PVector.dot(N,v3);
  float denominator = PVector.dot(N,v2); 

  float u=-10;
  if (denominator != 0) {
    u = numerator/denominator;
  }

  return u;
}

PVector doubleCross(PVector vecN, PVector vec) {
  PVector zVec=new PVector(0,0,1);
  PVector vecTemp =zVec.cross(vecN);
  PVector vecOut=vecTemp.cross(vec);

  //if (acos(vec.dot(vecOut)/(vec.mag*vecOut.mag)) > PI/2) { vecOut.mult(-1); }

  return vecOut;
}
