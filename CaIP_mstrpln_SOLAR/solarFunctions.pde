//SUN CALCULATION AND REPRESENTATION

//****************
//  CALCULATE SUN POSITION
Pt getCurrentSunVec(int mnth,int dy,float hr,float[][] vecArr){
  float scl=100;
  int[] mnthArr = {31,28,31,30,31,30,31,31,30,31,30,31};
  //49 LINES HALF-HOURS)FOR EVERY MONTH
  
  //GET VECTOR FOR 1ST OF MONTH (convert to 48 half hour time)
  PVector vecMnth00 = interpolateMinutes(vecArr, mnth,hr*2);

    //GET VECTOR FOR 1ST OF FOLLOWING MONTH (convert to 48 half hour time)
  PVector vecMnth01 = interpolateMinutes(vecArr,mnth+1,hr*2);
   
  //INTERPOLATE BRACKETING MONTHS TO CURRENT DAY
  PVector vecdiff=PVector.sub(vecMnth01,vecMnth00);
  float dayRatio =float(dy-1)/ float(mnthArr[mnth-1]-1);
  dayRatio = min(1.0,dayRatio);

  PVector vecIntrp = PVector.mult(vecdiff, dayRatio);
  PVector sunVec = PVector.add(vecMnth00,vecIntrp);
  Pt sunOUT=Anar.Pt(sunVec.x*scl, sunVec.y*scl ,sunVec.z*scl );
  return sunOUT;
}


PVector interpolateMinutes(float[][] vecArr,int mnth, float currTime){
  //GET LINE FOR 1ST OF CURRENT MONTH AT BRACKETING HALF HOURS
  int PrevLine=(((mnth-1) * 49) + floor(currTime)) % vecArr.length;
  int PostLine=(((mnth-1) * 49) + ceil(currTime+.05)) % vecArr.length;
  
  //GET VECTOR FOR BRACKETING HALF HOURS
  PVector vec00 =new PVector(vecArr[PrevLine][0],vecArr[PrevLine][1],vecArr[PrevLine][2]);
  PVector vec01 =new PVector(vecArr[PostLine][0],vecArr[PostLine][1],vecArr[PostLine][2]);


  //VECTOR BETWEEN BRACKETING HALF HOURS 
  PVector vecdiff =PVector.sub(vec01,vec00);
       
  //COEFFICIENT TO MULTIPLY vecdiff FOR INTERPOLATION
  float mins = currTime-floor(currTime);
  PVector vecIntrp = PVector.mult(vecdiff,mins);
  PVector vecMnth = PVector.add(vec00,vecIntrp);
  
  return vecMnth;
}



//****************
//    DRAW LINE OF SUN ANGLE
void showCurrentSunVec(Pt s, Pts sL){
  if (s.z()>0){ sL.stroke(250,200,0);  
  strokeWeight(4);
  sL.draw();
  }else { sL.stroke(150,0,255); }
  strokeWeight(1);
}



//****************
//    CONSTRUCT SUN DOME FOR HOURLY VARIATION
void hourlySunDome(float[][] vecArr, Obj sD){
  float scl=100;
  Pts temp=new Pts();
  for(int i=0; i<vecArr.length; i++){
    if (floor(i/49) > floor((i-1)/49)){
      temp.stroke(250,250,0,150);
      sD.add(temp);
      temp=new Pts(); 
    }
    if (vecArr[i][2] > 0) { temp.add(Anar.Pt(vecArr[i][0]*scl,vecArr[i][1]*scl,vecArr[i][2]*scl)); }
  }
}

//    CONSTRUCT SUN DOME FOR MONTHLY VARIATION
void monthlySunDome(float[][] vecArr, Obj sD){
  float scl=100;
  
  for(int i=0; i<49; i+=2){
    if (vecArr[i][2] > 0) {
      Pts temp=new Pts();
      for(int j=0; j<12; j++){
        int mnth=j*49;
        temp.add(Anar.Pt(vecArr[i+mnth][0]*scl,vecArr[i+mnth][1]*scl,vecArr[i+mnth][2]*scl));
      }
      temp.stroke(250,200,0,150);
      sD.add(temp);
    }
     
  }
}



//GET EXTRUDE HEIGHT
  void getExtrHt(Pt SunPos, HEM m, Pt apex, int i, Obj exF){
    color faceColor =color(0,80);
    float Zval=0;
    float dotprod = Pt.dot(SunPos,m.fN[i]);
    float ang = acos(dotprod/(SunPos.length()*m.fN[i].length() ));
    // TRANSLATING Z VALUE
    //  REPLACE ang WITH THE AVERAGE ANGLE
      ang = degrees(ang) ;   
      faceColor= color((90-ang)*3, 0, (ang)*1.5, 120 );
              if (((90-ang)>=0) && (90-ang)<=30) {
                Zval=(ang/4);
              }
              if (((90-ang)>30) && ((90-ang)<=50)){
                Zval=(ang*.6);
                faceColor= color((90-ang)*3.2,(90-ang),(ang)/2, 120 );
              }
             if (((90-ang)>50) && ((90-ang)<=80)){
                Zval=(ang);
                faceColor= color((90-ang)*2.5,(90-ang)*1.5,(ang)/2, 120 );
              }   
              if ((90-ang)>80  && ((90-ang)<=85)){
                Zval=(2*ang);                        
                faceColor= color((90-ang)*2.8,(90-ang)*1.8,(ang)/3, 120 );
               }           
              if ((90-ang)>85){
                Zval=(3*ang);              
                faceColor= color((90-ang)*3,(90-ang)*2,0, 120 );
               }
              if (ang>90) {
                Zval=-3;
                faceColor= color(0, 0,80, 120 );
               }
               
    exF.face((i*5)+3).fill(red(faceColor),green(faceColor),blue(faceColor));
    exF.face((i*5)+4).fill(red(faceColor),green(faceColor),blue(faceColor));
    apex.translateZ((Zval/2)-9);
  }
