class Canyon {

  Pts mainPath = new Pts();
  Obj connectedLines = new Obj();  

  float diffHauteur[][] = new float[4][4];
  int t1Minimal;
  int t2Minimal;
  int startImoins1;
  int startJmoins1;
  int exitloop = 0;

  int t1Start;
  int t1End;
  int t2Start;
  int t2End;

  PVector displacementVector;
  color ridgeColor;

  Pt nearestPoint;
  //Pts[][] connect = new Pts[gridX][gridY];
  //Pts[][] connect2 = new Pts[gridX][gridY];  
  Obj connect = new Obj();
  Obj connect2 = new Obj();
  int[][] lieuOasis = new int[gridX][gridY];
  Pts set1 = new Pts();

  // Canyon (departX, departY,direction)

  Canyon (int canyonStartX, int canyonStartY, int canyonDirTemp) {

    int canyonDir = canyonDirTemp;
    int startI = canyonStartX;
    int startJ = canyonStartY;

    mainPath.add(gridPoint[startI][startJ]);

    while (exitloop == 0) {

      float diffMinimal = 100000;

      // definit la direction preferentielle

      if ( canyonDir == 0 || canyonDir == 360) {
        t1Start =0;
        t1End =3;
        t2Start =0;
        t2End =2;
      }
      if ( canyonDir == 90) {
        t1Start =1;
        t1End =3;
        t2Start =0;
        t2End =3;
      }
      if ( canyonDir == 180) {
        t1Start =0;
        t1End =3;
        t2Start =1;
        t2End =3;
      }
      if ( canyonDir == 270) {
        t1Start =0;
        t1End =2;
        t2Start =0;
        t2End =3;
      }

      // sens du mouvement

      for (int t1=t1Start; t1<t1End; t1++) {
        for (int t2=t2Start; t2<t2End; t2++) {  

          // ne compte pas le point actuel
          if (t1 != 1 || t2 != 1) {
            // ne compte pas le point précédent
            if (t1 != (startImoins1-startI+1) && t2 != (startJmoins1-startJ+1)  ) {

              diffHauteur[t1][t2] = gridPoint[(startI-1+t1)][(startJ-1+t2)].z() - gridPoint[startI][startJ].z() ;

              // si la difference de hauteur est comme la difference minimale jusqu'à présent, ajoute ou enleve au hasard quelque chose
              if (diffHauteur[t1][t2] == diffMinimal) {
                diffHauteur[t1][t2] = diffHauteur [t1][t2] - random(-1,+1);
              }

              if (diffHauteur[t1][t2] < diffMinimal) {
                diffMinimal = diffHauteur [t1][t2];
                t1Minimal = t1;
                t2Minimal = t2;
              }
            }
          }
        }
      }

      // ajoute un point au canyon 
      mainPath.add(gridPoint[(startI-1+t1Minimal)][(startJ-1+t2Minimal)]);

      // prépare pour le point suivant
      startImoins1 = startI;
      startJmoins1 = startJ;

      startI = (startI-1+t1Minimal);
      startJ = (startJ-1+t2Minimal);

      // quitte le while si le canyon arrive au bord
      if (startI == 0 || startJ == 0 ||startI == gridX  ||startJ == gridY  ) {
        exitloop = 1;
      }
    }
  }


  void displayCanyon(int time) {
    Pts set0 = new Pts();
    for (int p = 0;p < time && p<mainPath.numOfPts();p++) {
      set0.add(mainPath.pt(p));
      strokeWeight(7);
      set0.stroke(30,150,250,200).draw();
    }
    
    connect=new Obj();
    connect2=new Obj();
    for(int i=0; i<(gridX); i++) {
      for(int j=0; j<(gridY); j++) {
        if (lowPointCount[i][j] > 15) { // LOWPOINT COUNT //////////////////////////////////
        
          float distance = 10000000;
          for (int k = 0; k < set0.numOfPts(); k++) {
            if ( (gridPoint[i][j].length(set0.pt(k))) < distance ) {
              distance = gridPoint[i][j].length(set0.pt(k));
              nearestPoint = mainPath.pt(k);
            }
          }
          if (distance < 350 ) { // DISTANCE 1 //////////////////////////////
            Pts addPts = new Pts(Anar.Pt(gridPoint[i][j].x(),gridPoint[i][j].y(),gridPoint[i][j].z()), Anar.Pt(nearestPoint.x(),nearestPoint.y(),nearestPoint.z()));
            addPts.stroke(0,95,190,190);
            connect.add(addPts);
            Circle cnnCir= new Circle(Anar.Pt(gridPoint[i][j].x(), gridPoint[i][j].y(), gridPoint[i][j].z()-1),(1.5*lowPointCount[i][j]));
            connect2.add(cnnCir.stroke(155,0,0,100));
            //connect[i][j] = new Pts(gridPoint[i][j],nearestPoint);
            //connect[i][j].stroke(200,0,200).draw();
            lieuOasis[i][j] = 1;
            for(int m=i-7; m<i+7; m++) {
              for(int n=j-7; n<j+7; n++) {
                if (m > 0 && m< gridX && n > 0 && n< gridY) {
                  if (lowPointCount[m][n] > 3) {
                    if ( gridPoint[i][j].length (gridPoint[m][n]) < 100 ) { // DISTANCE 2 //////////////////////////
                      Pts addPts2 = new Pts( Anar.Pt(gridPoint[i][j].x(),gridPoint[i][j].y(),gridPoint[i][j].z()),  Anar.Pt(gridPoint[m][n].x(),gridPoint[m][n].y(),gridPoint[m][n].z()+2) );
                      addPts2.stroke(20,45,135,170);
                      connect2.add(addPts2);
                      //connect2[m][n] = new Pts(gridPoint[i][j],gridPoint[m][n]);
                      //    connect2[m][n].stroke(0,0,120);
                      //connect2[m][n].draw();
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    strokeWeight(4);
   connect.draw();
   strokeWeight(3);
   connect2.draw();
  }

  void displaylowPoint(int time) {
    for(int i=0; i<(gridX); i++) {
      for(int j=0; j<(gridY); j++) {
        if (lieuOasis[i][j] == 1) {
        }
      }
    }
  }
}

