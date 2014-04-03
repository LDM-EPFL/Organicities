//////////////////////////////////////////////////////////////////
//FORMFINDER
//////////////////////////////////////////////////////////////////
void formfinder(){
  helpers = new Obj();
  Obj corners = new Obj();
  initialForm = new Obj();


  //////////////////////////////////////////////////////////////////
  //circulation calculations

  //get circulation angels
  float ang[] = new float[2];
  ang[0] = crot1.toFloat();
  ang[1] = crot2.toFloat();

  //get weight values
  float weight[] = new float[2];
  weight[0] = cweight[0].toFloat();
  weight[1] = cweight[1].toFloat();

  //get them sorted
  if (ang[1]>ang[0]){
    weight = reverse(weight);
  }
  ang = sort(ang);

  //calculate inbetween angels
  float diffang[] = new float[2];
  diffang[0] = ang[1]-ang[0];
  diffang[1] = 2*PI-diffang[0];

  //calculate division between those 2 angles
  int angdiv[] = new int[2];
  for (int i=0; i<2;i++){
    angdiv[i]=round(diffang[i]/(2*PI/5));
  }


  //////////////////////////////////////////////////////////////////
  //calculate rotation angle for each petal
  int numOfPetals = angdiv[0]+angdiv[1];
  float petalang[] = new float[numOfPetals];
  float subpetalang[] = new float[numOfPetals*2];

  int k=0;
  int m=0;

  for (int i=0;i<2;i++){
    switch(angdiv[i]){

    case 0:
      break;

    case 1:
      petalang[k] = ang[i]+diffang[i]/2;
      subpetalang[m] = -diffang[i]/2/(1.8+weight[(i+1)%2]/255);
      subpetalang[m+1] = diffang[i]/2/(1.8+weight[i]/255);

      k++;
      m+=2;
      break;

    case 2:
      petalang[k] = ang[i]+diffang[i]*5/16;
      subpetalang[m] = -diffang[i]/3/(1.8+weight[(i+1)%2]/255);
      subpetalang[m+1] = diffang[i]/8;

      petalang[k+1] = ang[i]+diffang[i]*11/16;
      subpetalang[m+2] = -diffang[i]/8;
      subpetalang[m+3] = diffang[i]/3/(1.8+weight[i]/255);

      k+=2;
      m+=4;
      break;

    case 3:
      petalang[k] = ang[i]+diffang[i]*3/16;
      subpetalang[m] = -diffang[i]/4.5/(1.8+weight[(i+1)%2]/255);
      subpetalang[m+1] = diffang[i]/10;

      petalang[k+1] = ang[i]+diffang[i]/2;
      subpetalang[m+2] = -diffang[i]/10;
      subpetalang[m+3] = diffang[i]/10;
      refang = petalang[k+1];
      refnum = k+1;

      petalang[k+2] = ang[i]+diffang[i]*13/16;
      subpetalang[m+4] = -diffang[i]/10;
      subpetalang[m+5] = diffang[i]/4.5/(1.8+weight[i]/255);

      k+=3;
      m+=6;
      break;

    case 4:
      petalang[k] = ang[i]+diffang[i]*3/16;
      subpetalang[m] = -diffang[i]/6/(1.8+weight[(i+1)%2]/255);
      subpetalang[m+1] = diffang[i]/12;

      petalang[k+1] = ang[i]+diffang[i]*6.3/16;
      subpetalang[m+2] = -diffang[i]/12;
      subpetalang[m+3] = diffang[i]/12;
      refang = petalang[k+1];
      refnum = k+1;

      petalang[k+2] = ang[i]+diffang[i]*9.7/16;
      subpetalang[m+4] = -diffang[i]/12;
      subpetalang[m+5] = diffang[i]/12;

      petalang[k+3] = ang[i]+diffang[i]*13/16;
      subpetalang[m+6] = -diffang[i]/12;
      subpetalang[m+7] = diffang[i]/6/(1.8+weight[i]/255);

      k+=4;
      m+=8;
      break;

    case 5:
      //don't change order!!!!
      petalang[k] = ang[i]+PI/5;
      subpetalang[0] = -diffang[i]/8/(1.8+weight[(i+1)%2]/255);
      subpetalang[1] = diffang[i]/14;

      petalang[k+4] = ang[i]+diffang[i]-PI/5;
      subpetalang[2] = -diffang[i]/14;
      subpetalang[3] = diffang[i]/14;      

      petalang[k+1] = ang[i]+PI/5+(petalang[k+4]-petalang[k])/4;
      subpetalang[4] = -diffang[i]/14;
      subpetalang[5] = diffang[i]/14;

      petalang[k+3] = ang[i]+diffang[i]-PI/5-(petalang[k+4]-petalang[k])/4;
      subpetalang[6] = -diffang[i]/14;
      subpetalang[7] = diffang[i]/14;      

      petalang[k+2] = ang[i]+diffang[i]/2;
      subpetalang[8] = -diffang[i]/14;
      subpetalang[9] = diffang[i]/8/(1.8+weight[i]/255);
      refang = petalang[k+2];
      refnum = k+2;

      break;
    }
  }


  //////////////////////////////////////////////////////////////////
  //rotate petallines

  Pts petalline[] = new Pts[numOfPetals];
  Pts subpetalline[] = new Pts[numOfPetals*2];
  int cornerdistance[] = new int[numOfPetals];
  Pt petalpt[] = new Pt[numOfPetals];

  for (int i=0;i<numOfPetals;i++){
    //rotate principal petallines
    petalline[i] = new Pts(circline);  
    RotateZ petalRot = new RotateZ(petalang[i]);
    Allign petalAllign = new Allign(center,center2,petalRot);
    petalline[i].apply(petalAllign);
    petalline[i].stroke(255,255,0);
    helpers.add(petalline[i]);

    //rotate subpetallines
    for (int j=0;j<2;j++){
      RotateZ subpetalRot = new RotateZ(subpetalang[(i*2)+j]);
      Allign subpetalAllign = new Allign(center,center2,subpetalRot);
      subpetalline[(i*2)+j]=new Pts(petalline[i]);
      subpetalline[(i*2)+j].apply(subpetalAllign);
      subpetalline[(i*2)+j].stroke(255,255,0,100);
      helpers.add(subpetalline[(i*2)+j]);
    }


    //////////////////////////////////////////////////////////////////
    //calculate cornerpoints

    //calculate outer cornerpoints
    int testerA=0;
    petalpt[i] = Pt.create(center);
    while(!kaiTak.hover((float)petalpt[i].x(),(float)petalpt[i].y())){
      petalpt[i] = new PtMid(petalline[i].pt(0),petalline[i].pt(1),100,testerA);
      testerA++;
    }
    cornerdistance[i] = testerA-2;
  }

  //correct extreme cornerpoints
  int sortedcornerdistance[] = new int[numOfPetals];
  sortedcornerdistance = sort(cornerdistance);

  for (int i=0;i<numOfPetals;i++){
    if (cornerdistance[i]>1.2*sortedcornerdistance[2]){
      petalpt[i] = new PtMid(petalline[i].pt(0),petalline[i].pt(1),100,(int)1.2*sortedcornerdistance[2]);
      cornerdistance[i] = (int)1.2*sortedcornerdistance[2];
    }
    petalpt[i] = new PtMid(petalline[i].pt(0),petalline[i].pt(1),100,cornerdistance[i]);
    corners.add(petalpt[i]);
  }

  //calculate subpetalcornerpoints
  for (int i=0;i<numOfPetals;i++){
    for (int j=0;j<2;j++){
      int testerB=0;
      Pt subpetalpt = Pt.create(center);
      while(!kaiTak.hover((float)subpetalpt.x(),(float)subpetalpt.y())){
        subpetalpt = new PtMid(subpetalline[i*2+j].pt(0),subpetalline[i*2+j].pt(1),100,testerB);
        testerB++;
        if (testerB>.85*cornerdistance[i])
          break;
      }
      subpetalpt = new PtMid(subpetalline[i*2+j].pt(0),subpetalline[i*2+j].pt(1),100,testerB-2);
      corners.add(subpetalpt);

      //calculate subsubpetalcornerpoints
      Pt subsubpetalpt = new PtMid(subpetalline[i*2+j].pt(0),subpetalline[i*2+j].pt(1),100,(int)(.35*cornerdistance[i]));
      corners.add(subsubpetalpt);
    }
  }

  for (int i=0;i<numOfPetals;i++){
    Pts petalform = new Pts();
    petalform.add(corners.pt(i*4+6));
    petalform.add(corners.pt(i*4+5));
    petalform.add(corners.pt(i));
    petalform.add(corners.pt(i*4+7));
    petalform.add(corners.pt(i*4+8));
    petalform.stroke(120,120,120);
    petalform.translate(0,0,-1);
    initialForm.add(petalform);
  }

  formfinderForm = new Pts();
  for(int i=0;i<numOfPetals;i++){
    for(int j=0;j<initialForm.line(i).numOfPts();j++){
      formfinderForm.add(initialForm.line(i).pt(j));
    }
  }
  formfinderForm.add(initialForm.line(0).pt(0));
  formfinderForm.translate(0,0,2);
  formfinderForm.stroke(255,255,255);
}
