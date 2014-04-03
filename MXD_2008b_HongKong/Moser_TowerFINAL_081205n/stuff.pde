//////////////////////////////////////////////////////////////////
//KAITAK
//////////////////////////////////////////////////////////////////
//slightly modified class KaiTak from Olivier D.
//follow instructions on his original file from his blog if necessary
class KaiTak{
  PImage water;
  float dx, dy;
  KaiTak(float sdx, float sdy){
    dx = sdx;
    dy = sdy;
    if (imageNum==0){
      water=loadImage("w1.jpg");
    }
    else if (imageNum==1){
      water=loadImage("w2.jpg");
    }
    else {
      water=loadImage("w3.jpg");
    }
  }

  void draw(){
    fill(255);
    image(water,dx,dy);
  }

  boolean hover(float x, float y){
    x = x -dx;
    y = y -dy;
    if(x < 0 || y < 0 || x > water.width || y > water.height){
      return true;
    }
    else{
      color c = water.get((int)x,(int)y);
      if( brightness(c) < 125){
        return false;
      }
      else{
        return true;
      }
    }	
  }

  void transfer(float sdx, float sdy){
    dx = sdx;
    dy = sdy;
  }
}



//////////////////////////////////////////////////////////////////
//POINTER
//////////////////////////////////////////////////////////////////
//draws controlpoints on the image to see if they are inside the constructable area
void pointer(){
  waterpoints = new Obj();
  landpoints = new Obj();

  for (int i=0; i<400; i+=10){
    for (int j=0; j<400; j+=10){
      if(kaiTak.hover(-200+i,-200+j)){
        Pt points = Pt.create(i-200,j-200,1);
        points.fill(255,0,0);
        waterpoints.add(points);
      }
      else{
        Pt points = Pt.create(i-200,j-200,1);
        points.fill(0,255,0);
        landpoints.add(points);
      }
    }
  }
}



//////////////////////////////////////////////////////////////////
//CENTERPOINT
//////////////////////////////////////////////////////////////////
//calculates the centerpoint of constructable area
void centerpoint(){
  centerline = new Pts();
  int xx = 0;
  int yy = 0;

  for(int i=0;i<landpoints.numOfPts();i++){
    xx += landpoints.pt(i).x();
    yy += landpoints.pt(i).y();
  }
  center = Pt.create(xx/landpoints.numOfPts(),yy/landpoints.numOfPts(),2);
  center2 = Pt.create(center);
  center2.translate(0,0,250);
  centerline = new Pts(center,center2);
  centerline.stroke(0,255,0);

  Pt circpt = Pt.create(center);
  circpt.translate(400,0,0);
  circline = new Pts();
  circline.add(center);
  circline.add(circpt);

  myScene.setCenter(center);
}



//////////////////////////////////////////////////////////////////
//CIRCULATION
//////////////////////////////////////////////////////////////////
//creates circulation lines
void circulation(){
  circline1 = new Pts();
  circline2 = new Pts();

  circSliders = new Sliders();
  circSliders.add(crot1);
  circSliders.add(crot2);
  circSliders.add(cweight[0]);
  circSliders.add(cweight[1]);

  circline1 = new Pts(circline);
  RotateZ circRot1 = new RotateZ(crot1);
  Allign circAllign1 = new Allign(center,center2,circRot1);
  circline1.apply(circAllign1);

  circline2 = new Pts(circline);
  RotateZ circRot2 = new RotateZ(crot2);
  Allign circAllign2 = new Allign(center,center2,circRot2);
  circline2.apply(circAllign2);
}
