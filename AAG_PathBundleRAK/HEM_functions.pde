//sectionHEM FINDS PLANAR INTERSECTIONS WITH AN HEM
//THIS SHOULD BE IMPLEMENTED WITHIN A LOOP OF ALL EDGES < EG i<myMESH.e.numOfLines(); >
//sectionHEM(myMESH, INDEX i OF EDGE TO CHECK, ORIGIN OF PLANE, NORMAL OF PLANE, Obj TO CONTAIN SECTION Pts, TAG FOR Pts=0)
void sectionHEM(HEM m, int n, Pt o, PVector N, Obj section,int c) {
  Pts seg=new Pts();

  //STARTPOINT OF EDGE IS VERTEX[EDGE ORIGIN VERTEX[n]]
  Pt st=m.v[m.eOV[n]];
  //ENDPOINT OF EDGE IS VERTEX[edge ORIGIN VERTEX of[edge NEXT EDGE[n]]]
  Pt en= m.v[m.eOV[m.eNE[n]]];
  float v=-10;
  float u= intersectLINEPLANE(st,en,o,N,seg);
  if (u>=0 && u<=1) { //intPt IS INTERSECTION POINT
    //LOOP THROUGH NEXT EDGES AROUND FACE
    v=sectionTWIN(m,n,o,N,seg);
  }

  if (v>=0 && v<=1) {
    seg.stroke(0,200*c,255*c,200);   
    section.add(seg);
  }
}
//ELSE EDGE DOES NOT INTERSECT


float sectionTWIN(HEM m, int n, Pt o, PVector N, Pts seg) {
  float u=-10;
  int x=m.eNE[n];
  while(x != n) {
    u=-10;
    u=intersectLINEPLANE( m.v[m.eOV[x]], m.v[m.eOV[m.eNE[x]]],o,N,seg );
    if (u>=0 && u<=1) {
      //LOOP THROUGH NEXT EDGES AROUND TWIN'S FACE? 
      int twnNdx = m.eTE[x];
      if (twnNdx>=0) { 
        sectionTWIN(m,twnNdx,o,N,seg);
      }
      x=n;
    } 
    else { 
      x=m.eNE[x];
    }
  } 
  return u;
}

//SOURCE: http://local.wasp.uwa.edu.au/~pbourke/geometry/planeline/
float intersectLINEPLANE(Pt Pt1, Pt Pt2, Pt Pt3, PVector N, Pts sect) {
  PVector v3=new PVector( Pt3.x()-Pt1.x(), Pt3.y()-Pt1.y(), Pt3.z()-Pt1.z() );
  PVector v2=new PVector( Pt2.x()-Pt1.x(), Pt2.y()-Pt1.y(), Pt2.z()-Pt1.z() ); 
  float numerator = PVector.dot(N,v3);
  float denominator = PVector.dot(N,v2); 

  float u=-10;
  if (denominator != 0) {
    u = numerator/denominator;
    v2.mult(u);
    if (u>=0 && u<=1) {

      //iPt IS INTERSECTION POINT
      Pt iPt=Anar.Pt(Pt1.x()+v2.x, Pt1.y()+v2.y, Pt1.z()+v2.z );
      sect.add(iPt);

      // DRAW MARKER AS BOX
      Pt uPt=Anar.Pt(iPt.x()-5,iPt.y()-5, iPt.z()-5);
      noStroke(); 
      Box bb= new Box(uPt,8,8,40);
      bb.fill(0,150,250,100);
      bb.draw();

      // DRAW MARKER AS CIRCLE        
      //Circle cc= new Circle(uPt,.5);
      //cc.fill(0,150,250,50);
      //cc.draw(); 

      // DRAW MARKER AS POINT
      //iPt.fill(0,150,250,50); 
      //iPt.setSz(.25);
      //iPt.draw();
    }
  }
  return u;
}



//SOURCE: http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
float[] intersectLINELINE2D(Pt Pt1, Pt Pt2, Pt Pt3,  Pt Pt4, Pts sect) {
  PVector v2=new PVector( Pt4.x()-Pt3.x(), Pt4.y()-Pt3.y(), Pt4.z()-Pt3.z() ); 

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
    v2.mult(u[1]);
    if (u[1]>0 && u[1]<1 && u[0]>0 && u[0]<1) {
      //iPt IS INTERSECTION POINT
      Pt iPt=Anar.Pt(Pt3.x()+v2.x, Pt3.y()+v2.y, Pt3.z()+v2.z );
      sect.add(iPt);
    }
  }
  return u;
}



void ptptConnection(Pt Pt1, Pt Pt2, int f1, int f2, HEM m, Pts seg) {
  float[] u = {
    -10,-10
  };
  //seg.add(Pt1);
  //n = FIRST TEST EDGE
  int n=m.fIE[f1];
  int x=n;
  int ct=0;
  // FOR TRIANGLES
  while (ct < 3) {
    u=intersectLINELINE2D(Pt1, Pt2, m.v[m.eOV[x]],  m.v[m.eOV[m.eNE[x]]], seg);
    if (u[1]>0 && u[1]<1 && u[0]>0 && u[0]<1) {
      //move to twin
      connectionTWIN(m, m.eTE[x], seg, Pt2);
      break;
    } 
    else { 
      x=m.eNE[x];
    }
    ct++;
  }
  seg.stroke(250,0,0);
  //seg.add(Pt2);
}


int connectionTWIN(HEM m, int n, Pts seg, Pt Pt2) {
  float[] u = {
    -10,-10
  };
  int x=m.eNE[n];
  int lastX=x;
  while(x != n) {
    u=intersectLINELINE2D(seg.ptEnd(), Pt2, m.v[m.eOV[x]],   m.v[m.eOV[m.eNE[x]]], seg);
    if (u[1]>0 && u[1]<1 && u[0]>0 &&u[0]<1) {
      //LOOP THROUGH NEXT EDGES AROUND TWIN'S FACE? 
      int twnNdx = m.eTE[x];
      if (twnNdx>=0) { 
        lastX=connectionTWIN(m, twnNdx, seg, Pt2);
      } 
      else { 
        lastX=x;
      }
      x=n;
      break;
    } 
    else { 
      x=m.eNE[x];
    }
  } 
  return lastX;
}


int[] faceID(Pt Pt2, HEM m) {
  int f1 = ceil(m.f.length/2); 
  Pt PtA=m.v[m.eOV[m.fIE[f1]]];
  Pt PtB=m.v[m.eOV[m.eNE[m.fIE[f1]]]];
  Pt PtC=m.v[m.eOV[m.eNE[m.eNE[m.fIE[f1]]]]];

  Pts seg=new Pts(Anar.Pt((PtA.x()+PtB.x()+PtC.x())/3,(PtA.y()+PtB.y()+PtC.y())/3,(PtA.z()+PtB.z()+PtC.z())/3  ));

  float[] u = {
    -10,-10
  };
  //seg.add( m.f[f1].center() );
  //n = FIRST TEST EDGE
  int n=m.fIE[f1];
  int x=n;
  int lastX=x;
  int ct=0;
  while (ct < 3) {
    u=intersectLINELINE2D(seg.pt(0), Pt2, m.v[m.eOV[x]],  m.v[m.eOV[m.eNE[x]]], seg);
    //  u=intersectLINELINE2D(m.f[f1].center(), Pt2, m.v[m.eOV[x]],  m.v[m.eOV[m.eNE[x]]], seg);
    if (u[1]>0 && u[1]<1 && u[0]>0 && u[0]<1) {
      //move to twin
      lastX=connectionTWIN(m, m.eTE[x], seg, Pt2);
      break;
    } 
    else { 
      x=m.eNE[x];
    }
    ct++;
  }
  //seg.add(Pt2);
  //seg.draw();
  int[] retFE= {
    m.eIF[lastX], lastX
  };
  return retFE;
}

