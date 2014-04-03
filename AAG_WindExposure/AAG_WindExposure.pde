//EPFL-ME:RAK Masterplan
//MxD
//****************
//DXF RECORD
import processing.pdf.*;
import processing.dxf.*;
boolean record;
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
Param tval = new Param(.00,0,1);
Sliders s = new Sliders();
Pt origin=Anar.Pt(2200,850,120);
int frmMod=61;
int frmSwtch=0;

  
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

//    WIND DATA
String[] txtWind;
float[][] wCoords;
float[] windData;
Pt windDraw;
Pt windVec;
Obj windRose=new Obj();
// WIND MONTHLY DATA
String[] txtWindMonthly;
float[][] wmCoords;
//WIND VECTOR--> helps for DUNE MOVEMENT
Obj WindVec= new Obj(); 
Pt [] PrevPt=new Pt[72];
Pt [] NxtPt=new Pt[72];
Obj allWind=new Obj();
Obj htWind[]=new Obj[40];
int mnth=0;

//    DATE PARAMETERS
Param mn=new Param(2,0,11,1);
Param dy=new Param(21,1,31,1);
Param hr=new Param(0,0,24,.25);
Param hr2=new Param(23,0,24,.25);
int frmCt = 0;

boolean sunCastBool=false;
boolean windCastBool=false;
boolean slopeBool=false;
Obj wTrc[]=new Obj[40];
int segMax=0;
int segSt[]=new int[40];
int segCt[]=new int[40];
Obj wTemp=new Obj();
Obj hTemp=new Obj();
int hCt[]=new int[40];
Obj allHt = new Obj();
int fCt[]=new int[40];
Obj fTemp=new Obj();
Obj allF=new Obj();
int f1=1550;
int f2=900;


//    PHYSICS
ParticleSystem px=new ParticleSystem(0, 0);
int prtclCt=8;
Pt[] prtcl = new Pt[prtclCt];
Traerparticle[] pxPrtcl = new Traerparticle[prtclCt];
Obj web = new Obj();



void setup(){
 size(1920,1080,OPENGL,P3D);
 //size(800,500,OPENGL);
  Anar.init(this);
  
//****************
  //  MOV 
  //mov=new MovieMaker(this, width, height, "mstrpln_XX.mov",30,MovieMaker.JPEG,MovieMaker.LOSSLESS,24);
  //  CAMERA SETUP
   Pt corigin = Anar.Pt(origin.x(),origin.y(),tval.multiply(4000).plus(200)); //previous values 650,750,1200, tval.multiply(3000).plus(500)
   turntable= new Circle(corigin,tval.plus(2400).minus(tval.multiply(2350) ) );
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
    siteBounds.translate(0,0,-50);
//****************
   //  CREATE HALF-EDGE MESH
   meshInit = new HEM(vCoords, ndxList);
   
   
//****************
   //IMPORT ANNUAL WIND DATA
   txtWind = loadStrings("RAK_windVector2009.txt");
   wCoords= new float[txtWind.length][4];      //[n][spd,ang,temp,hmd]
   readTxtData_WINDVEC(txtWind, wCoords);
//****************
   //IMPORT MONTHLY WIND DATA ON 9 YEARS
   txtWindMonthly = loadStrings("RAK_windVector2000-09monthly.txt");
   wmCoords= new float[txtWindMonthly.length][2];      //[n][speed,ang]
   readTxtData_WINDMONTHVEC(txtWindMonthly, wmCoords);
//****************

 
      
//****************
   //SLIDERS   
   s.add(tval); 
   s.add(mn);    s.add(dy);    s.add(hr);  s.add(hr2); 
   
   for (int i = 0; i < prtclCt; i++) {
    pxPrtcl[i] = px.makeParticle(1,random(-100,100),random(-100,100),0);
    prtcl[i]=Anar.Pt(pxPrtcl[i].position().x(),pxPrtcl[i].position().y(),pxPrtcl[i].position().z());
    for (int j = 0; j < i; j++) {
      px.makeAttraction(pxPrtcl[i],pxPrtcl[j],-500,5);
    }
  }
  
}




//****************
void draw(){
 background(255);
  //if (tval.get()<=.99){
  ccc.feed();
  //}else{ camera(origin.x(), origin.y()+100,3500, origin.x(), origin.y()+100, 0f, 0f,1f,0f);}

 
  if (frameCount>=80 ){
  
//****************  
  //  DRAW MESH
  //meshInit.displayF(); //DISPLAY FACES or
  meshInit.displayE(); //DISPLAY EDGES 


//EVERY ELEVEN FRAMES FIND NEW WIND VECTOR
if ( frmSwtch % frmMod ==0 && mnth<wmCoords.length ){
  allWind.add(wTemp);
  allHt.add(hTemp);
  allF.add(fTemp);
    //****************
  //  getCurrentWindVec SAMPLE VECTORS FROM .TXT FILE
  //windData = getCurrentWindVec(int(mn.get()),int(dy.get()),int(hr.get()),wCoords);
  windData = getMonthlyWindVec(mnth,wCoords);
  windDraw=Anar.Pt(windData[0], windData[1],-windData[2]/7);
  windVec=Anar.Pt(-windData[0], -windData[1],-windData[2]/7);
  for (int i=0; i<wTrc.length; i++){
   wTrc[i]=new Obj();
   htWind[i]=new Obj();
  }
  println("begin month "+mnth);
  for (int i=0; i<wTrc.length; i++){
    windPaths(windVec, meshInit, wTrc[i], i, windData[2],htWind[i]);
  }
  
    //  DRAW WIND ROSE
  if (mousePressed){
     //windRose=new Obj();
     //dailyWindRose(int(mn.get()),int(dy.get()),wCoords,windRose, origin);  
  }
  //windRose.draw();
  
  segMax=0;
  for (int i=0; i<wTrc.length; i++){
      if( wTrc[i].numOfLines()>segMax){
       segMax=  wTrc[i].numOfLines();
      }
      segCt[i]=0;
      hCt[i]=0;
      fCt[i]=0;
  }
  for (int i=0; i<wTrc.length; i++){
   segSt[i]= floor((segMax-wTrc[i].numOfLines())/2);
  }
  wTemp=new Obj();
  hTemp=new Obj();
  fTemp=new Obj();
  
  frmSwtch=1;
  if (mnth==1) { frmMod=41;}
  if (mnth==7) { frmMod=9;}
    strokeWeight(1);
    allWind.draw();
    if (mnth<50){ allHt.draw(); };
    allF.draw();
    mnth++;
    
  //CLOSE EVERY TEN FRAMES
  }else{
    
    if (mnth<=5){
      tval.set(tval.get()+.0009);   //0009
    } else if (mnth<=12){
      tval.set(tval.get()+.0012);    //0015
    } else {  tval.set(tval.get()+.0018);}   //0025
    
    float stpSize=max( floor(float(segMax)/float(frmMod-1)),2);
    //ADD TRACES TO DISPLAY OBJECTS
    //println(frameCount%11 + "  : " + segMax);
    for (int i=0; i<wTrc.length; i++){

      if (segCt[i]>=segSt[i]){
        //ADD 1/10 OF LINE TO DISPLAY OBJECT
        for (int j=0; j<ceil(stpSize); j++){
          if ( (segCt[i]+j)-(segSt[i])<wTrc[i].numOfLines() ){
            wTemp.add( wTrc[i].getLine( (segCt[i]+j)-(segSt[i])  ) ); 
          //if (i==20){ println("Trc: " + wTrc[i].numOfLines() + " HtL: " + htWind[i].numOfLines() + " HtF: " + htWind[i].numOfFaces()); }
          } 
        }
        segCt[i]+=ceil(stpSize);
        
      //ADD HT LINES TO hTemp
      if (wTrc[i].numOfLines()>0 ){
      for (int j=0; j< ceil( (float(htWind[i].numOfLines()) /  float(wTrc[i].numOfLines())) * floor(stpSize) ) ; j++){

        if ( (hCt[i]+j)<htWind[i].numOfLines() ){
          hTemp.add( htWind[i].getLine( hCt[i]+j )); 
        } 
      }
      hCt[i]+=ceil( (float(htWind[i].numOfLines()) /  float(wTrc[i].numOfLines())) * floor(stpSize) );  
     //ADD FACES TO fTemp
     for (int j=0; j< ceil( (float(htWind[i].numOfFaces()) /  float(wTrc[i].numOfLines())) * floor(stpSize) ) ; j++){

        if ( (fCt[i]+j)<htWind[i].numOfFaces() ){
          fTemp.add( htWind[i].getFace( fCt[i]+j )); 
        } 
      }
      fCt[i]+=ceil( (float(htWind[i].numOfFaces()) /  float(wTrc[i].numOfLines())) * floor(stpSize) );
      }  
      
      } else { segCt[i]+=ceil(stpSize); } //STEP CLOSER TO 
      
    }
    strokeWeight(4);
    wTemp.draw();
    strokeWeight(2);
    hTemp.draw();
    fTemp.draw();
    strokeWeight(1);
 
    allWind.draw();
    if (mnth<50){ allHt.draw();}
    allF.draw();
    
      //emiratesRd.draw();
      //siteBounds.draw();
    

    
    if (mnth==1){ 
      //frmCt++;
    }
    println("frame: "+ frmCt);
    //saveFrame("WindExposureHD"+frmCt+".jpg");
    frmCt++;
    frmSwtch++;
  }
  
  /*
  //if (windCastBool==true){
      wTrc=new Obj();
      println("begin month "+mnth);
      windPaths(windVec, meshInit, wTrc, 0, windData[2],htWind);
      allWind.add(wTrc);
      //windCastBool=false;
      mnth++;
      
      
    //  DRAW LINE FOR WIND POSITION
    //showCurrentWindVec(origin, windDraw, windData[4]);
    showCurrentWindVec(origin, windDraw, -10);
    strokeWeight(4);
    wTrc.draw();
    strokeWeight(1);
    }
    */


    WindVec.draw();
 


    
  //MAKING A DXF FILE STARTING RECORD HERE
  if (record) {
    beginRaw(PDF, "windPaths.pdf");
  }

//****************   

  //END OF DXF RECORDING
    if (record) {
    endRaw();
  }
  
  //MAKING A DXF FILE STARTING RECORD HERE
  if (record) {
    beginRaw(PDF, "windMarks.pdf");
  }
  strokeWeight(1);
  //htWind.draw();
      strokeWeight(2);
  emiratesRd.draw();
  siteBounds.draw();
    strokeWeight(1);
  //****************    
  //END OF DXF RECORDING
    if (record) {
    endRaw();
    println ("pdf finished");
    record=false;
  }

    if (mnth<105) { saveFrame("WindExposureHD"+frmCt+".jpg"); }
  
  //****************  
  //  DRAW SLIDER 
  //s.draw();
  //if (movBool==true){ mov.addFrame();} 
  }
}



void keyPressed(){
  if (key ==' '){ saveFrame("mstrpln_xx"+".jpg"); }
  if (key =='s'){ sunCastBool= true; }
  if (key =='w'){ windCastBool= true; }
  if (key =='m'){ if (movBool==true){mov.finish();}  movBool= false; }
  if (key =='d'){ slopeBool=true; }
  // key press for dxf file making
  if (key == 'r') record = true;


}
