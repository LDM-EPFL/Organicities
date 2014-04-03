/*************
 Mesh Section
 	http://codequotidien.wordpress.com/2011/12/11/face-id/
 ***************/

import processing.opengl.*;
//REQUIRES ANAR+ LIBRARY: http://anar.ch/
import anar.*;

//DATA IMPORT VARIABLES
String[] txtVtx;
String[] txtNdx;
float[][] vCoords;
ArrayList[] ndxList;
HEM myMesh;

//CAMERA VISUALIZATION VARIABLES
Camera ccc;
Circle turntable;
Pt camPt;
Param tval = new Param(.1,0,1.5);
Sliders s = new Sliders();
Pt origin=Anar.Pt(0,0,5);
Pt Matterhorn=Anar.Pt(5,16,21.7);


//SECTION VARIABLES
PVector sectN;
//Pt sectPt=Anar.Pt(45.3,10,0);
int ptCt=5;
Pt[] cntr = new Pt[ptCt];
Circle[] circ=new Circle[ptCt];
//Pt[] prtcl = new PtCurve[ptCt];
momentumPt[] prtcl = new momentumPt[ptCt];

Param t=new Param(.01);
Obj web = new Obj();
Obj sectAll =new Obj();
RenderFaceNoStroke rendFace=new RenderFaceNoStroke(new AColor(180,150));
Obj faceTrack=new Obj();

//********************** SETUP ********************** 
void setup() {
  size(950,690, OPENGL);
  Anar.init(this); 


  //CAMERA SETUP
  Pt corigin = Anar.Pt(origin.x(),origin.y(),tval.plus(80).minus(tval.multiply(55)));
  turntable= new Circle(corigin, tval.plus(50).minus(tval.multiply(15)));// tval.plus(.01).multiply(500));
  camPt = new PtCurve(turntable,tval); 
  ccc = new Camera(-30f,-30f,-30f,origin.x(),origin.y(),origin.z());
  ccc.setCamera(camPt);
  s.add(tval);

  //IMPORT BOTH TEXT FILES
  txtVtx = loadStrings("MeshVertex_ZRMT.txt");
  txtNdx = loadStrings("MeshIndex_ZRMT.txt");
  vCoords= new float[txtVtx.length][3];
  ndxList= new ArrayList[txtNdx.length];
  //  IMPORT VALUES FROM TXT FILE
  ReadTxtData_INDEXEDMESH(txtVtx,txtNdx, vCoords, ndxList);

  //  CREATE HALF-EDGE MESH
  myMesh = new HEM(vCoords, ndxList);

  //  CREATE SECTION PLANE
  for (int i=0; i<ptCt; i++) {
    cntr[i]=Anar.Pt(random(-40,40),random(-40,40),0);
    circ[i]=new Circle(cntr[i],random(6,14));
    //prtcl[i]=new PtCurve(circ[i], t.multiply( ((i % 2)-.5)*-2 ).plus(i %2));
     PVector vec = new PVector( random(-1,1),random(-1,1), 0);
    prtcl[i]=new momentumPt(random(-40,40),random(-40,40),0, vec.x, vec.y, vec.z, 1, int(((i % 2)-.5)*2));
  }
}


//********************** DRAW ********************** 
void draw() {
  background(255);  
  ccc.feed();

  if (frameCount>=50 ) {
    println(frameCount);
    if (frameCount<=380) {
      int fDelay=(frameCount-50);
      tval.set(tval.get()+.0025);

      web=new Obj();
      float dimB = .4;
      int f1Prt[]=new int[2];
      for (int i=1; i<ptCt; i++) {
        f1Prt=faceID(prtcl[i], myMesh);
                
        if (f1Prt[1]<0){
         prtcl[i].vX *=-1; 
         prtcl[i].vY *=-1;
         prtcl[i].vZ *=-1 ;
        }
        PVector Nrm= new PVector(myMesh.fN[f1Prt[0]].x(), myMesh.fN[f1Prt[0]].y(), myMesh.fN[f1Prt[0]].z());
        float zSet =intersectVECPLANE(prtcl[i], Anar.Pt(0,0,1), myMesh.fC[f1Prt[0]], Nrm);
        
        prtcl[i].setZ(zSet);
        slopeUp(prtcl[i], myMesh, f1Prt[0], prtcl[i].dir );
        prtcl[i].setInMotion(1f,.5f);
        
        prtcl[i].trail.draw();
        //myMesh.f[f1Prt[0]].draw();   
        
        for (int j=0; j<i; j++) {
          Pts trace=new Pts();
          if (prtcl[i].dir == prtcl[j].dir){
          trace.stroke(100,0,0,125);
          }else{  
          trace.stroke(50,100 + (i*5),250,200);
          }
          int[] f2Prt=ptptConnection(prtcl[i], prtcl[j], f1Prt[0], myMesh,trace);
          web.add(trace);
          println(trace.numOfPts() );
          //if(f2Prt[1]>0){ myMesh.f[f2Prt[0]].fill(0,150,250,50).draw();}
        }
      }
      
      t.set(t.get()+.01);
      if ( t.get() >=1 ) { t.set(.01); }
    }
    strokeWeight(1);
    web.draw();    
    strokeWeight(1);

    //CHOOSE DISPLAY MODE
    myMesh.displayF();
    //myMesh.displayE();
    
    //if (frameCount<425){ saveFrame("codeQuotidien_HEMx"+frameCount+".jpg"); }
    
  } 
  else {
    print(".");
  }
  //s.draw();
}


//********************** KEYPRESS ********************** 
void keyPressed() {
  if (key ==' ') { 
    saveFrame("codeQuotidien_HEM"+frameCount+".jpg");
  }
}

