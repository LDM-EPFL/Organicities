import processing.pdf.*;
import processing.dxf.*; //pour export dxf ...
boolean record;

import processing.opengl.*;
import oog.*;

Oog myScene;
//Camera myCamera;        //nouvelle camera

Pts pts = new Pts();


Obj Dots;
Obj Grasshopper;
Pt turtle;
Transform[] T;

Param bob;
Param boby;
Sliders mySlide;
//Param vinghtcinq;
//Param zero;

void setup() {
  hint(ENABLE_OPENGL_4X_SMOOTH);  
  size(750, 750, OPENGL);
  myScene = new Oog(this);
  // myCamera = new Camera();  //nouvelle camera

  bob = new Param(4,0,15);
  boby = new Param(0,0,5);
  mySlide = new Sliders(pts);
  mySlide.add(bob);
  mySlide.add(boby);

  myScene.drawAxis();
  initForm();
}

void initForm() { 

  // zero = new Param (0);
  //vinghtcinq = new Param (10);


  T = new Transform[6];

  T[0] = new Translate(25,0,0);
  T[1] = new Translate(-25,0,0);
  T[2] = new Translate(0,25,0);
  T[3] = new Translate(0,-25,0);
  T[4] = new Translate(0,0,25);
  T[5] = new Translate(0,0,-25);

  turtle = Pt.create(0,0,0);

  pts = new Pts();
  pts.add(turtle);

  pts.stroke(255, 100, 100);

  for (int i=0; i<1; i++) step();	


}

void step() {
  // add new point from turtle using random translation
  Pt next = Pt.create(turtle, T[0]);    //(int) random(3)]);

  pts.add(next);
  turtle = next;
  // if(random(100)<70){
  // pts.add(next);
  // turtle = next;
  // }
  // else{
  //   turtle = next;
  //  }
  //} 
  Grasshopper = new Obj();

  CSpline curve = new CSpline(pts,(bob.toInt()));
  curve.stroke(0,0,0);

 // Face farceur = new Face(curve);
  Grasshopper.add(curve);
 // Grasshopper.add(farceur);


  myScene.setCenter(pts);
  // mySlide = new Sliders(pts);

}

void step2() {

  Pt next = Pt.create(turtle, T[1]);

  pts.add(next);
  turtle = next;

  CSpline curve = new CSpline(pts,(bob.toInt()));
  curve.stroke(0,0,0);




//  Face farceur = new Face(curve);
    
  Grasshopper.add(curve);
//  Grasshopper.add(farceur);

}
void step3() {

  Pt next = Pt.create(turtle, T[2]);

  pts.add(next);
  turtle = next;

  CSpline curve = new CSpline(pts,(bob.toInt()));
  curve.stroke(0,0,0);

 // Face farceur = new Face(curve);
  Grasshopper.add(curve);
 // Grasshopper.add(farceur);
}
void step4() {

  Pt next = Pt.create(turtle, T[3]);

  pts.add(next);
  turtle = next;

  CSpline curve = new CSpline(pts,(bob.toInt()));
  curve.stroke(0,0,0);

  // Face farceur = new Face(curve);
  Grasshopper.add(curve);
  //Grasshopper.add(farceur);
}
void step5() {

  Pt next = Pt.create(turtle, T[4]);

  pts.add(next);
  turtle = next;

  CSpline curve = new CSpline(pts,(bob.toInt()));
  curve.stroke(0,0,0);

 // Face farceur = new Face(curve);
  Grasshopper.add(curve);
 // Grasshopper.add(farceur);
}
void step6() {

  Pt next = Pt.create(turtle, T[5]);

  pts.add(next);
  turtle = next;

  CSpline curve = new CSpline(pts,(bob.toInt()));
  curve.stroke(0,0,0);

 // Face farceur = new Face(curve);
  Grasshopper.add(curve);
  //Grasshopper.add(farceur);
}


/////*///*/***////////*



/////*///*/***////////*

void draw() {
  if (record) {
    beginRaw(PDF, "output.pdf");
    //beginRaw(DXF, "output.dxf");
  }
  background(255);
  pts.draw();
  Grasshopper.draw();
  mySlide.draw();
  //myCamera.update();     //nouvelle camera

  if (record) {
    endRaw();
    record = false;
  }
}


void keyPressed(){
  if(key=='w') {
    step();
  }
  if(key=='s') {
    step2();
  }
  if(key=='a') {
    step3();
  }
  if(key=='d') {
    step4();
  }
  if(key=='i') {
    step5();
  }
  if(key=='j') {
    step6();
  }
  if(key=='p') {
    initForm();
  }
  if (key == 'r') {
    record = true;
  }
}






