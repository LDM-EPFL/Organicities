//////////////////////////////////////////////////////////////////
//FLOORS
//////////////////////////////////////////////////////////////////
void floors(){
  petalfloor = new Obj();
  corefloor = new Obj();


  //creating petal floor
  for (int i=0;i<bones.numOfLines();i++){
    Face petal = new Face();

    double len = Pt.length(bones.line(i).pt(1),bones.line(i).pt(2));
    int thickness = 4;

    if (len > (thickness+1)*sub){
      int division = floor(((float)len/sub-thickness)/((float)len/sub)*100);
      PtMid pt1 = new PtMid(bones.line(i).pt(2),bones.line(i).pt(1),100,division);
      PtMid pt2 = new PtMid(bones.line(i).pt(2),bones.line(i).pt(3),100,division);

      PtMid ptIn1 = new PtMid(bones.line(i).pt(0),new PtMid(bones.line(i).pt(1),bones.line(i).pt(2),5,4));
      PtMid ptIn2 = new PtMid(bones.line(i).pt(4),new PtMid(bones.line(i).pt(3),bones.line(i).pt(2),5,4));

      petal.add(bones.line(i).pt(0));
      petal.add(bones.line(i).pt(1));
      petal.add(pt1);
      petal.add(ptIn1);
      petal.add(ptIn2);
      petal.add(pt2);
      petal.add(bones.line(i).pt(3));
      petal.add(bones.line(i).pt(4));

    }
    else{
      petal.add(bones.line(i));
    }
    petalfloor.add(petal);
  }
  //creating core floor
  for (int i=0;i<bones.numOfLines();i+=5){
    Face core = new Face();
    for (int j=0;j<5;j++){
      core.add(bones.line(i+j).pt(0));
      core.add(bones.line(i+j).pt(4));
      corefloor.add(core);
    }
  }
}



//////////////////////////////////////////////////////////////////
//FACADE
//////////////////////////////////////////////////////////////////
void facade(){
  petalfacade = new Group();
  corefacade = new Group();


  //creating facade panels on petal
  for (int i=0;i<bones.numOfLines()-5;i++){
    Obj petalpanels = new Obj();

    if(petalfloor.face(i).numOfPts()!=5){
      for(int j=0;j<petalfloor.face(i).numOfPts()-1;j++){
        if (petalfloor.face(i+5).numOfPts()==petalfloor.face(i).numOfPts()){
          double len = Pt.length(petalfloor.face(i).pt(j),petalfloor.face(i).pt(j+1));

          if (len < sub) len = sub;

          PtsMid line1 = new PtsMid(petalfloor.face(i).pt(j),petalfloor.face(i).pt(j+1),(int)len/sub); //bottomline
          PtsMid line2 = new PtsMid(petalfloor.face(i+5).pt(j),petalfloor.face(i+5).pt(j+1),(int)len/sub); //topline

          for (int k=0;k<line1.numOfPts()-1;k++){
            Face panel = new Face();
            panel.add(line1.pt(k));
            panel.add(line1.pt(k+1));
            panel.add(line2.pt(k+1));
            panel.add(line2.pt(k));
            petalpanels.add(panel);
          }
        }

        else{
          if (j<2){
            double len = Pt.length(petalfloor.face(i).pt(j),petalfloor.face(i).pt(j+1));

            if (len < sub) len = sub;

            PtsMid line1 = new PtsMid(petalfloor.face(i).pt(j),petalfloor.face(i).pt(j+1),(int)len/sub); //bottomline
            PtsMid line2 = new PtsMid(petalfloor.face(i+5).pt(j),petalfloor.face(i+5).pt(j+1),(int)len/sub); //topline

            for (int k=0;k<line1.numOfPts()-1;k++){
              Face panel = new Face();
              panel.add(line1.pt(k));
              panel.add(line1.pt(k+1));
              panel.add(line2.pt(k+1));
              panel.add(line2.pt(k));
              petalpanels.add(panel);
            }
          }
          else if (j<5){
            Face panel = new Face();
            panel.add(petalfloor.face(i).pt(j));
            panel.add(petalfloor.face(i).pt(j+1));
            panel.add(petalfloor.face(i+5).pt(2));
            petalpanels.add(panel);

          }
          else {
            double len = Pt.length(petalfloor.face(i).pt(j),petalfloor.face(i).pt(j+1));

            if (len < sub) len = sub;

            PtsMid line1 = new PtsMid(petalfloor.face(i).pt(j),petalfloor.face(i).pt(j+1),(int)len/sub); //bottomline
            PtsMid line2 = new PtsMid(petalfloor.face(i+5).pt(j-3),petalfloor.face(i+5).pt(j-2),(int)len/sub); //topline

            for (int k=0;k<line1.numOfPts()-1;k++){
              Face panel = new Face();
              panel.add(line1.pt(k));
              panel.add(line1.pt(k+1));
              panel.add(line2.pt(k+1));
              panel.add(line2.pt(k));
              petalpanels.add(panel);
            }
          }
        }
      }
    }
    else{
      for(int j=0;j<4;j++){
        double len = Pt.length(bones.line(i).pt(j),bones.line(i).pt(j+1));

        if (len < sub) len = sub;

        PtsMid line1 = new PtsMid(bones.line(i).pt(j),bones.line(i).pt(j+1),(int)len/sub); //bottomline
        PtsMid line2 = new PtsMid(bones.line(i+5).pt(j),bones.line(i+5).pt(j+1),(int)len/sub); //topline

        for (int k=0;k<line1.numOfPts()-1;k++){
          Face panel = new Face();
          panel.add(line1.pt(k));
          panel.add(line1.pt(k+1));
          panel.add(line2.pt(k+1));
          panel.add(line2.pt(k));
          petalpanels.add(panel);
        }
      }
    }
    petalfacade.add(petalpanels);
  }

  //creating facade panels on core
  for (int i=0;i<bones.numOfLines()-5;i+=5){

    for (int j=0;j<5;j++){
      Obj corepanels = new Obj();

      int next;
      if (j%5 == 4){
        next = i+j-4;
      }
      else {
        next = i+j+1;
      }

      double len = Pt.length(bones.line(i+j).pt(4),bones.line(next).pt(0));

      if (len < sub) len = sub;

      PtsMid line1 = new PtsMid(bones.line(i+j).pt(4),bones.line(next).pt(0),(int)len/sub); //bottomline
      PtsMid line2 = new PtsMid(bones.line(i+j+5).pt(4),bones.line(next+5).pt(0),(int)len/sub); //topline

      for (int k=0;k<line1.numOfPts()-1;k++){
        Face panel = new Face();
        panel.add(line1.pt(k));
        panel.add(line1.pt(k+1));
        panel.add(line2.pt(k+1));
        panel.add(line2.pt(k));

        corepanels.add(panel);
      }
      corefacade.add(corepanels);
    }
  }
  petalfacade.fill(69,194,246,50);
  corefacade.fill(69,194,246,50);
}


//////////////////////////////////////////////////////////////////
//WINDOWS
//////////////////////////////////////////////////////////////////
void windows(){
  windows = new Obj();
  windowglass = new Obj();

  /////////////////////
  //variables
  int subW = 22; //window subdivision
  float minW = 1.7;
  int floorCounter = 0;

  int centerClose = -2;
  int centerFar = 1;
  int publicSpace = -2;
  int privateSpace = 0;
  int north = -2;
  int south = 1;


  //petalwindows
  for (int k=0;k<petalfacade.numOfObj();k++){
    floorCounter = (int)k/5;

    for (int j=0;j<petalfacade.obj(k).numOfFaces();j++){
      if (petalfacade.obj(k).face(j).numOfPts()==4){

        Face form1 = petalfacade.obj(k).face(j);


        if ((float)Pt.length(form1.pt(0),form1.pt(1)) < minW){
          Face form2 = new Face();
          form2.add(form1.pt(0));
          form2.add(form1.pt(1));
          form2.add(form1.pt(2));
          form2.add(form1.pt(3));
          windowglass.add(form2);
        }
        else {

          int rando = -round(random(4));

          int windowparameter = privateSpace; //private space
          if (j==0 || j==petalfacade.obj(k).numOfFaces()) windowparameter = centerClose+1+publicSpace; //public space
          if (k%5==3) windowparameter +=north; //north side
          if (k%5==1) windowparameter +=south; //south side
          if (k%5==0) windowparameter +=south; //south side

          if ((int)petalfacade.obj(k).numOfFaces()*4/5>j && ceil(petalfacade.obj(k).numOfFaces()*1/5)<j){
            windowparameter += centerFar;
          }
          else{
            windowparameter += centerClose;
            }

          //int diagonal = min(max(3,(int)(abs(sin(PI/subW*floorCounter))*subW/2)+windowparameter+rando),(int)subW/2-1);
          int diagonal = min(max(3,(int)(abs(cos(PI/subW*floorCounter))*subW/2)+windowparameter+rando),(int)subW/2-1);

          Face glass = new Face();

          for (int i=0; i<4; i++){
            PtMid diagonalPt1 = new PtMid(form1.pt(i),form1.pt((i+2)%4),subW,diagonal);
            PtMid diagonalPt2 = new PtMid(form1.pt((i+1)%4),form1.pt((i+3)%4),subW,diagonal);
            PtMid midPt = new PtMid(form1.pt(i),form1.pt((i+1)%4));

            glass.add(diagonalPt1);
            glass.add(midPt);


            Face form2 = new Face();
            form2.add(form1.pt(i));
            form2.add(midPt);
            form2.add(diagonalPt1);
            windows.add(form2);

            Face form3 = new Face();                        
            form3.add(form1.pt((i+1)%4));
            form3.add(diagonalPt2);
            form3.add(midPt);
            windows.add(form3);
          }
          windowglass.add(glass);
        }
      }
      else {
        windows.add(petalfacade.obj(k).face(j));
      }      
    }
  }


  //corewindows
  for (int k=0;k<corefacade.numOfObj();k++){
    floorCounter = (int)k/5;

    for (int j=0;j<corefacade.obj(k).numOfFaces();j++){
      Face form1 = corefacade.obj(k).face(j);
      if ((float)Pt.length(form1.pt(0),form1.pt(1)) < minW){
        Face form2 = new Face();
        form2.add(form1.pt(0));
        form2.add(form1.pt(1));
        form2.add(form1.pt(2));
        form2.add(form1.pt(3));
        windowglass.add(form2);
      }
      else {
        Face glass = new Face();

        float rand = random(2);
        int rando;

        if (round(rand) == 1){
          rando=0;
        }
        else if (round(rand) == 0){
          rando = -1;
        }
        else {
          rando = 1;
        }

        int windowparameter = publicSpace+centerClose; //public space, close to center
        if (k%5==2) windowparameter +=north; //north side
        if (k%5==3) windowparameter +=north; //north side
        if (k%5==0) windowparameter +=south; //south side

        for (int i=0; i<4; i++){
          int diagonal = min(max(1,(int)(abs(sin(PI/subW*floorCounter))*subW/2)+windowparameter+rando),(int)subW/2-1);
          PtMid diagonalPt1 = new PtMid(form1.pt(i),form1.pt((i+2)%4),subW,diagonal);
          PtMid diagonalPt2 = new PtMid(form1.pt((i+1)%4),form1.pt((i+3)%4),subW,diagonal);
          PtMid midPt = new PtMid(form1.pt(i),form1.pt((i+1)%4));

          glass.add(diagonalPt1);
          glass.add(midPt);

          Face form2 = new Face();
          form2.add(form1.pt(i));
          form2.add(midPt);
          form2.add(diagonalPt1);
          windows.add(form2);

          Face form3 = new Face();                        
          form3.add(form1.pt((i+1)%4));
          form3.add(diagonalPt2);
          form3.add(midPt);
          windows.add(form3);
        }
        if (glass.numOfPts()!=0) windowglass.add(glass);
      }
    }
  }

  windowglass.fill(0,0,0,80);
  windows.fill(69,194,246,100);
}
