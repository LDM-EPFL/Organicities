Obj createModule(Pts basicLine,Pts basicLineUp,Pts basicLineSlab,Pts basicLineSlabUp){
  Obj ruban = new Obj();

  CSpline curve = new CSpline(basicLine,6);
  ((CSpline)curve).closedMode = true;
  ((CSpline)curve).mode = CSpline.NEXT;
  Pts curveUniform = curve.getPts(numberOfPts);

  Pts curveMidDown = new Pts();
  for(int i = 0; i<curveUniform.numOfPts(); i+=8)
    curveMidDown.add(curveUniform.pt(i));

  CSpline curveSlab = new CSpline(basicLineSlab,6);
  ((CSpline)curveSlab).closedMode = true;
  ((CSpline)curveSlab).mode = CSpline.NEXT;
  Pts curveUniformSlab = curveSlab.getPts(numberOfPts);

  CSpline curveUp = new CSpline(basicLineUp,6);
  ((CSpline)curveUp).closedMode = true;
  ((CSpline)curveUp).mode = CSpline.NEXT;
  Pts curveUniformUp = curveUp.getPts(numberOfPts);

  Pts curveMidUp = new Pts();
  for(int i = 0; i<curveUniform.numOfPts(); i+=8)
    curveMidUp.add(curveUniformUp.pt(i));

  CSpline curveSlabUp = new CSpline(basicLineSlabUp,6);
  ((CSpline)curveSlabUp).closedMode = true;
  ((CSpline)curveSlabUp).mode = CSpline.NEXT;
  Pts curveUniformSlabUp = curveSlabUp.getPts(numberOfPts);

 // ruban.add(curveUniform);
  curveUniform.stroke(255,0,0);
  //ruban.add(curveUniformUp);
  curveUniformUp.stroke(0,255,0);

  int p = 16*(int)random(2);
  //println(p);

  //ParamLength di = new ParamLength(curveWithPointsUniformUptrans.pt(1),curveWithPointsUniformUp.pt(1));

  //println(di);


  Pts extDown = new Pts();
  Pts intDown = new Pts();
  Pts extUp = new Pts();
  Pts intUp = new Pts();



  //Param offdivext = new ParamDiv(offext,4);
  //Param offdivint = new ParamDiv(offint,4);



  ////////////////////////////////////////////////////
  ///////////////////////////////////////////////////
  Obj etageMid = new Obj();
  Pts midtemp = new Pts();
  Pts mid = new Pts();

  ////// calcul des points millieux entre les 2 courbes
  for(int i = 0; i<curveUniform.numOfPts(); i++){
    Pts etageMidtemp = new Pts();
    etageMidtemp = new PtsMid(curveUniform.pt(i),curveUniformUp.pt(i),2); 
    etageMid.add(etageMidtemp);
  }

  for(int i=0; i<curveUniform.numOfPts(); i+=8)
    mid.add(etageMid.line(i).pt(1));

  //for(int i=0; i<curveUniform.numOfPts(); i++)
  //ruban.add(mid);

  ///////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////

  Param offext;

  for(int i = 0 ; i<=curveUniform.numOfPts(); i++){

    if( i<2*curveUniform.numOfPts()/3){
      offext = new Param(1+sin(i*(PI/(2*curveUniform.numOfPts()/3))));
    }
    else 
    { 
      offext = new Param(1);
    } 

    Transform OffsetOut = new Transform();
    OffsetOut.translate(zero,zero,offext);

    Transform Offset3Pts = new Transform(curveUniform.pt((i)%curveUniform.numOfPts()),curveUniformSlab.pt((i)%curveUniform.numOfPts()),curveUniform.pt((i+1)%curveUniform.numOfPts()), OffsetOut);
    Transform Offset3PtsUp = new Transform(curveUniformUp.pt((i)%curveUniform.numOfPts()),curveUniformSlabUp.pt((i)%curveUniform.numOfPts()),curveUniformUp.pt((i+1)%curveUniform.numOfPts()), OffsetOut);
    Pt OffsetPt = Pt.create(curveUniform.pt((i)%curveUniform.numOfPts()));
    Pt OffsetPtUp = Pt.create(curveUniformUp.pt((i)%curveUniform.numOfPts()));
    OffsetPt.apply(Offset3Pts);
    OffsetPtUp.apply(Offset3PtsUp);
    extDown.add(OffsetPt);
    extUp.add(OffsetPtUp);
  }


  Param offint;
  for(int i = 0 ; i<=curveUniform.numOfPts(); i++){
    if( i<2*curveUniform.numOfPts()/3)
      offint = new Param(-1-sin(i*(PI/(2*curveUniform.numOfPts()/3))));
    else 
    { 
      offint = new Param(-1);
    }  
    Transform OffsetInt = new Transform();
    OffsetInt.translate(zero,zero,offint); 

    Transform Offset3Pts = new Transform(curveUniform.pt((i)%curveUniform.numOfPts()),curveUniformSlab.pt((i)%curveUniform.numOfPts()),curveUniform.pt((i+1)%curveUniform.numOfPts()), OffsetInt);
    Transform Offset3PtsUp = new Transform(curveUniformUp.pt((i)%curveUniform.numOfPts()),curveUniformSlabUp.pt((i)%curveUniform.numOfPts()),curveUniformUp.pt((i+1)%curveUniform.numOfPts()), OffsetInt);
    Pt OffsetPt = Pt.create(curveUniform.pt((i)%curveUniform.numOfPts()));
    Pt OffsetPtUp = Pt.create(curveUniformUp.pt((i)%curveUniform.numOfPts()));
    OffsetPt.apply(Offset3Pts);
    OffsetPtUp.apply(Offset3PtsUp);
    intDown.add(OffsetPt);
    intUp.add(OffsetPtUp);
  }

  Obj tempPts = new Obj();
  Pts slabint = new Pts();
  Pts slabext = new Pts();
  /*
  for(int i =3; i<=curveWithPointsUniform.numOfPts(); i+=16){
   slabint.add( intDown.pt(i));
   slabint.add( intDown.pt(i+1));
   slabint.add( intDown.pt(i+2));
   slabint.add( curveWithPointsUniform.pt((i+5)%curveWithPointsUniform.numOfPts()));
   slabint.add( curveWithPointsUniform.pt((i+8)%curveWithPointsUniform.numOfPts()));
   slabint.add( curveWithPointsUniform.pt((i+9)%curveWithPointsUniform.numOfPts()));
   slabint.add( curveWithPointsUniform.pt((i+10)%curveWithPointsUniform.numOfPts()));
   slabint.add( curveWithPointsUniform.pt((i+13)%curveWithPointsUniform.numOfPts()));
   }
   
   for(int i =3; i<curveWithPointsUniform.numOfPts(); i+=16){  
   slabext.add( curveWithPointsUniform.pt(i));
   slabext.add( curveWithPointsUniform.pt(i+1));
   slabext.add( curveWithPointsUniform.pt(i+2));
   slabext.add( curveWithPointsUniform.pt((i+5)%curveWithPointsUniform.numOfPts()));
   slabext.add( extDown.pt((i+8)%curveWithPointsUniform.numOfPts()));
   slabext.add( extDown.pt((i+9)%curveWithPointsUniform.numOfPts()));
   slabext.add( extDown.pt((i+10)%curveWithPointsUniform.numOfPts()));
   slabext.add( curveWithPointsUniform.pt((i+13)%curveWithPointsUniform.numOfPts()));
   }
   */


  Obj curveDownGroup = new Obj();
  for(int i = 3 ; i<curveUniform.numOfPts(); i+=16){ 
    Pts temp = new Pts();
    temp.add(curveUniform.pt(i));
    temp.add(curveUniform.pt(i+1));
    temp.add(curveUniform.pt(i+2));
    temp.stroke(0,0,255);
    curveDownGroup.add(temp);
  }


  Obj curveUpGroup = new Obj();
  for(int i = 3 ; i<curveUniform.numOfPts(); i+=16){ 
    Pts temp = new Pts();
    temp.add(curveUniformUp.pt(i));
    temp.add(curveUniformUp.pt(i+1));
    temp.add(curveUniformUp.pt(i+2));
    temp.stroke(0,0,255);
    curveUpGroup.add(temp);
  }
 


  Obj extDownGroup = new Obj();
  for(int i = 11 ; i<curveUniform.numOfPts(); i+=16){ 
    Pts temp = new Pts();
    temp.add(extDown.pt(i));
    temp.add(extDown.pt(i+1));
    temp.add(extDown.pt(i+2));
    temp.stroke(0,0,255);
    extDownGroup.add(temp);
  }
 


  Obj extUpGroup = new Obj();
  for(int i = 11 ; i<curveUniform.numOfPts(); i+=16){ 
    Pts temp = new Pts();
    temp.add(extUp.pt(i));
    temp.add(extUp.pt(i+1));
    temp.add(extUp.pt(i+2));
    temp.stroke(0,0,255);
    extUpGroup.add(temp);
  }


  Pts Slab1 = new Pts();
  for(int i = 1 ; i<3; i++)
    Slab1.add(curveDownGroup.line(13).pt(i));
  Slab1.add(curveMidDown.pt(27));
  for(int i = 0 ; i<3; i++)
    Slab1.add(extDownGroup.line(13).pt(i));
  Slab1.add(curveMidDown.pt(28));
  for(int i = 0 ; i<3; i++)
    Slab1.add(curveDownGroup.line(14).pt(i));
  Slab1.add(curveMidDown.pt(29));
  for(int i = 0 ; i<3; i++)
    Slab1.add(extDownGroup.line(14).pt(i));
  Slab1.add(curveMidDown.pt(0));
  for(int i = 0 ; i<3; i++)
    Slab1.add(curveDownGroup.line(0).pt(i));
  Slab1.add(curveMidDown.pt(1));
  for(int i = 0 ; i<3; i++)
    Slab1.add(extDownGroup.line(0).pt(i));
  Slab1.add(mid.pt(2));
  for(int i = 0 ; i<3; i++)
    Slab1.add(curveUpGroup.line(1).pt(i));
  Slab1.add(curveMidUp.pt(3));
  for(int i = 0 ; i<3; i++)
    Slab1.add(extUpGroup.line(1).pt(i));
  Slab1.add(mid.pt(4));
  for(int i = 0 ; i<2; i++)
    Slab1.add(curveDownGroup.line(2).pt(i));
 
  ruban.add(Slab1);

  Pts Slab2 = new Pts();
  for(int i = 1 ; i<3; i++)
    Slab2.add(extUpGroup.line(2).pt(i));
  Slab2.add(curveMidUp.pt(6));
  for(int i = 0 ; i<3; i++)
    Slab2.add(curveUpGroup.line(3).pt(i));
  Slab2.add(curveMidUp.pt(7));
  for(int i = 0 ; i<3; i++)
    Slab2.add(extUpGroup.line(3).pt(i));
  Slab2.add(mid.pt(8));
  for(int i = 0 ; i<3; i++)
    Slab2.add(curveDownGroup.line(4).pt(i));
  Slab2.add(curveMidDown.pt(9));
  for(int i = 0 ; i<3; i++)
    Slab2.add(extDownGroup.line(4).pt(i));
  Slab2.add(curveMidDown.pt(10));
  for(int i = 0 ; i<3; i++)
    Slab2.add(curveDownGroup.line(5).pt(i));
  Slab2.add(curveMidDown.pt(11));
  for(int i = 0 ; i<3; i++)
    Slab2.add(extDownGroup.line(5).pt(i));
  Slab2.add(curveMidDown.pt(12));
  for(int i = 0 ; i<3; i++)
    Slab2.add(curveDownGroup.line(6).pt(i));
  Slab2.add(curveMidDown.pt(13));
  for(int i = 0 ; i<3; i++)
    Slab2.add(extDownGroup.line(6).pt(i));
  Slab2.add(mid.pt(14));
  for(int i = 0 ; i<3; i++)
    Slab2.add(curveUpGroup.line(7).pt(i));
  Slab2.add(curveMidUp.pt(15));
  for(int i = 0 ; i<3; i++)
    Slab2.add(extUpGroup.line(7).pt(i));
  Slab2.add(curveMidUp.pt(16));
  for(int i = 0 ; i<3; i++)
    Slab2.add(curveUpGroup.line(8).pt(i));
  Slab2.add(curveMidUp.pt(17));
  for(int i = 0 ; i<3; i++)
    Slab2.add(extUpGroup.line(8).pt(i));
  Slab2.add(mid.pt(18));
  for(int i = 0 ; i<3; i++)
    Slab2.add(curveDownGroup.line(9).pt(i));
  Slab2.add(curveMidDown.pt(19));
  for(int i = 0 ; i<3; i++)
    Slab2.add(extDownGroup.line(9).pt(i));
  Slab2.add(curveMidDown.pt(20));
  for(int i = 0 ; i<3; i++)
    Slab2.add(curveDownGroup.line(10).pt(i));
  Slab2.add(curveMidDown.pt(21));
  for(int i = 0 ; i<3; i++)
    Slab2.add(extDownGroup.line(10).pt(i));
  Slab2.add(mid.pt(22));
  for(int i = 0 ; i<3; i++)
    Slab2.add(curveUpGroup.line(11).pt(i));
  Slab2.add(curveMidUp.pt(23));
  for(int i = 0 ; i<3; i++)
    Slab2.add(extUpGroup.line(11).pt(i));
  Slab2.add(curveMidUp.pt(24));
  for(int i = 0 ; i<3; i++)
    Slab2.add(curveUpGroup.line(12).pt(i));
  Slab2.add(curveMidUp.pt(25));
  for(int i = 0 ; i<2; i++)
    Slab2.add(extUpGroup.line(12).pt(i));
  ruban.add(Slab2);

  Pts Slab3 = new Pts();
  for(int i = 1 ; i<3; i++)
    Slab3.add(curveDownGroup.line(13).pt(i));
  Slab3.add(mid.pt(27));
  for(int i = 0 ; i<3; i++)
    Slab3.add(extUpGroup.line(13).pt(i));
  Slab3.add(curveMidUp.pt(28));
  for(int i = 0 ; i<3; i++)
    Slab3.add(curveUpGroup.line(14).pt(i));
  Slab3.add(curveMidUp.pt(29));
  for(int i = 0 ; i<3; i++)
    Slab3.add(extUpGroup.line(14).pt(i));
  Slab3.add(curveMidUp.pt(0));
  for(int i = 0 ; i<3; i++)
    Slab3.add(curveUpGroup.line(0).pt(i));
  Slab3.add(curveMidUp.pt(1));
  for(int i = 0 ; i<3; i++)
    Slab3.add(extUpGroup.line(0).pt(i));
  Slab3.add(curveMidUp.pt(2));
  for(int i = 0 ; i<2; i++)
    Slab3.add(curveUpGroup.line(1).pt(i));
  ruban.add(Slab3);


  Pts Slab4 = new Pts();

  for(int i = 1 ; i<3; i++)
    Slab4.add(extUpGroup.line(3).pt(i));
  Slab4.add(curveMidUp.pt(8));
  for(int i = 0 ; i<3; i++)
    Slab4.add(curveUpGroup.line(4).pt(i));
  Slab4.add(curveMidUp.pt(9));
  for(int i = 0 ; i<3; i++)
    Slab4.add(extUpGroup.line(4).pt(i));
  Slab4.add(curveMidUp.pt(10));
  for(int i = 0 ; i<3; i++)
    Slab4.add(curveUpGroup.line(5).pt(i));
  Slab4.add(curveMidUp.pt(11));
  for(int i = 0 ; i<3; i++)
    Slab4.add(extUpGroup.line(5).pt(i));
  Slab4.add(mid.pt(12));
  for(int i = 0 ; i<2; i++)
    Slab4.add(curveDownGroup.line(6).pt(i));
  ruban.add(Slab4);
  ////////////////////////// Diagonale1 ///////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////
  /*Obj diagonale1ext = new Obj();
   for(int i = 4+p ; i<curveWithPointsUniform.numOfPts(); i+=32){
   int j = i/8;
   Pts temp = new Pts();
   temp.add(extDown.pt(i));
   temp.add(extDown.pt(i+1));
   temp.add(mid.pt((j+1)%curveWithPointsUniform.numOfPts()));
   temp.add(curveWithPointsUniformUp.pt((i+7)%curveWithPointsUniform.numOfPts()));
   temp.add(curveWithPointsUniformUp.pt((i+8)%curveWithPointsUniform.numOfPts()));
   temp.stroke(0,255,0);
   diagonale1ext.add(temp);
   }
   //ruban.add(diagonale1ext);
   
   slabext.stroke(255,0,0); 
   slabint.stroke(0,255,0); 
   
   //ruban.add(slabext);
   //ruban.add(slabint);
   //ruban.add(extDown);
   //ruban.add(extUp);
   //ruban.add(intDown);
   //ruban.add(intUp);
   
   //ruban.add(basicLine);
   //ruban.add(basicLineUp);
   */
  return ruban;
}
