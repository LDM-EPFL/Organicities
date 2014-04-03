import processing.core.*; import processing.dxf.*; import processing.pdf.*; import oog.*; import processing.opengl.*; import java.applet.*; import java.awt.*; import java.awt.image.*; import java.awt.event.*; import java.io.*; import java.net.*; import java.text.*; import java.util.*; import java.util.zip.*; import javax.sound.midi.*; import javax.sound.midi.spi.*; import javax.sound.sampled.*; import javax.sound.sampled.spi.*; import java.util.regex.*; import javax.xml.parsers.*; import javax.xml.transform.*; import javax.xml.transform.dom.*; import javax.xml.transform.sax.*; import javax.xml.transform.stream.*; import org.xml.sax.*; import org.xml.sax.ext.*; import org.xml.sax.helpers.*; public class ProcessingTower_olivier extends PApplet {//////*////////////*/////////*//////////////////////////////////////*///////////////////////////////////////
///////////////////////////*///////// Studio Huang///////*//////////////////////////////////////////////////
//////*////////////*/////////*//////////////////////////////////////*///////////////////////////////////////
////////////*/Student Ilegems Olivier////////*////////////*/////////////*///////////////////////////////////
//////*////////////*/////////*//////////////////////////////////////*///////////////////////////////////////
//////*/////////////////////**/////////Spiral_tower

 //pour export dxf ...
 //pour exporter en pdf. (r)
boolean record;          




//Camera myCamera;

//d\u00e9claration des param\u00e8tre:
Param DiamExt1;  
Param DiamExt2;  
Param DiamInt;  
Param Hauteur; 
Param Scale1;
Param Scale2;
Param Scale3;
Param ZSlab;
Param ZSlabZero;
Param ZSlabExtrude;
Param SlabIrregulator;
Param SlabIrregulator2;
Param SlabIrregulator3;
Sliders Transformer;   //mon set de sliders.
Param Un;
Param Zero;
Param Dix;

int numOfSides = 40;
int numOfLoops = 20;//nombre de "niches" = 2*numOfloops - 1
float theta = 2*PI/(numOfSides);
float theta2 = -(2*PI/(numOfSides));

Oog goo;
Obj myObj;

//*//*//////////*////////*//////////*///////////////*//////////*//*//////*/////////*/////*//////*///////*///
///////*//////*///SETUP

public void setup() {
  hint(ENABLE_OPENGL_4X_SMOOTH);  
  size(800, 800, OPENGL);
  goo = new Oog(this);

  //myCamera = new Camera();
  //goo.defaultScene = false;

  //Scene.drawAxis = true;

  DiamExt1 = new Param(130,20,400);
  DiamExt2 = new Param(130,20,400);
  DiamInt = new Param(10,0,50);
  Hauteur = new Param(1,-3,3,"H");
  Scale1 = new Param(.995f,.8f,1.005f,"S1");
  Scale2 = new Param(.995f,.8f,1.005f,"S2");
  Scale3 = new Param(1.0005f,0.999f,2,"S3");
  ZSlab = new Param(-5,-200,200,"Slab");
  ZSlabZero = new Param(0,-180,220,"Slab");
  ZSlabExtrude = new Param(-1,-10,20,"Slab");
  SlabIrregulator = new Param(0,-5,5,"Irregulator");   //valeur test 1.2
  SlabIrregulator2 = new Param(0,-5,5,"Irregulator2");    //valeur test 0.6 
  SlabIrregulator3 = new Param(0,-10,10,"Irregulator3");       

  Transformer = new Sliders();

  Transformer.add(DiamExt1);   
  Transformer.add(DiamExt2);
  Transformer.add(DiamInt);
  Transformer.add(Hauteur);
  Transformer.add(Scale1);
  Transformer.add(Scale2);
  Transformer.add(Scale3);
  Transformer.add(ZSlab);
  Transformer.add(ZSlabZero);
 // Transformer.add(ZSlabExtrude);
  Transformer.add(SlabIrregulator);
  Transformer.add(SlabIrregulator2);
  Transformer.add(SlabIrregulator3);

  initForm();
}

//*//*//////////*////////*//////////*///////////////*//////q///*//*//////*/////////*/////*//////*///////*///
///////*//////*///VOID

public void initForm() {
  //Create a new Object to store our shape
  myObj = new Obj();  

  Un = new Param (1);
  Zero = new Param (0.f);
  Dix = new Param (10.f);


  // starting point
  Pt a = Pt.create(DiamExt1,Zero,Zero);
  Pt b = Pt.create(DiamExt2,Zero,Zero);
  Pt c = Pt.create(DiamInt,Zero,Zero);
  Pt d = Pt.create(DiamInt,Zero,Zero);

  // transformation
  RotateZ rot = new RotateZ(theta);
  RotateZ rot2 = new RotateZ(theta2);
  Translate t = new Translate(Zero,Zero,Hauteur);
  Scale s     = new Scale(Scale1,Scale1,Un);
  Scale sAntihorraire = new Scale(Scale2,Scale2,Un);
  Scale sReverse     = new Scale(Scale3,Scale3,Un);


  //Create new Lines
  Pts myLineSkin = new Pts();
  Pts myLineCore = new Pts();

  Pts myLineSkin2 = new Pts();
  Pts myLineCore2 = new Pts();


 //Param bb = new Param(0.6,"bb");
 // Transformer.add(bb);


  for (int i=0; i<numOfSides*numOfLoops; i=i+2) {

    // d\u00e9compose "transform Ovoid"
    Param ee = new Param(i/10.0f);   
    Param cc = new ParamSin(ee);
    Param aa = new ParamCos(ee);
    
    Param n = new ParamMul(cc,SlabIrregulator); //(ParamMultiplication)(sin(i/10.0)*SlabIrregulator)
    Param m = new ParamMul(aa,SlabIrregulator2); //(cos(i/10.0)*SlabIrregulator2)
    Param o = new ParamMul(aa,SlabIrregulator);  //(cos(i/10.0)*SlabIrregulator)
    Param p = new ParamMul(cc,SlabIrregulator2);  //(sin(i/10.0)*SlabIrregulator2)
    
    // d\u00e9compose "transform Irregulier"
    Param gg = new Param(i);
    Param dd = new ParamSin(gg);
    Param ff = new ParamCos(gg);
     
    Param q = new ParamMul(dd,SlabIrregulator3);
    Param r = new ParamMul(ff,SlabIrregulator3);
    
    Transform Ovoid = new Transform();   
    Ovoid.translate(n,m,Zero);
    
    Transform Ovoid2 = new Transform();   
    Ovoid2.translate(o,p,Zero);     
    
    Transform Irregulier = new Transform();
    Irregulier.translate(q,r,Zero);

    a = Pt.create(a);
    c = Pt.create(c);
    a.apply(rot);
    a.apply(t);
    a.apply(s);
    a.apply(Ovoid);
    a.apply(Irregulier);

    c.apply(rot);
    c.apply(t);
    c.apply(sReverse);

    myLineCore.add(c);
    myLineSkin.add(a);


    myLineSkin2.render = new RenderPtsLine(new OogColor(155,100,100));
    myLineCore2.render = new RenderPtsLine(new OogColor(155,100,100));
    b = Pt.create(b);  
    d = Pt.create(d);    

    b.apply(rot2);
    b.apply(t);
    b.apply(sAntihorraire);
    b.apply(Ovoid2);
    b.apply(Irregulier);

    d.apply(rot2);
    d.apply(t);
    d.apply(sReverse);

    Transform localTran = new Transform();

    b.apply(localTran);  

    myLineSkin2.add(b);
    myLineCore2.add(d);

    //myObj.add(myLineSkin);   //Store the lines in my object
    //myObj.add(myLineCore);
    //myObj.add(myLineSkin2); 
    //myObj.add(myLineCore2);

  }

  //*//*//////////*////////*//////////*///////////////*//////////*//*//////*/////////*/////*//////*///////*///
  ///////*//////*///FACE


  //face no 1 : FloorFace (l'\u00e9tage du gratte ciel)

  Translate T = new Translate(Zero,Zero,ZSlab);
  Pts myLineCoreBas = new Pts (myLineCore,T);

  Translate Tzero = new Translate(Zero,Zero,ZSlabZero);
  Pts myLineCoreZero = new Pts (myLineCore,Tzero);

  for(int i=0; i<myLineSkin.numOfPts()-2; i++)
  {
    //   if(i%60==0) continue;

    Face FloorFace = new Face();
    Face FloorFace2 = new Face();
    Face CloseDalle = new Face();

    FloorFace.add(myLineSkin.pt(i+1));   
    FloorFace.add(myLineSkin.pt(i+2));   
    FloorFace.add(myLineCoreZero.pt(i+2));   
    FloorFace.add(myLineCoreZero.pt(i+1));  

    FloorFace2.add(myLineSkin.pt(i+1));   
    FloorFace2.add(myLineSkin.pt(i+2));   
    FloorFace2.add(myLineCoreBas.pt(i+2));   
    FloorFace2.add(myLineCoreBas.pt(i+1));  

    CloseDalle.add(myLineCoreZero.pt(i+1));   
    CloseDalle.add(myLineCoreZero.pt(i+2));   
    CloseDalle.add(myLineCoreBas.pt(i+2));   
    CloseDalle.add(myLineCoreBas.pt(i+1));  

    // FloorFace.fill(120,30,30);
    myObj.add(FloorFace);    
    myObj.add(FloorFace2);  
    //  myObj.add(CloseDalle);     

    Obj FloorFaceThikness = new Extrude(FloorFace,Pt.create(Zero,Zero,ZSlabExtrude));

    // FloorFaceThikness.fill(120,30,30);
    myObj.add(FloorFaceThikness);
  }
  ////////////////////////////////////////////////////////////
  //face no 2 : FloorFace (l'\u00e9tage du gratte ciel)

  Pts myLineCoreBas2 = new Pts (myLineCore2,T);

  Pts myLineCoreZero2 = new Pts (myLineCore2,Tzero);

  for(int i=0; i<myLineSkin.numOfPts()-2; i++)
  {
    Face FloorFaceB = new Face();
    Face FloorFaceB2 = new Face();
    Face CloseDalleB = new Face();

    FloorFaceB.add(myLineSkin2.pt(i+1));   
    FloorFaceB.add(myLineSkin2.pt(i+2));   
    FloorFaceB.add(myLineCoreZero2.pt(i+2));   
    FloorFaceB.add(myLineCoreZero2.pt(i+1));  

    FloorFaceB2.add(myLineSkin2.pt(i+1));   
    FloorFaceB2.add(myLineSkin2.pt(i+2));   
    FloorFaceB2.add(myLineCoreBas2.pt(i+2));   
    FloorFaceB2.add(myLineCoreBas2.pt(i+1));  

    CloseDalleB.add(myLineCoreZero2.pt(i+1));   
    CloseDalleB.add(myLineCoreZero2.pt(i+2));   
    CloseDalleB.add(myLineCoreBas2.pt(i+2));   
    CloseDalleB.add(myLineCoreBas2.pt(i+1));  

    //  FloorFace.fill(120,30,30);
    myObj.add(FloorFaceB);    
    myObj.add(FloorFaceB2);  
    //myObj.add(CloseDalle);     

    Obj FloorFaceThiknessB = new Extrude(FloorFaceB,Pt.create(Zero,Zero,ZSlabExtrude));

    // FloorFaceThikness.fill(120,30,30);
    myObj.add(FloorFaceThiknessB);
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////face 4 : SurfaceCore (1er partie des surfaces qui enferment le "core")

  for(int i=0; i<myLineSkin.numOfPts()-numOfSides; i++)

  {
    Face SurfaceCore = new Face();
    Face SurfaceCoreB = new Face();

    SurfaceCore.add(myLineCore.pt(i+1));     
    SurfaceCore.add(myLineCore.pt(i+numOfSides));  
    SurfaceCore.add(myLineCore.pt(i+numOfSides-1));  

    SurfaceCoreB.add(myLineCore.pt(i+2));     
    SurfaceCoreB.add(myLineCore.pt(i+1));  
    SurfaceCoreB.add(myLineCore.pt(i+numOfSides-1));  

    // SurfaceCore.fill(120,120,30);
    myObj.add(SurfaceCore);       
    myObj.add(SurfaceCoreB);  
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////face skin
  //boolean seqOn = true;


  for(int i=0; i<myLineSkin.numOfPts()-numOfSides; i++)
  {
  //  if(seqOn == true && random(10)<2)
  //    seqOn = false;

  //  if(seqOn == false && random(10)<4)
  //    seqOn = true;

   // if(seqOn == true)
   // {
      Face SurfaceSkin = new Face();
      Face SurfaceSkinB = new Face();

      SurfaceSkin.add(myLineSkin2.pt(i+1));     
      SurfaceSkin.add(myLineSkin2.pt(i+numOfSides));  
      SurfaceSkin.add(myLineSkin2.pt(i+numOfSides-1));  

      SurfaceSkinB.add(myLineSkin2.pt(i+2));     
      SurfaceSkinB.add(myLineSkin2.pt(i+1));  
      SurfaceSkinB.add(myLineSkin2.pt(i+numOfSides-1));  

      //if(random(100)<30){
      //SurfaceSkin.fill(random(0,200),random(0,200),random(0,200),40);}

      //if(random(100)<30){
      //SurfaceSkinB.fill(random(0,200),random(0,200),random(0,200),40);}


      myObj.add(SurfaceSkin);       
      myObj.add(SurfaceSkinB);  

  //  }
  }

  //*//////////////////////*//////////////////////////*/////////////*//////////////////////*//////*///////*///
  //////////////*///face 3""" essai\u00e9 de donner \u00e9paisseur aux spirale
  for(int i=0; i<myLineSkin.numOfPts()-3; i=i+1)

  {
    Face RopeThickness = new Face();  //Horraire
    Face RopeThickness2 = new Face(); // AntiHorraire
    Face RopeThickness3 = new Face();  //Horraire
    Face RopeThickness4 = new Face(); // AntiHorraire

      RopeThickness.add(myLineSkin.pt(i+1));    
    RopeThickness.add(myLineSkin.pt(i+2));   
    RopeThickness.add(myLineSkin.pt(i+3));  

    RopeThickness2.add(myLineSkin2.pt(i+1));    
    RopeThickness2.add(myLineSkin2.pt(i+2));   
    RopeThickness2.add(myLineSkin2.pt(i+3));  

    RopeThickness3.add(myLineCore.pt(i+1));    
    RopeThickness3.add(myLineCore.pt(i+2));   
    RopeThickness3.add(myLineCore.pt(i+3));  

    RopeThickness4.add(myLineCore2.pt(i+1));    
    RopeThickness4.add(myLineCore2.pt(i+2));   
    RopeThickness4.add(myLineCore2.pt(i+3));  

    //RopeThickness.fill(120,30,30);
    // myObj.add(RopeThickness);  
    //RopeThickness2.fill(30,30,120);
    // myObj.add(RopeThickness2);  
    //RopeThickness3.fill(120,30,30);
    //myObj.add(RopeThickness3);  
    //RopeThickness4.fill(30,30,120);
    //myObj.add(RopeThickness4);  

    //Obj RopeThickness3D = new Extrude(RopeThickness,Pt.create(0,0,-1));
    // Obj RopeThickness3D2 = new Extrude(RopeThickness2,Pt.create(0,0,-1));
    //Obj RopeThickness3D3 = new Extrude(RopeThickness3,Pt.create(0,0,-1));
    //Obj RopeThickness3D4 = new Extrude(RopeThickness4,Pt.create(0,0,-1));

    //RopeThickness3D.fill(120,30,30);
    //myObj.add(RopeThickness3D);
    //RopeThickness3D2.fill(30,30,120);
    // myObj.add(RopeThickness3D2);
    //RopeThickness3D.fill(120,30,30);
    //myObj.add(RopeThickness3D3);
    //RopeThickness3D2.fill(30,30,120);
    //myObj.add(RopeThickness3D4);

  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////face 4 : SurfaceCore (1er partie des surfaces qui enferment le "core")

  for(int i=0; i<myLineSkin.numOfPts()-(numOfSides+2); i=i+2)
  {
    Face verticales = new Face();

    verticales.add(myLineSkin.pt(i+2));   
    verticales.add(myLineSkin.pt(i+1));   
    verticales.add(myLineSkin.pt(i+numOfSides+1));   
    verticales.add(myLineSkin.pt(i+numOfSides+2));  

    verticales.fill(200,100,100);
    //myObj.add(verticales);  
  }

  //*//*//////////*////////*//////////*///////////////*//////////*//*//////*/////////*/////*//////*///////*///
  //goo.sliders(myObj);   //Create Sliders based on an object

  goo.setCenter(myObj);

}

//boolean imRecording = false;

public void draw() {
  if (record) {                
    // beginRaw(PDF, "output.pdf");
    beginRaw(DXF, "output.dxf");
  }   
  background(50);
  //myCamera.update();
  myObj.draw();
  Transformer.draw(); 
  if (record) {         
    endRaw();            
    record = false;      
  }
//  if(imRecording)
 //   saveFrame("tower####.tga"); 
}

public void keyPressed(){

  switch(key) {
  case 'q': 
    initForm();
    break;
  case 'r': 
    record = true;
 // case 'm':
 //   imRecording = true;
  //  println("isRecording: "+imRecording);
  }   
}



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
//	  myCamera.zoom((float)delta); 
	}
}


  static public void main(String args[]) {     PApplet.main(new String[] { "ProcessingTower_olivier" });  }}