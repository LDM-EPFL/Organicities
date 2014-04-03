/*************
Mesh Section
	http://codequotidien.wordpress.com/2011/12/11/mesh-section/
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
void sectionHEM(HEM m, int n, Pt o, PVector N, Obj section){
   Pts seg=new Pts();

   //STARTPOINT OF EDGE IS VERTEX[EDGE ORIGIN VERTEX[n]]
   Pt st=m.v[m.eOV[n]];
   //ENDPOINT OF EDGE IS VERTEX[edge ORIGIN VERTEX of[edge NEXT EDGE[n]]]
   Pt en= m.v[m.eOV[m.eNE[n]]];
   float v=-10;
   float u= intersectLINEPLANE(st,en,o,N,seg);
    if (u>=0 && u<=1){ //intPt IS INTERSECTION POINT (i.e. INTERSECTIOIN OCCURS BETWEEN START (u=0) AND END (u=1) OF EDGE)
     //GO TO sectionTWIN WHERE 
        v=sectionTWIN(m,n,o,N,seg);
   }

   if (v>=0 && v<=1){
   //  SET COLOR
   seg.stroke(255,0,0);   
   section.add(seg);
   }
}
//ELSE EDGE DOES NOT INTERSECT


float sectionTWIN(HEM m, int n, Pt o, PVector N, Pts seg){
    float u=-10;
     int x=m.eNE[n];
     while(x != n){
       
      u=-10;
      u=intersectLINEPLANE( m.v[m.eOV[x]], m.v[m.eOV[m.eNE[x]]],o,N,seg );
      if (u>=0 && u<=1){
              //LOOP THROUGH NEXT EDGES AROUND TWIN'S FACE? 
        int twnNdx = m.eTE[x];
        if (twnNdx>=0){ sectionTWIN(m,twnNdx,o,N,seg);  }
        x=n;
      } else { x=m.eNE[x]; }
      
     } 
return u;
}


//SOURCE: http://local.wasp.uwa.edu.au/~pbourke/geometry/planeline/
float intersectLINEPLANE(Pt Pt1, Pt Pt2, Pt Pt3, PVector N, Pts sect){
  PVector v3=new PVector( Pt3.x()-Pt1.x(), Pt3.y()-Pt1.y(), Pt3.z()-Pt1.z() );
  PVector v2=new PVector( Pt2.x()-Pt1.x(), Pt2.y()-Pt1.y(), Pt2.z()-Pt1.z() ); 
 float numerator = PVector.dot(N,v3);
 float denominator = PVector.dot(N,v2); 
  
 float u=-10;
 if (denominator != 0){
   u = numerator/denominator;
   v2.mult(u);
    if (u>=0 && u<=1){
       /*
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
        */
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

  float[] u= {-10,-10};
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


int[] ptptConnection(Pt Pt1, Pt Pt2, int f1, HEM m, Pts seg){
  float[] u = {-10,-10};
  //START POINT
  Pt zVec=Anar.Pt(0,0,1);
  PVector N=new PVector(m.fN[f1].x()- m.fC[f1].x(), m.fN[f1].y()- m.fC[f1].y(), m.fN[f1].z()- m.fC[f1].z() );
  float zVal=intersectVECPLANE(Pt1, zVec, m.fC[f1], N);
       Pt iPt=Anar.Pt(Pt1.x(), Pt1.y(), Pt1.z()+zVal );
       //seg.add(iPt);
  
  //n = FIRST TEST EDGE
  int n=m.fIE[f1];
  int x=n;
  int lastX=x;
  int ct=0;
  // FOR TRIANGLES
  while (ct < 3){
  u=intersectLINELINE2D(Pt1, Pt2, m.v[m.eOV[x]],  m.v[m.eOV[m.eNE[x]]], seg);
  //println(u[0] +" : "+ u[1]);
     if (u[1]>0 && u[1]<1 && u[0]>0 && u[0]<1){
        //move to twin
        int twnNdx = m.eTE[x];
        if (twnNdx>=0){ lastX=connectionTWIN(m, twnNdx, seg, Pt2);} else { lastX=x; }
        break;
     } else { x=m.eNE[x]; }
     ct++;  
  }
  //seg.stroke(0);

  //END POINT
  int f2=m.eIF[lastX];
  
 N=new PVector(m.fN[f2].x()- m.fC[f2].x(), m.fN[f2].y()- m.fC[f2].y(), m.fN[f2].z()- m.fC[f2].z() );
  zVal=intersectVECPLANE(Pt2, zVec, m.fC[f2], N);
       iPt=Anar.Pt(Pt2.x(), Pt2.y(), Pt2.z()+zVal );
       //seg.add(iPt);


  int[] retFE= {m.eIF[x], x};
  return retFE;
}


int connectionTWIN(HEM m, int n, Pts seg, Pt Pt2){
    float[] u = {-10,-10};
     int x=m.eNE[n];
     int lastX=x;
     while(x != n){
      u=intersectLINELINE2D(seg.ptEnd(), Pt2, m.v[m.eOV[x]],   m.v[m.eOV[m.eNE[x]]], seg);
      if (u[1]>0 && u[1]<1 && u[0]>0 &&u[0]<1){
              //LOOP THROUGH NEXT EDGES AROUND TWIN'S FACE? 
        int twnNdx = m.eTE[x];
        if (twnNdx>=0){ lastX=connectionTWIN(m, twnNdx, seg, Pt2);  } else { lastX=x; }
        x=n;
        break;
      } else { x=m.eNE[x]; }
      
     } 
return lastX;
}


int[] faceID(Pt Pt2, HEM m){
   int f1 = ceil(m.f.length/2); 
   Pt PtA=m.v[m.eOV[m.fIE[f1]]];
   Pt PtB=m.v[m.eOV[m.eNE[m.fIE[f1]]]];
   Pt PtC=m.v[m.eOV[m.eNE[m.eNE[m.fIE[f1]]]]];
  
   Pts seg=new Pts(Anar.Pt((PtA.x()+PtB.x()+PtC.x())/3,(PtA.y()+PtB.y()+PtC.y())/3,(PtA.z()+PtB.z()+PtC.z())/3  ));

   float[] u = {-10,-10};
  //seg.add( m.f[f1].center() );
  //n = FIRST TEST EDGE
  int n=m.fIE[f1];
  int x=n;
  int lastX=x;
  int ct=0;
  while (ct < 3){
  u=intersectLINELINE2D(seg.getPt(0), Pt2, m.v[m.eOV[x]],  m.v[m.eOV[m.eNE[x]]], seg);
  //  u=intersectLINELINE2D(m.f[f1].center(), Pt2, m.v[m.eOV[x]],  m.v[m.eOV[m.eNE[x]]], seg);
     if (u[1]>0 && u[1]<1 && u[0]>0 && u[0]<1){
        //move to twin
         lastX=connectionTWIN(m, m.eTE[x], seg, Pt2);
        break;
     } else { x=m.eNE[x]; }
     ct++;  
  }

  //RETURNS THE INDEX OF THE IncidentFace, INDEX OF LAST VALID Edge 
  //(IF POINT IS OFF OF THE MESH, THE LAST Face AND Edge IN THE DIRECTION OF THE POINT IN THIS CASE, THE LAST Edge's TwinEdge INDEX WILL BE -10
  int[] retFE= {m.eIF[lastX], lastX};
  return retFE;
}


