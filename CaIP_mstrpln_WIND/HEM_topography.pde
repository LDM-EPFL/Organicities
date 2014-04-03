void castVector(HEM m, int vNdx, Pt vec, Obj castLine, Obj castSlice, Obj castFace, char type) {
  float ang=( vec.z()/vec.length() );
  //FIND EDGE WHICH cast INTERSECTS FROM VERTEX vNdx
  //n IS INCIDENT EDGE INDEX TO v[vNdx] 
  int n=m.vIE[vNdx];
  int a=m.vIE[vNdx];
  Pts castPath= new Pts();
  castPath.add(m.v[vNdx]);

  //x IS TEST NEXT EDGE INDEX IN CHAIN
  int x=m.eNE[n];
  while(x != n) {
  //  DUMMY VALUES OF u[]
  float[] u= {-10,-10};
    //castLINEVEC3D(vertex, vector, test edge's Origin Vertex, test edge's Next Edge's Origin Vertex, polyline, angle, face Index, HEM)
    u=castLINEVEC3D(m.v[vNdx], vec, m.v[m.eOV[x]], m.v[m.eOV[m.eNE[x]]],castPath,ang,m.eIF[x], m);
    //IF INTERSECTS WITHIN SEGMENT
    if (u[1]>0 && u[1]<1 && u[0]>0) {

      if (castPath.numOfPts()>1){
      //LOOP THROUGH NEXT EDGES AROUND TWIN'S FACE? 

      if (m.eTE[x]>=0){ 
        int eNdx=castTWIN(m,m.eTE[x],vec,castPath,ang, castFace, type);  
        if (type=='s'){castFace.add( m.f[m.eIF[x]].fill(0,120));}
        if (type=='w'){castFace.add( m.f[m.eIF[x]].fill(0,100,250,120));}
        Face partF = new Face();
        //!!!!  fix ePE  !!!!!
        partF.add(m.v[m.eOV[eNdx]]);  partF.add(m.v[m.eOV[m.eNE[m.eNE[eNdx]]]]); partF.add(castPath.ptEnd());
        if (type=='s'){partF.fill(0,60);}
        if (type=='w'){partF.fill(0,200,250,60);}
        castFace.add(partF);
      }
      //SHADOWS
      castPath.stroke(0,150);
      castLine.add(castPath);
      
      Face shdwFace=new Face(castPath);
      if (type=='s'){ shdwFace.fill(60, 82,90,100); }
      if (type=='w'){ shdwFace.fill(60, 82,90,100); }
      castSlice.add(shdwFace);

      }
      
      break;
    } 
    else { 
      if (m.eNE[x]!=a) { 
        x=m.eNE[x];
      } 
      else { 
        if ( m.eTE[x]>=0) {
          a=m.eTE[x];
          x=m.eTE[x];
        } 
        else {
          break;
        }
      }
    }
  }
}


int castTWIN(HEM m, int n, Pt vec, Pts sect, float ang, Obj castFace, char type){
     int x=m.eNE[n];
     int lastE=x;
     float[] u= {-10,-10};
     int ct=sect.numOfPts();
     while(x != n){
      u=castLINEVEC3D(sect.getPt(ct-1), vec, m.v[m.eOV[x]], m.v[m.eOV[m.eNE[x]]],sect,ang,m.eIF[x], m);
      if (u[1]>0 && u[1]<1 && u[0]>0){
        lastE=x;
        //RECURSE THROUGH NEXT EDGES AROUND TWIN'S FACE? 
        if (sect.numOfPts()>ct && m.eTE[x]>=0){lastE = castTWIN(m, m.eTE[x], vec,sect,ang, castFace, type);  }
              Face castF = new Face( m.f[m.eIF[x]] );
              if (type=='s'){castF.fill(0,80);}
              if (type=='w'){castF.fill(0,200,250,80);}
              castFace.add(castF);
        break;
      } else { x=m.eNE[x]; }
      
     } 
return lastE;
}


//SOURCE: http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/
float[] castLINEVEC3D(Pt Pt1, Pt vec, Pt Pt3,  Pt Pt4, Pts sect,float ang, int fNdx, HEM m) {
  float[] u={-10,-10};
  u= intersectLINEVEC2D(Pt1, vec,Pt3, Pt4);

    if (u[1]>0 && u[1]<1 && u[0]>0 ) {
      Pt v2=Anar.Pt((Pt4.x()-Pt3.x())*u[1], (Pt4.y()-Pt3.y())*u[1], (Pt4.z()-Pt3.z())*u[1]) ;

      //iPt IS INTERSECTION POINT
      Pt iPt=Anar.Pt(Pt3.x()+v2.x(), Pt3.y()+v2.y(), Pt3.z()+v2.z() );
      
      if (iPt.z()-sect.getPt(0).z()<ang*iPt.length(sect.getPt(0))){
        
        sect.add(iPt);
      } else {
        Pt nPt=Anar.Pt(m.f[fNdx].normal().x()- m.f[fNdx].center().x(), m.f[fNdx].normal().y()- m.f[fNdx].center().y(), m.f[fNdx].normal().z()- m.f[fNdx].center().z() );
        castVECPLANE(sect.getPt(0), vec, m.f[fNdx].center(), nPt, sect);
        u[0]=-10;        
      }
    }
  return u;
}


//SOURCE: http://local.wasp.uwa.edu.au/~pbourke/geometry/planeline/
float castVECPLANE(Pt Pt1, Pt vec, Pt Pt3, Pt N, Pts sect){
    PVector nVec=new PVector(N.x(),N.y(), N.z() );
    float u = intersectVECPLANE(Pt1, vec, Pt3, nVec);    

    if (u>=0){
       vec=Anar.Pt(vec.x()*u, vec.y()*u, vec.z()*u);
       //iPt IS INTERSECTION POINT
       Pt iPt=Anar.Pt(Pt1.x()+vec.x(), Pt1.y()+vec.y(), Pt1.z()+vec.z() );
       sect.add(iPt);
    }
return u;
}




//****************  
void faceDrain(HEM m, int vNdx, Pts path){
  int ct=path.numOfPts();
  float minAng=0;
  int minF=-10;
   int eOut=-10;
    Pt ptOut=m.v[vNdx];
  //FOR GIVEN VERTEX, FIND STEEPEST DOWNHILL ON ADJACENT FACES
  
  //TEST INITIAL FACE
 int eNdx=m.vIE[vNdx];
 int fNdx=m.eIF[eNdx];


  
 Pt fNorm=m.f[fNdx].center().minus(m.f[fNdx].normal());
 //fNorm=Anar.Pt(-fNorm.x(),-fNorm.y(), -fNorm.z());
 Pts testPts=new Pts();
 Pt Pt3= m.e[m.eNE[eNdx]].getPt(0); Pt Pt4= m.e[m.eNE[eNdx]].getPt(1);
 float[] u=intersectLINEVEC2D(m.v[vNdx], fNorm,Pt3, Pt4);
 if (u[1]>=0 && u[1]<=1 && u[0]>0 ) {
   
   Pt v2=Anar.Pt((Pt4.x()-Pt3.x())*u[1], (Pt4.y()-Pt3.y())*u[1], (Pt4.z()-Pt3.z())*u[1]) ;
   //iPt IS INTERSECTION POINT
   Pt iPt=Anar.Pt(Pt3.x()+v2.x(), Pt3.y()+v2.y(), Pt3.z()+v2.z() );
   float testZ=iPt.z()-m.v[vNdx].z();
        //println(Pt3.z()+" : "+Pt4.z()+" : "+m.v[vNdx].z());

   float testAng= testZ / m.v[vNdx].length(iPt) ;
   if (testAng<minAng){
     minAng=testAng;
     minF=fNdx;
     ptOut=iPt;
     eOut=m.eNE[eNdx];
   }
 }
  if (m.eTE[eNdx]>=0){
  //NEXT EDGE (x) IS NEXT-EDGE OF EDGE-TWIN
   int x=m.eNE[m.eTE[eNdx]];
   int nextF=m.eIF[x];

   //LOOP THROUGH NEXT EDGES LEAVING VERTEX UNTIL RETURN TO ORIGINAL
   while(x != eNdx){
     fNorm=Anar.Pt(m.f[nextF].center().x()-m.f[nextF].normal().x(), m.f[nextF].center().y()-m.f[nextF].normal().y(), m.f[nextF].center().z()-m.f[nextF].normal().z()  );
     Pt3= m.e[m.eNE[x]].getPt(0);   Pt4= m.e[m.eNE[x]].getPt(1);

     u=intersectLINEVEC2D( m.v[vNdx], fNorm, m.e[m.eNE[x]].getPt(0),  m.e[m.eNE[x]].getPt(1));
     
     if (u[1]>=0 && u[1]<=1 && u[0]>0 ) {

       Pt v2=Anar.Pt((Pt4.x()-Pt3.x())*u[1], (Pt4.y()-Pt3.y())*u[1], (Pt4.z()-Pt3.z())*u[1]) ;
       //iPt IS INTERSECTION POINT
       Pt iPt=Anar.Pt(Pt3.x()+v2.x(), Pt3.y()+v2.y(), Pt3.z()+v2.z() );
       float testZ=iPt.z()-m.v[vNdx].z();
     
      if (testZ < 0){
      float testAng= testZ /   m.v[vNdx].length(iPt) ;
       if (testAng<minAng){
         minAng=testAng;
         minF=nextF;
         ptOut=iPt;
         eOut=m.eNE[x];
        
       }
      }
     } 
     
      if (m.eTE[x]>=0) { x=m.eNE[m.eTE[x]]; nextF=m.eIF[x];
      } else {break;}
   }
 
  if (minF>=0){ 
   path.add(ptOut);
   m.f[minF].draw();
   //RECURSE
   if (m.eTE[eOut]>=0){ drainTWIN(m, m.eTE[eOut],path); }
   } 
   }


   if (path.numOfPts()==ct){
     int minV=-10;
     float minZ=m.v[vNdx].z();
     
     //CHECK FIRST LEAVING EDGE
     if(m.v[m.eOV[m.eNE[eNdx]]].z()<minZ){
       minV=m.eOV[m.eNE[eNdx]];
       minZ=m.v[m.eOV[m.eNE[eNdx]]].z();
     }
     
     if(m.eTE[eNdx]>=0){
     //LOOP THROUGH REMAINING LEAVING EDGES
     int x=m.eNE[m.eTE[eNdx]];

     while(x != eNdx){

       if(m.v[m.eOV[m.eNE[x]]].z()<minZ){
         minV=m.eOV[m.eNE[x]];
         minZ=m.v[m.eOV[m.eNE[x]]].z();
       } 
       
       if (m.eTE[x]>=0){ x=m.eNE[m.eTE[x]] ; } else { break;}
      }
     
     }
     
     if(minV>=0){
       path.add(m.v[minV]);
       faceDrain(m, minV, path);
     }
   }

}

int drainTWIN(HEM m, int n, Pts sect){
     int x=m.eNE[n];
     int lastE=x;
     float[] u= {-10,-10};
     int ct=sect.numOfPts();
     Pt fNorm=m.f[m.eIF[n]].center().minus(m.f[m.eIF[n]].normal());
     
     while(x != n){
      Pt Pt3= m.v[m.eOV[x]]; Pt Pt4= m.v[m.eOV[m.eNE[x]]];
      u=intersectLINEVEC2D(sect.getPt(ct-1), fNorm, m.v[m.eOV[x]], m.v[m.eOV[m.eNE[x]]]);
      
      if (u[1]>=0 && u[1]<=1 && u[0]>0){
         Pt v2=Anar.Pt((Pt4.x()-Pt3.x())*u[1], (Pt4.y()-Pt3.y())*u[1], (Pt4.z()-Pt3.z())*u[1]) ;
         //iPt IS INTERSECTION POINT
         Pt iPt=Anar.Pt(Pt3.x()+v2.x(), Pt3.y()+v2.y(), Pt3.z()+v2.z() );

        if (iPt.z()<sect.getPt(ct-1).z()){ sect.add(iPt);  //
        lastE=x;
        //RECURSE THROUGH NEXT EDGES AROUND TWIN'S FACE? 
        if (m.eTE[x]>=0){lastE = drainTWIN(m, m.eTE[x], sect);     }
        }
        break;
      } else { x=m.eNE[x]; }
     
   }
   if (sect.numOfPts()==ct){ 
     int xCont=-10;
                 //println(m.v[m.eOV[x]].z() +" < "+m.v[m.eOV[m.eNE[x]]].z());
     if (m.v[m.eOV[x]].z() < m.v[m.eOV[m.eNE[x]]].z() ){ xCont=m.eOV[x]; }
     if (m.v[m.eOV[x]].z() > m.v[m.eOV[m.eNE[x]]].z() ){  xCont=m.eOV[m.eNE[x]]; }
     if (xCont>=0){
     sect.add(m.v[xCont]);
      //println(m.v[xCont].z()); println(" ");
     faceDrain(m, xCont, sect);
     }
   }
     
return lastE;
}






//****************  
int edgeDrain(HEM m, int vNdx, Pts path){
  float minAng=0;
  int minE=-10;
  //FOR GIVEN VERTEX, FIND STEEPEST DOWNHILL INCIDENT EDGE LEAVING VERTEX
  
  //TEST INITIAL EDGE
  int eNdx=m.vIE[vNdx];
  int nextVndx=m.eOV[m.eNE[eNdx]];
  float testZ= (m.e[eNdx].getPt(1).z()-m.e[eNdx].getPt(0).z());
      if (testZ<0){      
        float testAng= testZ / m.e[eNdx].length() ;
        if (testAng<minAng){ minAng=testAng; minE=eNdx; }
      } //else {if (testZ==0){m.e[eNdx].stroke(0,200,250).draw(); } }
 if (m.eTE[eNdx]>=0){
 int x=m.eNE[m.eTE[eNdx]];
 //LOOP THROUGH NEXT EDGES AROUND VERTEX UNTIL RETURN TO ORIGINAL
 while(x != eNdx){
      float deltZ= (m.e[x].getPt(1).z()-m.e[x].getPt(0).z());
      if (deltZ<0){      
        float ang= deltZ / m.e[x].length() ;
        if (ang<minAng){ minAng=ang; minE=x; }
      } //else {if (deltZ==0){m.e[x].stroke(0,200,250).draw(); } }
      if (m.eTE[x]>=0) { x=m.eNE[m.eTE[x]];
      } else {break;} 
 }
 
 if (minE>=0){ 
   nextVndx=  m.eOV[m.eNE[minE]] ;
   path.add(m.v[nextVndx]);
   nextVndx=edgeDrain(m, nextVndx, path);
 } else { nextVndx=vNdx; }

 }
 
  return(nextVndx);
}
