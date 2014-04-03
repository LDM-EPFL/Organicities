float[] getCurrentWindVec(int mnth,int dy,int hr,float[][] vecArr) {
  int[] mnthArr = {31,28,31,30,31,30,31,31,30,31,30,31};
  int[] mnthSum = {0,31,59,90, 120, 151,181,212,243,273, 304,334  }   ;
  //vecArr[n][spd,ang,temp,hmd]

  int ndx = mnthSum[mnth]*24 + (dy-1)*24 + hr;
  float rad = radians(vecArr[ndx][1]);
  //Pt WindVec = Anar.Pt(sin (rad)*vecArr[ndx][0], -(cos (rad))*vecArr[ndx][0], vecArr[ndx][2]);
  
  //valout[vecX,vecY, spd,ang,temp,hmd]
  float[] valOut={sin (rad)*vecArr[ndx][0],  -(cos (rad))*vecArr[ndx][0], vecArr[ndx][0],vecArr[ndx][1],vecArr[ndx][2], vecArr[ndx][3]};
  return valOut;
} 

float[] getMonthlyWindVec(int ndx,float[][] vecArr) {
  //vecArr[n][spd,ang]
  float rad = radians(vecArr[ndx][1]+random(-4.5,4.5) );

  //valout[vecX,vecY, spd,ang]
  float[] valOut={sin (rad)*vecArr[ndx][0],  -(cos (rad))*vecArr[ndx][0], vecArr[ndx][0],vecArr[ndx][1],};
  return valOut;
}


//****************
//    DRAW LINE OF WIND ANGLE
void showCurrentWindVec(Pt o, Pt wX, float t){
  float scl=30;
  Pt w=Anar.Pt(wX.x()*scl ,wX.y()*scl ,0);
  w.translate(o);
  Pts windLine = new Pts(o,w);
  if (t>0){
  windLine.stroke((t-15)*10, 0, (20-(t-15))*10); 
  }
  strokeWeight(4);
  windLine.draw();
  strokeWeight(1);
}



//****************
//    CONSTRUCT WIND ROSE FOR CURRENT DAY
void dailyWindRose(int mnth,int dy,float[][] vecArr, Obj wR, Pt o){
  float scl=30;
  int[] mnthSum = {0,31,59,90, 120, 151,181,212,243,273, 304,334  }   ;
  Pts edg = new Pts();
  for(int i=0; i<24; i++){
      int ndx = mnthSum[mnth]*24 + (dy-1)*24+i;
      float rad = radians(vecArr[ndx][1]);
      Pt w = Anar.Pt(sin (rad)*vecArr[ndx][0]*scl +o.x(), -(cos (rad))*vecArr[ndx][0]*scl +o.y(),o.z());
      
      Pts temp=new Pts();
      temp.add(o.x(), o.y(), o.z());
      temp.add(w);
      temp.stroke((vecArr[ndx][2]-15)*10, 0, (20-(vecArr[ndx][2]-15))*10,150);
      
      wR.add(temp);//new Pts(o,w));
  }
}


//****************
//    WIND
void windPaths(Pt wVec, HEM m, Obj allTrace,float t, float spd, Obj ht){
 //CONSTRUCT PTARC
 //Pt windPt=Anar.Pt();
 Pt zVec=Anar.Pt(0,0,1);

 //CREATE SEMI-CIRCLE OF INITIAL POINTS 
 float ang = atan(-wVec.x()/wVec.y());
 if (wVec.y()>0) {ang+=PI; }
   if(wVec.length()>0){
 //for (int i=0; i<windPt.length; i++){
    ang+=t*(radians(180/40));
    Pt windPt=Anar.Pt(2000+cos(ang)*3000,500+sin(ang)*3000,0);


    Obj trace=new Obj();
    
   //FIND LANDING POINT
   //FIND FACEID, IF LAST EDGE IS NOT OUTSIDE EDGE, THEN PT IS ON MESH, OTHERWISE MOVE IN AGAIN
    for (int j=0; j<500; j++){
     windPt=Anar.Pt(windPt.x()+(1*wVec.x()),windPt.y()+(1*wVec.y()),windPt.z()+(1*wVec.z()) );

    int[] fID=faceID(windPt,m);
    
    if (m.eTE[fID[1]]>0){  
       PVector N=new PVector(m.fN[fID[0]].x(), m.fN[fID[0]].y(), m.fN[fID[0]].z() );
       float u=intersectVECPLANE(windPt, zVec,m.fC[fID[0]], N);
       Pt planePt=Anar.Pt(windPt.x(),windPt.y(),windPt.z()+u);
       //trace.add(planePt);
       windCont(m, planePt, trace, wVec,wVec, fID, ht );
       break;
    }
    }
  allTrace.add(trace);
  //}
 }else{println("NO WIND"); }
 println("end");
}


void windCont (HEM m, Pt stpt,Obj trc, Pt vVec, Pt wVec, int[] ndx, Obj ht){
  //FIRST LOOP AROUND FACE TO FIND NEXT EDGE INTERSECTION IN DIRECTION OF WIND
  int x=ndx[1];
  int prevE=-10;
  Pt newVec=Anar.Pt(vVec.x(), vVec.y(), vVec.z());
  
  //CALL LOOPFACE TO FIND u={U0,U1,EDGE}
   float[] u= loopFace(m,vVec,stpt, ndx[1], true);
   float[] uNew={vVec.x(), vVec.y(), vVec.z(), u[2]};
   
  Pts seg=new Pts(stpt);
  //FIND POINT ON EDGE x, CHECK ABOVE/BELOW
  edgeInt( m, seg, vVec, u,ht);
  u[2]=m.eTE[int(u[2])];
  trc.add(seg);  
  Pt enpt=seg.ptEnd();
  
  seg=new Pts(enpt);
  while(int(u[2])>=0){
   prevE=m.eTE[int(u[2])];
   u=loopFace(m,newVec,enpt, int(u[2]), false);
   //u=loopFace(m,newVec,seg.ptEnd(), int(u[2]), false);
   if (u[1]>0 && u[1]<1 && u[0]>0 ){
     uNew =edgeInt( m, seg, newVec, u, ht);
     trc.add(seg);
     enpt=seg.ptEnd(); 
     seg=new Pts(enpt); 
     //if(int(uNew[3])!=int(u[2])){
     //  u[2]=uNew[3];
     
     newVec=Anar.Pt(uNew[0]+wVec.x()/2, uNew[1]+wVec.y()/2,uNew[2]+wVec.z()*1.4);
     //newVec=Anar.Pt(uNew[0]+wVec.x()/2, uNew[1]+wVec.y()/2,uNew[2]+wVec.z());
     
     newVec.multiply(wVec.length()/newVec.length());
     //}
   }
   u[2]=m.eTE[int(u[2])];
   if(u[2]==prevE){println("EXPLODE"); break; }
   
  }
  
}



float[] edgeInt(HEM m, Pts seg, Pt vec, float[] u, Obj ht){
  float[] retVal={vec.x(), vec.y(), vec.z(), u[2]};
  
  int eNdx=int(u[2]);
   Pt Pt3=m.v[m.eOV[eNdx]];
   Pt Pt4= m.v[m.eOV[m.eNE[eNdx]]];
  
   Pt v1=Anar.Pt((Pt4.x()-Pt3.x())*u[1], (Pt4.y()-Pt3.y())*u[1], (Pt4.z()-Pt3.z())*u[1]);
   Pt iPt=Anar.Pt(Pt3.x()+v1.x(), Pt3.y()+v1.y(), Pt3.z()+v1.z() );
 
   Pt v0=Anar.Pt((vec.x())*u[0], (vec.y())*u[0], (vec.z())*u[0]) ;
   Pt vPt=Anar.Pt(seg.ptEnd().x()+v0.x(), seg.ptEnd().y()+v0.y(), seg.ptEnd().z()+v0.z() );

       
   if(vPt.z()<iPt.z()) {
     //VECTOR GOES BELOW FACE
     PVector nVec=faceInt(m,seg,vec,m.eIF[eNdx]);
     Pt sqPt = Anar.Pt(seg.ptEnd().x()-7.5, seg.ptEnd().y()-7.5, seg.ptEnd().z());
     ht.add(new Square(sqPt,15).stroke(255,0,0,200));
     //CHANGE VECTOR
     float d=seg.ptEnd().length(iPt);
     nVec.mult(vec.length()/nVec.mag() );
     //println(nVec.z );
     
     //Pt newVec=Anar.Pt(vec.x()+nVec.x/3, vec.y()+nVec.y/3, vec.z()+(nVec.z/20));
     Pt newVec=Anar.Pt(iPt.x()-seg.ptEnd().x()+nVec.x/6, iPt.y()-seg.ptEnd().y()+nVec.y/6,(iPt.z()-seg.ptEnd().z())*.75 );
     
     //float[] uNew=loopFace(m,newVec, seg.ptEnd(), int(u[2]), false);
     //println(uNew[2]);
     //edgeONLY( m, seg, newVec, uNew);
     retVal[0]= newVec.x();
     retVal[1]= newVec.y();
     retVal[2]= newVec.z();
     //retVal[3]= uNew[2];
     seg.add(iPt);
   } else {
     if (vPt.z()-iPt.z()<40) {
         PVector nVec=new PVector(m.fN[m.eIF[eNdx]].x(), m.fN[m.eIF[eNdx]].y(), m.fN[m.eIF[eNdx]].z() );
        
        float d=40-(vPt.z()-iPt.z());
        nVec.mult(d/nVec.mag() );
     
        Pt newVec=Anar.Pt(vec.x()+nVec.x/7 ,vec.y()+nVec.y/7, vec.z() );
        retVal[0]= newVec.x();
         retVal[1]= newVec.y();
         retVal[2]= newVec.z();
     }
     //VECTOR IS ABOVE FACE
     seg.add(vPt);
     int ckHt=50+round(vPt.z()-iPt.z())*4; //if (ckHt>250){ ckHt=250;}
     if (ckHt>265){
     seg.stroke(190,235,240);
       ht.add(new Pts(iPt, vPt).stroke(190,235,240 ));
     }else{
       if (ckHt>250){ ckHt=250;}
       seg.stroke( ckHt);
       ht.add(new Pts(iPt, vPt).stroke((ckHt )));
     }  
 }
return retVal;
}





void edgeONLY(HEM m, Pts seg, Pt vec, float[] u){
  int eNdx=int(u[2]);
   Pt Pt3=m.v[m.eOV[eNdx]];
   Pt Pt4= m.v[m.eOV[m.eNE[eNdx]]];
  
   Pt v1=Anar.Pt((Pt4.x()-Pt3.x())*u[1], (Pt4.y()-Pt3.y())*u[1], (Pt4.z()-Pt3.z())*u[1]);
   Pt iPt=Anar.Pt(Pt3.x()+v1.x(), Pt3.y()+v1.y(), Pt3.z()+v1.z() );
 
   Pt v0=Anar.Pt((vec.x())*u[0], (vec.y())*u[0], (vec.z())*u[0]) ;
   Pt vPt=Anar.Pt(seg.ptEnd().x()+v0.x(), seg.ptEnd().y()+v0.y(), seg.ptEnd().z()+v0.z() );
  
   if(vPt.z()<iPt.z()) {
     //VECTOR IS BELOW FACE
     seg.add(iPt);
   } else {
     //VECTOR IS ABOVE FACE
     seg.add(vPt);
   }
}




PVector faceInt(HEM m, Pts seg, Pt vec, int fNdx){
     PVector nVec=new PVector(m.fN[fNdx].x(), m.fN[fNdx].y(), m.fN[fNdx].z() );
   
   float u = intersectVECPLANE(seg.ptEnd(), vec, m.f[fNdx].center(), nVec);
   Pt vU=Anar.Pt((vec.x())*u, (vec.y())*u, (vec.z())*u) ;
   Pt iPt=Anar.Pt(seg.ptEnd().x()+vU.x(), seg.ptEnd().y()+vU.y(), seg.ptEnd().z()+vU.z() );  
             // new Circle(iPt,20).draw(); 
   seg.add(iPt);
   return nVec;
}



float[] loopFace(HEM m, Pt vec, Pt orgn, int ndx, boolean all){
  Pt Pt3; Pt Pt4;
  int e=ndx;
  int x=m.eNE[ndx];
  float[] u= {-10,-10};
  
  // CHECK EDGE eNdx IF TRUE
  if(all){
          Pt3=m.v[m.eOV[ndx]];
          Pt4= m.v[m.eOV[m.eNE[ndx]]];
          u= intersectLINEVEC2D(orgn, vec,Pt3, Pt4);
    
          if (u[1]>0 && u[1]<1 && u[0]>0){
            x=ndx;
            e=x;
          }
  }
  
 
  while (x!=ndx){
     Pt3=m.v[m.eOV[x]];
     Pt4= m.v[m.eOV[m.eNE[x]]];
                      
     u = intersectLINEVEC2D(orgn, vec,Pt3, Pt4);
                      
     if (u[1]>0 && u[1]<1 && u[0]>0 ) {
       e=x;
       x=ndx;
       break;
     } else { x=m.eNE[x]; }
  }
  
  float[] retVal={u[0],u[1],e};
  return retVal;
}

//***************************
//MONTHLY WIND DATA OVER 9 YEARS
//fonction gives the point for the wind vector to be drawn but also is calculating the dunemovement within it but returned into an object
Pt WindMonthlyMove (float[][] wmCoords, Pt [] PrevPt, int i, Obj DuneMove, Pts[]BDp1,Pts[]SDp2,Pts[]BDp3,Pts[]SDp4){
  //wmCoords(line, speed, angle)
 
  float rad = radians(wmCoords[i][2]);
  float b=20;// b value can varie, depending on how much movement we want the wind to be doing

  Pt wm = Anar.Pt(sin (rad)*wmCoords[i][1]*b +PrevPt[i-35].x(), -(cos (rad))*wmCoords[i][1]*b +PrevPt[i-35].y(),PrevPt[i-35].z());


  return wm;
}


