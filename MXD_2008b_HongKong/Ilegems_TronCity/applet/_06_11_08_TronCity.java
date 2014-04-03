import processing.core.*; import processing.pdf.*; import processing.dxf.*; import processing.opengl.*; import oog.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; import javax.sound.midi.*; import javax.sound.midi.spi.*; import javax.sound.sampled.*; import javax.sound.sampled.spi.*; import java.util.regex.*; import javax.xml.parsers.*; import javax.xml.transform.*; import javax.xml.transform.dom.*; import javax.xml.transform.sax.*; import javax.xml.transform.stream.*; import org.xml.sax.*; import org.xml.sax.ext.*; import org.xml.sax.helpers.*; public class _06_11_08_TronCity extends PApplet {
 //pour export dxf ...
boolean record;




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

public void setup() {
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

public void initForm() { 

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

public void step() {
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

public void step2() {

  Pt next = Pt.create(turtle, T[1]);

  pts.add(next);
  turtle = next;

  CSpline curve = new CSpline(pts,(bob.toInt()));
  curve.stroke(0,0,0);




//  Face farceur = new Face(curve);
    
  Grasshopper.add(curve);
//  Grasshopper.add(farceur);

}
public void step3() {

  Pt next = Pt.create(turtle, T[2]);

  pts.add(next);
  turtle = next;

  CSpline curve = new CSpline(pts,(bob.toInt()));
  curve.stroke(0,0,0);

 // Face farceur = new Face(curve);
  Grasshopper.add(curve);
 // Grasshopper.add(farceur);
}
public void step4() {

  Pt next = Pt.create(turtle, T[3]);

  pts.add(next);
  turtle = next;

  CSpline curve = new CSpline(pts,(bob.toInt()));
  curve.stroke(0,0,0);

  // Face farceur = new Face(curve);
  Grasshopper.add(curve);
  //Grasshopper.add(farceur);
}
public void step5() {

  Pt next = Pt.create(turtle, T[4]);

  pts.add(next);
  turtle = next;

  CSpline curve = new CSpline(pts,(bob.toInt()));
  curve.stroke(0,0,0);

 // Face farceur = new Face(curve);
  Grasshopper.add(curve);
 // Grasshopper.add(farceur);
}
public void step6() {

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

public void draw() {
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


public void keyPressed(){
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







/*
POUR UTILISER LA CAMERA

0/ ajouter Camera.pde dans le sketch folder

1/ d\u00c3\u00a9clarer la cam\u00c3\u00a9ra au d\u00c3\u00a9but du script :

	Camera myCamera;


2/ initialiser la cam\u00c3\u00a9ra dans le setup et enlever les reglages par d\u00c3\u00a9faut :
void setup()

	{
		...
		myCamera = new Camera();
		myScene.defaultScene = false;
		...
	}


3/ actualiser la cam\u00c3\u00a9ra dans draw, si on met un Obj comme argument, la cam\u00c3\u00a9ra va le cibler, sinon, elle cible l'origine :

	void draw()
	{
		...
		//myCamera.update(myObj);
		//ou
		myCamera.update();
		...
	}

*/


class Camera
{
	Pt targetPoint = Pt.create(0 , 0);;
	float distance = 200.0f;
	
	float mX = 0.5f;
	float mY = 0.5f;
	
	Camera()
	{
		addMouseWheelListener(new java.awt.event.MouseWheelListener() { public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { mouseWheel(evt.getWheelRotation());}});
		
		update();
	}
	
	public void targetObject(Obj obj)
	{
		try
		{
		targetPoint = new PtBaryRedux(new Pts(obj.boundingBox()));
		}
		catch(Exception e)
		{
			//boudingBox vide jette une exception !
		}
	}
	
	public void update(Obj tgtObj)
	{
		targetObject(tgtObj);
		update();
	}
	
	public void update()
	{
		if(mousePressed && (mouseButton == CENTER))
		{
			mX = (float)mouseX / (float)width;
			mY = (float)mouseY / (float)height;
		}
		
		float posX = mY * distance * cos(-mX * TWO_PI);
		float posY = mY * distance * sin(-mX * TWO_PI);
		float posZ = distance * cos(mY * HALF_PI);
	
		
		camera(posX,posY,posZ,(float)targetPoint.x(),(float)targetPoint.y(),(float)targetPoint.z(), 0,0,-1.0f);
	}

	public void zoom(float z)
	{
		distance *= 1+z/100.0f;
	}
	
	public void mouseWheel(int delta)
	{
	 // myCamera.zoom((float)delta); 
	}
}


  static public void main(String args[]) {     PApplet.main(new String[] { "_06_11_08_TronCity" });  }}