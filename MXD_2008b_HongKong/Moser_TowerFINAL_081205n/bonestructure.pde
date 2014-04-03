//////////////////////////////////////////////////////////////////
//BONES
//////////////////////////////////////////////////////////////////
void bonestructure(){
  bones = new Obj();

  //////////////////////////////////////////////////////////////////
  //variables
  float a = 7; //size of initialForm (default: 7)
  int nF = 100; //number of floors (default: 100)
  float hF = 1.2; //height of one floor (default: 1.2)
  float inter = 4; //interval of the wavy form (default: 4)
  int bump = 3; //height of wavy form (default: 3)
  int numOfPetals = initialForm.numOfLines();

  //////////////////////////////////////////////////////////////////
  //defining shape of topfloor
  Obj finalForm = new Obj();
  for(int i=0;i<numOfPetals;i++){
    Pts petalform = new Pts();
    petalform.add(a*2/9,-a*1/9,nF*hF);
    petalform.add(a*2/3,-a*1/3,nF*hF);
    petalform.add(a,0,nF*hF);
    petalform.add(a*2/3,a*1/3,nF*hF);
    petalform.add(a*2/9,a*1/9,nF*hF);

    petalform.translate(center.x(),center.y(),0);    

    RotateZ tBones = new RotateZ(refang+2*PI/numOfPetals*(i-refnum));
    Allign bonesAllign = new Allign(center,center2,tBones);

    petalform.apply(bonesAllign);
    petalform.stroke(120,120,120);
    finalForm.add(petalform);
  }

  //////////////////////////////////////////////////////////////////
  //creating inbetween floors
  Obj transitForm = new Obj();
  Obj transitLines = new Obj();

  //creating guidelines
  for (int j=0;j<numOfPetals;j++){
    for (int i=0;i<5;i++){
      Pts cornerline = new Pts();
      cornerline.add(initialForm.line(j).pt(i));
      cornerline.add(finalForm.line(j).pt(i));
      cornerline.stroke(120,120,120);
      transitLines.add(cornerline);
    }
  }

  //creating floors
  for (int i=1;i<nF;i++){
    Obj transitFloor = new Obj();
    Pts transitPetals = new Pts();
    int petalnum = 0;

    for (int j=0;j<transitLines.numOfLines();j++){
      transitPetals.add(new PtMid(transitLines.line(j).pt(0),transitLines.line(j).pt(1),nF,i));

      if (petalnum==4){
        transitPetals.stroke(120,120,120);
        transitFloor.add(transitPetals);
        petalnum=-1;
        transitPetals = new Pts();
      }
      petalnum++;
    }

    Scale transitScale1 = new Scale(bump*-sin(i/inter)/50+1,bump*-sin(i/inter)/50+1,1);
    Scale transitScale2 = new Scale(11*bump*-sin(i/inter/11)/50+1,11*bump*-sin(i/inter/11)/50+1,1);

    Allign transitAllign1 = new Allign(center, center2, transitScale1);
    Allign transitAllign2 = new Allign(center, center2, transitScale2);

    transitFloor.apply(transitAllign1);
    transitFloor.apply(transitAllign2);

    transitForm.add(transitFloor);
  }


  bones.add(initialForm);
  bones.add(transitForm);
  //bones.add(finalForm);
}
