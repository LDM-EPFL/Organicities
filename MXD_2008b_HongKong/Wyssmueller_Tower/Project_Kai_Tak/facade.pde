Obj createFacade(Pts basicLine,Pts basicLineUp,Pts basicLineSlab,Pts basicLineSlabUp){
  Obj ruban = new Obj();
  //////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////



  ///////////////////////////////////////////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////

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

  Obj curveDownGroupD = new Obj();
  for(int i = 11 ; i<curveUniform.numOfPts(); i+=16){ 
    Pts temp = new Pts();
    temp.add(curveUniform.pt(i));
    temp.add(curveUniform.pt(i+1));
    temp.add(curveUniform.pt(i+2));
    temp.stroke(0,0,255);
    curveDownGroupD.add(temp);
  }

  Obj curveUpGroupD = new Obj();
  for(int i = 11 ; i<curveUniform.numOfPts(); i+=16){ 
    Pts temp = new Pts();
    temp.add(curveUniformUp.pt(i));
    temp.add(curveUniformUp.pt(i+1));
    temp.add(curveUniformUp.pt(i+2));
    temp.stroke(0,0,255);
    curveUpGroupD.add(temp);
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

  Obj intDownGroup = new Obj();
  for(int i = 3 ; i<curveUniform.numOfPts(); i+=16){ 
    Pts temp = new Pts();
    temp.add(intDown.pt(i));
    temp.add(intDown.pt(i+1));
    temp.add(intDown.pt(i+2));
    temp.stroke(0,0,255);
    intDownGroup.add(temp);
  }

  Obj intUpGroup = new Obj();
  for(int i = 3 ; i<curveUniform.numOfPts(); i+=16){ 
    Pts temp = new Pts();
    temp.add(intUp.pt(i));
    temp.add(intUp.pt(i+1));
    temp.add(intUp.pt(i+2));
    temp.stroke(0,0,255);
    intUpGroup.add(temp);
  }


  Pts Slab1 = new Pts();
  for(int i = 1 ; i<3; i++)
    Slab1.add(curveUpGroup.line(3).pt(i));
  Slab1.add(mid.pt(7));
  for(int i = 0 ; i<3; i++)
    Slab1.add(extDownGroup.line(3).pt(i));
  Slab1.add(curveMidDown.pt(8));
  for(int i = 0 ; i<2; i++)
    Slab1.add(curveDownGroup.line(4).pt(i)); 
  ruban.add(Slab1);

  Pts Slab1int = new Pts();
  for(int i = 1 ; i<3; i++)
    Slab1int.add(intUpGroup.line(3).pt(i));
  Slab1int.add(mid.pt(7));
  for(int i = 0 ; i<3; i++)
   Slab1int.add(curveDownGroupD.line(3).pt(i));
  Slab1int.add(curveMidDown.pt(8));
  for(int i = 0 ; i<2; i++)
    Slab1int.add(intDownGroup.line(4).pt(i)); 
  ruban.add(Slab1int);

  ///////////////////////////////////////////////////////////////

  Pts Slab2 = new Pts();
  for(int i = 1 ; i<3; i++)
    Slab2.add(curveUpGroup.line(7).pt(i));
  Slab2.add(mid.pt(15));
  for(int i = 0 ; i<3; i++)
    Slab2.add(extDownGroup.line(7).pt(i));
  Slab2.add(curveMidDown.pt(16));
  for(int i = 0 ; i<2; i++)
    Slab2.add(curveDownGroup.line(8).pt(i));
  ruban.add(Slab2);  
  ////////////////////////////////////////////////////////////////
  Pts Slab2int = new Pts();
  for(int i = 1 ; i<3; i++)
    Slab2int.add(intUpGroup.line(7).pt(i));
  Slab2int.add(mid.pt(15));
  for(int i = 0 ; i<3; i++)
    Slab2int.add(curveDownGroupD.line(7).pt(i));
  Slab2int.add(curveMidDown.pt(16));
  for(int i = 0 ; i<2; i++)
    Slab2int.add(intDownGroup.line(8).pt(i));
  ruban.add(Slab2int);  
  ///////////////////////////////////////////////////////////////////////////

  Pts Slab3 = new Pts();
  for(int i = 1 ; i<3; i++)
    Slab3.add(curveUpGroup.line(10).pt(i));
  Slab3.add(mid.pt(21));
  for(int i = 0 ; i<2; i++)
    Slab3.add(extDownGroup.line(10).pt(i));
  ruban.add(Slab3); 

  Pts Slab3int = new Pts();
  for(int i = 1 ; i<3; i++)
    Slab3int.add(intUpGroup.line(10).pt(i));
  Slab3int.add(mid.pt(21));
  for(int i = 0 ; i<2; i++)
    Slab3int.add(curveDownGroupD.line(10).pt(i));
  ruban.add(Slab3int);

  Pts Slab4 = new Pts();
  for(int i = 1 ; i<3; i++)
    Slab4.add(extUpGroup.line(12).pt(i));
  Slab4.add(mid.pt(26));
  for(int i = 0 ; i<2; i++)
    Slab4.add(curveDownGroup.line(13).pt(i));
  ruban.add(Slab4);

  Pts Slab4int = new Pts();
  for(int i = 1 ; i<3; i++)
    Slab4int.add(curveUpGroupD.line(12).pt(i));
  Slab4int.add(mid.pt(26));
  for(int i = 0 ; i<2; i++)
    Slab4int.add(intDownGroup.line(13).pt(i));
  ruban.add(Slab4int);


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
