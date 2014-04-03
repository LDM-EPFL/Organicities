import processing.opengl.*;
//REQUIRES ANAR+ LIBRARY: http://anar.ch/
import anar.*;

//DATA IMPORT VARIABLES
String[] txtVtx;
String[] txtNdx;
float[][] vCoords={{-15,8,7},{-6,8,7},{-17,0,6},{-6,0,0},{4,8,8},{5,0,4},{10,8,7},{12,0,1},{15,0,0},{13,8,4},{17,8,1},{-17,-3,2},{-16,-5,-1},{-6,-5,8},{5,-5,-1},{13,-5,6},{18,-5,4}};
int[][] ndx={{1,0,2},{2,3,1},{1,3,4},{3,5,4},{5,6,4},{7,6,5},{8,6,7},{12,13,3},{13,14,3},{5,3,14},{7,5,14},{7,14,15},{8,7,15},{8,15,16},{12,3,2,11},{6,8,10,9}};
ArrayList[] ndxList;
HEM myMesh;

//CAMERA VISUALIZATION VARIABLES
Camera ccc;
Circle turntable;
Pt camPt;
Param tval = new Param(0,0,1.5);
Sliders s = new Sliders();
Pt origin=Anar.Pt(0,0,0);
float tickT=.0027;

void setup(){
 size(1920,1080,OPENGL);
 Anar.init(this); 
 
  //CAMERA SETUP
 Pt corigin = Anar.Pt(0,0,30);
 turntable= new Circle(corigin, tval.plus(.02).multiply(18));
 camPt = new PtCurve(turntable,tval); 
 ccc = new Camera(-30f,-30f,-30f,0f,0f,0f);
 ccc.setCamera(camPt);
 s.add(tval);
 
 //ndxList IS AN ARRAYLIST SO THAT FACES MAY BE VARIABLE nGON WHEN THE MESH IS IMPORTED
   //THIS STEP SEEMS REDUNDANT SINCE THE VALUES ARE GIVEN ABOVE, BUT THIS FACILITATES IMPORTING MESHES MODELLED IN A CAD PROGRAM VIA .txt FILES (THIS WILL BE A FUTURE FUNCTION)
 ndxList= new ArrayList[ndx.length];
 for(int i=0; i<ndx.length; i++){
   ndxList[i]=new ArrayList();
   for(int j=0; j<ndx[i].length; j++){
     ndxList[i].add(ndx[i][j]);
   }
 }
 
 //  CREATE HALF-EDGE MESH
 myMesh = new HEM(vCoords, ndxList);
}

void draw(){
  background(255);  
  ccc.feed();
   if (frameCount>=30 ){
     int fDelay=(frameCount-30);
     //myMesh.f[(fDelay-(fDelay)%4)/4].fill(50,250,0).draw();
     myMesh.f[(fDelay-(fDelay)%4)/4].fill(0,150,250).draw();
     if (frameCount<700){
     tval.set(tval.get()+ tickT);
     }
     if (fDelay%4==3){
       myMesh.splitCntr((fDelay-3)/4);
     }
   }
   if (tval.get()>=1.35){ tickT=-.0020;} //tval.set(0);}
   println(frameCount);
   
   if (frameCount<720){
  //CHOOSE DISPLAY MODE
  myMesh.displayF();
  //myMesh.displayE();
   saveFrame("MeshSubdvisionHD"+frameCount+".jpg");
   }
  
  
}

void keyPressed(){
  if (key ==' '){ saveFrame("codeQuotidien_HEM"+frameCount+".jpg"); }
}
