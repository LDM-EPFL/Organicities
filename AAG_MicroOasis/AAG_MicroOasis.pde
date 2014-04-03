import gifAnimation.*;
import processing.opengl.*;
import anar.*;
import processing.pdf.*;
GifMaker gifExport;

Pt origin=Anar.Pt(0,0,0);

// IMAGE VARIABLES
PImage topoImg; 
int wImg;
int hImg;

// TOPOGRAPHY FACE VARIABLES
int gridY = 50;
int gridX = int(gridY);
Pt[][] gridPoint = new Pt[gridX+1][gridY+1];
Face[][][] gridFace = new Face [gridX][gridY][2];

// CANYON
Canyon[][][] myCanyon = new Canyon [gridX][gridY][4];

//OASIS VARIABLES
int resolution = 2; 
int decalage = 2; 
Obj [][] relations = new Obj[gridX][gridY];
int[][] lowPointCount = new int[gridX+1][gridY+1];

//    SLIDERS
Sliders s = new Sliders();
float[] xStarts={6.2,44.7,30.4,22.5};
int ctTrace=0;
Param posXSlider =new Param(xStarts[ctTrace], 1, gridX-1);
Param posYSlider =new Param(0, 1, gridX-1);
Param dirSlider = new Param(180,0,270,90);
int sliderTime; // TEMPS AUTOMATIQUE 


// GRPAPHIC VARIABLES
float zFactor = .65;
float growRate = 10; // GROWTHRATE //// 
int canyonDraw = 0;

Camera ccc;
Pt camPt; //=Anar.Pt(0,500,400);
Pt camOrigin;//=Anar.Pt(0,150,0);
Param camTracking=new Param(0f,0,100);
int imgCt=0;
//////////////////////////////////////////////////////////////////////////////////////////////////

void setup() {
  size(1920,1080,OPENGL);
  Anar.init(this);
  Anar.drawAxis(false);
  randomSeed(0);

    //gifExport = new GifMaker(this, "animation_time_4.gif");
   //gifExport.setRepeat(0); // make it an "endless" animation
  // gifExport.setTransparent(255,255,255);

    //cc = new Camera(Anar.Pt(0,600,400), Anar.Pt(0,150,0));
    camPt=Anar.Pt(0,camTracking.plus(600),camTracking.multiply(-4).plus(600));
    camOrigin=Anar.Pt(0,camTracking.plus(150),0);
    ccc = new Camera(camPt, camOrigin);
    ccc.setCamera(camPt);
  // LOAD IMAGE
  topoImg = loadImage ("greyscale_1250_1250.jpg");
  topoImg.loadPixels();
  wImg=topoImg.width;
  hImg=topoImg.height;

  // SET TOPOGRAPHY
  for(int i=0; i<(gridX+1); i++) {
    int xVal = floor((wImg-1)*i/(gridX)); 
    for(int j=0; j<(gridY+1); j++) {
      int yVal = floor((hImg-1)*j/(gridY));
      int pxlNdx = (yVal*hImg) + xVal;
      gridPoint[i][j] = Anar.Pt(xVal-wImg/2,yVal-hImg/2,0);
      color pixCol = topoImg.pixels[pxlNdx];
      gridPoint[i][j].z(red(pixCol)*zFactor); // scale z axis
      // MAKE FACES
      if ( (i>0) && (j>0) ) { 
        gridFace[i-1][j-1][0] = new Face(gridPoint[i-1][j-1],gridPoint[i][j],gridPoint[i  ][j-1]);
        gridFace[i-1][j-1][1] = new Face(gridPoint[i-1][j  ],gridPoint[i][j],gridPoint[i-1][j-1]);
      }
    }
  }

  // SET OASIS PTS
  for(int i=resolution; i<(gridX-resolution); i++) {
    for(int j=resolution; j<(gridY-resolution); j++) {
      Pt lowPoint = Anar.Pt(0,0,1000000);

      // parcours tous (+resolution,-resolution) les points autour des points de la grille

      //relations[i][j] = new Pts ();
            relations[i][j]=new Obj();
      for(int t1=0; t1<((resolution*2)+1); t1++) {
        for(int t2=0; t2<((resolution*2)+1); t2++) {
          if (gridPoint[(i+t1-resolution)][(j+t2-resolution)].z() < lowPoint.z()) {
            lowPoint = gridPoint[(i+t1-resolution)][(j+t2-resolution)];
          }
        }
      }
      // compter le nombre de fois qu'un point est un lowpoint
      for(int t1=0; t1<((resolution*2)+1); t1++) {
        for(int t2=0; t2<((resolution*2)+1); t2++) {
          if (gridPoint[(i+t1-resolution)][(j+t2-resolution)] == lowPoint) {
            lowPointCount[(i+t1-resolution)][(j+t2-resolution)]=lowPointCount[(i+t1-resolution)][(j+t2-resolution)]+1;
          }
        }
      }
      for(int t1=0; t1<((resolution*2)+1); t1++) {
        for(int t2=0; t2<((resolution*2)+1); t2++) {
          float delt=(dist( lowPoint.x(), lowPoint.y(), lowPoint.z(), gridPoint[i+t1-resolution][j+t2-resolution].x(), gridPoint[i+t1-resolution][j+t2-resolution].y(), gridPoint[i+t1-resolution][j+t2-resolution].z() ));
          relations[i][j].add(new Pts(lowPoint, gridPoint[i+t1-resolution][j+t2-resolution]).stroke((2*delt)-50,120-(delt/2)));
          //relations[i][j].add(lowPoint);
          //relations[i][j].add(gridPoint[i+t1-resolution][j+t2-resolution]);
        }
      }
    }
  }

  //    INIT CANYON
  for(int i=1; i<(gridX); i++) {
    for(int j=1; j<(gridY); j++) {
      myCanyon[i][j][0] = new Canyon(i,j,0);
      myCanyon[i][j][1] = new Canyon(i,j,90);
      myCanyon[i][j][2] = new Canyon(i,j,180);
      myCanyon[i][j][3] = new Canyon(i,j,270);
    }
  }

  //    ADD SLIDER
  s.add(posXSlider);
  s.add(posYSlider);
  s.add(dirSlider);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
void draw() {
  randomSeed(0);

  
  if (frameCount%3==0)
  {
    println(frameCount);

  
  background(255);
  noLights(); // no 3d shading

  strokeWeight(2);
  //s.draw();
  // CAMERA TOP OU PERSP

  ccc.feed(); 
 if (frameCount>690) {camTracking.set(camTracking.get()+1.27); }
 //ortho(-1050, 1050, -700,  700,  -5000, 5000); // ortho(left, right, bottom, top, near, far)


  /*// DRAW FACES
   for(int i=0; i<(gridX); i++) {
   for(int j=0; j<(gridY); j++) {
   strokeWeight(1);
   gridFace[i][j][0].draw ();
   gridFace[i][j][1].draw ();
   }
   }*/

  // DRAW OASIS LINES
  for(int i=resolution; i<(min(gridX-resolution,frameCount/3)); i=i+decalage) {
    for(int j=resolution; j<(min(gridY-resolution,frameCount/3)); j=j+decalage) {
      strokeWeight(0.1);
      relations[i][j].draw();
    }
  }

  // DRAW CIRCLE BOTTOM OF OASIS
  for(int i=0; i<(min(gridX,frameCount/3.8)); i++) {
    for(int j=0; j<(min(gridY,frameCount/3.8)); j++) {
      if (lowPointCount[i][j] > 3) {
        //fill (255,0,0,50);
        //ellipse (gridPoint[i][j].x(), gridPoint[i][j].y(), 7*lowPointCount[i][j], 7*lowPointCount[i][j]);
        Circle cir=new Circle(Anar.Pt(gridPoint[i][j].x(), gridPoint[i][j].y(),gridPoint[i][j].z()-5),3.5*lowPointCount[i][j]);
        cir.fill(255,0,0,40+4*lowPointCount[i][j]) ;
        cir.draw();
      }
    }
  }
  // DRAW CANYON AND RIDGE
  int sliderX = int(posXSlider.get());
  int sliderY = int(posYSlider.get());
  int sliderDir = int(dirSlider.get())/90;


  //   int nombreCanyon = ceil(sliderTime/growRate); 
  //   for (int t = 0; t < nombreCanyon;t++)
  //    myCanyon[int(random(0,gridX-1))][int(random(0,gridX-1))][sliderDir].displayCanyon(int(sliderTime-growRate*t));
  //    myCanyon[int(random(0,gridX-1))][int(random(0,gridX-1))][sliderDir].displaylowPoint(int(sliderTime-growRate*t)); 
  //  sliderDir = 0,1,2,3 = DIRECTION DES CANYON
  //  sliderDir = int(random(0,3)) DIRECTION ALEATOIRE
 

 if (frameCount>150){
  sliderTime++; // TEMPS AUTOMATIQUE 
  myCanyon[sliderX][sliderY][sliderDir].displayCanyon(sliderTime);
  myCanyon[sliderX][sliderY][sliderDir].displaylowPoint(sliderTime);
  if (sliderTime==70){
    if (ctTrace<3) {
     sliderTime=0;
     ctTrace++; 
    posXSlider.set(xStarts[ctTrace]);
    }
  }
  //println (frameCount);
 }
 if (imgCt <720 ){
   saveFrame("MicroOase"+imgCt+".jpg");
   imgCt++;
   saveFrame("MicroOase"+imgCt+".jpg");
   imgCt++;
 }
  }
}



/*
void keyPressed() {
  if (key == 'p') {
    beginRaw(PDF, "output.pdf"); 
    //record = true;
  }
  if (key == 'u') {
    endRaw();
  }

// gifExport.finish();

}
*/
void keyPressed() {
  if (key =='z') {
    saveFrame("topoHair"+frameCount+".jpg");
  }
  
}

