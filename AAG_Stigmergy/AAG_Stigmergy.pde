import processing.opengl.*;
import anar.*;

PFont font;
void initText() {
  font = loadFont("Helvetica-11.vlw");
  textFont(font, 11);
}

/*
 * Ants' agents sketch by Patrick Gaudard and Mathieu Hefti
 * Based on analysis by Patrick Gaudard, Mathieu Hefti, Andrea Pellacani and Manuel Potterat
*/

////////// APPLET'S PARAMETERS //////////
// Sets number of moving elements
int numOfMvElements = 100;
// Sets grid definition (dimension between 2 points) and grid sizes (number of points in 2D)
int gridDef = 20;
int gridSizeX = 25;
int gridSizeY = 25;
// Sets k factor (probability to go to an unmarked grid point)
int k = 1;
// Sets the inertia for a particle to continue in the same direction (percent of k)
int w = 0;
// Sets life-time (levels decrease of 1/f on each draw()'s loop)
int f = 100;
// Sets number of space types and number of criterias (declaration in Types.pde file)
int numOfTypes = 5;
int numOfCriterias = 3;
// Sets multiplicator of relations in probability calculation
int multiplyTypes = 1;
int multiplyCriterias = 1;



////////// SLIDERS //////////
Param kParam = new Param(1, 0, 10, 1).tag("K");
Param wParam = new Param(10, 0, 100, 10).tag("W");
Param fParam = new Param(150, 0, 500, 10).tag("F");
Param tParam = new Param(1, 0, 10, 1).tag("multiTypes");
Param cParam = new Param(1, 0, 10, 1).tag("multiCriterias");



////////// MAIN VARIABLES //////////
// Creates moving elements group
MvElements[] mvElements = new MvElements[numOfMvElements];

// Loads images that will influence moving elements
PImage[] influenceImages = new PImage[numOfCriterias];

// Creates grid points group
GridPts[][] gridPoints = new GridPts[gridSizeX][gridSizeY];

//CAMERA VISUALIZATION VARIABLES
Camera ccc;
Circle turntable;
Pt camPt;
Param tval = new Param(-.4,-.4,1.3);
Sliders s = new Sliders();
Pt origin=Anar.Pt(250,250,-80);


////////// APPLET'S SETUP //////////
void setup() {
  frameRate=12;
  size(1920, 1080, OPENGL);
  Anar.init(this);
  Anar.drawAxis(false);
  s.add(tval);
  //s.add(kParam);
  //s.add(wParam);
  //s.add(fParam);
  //s.add(tParam);
  //s.add(cParam);

  initText();
  typesSettings();

  //CAMERA SETUP
  Pt corigin = Anar.Pt(origin.x(),origin.y(),(((tval.minus(.6)).abs()).multiply(-300)).plus(400) );
  turntable= new Circle(corigin, (((tval.minus(.3)).abs()).multiply(250)).plus(120) );
  camPt = new PtCurve(turntable, tval.plus(.4).multiply(2f/7f).plus(.6)  ); 
 
  ccc = new Camera(-30f,-30f,-30f,origin.x(),origin.y(),origin.z());
  ccc.setCamera(camPt);
  
  
  // Creates each moving element (amout of particles per type controled by types declaration)
  for (int i = 0;i < numOfTypes;i++) {
    int firstIndex = 0;
    for (int j = 0;j < i;j++) {
      firstIndex += mvElements.length * typesRates[j]/100;
    }
    for (int j = firstIndex;j < firstIndex + mvElements.length * typesRates[i]/100;j++) {
      mvElements[j] = new MvElements((int)random(gridSizeX), (int)random(gridSizeY), i);
      println("#" + j + " initialized with " + mvElements[j].toString());
    }
  }

  // Loads images that will influence the moving elements
  for (int i = 0;i < influenceImages.length;i++) {
    influenceImages[i] = loadImage("image" + i + ".gif");
  }

  // Creates each grid point
  for (int i = 0;i < gridPoints.length;i++) {
    for (int j = 0;j < gridPoints[i].length;j++) {
      gridPoints[i][j] = new GridPts(i, j);
    }
  }
}



////////// DISPLAY SCRIPT //////////
boolean displayCriterias = false; // Display criterias levels if true, otherwise types levels (changed during execution with C key)
boolean displayMaximum = false; // Display only maximum level if true, otherwise all levels (changed during execution with M key)
boolean displayLimits = false; // Display only limits if true, otherwise all points (changed during execution with L key)
boolean displayBitmap = false; // Display each types grid side by side
void draw() {
  background(255);
  checkParams();
  //if (tval.get()<0){  camPt = new PtCurve(turntable,   (tval.plus(1)).minus(floor(tval.plus(1).get())) ); 
if (frameCount>=30){
//  } //else { camPt = new PtCurve(turntable, tval);}
  ccc.setCamera(camPt);
ccc.feed();
//s.draw();

if (frameCount==125){ displayMaximum=true;}
if (round(tval.get()*1000)==305){ displayLimits =true;}
if (round(tval.get()*100)==110){ displayLimits =false;}

if (frameCount>95){ tval.set(tval.get()+.005); }
println (frameCount +" : " + ((tval.get())) );
/*
  if (displayCriterias) {
    for (int i = 0;i < numOfCriterias;i++) { // Displays criterias legend
      pushMatrix();
      translate(-150, i*15, 0);
      stroke((i/4)%2 * 255, (i/2)%2 * 255, i%2 * 255);
      noFill();
      //box(10, 10, 10);
      text(criteriasTags[i], 30, 0);
      popMatrix();
    }
  } else {
    for (int i = 0;i < numOfTypes;i++) { // Displays types legend
      pushMatrix();
      translate(-150, i*15, 0);
      stroke((i/4)%2 * 255, (i/2)%2 * 255, i%2 * 255);
      text(typesTags[i], 30, 0);
      noFill();
      box(10, 10, 10);
      popMatrix();
    }
  }
*/
  for (int i = 1;i < gridPoints.length-1;i++) { // Draws each grid point
    for (int j = 1;j < gridPoints[i].length-1;j++) {
      gridPoints[i][j].drawGridPts();
    }
  }

  for (int i = 0;i < mvElements.length;i++) { // Draws each moving element and mark the grid with its types parameters
    mvElements[i].drawMvElements();
    mvElements[i].markGrid();
  }

  for (int i = 0;i < mvElements.length;i++) { // Moves each moving element
    mvElements[i].moveMvElements();
  }

  for (int i = 0;i < gridPoints.length;i++) { // Updates each grid point regarding evaporation rate
    for (int j = 0;j < gridPoints[i].length;j++) {
      gridPoints[i][j].updatePts(f);
    }
  }
  //if ((frameCount-30)<720)  saveFrame("stigmergyHD" + (frameCount-30) + ".jpg");
}
}

void checkParams() {
  if (k != kParam.toInt()) k = kParam.toInt();
  if (w != wParam.toInt()) w = wParam.toInt();
  if (f != fParam.toInt()) f = fParam.toInt();
  if (multiplyTypes != tParam.toInt()) multiplyTypes = tParam.toInt();
  if (multiplyCriterias != cParam.toInt()) multiplyCriterias = cParam.toInt();
}

void keyPressed() {
  if (key == ' ') save("screenShot.jpg");
  if (key == 'c') displayCriterias = displayCriterias ? false : true;
  if (key == 'm') displayMaximum = displayMaximum ? false : true;
  if (key == 'l') displayLimits = displayLimits ? false : true;
  if (key == 'b') displayBitmap = displayBitmap ? false : true;
}
