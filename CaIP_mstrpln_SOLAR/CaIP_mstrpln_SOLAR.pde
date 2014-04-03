//EPFL-ME:RAK Masterplan
//MxD

//****************
//  LIBRARIES
import processing.video.*;
import processing.opengl.*;
import anar.*;
import physics.*;

//  MOV
MovieMaker mov;
boolean movBool=false;
//  CAMERA VARIABLES
Camera ccc;
Circle turntable;
Pt camPt;
Param tval = new Param(.3,0,1);
Sliders s = new Sliders();
Pt origin=Anar.Pt(2000,500,120);
  
  
//****************
//  DATA IMPORT VARIABLES
//    TOPOGRAPHY
String[] txtVtx;
String[] txtNdx;
float[][] vCoords;
ArrayList[] ndxList;
HEM meshInit;
String[] rdVtx;
Obj emiratesRd;      // road
String[] bndVtx;
Obj siteBounds;      // site

//    SOLAR POSITION
String[] txtSun;
float[][] sCoords;
Pt sunVec;
Pts sunLine=new Pts();
Obj sunDome=new Obj();


//    DATE PARAMETERS
Param mn=new Param(6,0,11,1);
Param dy=new Param(21,1,31,1);
Param hr=new Param(5,0,24,.125);
//Param hr2=new Param(17.5,0,24,.25);
boolean sunCastBool=false;
boolean windCastBool=false;
boolean slopeBool=false;
Obj castTrc=new Obj();
Obj castSlc=new Obj();
Obj castFc=new Obj();
Pts cnnct=new Pts();
Obj eSlope=new Obj();
Obj wTrc=new Obj();
int f1=1550;
int f2=900;


//****************
// SUN OVERLAY DATA
int pVal=2;
boolean SunPicksBool=false;
boolean sunIncidenceBool=false;
Obj FaceNew=new Obj();
//    float[] angSum;
//    PVector[] faceNorm;

Pt[] extrPt;
Obj Extr=new Obj();


Pt[] pt;



void setup(){
  size(1024,768,OPENGL);
  Anar.init(this);
//****************
  //  MOV 
  //mov=new MovieMaker(this, width, height, "mstrpln_XX.mov",30,MovieMaker.JPEG,MovieMaker.LOSSLESS,24);
  //  CAMERA SETUP
   Pt corigin = Anar.Pt(origin.x(),origin.y(),tval.multiply(2000).plus(250)); //previous values 650,750,1200, tval.multiply(3000).plus(500)
   ///turntable= new Circle(corigin,tval.multiply(750).plus(1250) ); //CIRCLE EXPANDS WITH TVAL
   turntable= new Circle(corigin,2000 );//CIRCLE WITH CONSTANT RADIUS
   camPt = new PtCurve(turntable,tval);
   ccc = new Camera(camPt,origin);
   ccc.setCamera(camPt);

//****************
    //IMPORT TOPOGRAPHY TEXT FILES
   txtNdx = loadStrings("MeshIndexTSS.txt");
   txtVtx = loadStrings("MeshVertexTSS.txt");
   vCoords= new float[txtVtx.length][3];
   ndxList= new ArrayList[txtNdx.length];
   //  IMPORT VALUES FROM TXT FILE
   ReadTxtData_ARRAYONLY(txtVtx,txtNdx, vCoords, ndxList);
//****************
    //IMPORT CONTEXT
    rdVtx=loadStrings("311_Vertex.txt");
    emiratesRd=new Obj();
    ReadTxtData_VERTEX(rdVtx, emiratesRd);
    
    bndVtx=loadStrings("site_Vertex.txt");
    siteBounds=new Obj();
    ReadTxtData_VERTEX(bndVtx, siteBounds);
    
//****************
   //  CREATE HALF-EDGE MESH
   meshInit = new HEM(vCoords, ndxList);
   
   
//****************
   //IMPORT ANNUAL SUN DATA
   txtSun = loadStrings("RAK_sunVector.txt");
   sCoords= new float[txtSun.length][3];        //[n][x,y,z]
   readTxtData_SOLARVEC(txtSun, sCoords);
   sunVec = getCurrentSunVec(int(mn.get()),int(dy.get()),hr.get(),sCoords) ;
   //sunVec2 = getCurrentSunVec(int(mn.get()),int(dy.get()),hr.get(),sCoords) ;
   sunVec.translate(origin);
   sunLine=new Pts(origin, sunVec);
   hourlySunDome(sCoords, sunDome);
   monthlySunDome(sCoords, sunDome);
   sunDome.translate(origin);
//****************
    //IMPORT SUN OVERLAY DATA
//    angSum= new float[meshInit.f.length] ;

//**************** 
  //  EXTRUDE ALL
extrPt=new Pt[meshInit.f.length];
for (int i=0; i<meshInit.f.length; i++){
  extrPt[i]=Anar.Pt(0,0,10);
  Extr.add(new Extrude(meshInit.f[i],extrPt[i]).fill(250,120));
}

//****************
   //SLIDERS   
   //s.add(tval); 
   s.add(mn);    s.add(dy);    s.add(hr); // s.add(hr2); 
}




//****************
void draw(){
 background(255);
   ccc.feed();
  //camera(0, 600,4000f, origin.x(), origin.y()+600, 0f, 0f,1f,0f);

  if (frameCount>=50){
    if ( hr.get()<24){ hr.set(hr.get()+.125);}
    if (frameCount>70 && tval.get()<.81){
    tval.set(tval.get()+.005);
    }
    //px.tick();      
    emiratesRd.draw();
    siteBounds.draw();
    

 
    



//****************
  //  getCurrentSunVec INTERPOLATES (LINEARLY) BETWEEN THE SAMPLE VECTORS FROM .TXT FILE
  sunVec.set( getCurrentSunVec(int(mn.get()),int(dy.get()),hr.get(),sCoords) );
  //  DRAW LINE FOR SUN POSITION
    showCurrentSunVec(sunVec,sunLine);
  //  DRAW SUN DOME
  sunDome.draw();
  
  //****************  
  //  DRAW MESH
  //if( sunVec.z()<50){
   // stroke(80);
  //meshInit.displayF(); //DISPLAY FACES or
  //} else{
    //sunCastBool=true;
    
  //meshInit.displayE(); //DISPLAY EDGES 
  //}
  if (frameCount%2==0){SunPicksBool=true;}  
  if(hr.get()>8.6 && hr.get()<15.6){ sunCastBool=false;   } 
   
    
  /*/****************    
  if (sunCastBool==true){
    Pt vecCast=sunVec.minus(origin);
    println("checking sun:");
      castTrc=new Obj();
      castSlc=new Obj();
      castFc=new Obj();
  //  CAST VECTOR: SELF-SHADE
  for (int i=0; i<meshInit.v.length; i++){
    castVector(meshInit,i, vecCast, castTrc, castSlc, castFc,'s');
  }
  sunCastBool=false;
  println("finished");
  }
  */
  
    //****************  ???????  
  if (sunIncidenceBool==true){
    println("checking sun incidence overlay");
     println("finished");
  }
  sunIncidenceBool=false;
  
  //FaceNew.draw();
  
  //********************
  if (SunPicksBool==true){
   println("checking sun incidence");
   Pt vecCast=origin.minus(sunVec);
   for (int i=0; i<extrPt.length; i++){
      getExtrHt(vecCast, meshInit, extrPt[i], i, Extr);
   }
  }
  stroke(100,50);
  Extr.draw();

 
  //FaceNew.draw();
  //TruncObj.draw();
  //Extrudef.draw();
  

    
    
    
//***********************  
  //strokeWeight(2);
  //castTrc.draw();
  //noStroke();
  //castSlc.draw();
  //castFc.draw();
  strokeWeight(1);
//****************  
  //  DRAW SLIDER 
  //s.draw();
  //if (movBool==true){ mov.addFrame();} 
  println(tval.get()+" "+hr.get());
  
//  if ((frameCount-50)<=170){
  //  saveFrame("incidenceD_"+(frameCount-50)+".jpg");
  //}
  
  }
  }




void keyPressed(){
  if (key ==' '){ saveFrame("mstrpln_xx"+".jpg"); }
  if (key =='s'){ sunCastBool= true; }
  if (key =='w'){ windCastBool= true; }
  if (key =='m'){ if (movBool==true){mov.finish();}  movBool= false; }
  if (key =='d'){ slopeBool=true; }
  if (key =='h'){ sunIncidenceBool= true; }
  if (key =='p'){SunPicksBool= true; }
  if (key =='o'){ pVal=((pVal+1)%3); }// pVal==1: truncated, pVal==2: extruded
  
}
