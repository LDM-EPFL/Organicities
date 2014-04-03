import oog.*;
import processing.opengl.*;
import processing.dxf.*;
boolean record = false;

Oog myScene;
Obj form;
Obj affichage = new Obj();
Sliders mySliders;

void setup(){
  size(1800,1000,OPENGL);
  myScene = new Oog(this);
  //Pts.globalRender = new RenderPtsAll();
  Scene.drawAxis = true;
  mySliders = new Sliders();
  createForm();
  //form.fill(100,220,220,240);

  //Face.globalRender = new RenderFaceSequence(new OogColor(255,255,0),new OogColor(255,0,0), 255) ;
  //Face.globalRender = new RenderFaceNoStroke(new OogColor(255,150,0)) ;
  //Face.globalRender = new RenderFaceMagicPower();
}


// hauteur d'etage/2  
float hauteur = 1.4;
// slab/2  
float slabthick = 0.3;
// nb de point 
int numberOfPts = 240;
int numOfSides = 20;


Param zero = new Param(0);
Obj module;
Obj module2;
Obj moduleInt;
Obj module2Int;
Obj facade;
Obj facade2;
Obj windows;
Obj Hotel;
Obj Hotel2;
Obj HotelInt;
Obj Hotel2Int;
float alfa = 2*PI/numOfSides;

void createForm(){

  form = new Obj();

  Pt a = Pt.create(0,50,0);      
  Pt b = Pt.create(0,0,0);
  Pt c = Pt.create(-50,0,0);

  Pts midAB = new PtsMid(a,b,2);
  Pts midBC = new PtsMid(b,c,2);
  Pts midCA = new PtsMid(c,a,2);

  Pts basicLine = new Pts();

  basicLine.add(a);
  basicLine.add(midAB.pt(1));
  basicLine.add(b);
  basicLine.add(midBC.pt(1));
  basicLine.add(c);
  basicLine.add(midCA.pt(1));

/////////////////////////////////////////////////////////////////////////////////////////
  Pt aInt = Pt.create(-8,30.6,0);      
  Pt bInt = Pt.create(-8,8,0);
  Pt cInt = Pt.create(-30.6,8,0);

  Pts midABInt = new PtsMid(aInt,bInt,2);
  Pts midBCInt = new PtsMid(bInt,cInt,2);
  Pts midCAInt = new PtsMid(cInt,aInt,2);

  Pts basicLineInt = new Pts();

  basicLineInt.add(aInt);
  basicLineInt.add(midABInt.pt(1));
  basicLineInt.add(bInt);
  basicLineInt.add(midBCInt.pt(1));
  basicLineInt.add(cInt);
  basicLineInt.add(midCAInt.pt(1));
//////////////////////////////////////////////////////////////////////////////////////////////////////
  
  Transform slab = new Transform();
  slab.translate(0,0,2*slabthick);

  Pts basicLineSlab = new Pts(basicLine);
  basicLineSlab.apply(slab);
  
   Pts basicLineIntSlab = new Pts(basicLineInt);
  basicLineIntSlab.apply(slab);


  Transform floorscale1 = new Transform();
  floorscale1.translate(0,0,2*hauteur+2*slabthick);
  floorscale1.scale(0.995,0.995,1);
  Transform floorscale = new Transform(bInt,floorscale1);
  
  Transform floorscale2 = new Transform();
  floorscale2.translate(0,0,2*hauteur+2*slabthick);
  floorscale2.scale(0.997,0.997,1);
  Transform floorscaleInt = new Transform(midABInt.pt(1),floorscale2);
  
  Obj tower = new Obj();

  float k = 40;

  Param [] etage = new Param [87];
  ////////// boucle qui crée les etages///////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////
  for(int i=0; i<etage.length; i++){

    RotateZ rotE = new RotateZ((-2*PI/700));
    RotateZ rotW = new RotateZ((-2*PI/900));

    Translate bulbe1 = new Translate(((sq(sq(k))/(sq(i-70)+sq(k)))-k)/150,0,0);
    Translate bulbe2 = new Translate(0,0,((sq(sq(k))/(sq(i-40)+sq(k)))-k)/140);
    Translate bulbe3 = new Translate(0,0,-((sq(sq(k))/(sq(i)+sq(k)))-k)/180);
    
      Translate bulbe1int = new Translate(((sq(sq(k))/(sq(i-70)+sq(k)))-k)/200,0,0);
    Translate bulbe2int = new Translate(0,0,2);
    Translate bulbe3int = new Translate(0,0,-1);

    Pts basicLineCopy = new Pts(basicLine);
    Pts basicLineSlabCopy = new Pts(basicLineSlab);

    basicLineCopy.pt(4).apply(rotE);
    basicLineCopy.apply(floorscale);

    Pts midABCopy = new PtsMid(basicLineCopy.pt(0),basicLineCopy.pt(2),2);
    Pts midBCCopy = new PtsMid(basicLineCopy.pt(2),basicLineCopy.pt(4),2);
    Pts midCACopy = new PtsMid(basicLineCopy.pt(4),basicLineCopy.pt(0),2);

    Pts basicLineUp = new Pts();
    basicLineUp.add(basicLineCopy.pt(0));
    basicLineUp.add(midABCopy.pt(1));
    basicLineUp.add(basicLineCopy.pt(2));
    basicLineUp.add(midBCCopy.pt(1));
    basicLineUp.add(basicLineCopy.pt(4));
    basicLineUp.add(midCACopy.pt(1));

    basicLineSlabCopy.pt(4).apply(rotE);
    basicLineSlabCopy.apply(floorscale);

    Pts midABSlabCopy = new PtsMid(basicLineSlabCopy.pt(0),basicLineSlabCopy.pt(2),2);
    Pts midBCSlabCopy = new PtsMid(basicLineSlabCopy.pt(2),basicLineSlabCopy.pt(4),2);
    Pts midCASlabCopy = new PtsMid(basicLineSlabCopy.pt(4),basicLineSlabCopy.pt(0),2);

    Pts basicLineSlabUp = new Pts();
    basicLineSlabUp.add(basicLineSlabCopy.pt(0));
    basicLineSlabUp.add(midABSlabCopy.pt(1));
    basicLineSlabUp.add(basicLineSlabCopy.pt(2));
    basicLineSlabUp.add(midBCSlabCopy.pt(1));
    basicLineSlabUp.add(basicLineSlabCopy.pt(4));
    basicLineSlabUp.add(midCASlabCopy.pt(1));

    Transform bulbeallign0 = new Transform(basicLineSlabUp.pt(0), basicLineSlabUp.pt(2), basicLineUp.pt(0), bulbe1);
    Transform  bulbeallign1 = new Transform(basicLineSlabUp.pt(2), basicLineSlabUp.pt(4), basicLineUp.pt(2), bulbe2);
    Transform bulbeallign2 = new Transform(basicLineSlabUp.pt(0), basicLineSlabUp.pt(4), basicLineUp.pt(0), bulbe3);


    basicLineUp.pt(1).apply(bulbeallign0); 
    basicLineUp.pt(3).apply(bulbeallign1); 
    basicLineUp.pt(5).apply(bulbeallign2);

    basicLineSlabUp.pt(1).apply(bulbeallign0); 
    basicLineSlabUp.pt(3).apply(bulbeallign1); 
    basicLineSlabUp.pt(5).apply(bulbeallign2);

Pts basicLineIntCopy = new Pts(basicLineInt);
    Pts basicLineIntSlabCopy = new Pts(basicLineIntSlab);

    basicLineIntCopy.pt(4).apply(rotW);
    basicLineIntCopy.apply(floorscaleInt);

    Pts midABIntCopy = new PtsMid(basicLineIntCopy.pt(0),basicLineIntCopy.pt(2),2);
    Pts midBCIntCopy = new PtsMid(basicLineIntCopy.pt(2),basicLineIntCopy.pt(4),2);
    Pts midCAIntCopy = new PtsMid(basicLineIntCopy.pt(4),basicLineIntCopy.pt(0),2);

    Pts basicLineIntUp = new Pts();
    basicLineIntUp.add(basicLineIntCopy.pt(0));
    basicLineIntUp.add(midABIntCopy.pt(1));
    basicLineIntUp.add(basicLineIntCopy.pt(2));
    basicLineIntUp.add(midBCIntCopy.pt(1));
    basicLineIntUp.add(basicLineIntCopy.pt(4));
    basicLineIntUp.add(midCAIntCopy.pt(1));

    basicLineIntSlabCopy.pt(4).apply(rotW);
    basicLineIntSlabCopy.apply(floorscaleInt);

    Pts midABIntSlabCopy = new PtsMid(basicLineIntSlabCopy.pt(0),basicLineIntSlabCopy.pt(2),2);
    Pts midBCIntSlabCopy = new PtsMid(basicLineIntSlabCopy.pt(2),basicLineIntSlabCopy.pt(4),2);
    Pts midCAIntSlabCopy = new PtsMid(basicLineIntSlabCopy.pt(4),basicLineIntSlabCopy.pt(0),2);

    Pts basicLineIntSlabUp = new Pts();
    basicLineIntSlabUp.add(basicLineIntSlabCopy.pt(0));
    basicLineIntSlabUp.add(midABIntSlabCopy.pt(1));
    basicLineIntSlabUp.add(basicLineIntSlabCopy.pt(2));
    basicLineIntSlabUp.add(midBCIntSlabCopy.pt(1));
    basicLineIntSlabUp.add(basicLineIntSlabCopy.pt(4));
    basicLineIntSlabUp.add(midCAIntSlabCopy.pt(1));
    //form.add(basicLineUp);
    //form.add(basicLineSlabUp);
    
     Transform bulbeallign0Int = new Transform(basicLineIntSlabUp.pt(0), basicLineIntSlabUp.pt(2), basicLineIntUp.pt(0), bulbe1int);
    Transform  bulbeallign1Int = new Transform(basicLineIntSlabUp.pt(2), basicLineIntSlabUp.pt(4), basicLineIntUp.pt(2), bulbe2int);
    Transform bulbeallign2Int = new Transform(basicLineIntSlabUp.pt(0), basicLineIntSlabUp.pt(4), basicLineIntUp.pt(0), bulbe3int);
    
    
 basicLineIntUp.pt(1).apply(bulbeallign0Int); 
    basicLineIntUp.pt(3).apply(bulbeallign1Int); 
    basicLineIntUp.pt(5).apply(bulbeallign2Int);

    basicLineIntSlabUp.pt(1).apply(bulbeallign0Int); 
    basicLineIntSlabUp.pt(3).apply(bulbeallign1Int); 
    basicLineIntSlabUp.pt(5).apply(bulbeallign2Int);

if(i%4==0){
//windows = createWindows(basicLineInt,basicLineIntUp,basicLineIntSlab,basicLineIntSlabUp);
//tower.add(windows);
windows = createWindows(basicLine,basicLineUp,basicLineSlab,basicLineSlabUp);
tower.add(windows);
}

/*if(i%2==0){
    //module = createModule(basicLine,basicLineUp,basicLineSlab,basicLineSlabUp);
    //moduleInt = createModuleInt(basicLineInt,basicLineIntUp,basicLineIntSlab,basicLineIntSlabUp);
    //facade = createFacade(basicLine,basicLineUp,basicLineSlab,basicLineSlabUp);
  // Hotel = createHotel(basicLine,basicLineUp,basicLineSlab,basicLineSlabUp);
//tower.add(Hotel);
//HotelInt = createHotelInt(basicLineInt,basicLineIntUp,basicLineIntSlab,basicLineIntSlabUp);
//tower.add(HotelInt);
//tower.add(module);
 // tower.add(moduleInt);
    //tower.add(facade);
   
 }
 else{
   // Hotel2 = createHotel2(basicLine,basicLineUp,basicLineSlab,basicLineSlabUp);
//tower.add(Hotel2);
Hotel2Int = createHotel2Int(basicLineInt,basicLineIntUp,basicLineIntSlab,basicLineIntSlabUp);
tower.add(Hotel2Int);
    //module2 = createModule2(basicLine,basicLineUp,basicLineSlab,basicLineSlabUp);
   //module2Int = createModule2Int(basicLineInt,basicLineIntUp,basicLineIntSlab,basicLineIntSlabUp);
   // facade2 = createFacade2(basicLine,basicLineUp,basicLineSlab,basicLineSlabUp);
  // tower.add(module2);
 //tower.add(module2Int);
  // tower.add(facade2);
    }
  
*/    
    
    basicLine=basicLineUp;
    basicLineSlab=basicLineSlabUp;
    basicLineInt=basicLineIntUp;
    basicLineIntSlab=basicLineIntSlabUp;

  }

  form.add(tower);

  // mySliders.add(bulbe1);
  // mySliders.add(bulbe2);
  // mySliders.add(bulbe3);

  //mySliders.add(rotE);

  myScene.setCenter(form);
}


void draw(){

  background(255);
  form.draw();
  affichage.draw();

  mySliders.draw();

  //saveFrame("trucMachin####.tga");
}

void keyPressed(){

  switch(key){

  case 'r':
    RhinoScript.exportObj(form,this.getClass().getName());
    break;
  case 's':
    SketchUpRuby.exportObj(form,this.getClass().getName());
    break;
  }
}
