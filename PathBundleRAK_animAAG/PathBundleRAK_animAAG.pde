//LIBRARIES
import processing.opengl.*;
import anar.*;
import physics.*;
import processing.dxf.*;

//GLOBAL DECLARATIONS
PVector z = new PVector(0, 0, 1); //global unit z vector
//ACCESS POINTS
String[] accTxt;        //to hold access points text input
Pt[] accPt;             //to hold access points
Circle[] accCirc;       //to visualize Pt as Circle
String[] perpTxt;       //to hold perpendicular vector text input
Pt[] perpPt;            //to hold perpendicular points
PVector[] perpVec;      //to hold initial directions
Obj ptDraw = new Obj(); //to hold start and end point visualizations
//TARGET POINTS
String[] tarTxt;  //to hold target point text input
Pt[] tarPt;       //to hold target points
Circle[] tarCirc; //to visualize target points as Circle
//BOUNDARY POLYLINES
String[] boundTxt;       //to hold boundary text input
Pts[] boundPts;          //to hold boundaries as Pts
Obj context = new Obj(); //to hold context geometry for visualization
////MESH TOPOGRAPHY
String[] txtVtx;     //to hold vertex text input
String[] txtNdx;     //to hold index text input
float[][] vCoords;   //to hold vertex coordinates
ArrayList[] ndxList; //to hold indices (will be integers)
HEM meshInit;        //to hold the resulting half-edge mesh, see HEM_class tab
//SEEKING AGENTS
int stPtCt;                //to hold number of MomentumPt start points
int tarPtCt;               //to hold number of MomentumPt target points
int total;                 //to hold total number of MomentumPts created
int stopped;               //to compare to tell when all agents have reached target
int[][] hierarchy;         //to hold agent priority, see class and step()
int hierarchyCt;           //counter for incremental display of agents launched
MomentumPt[][] blacklines; //to hold seeking agents, first length is start points, second target points; every start seeks every target
//BUNDLED PATHS
ParticleSystem[][] ps;    //to hold bundled lines
int dropRate = 10;        //~10 //frequency at which particles are 'dropped'
Obj pathDraw = new Obj(); //to hold particle markers and spring visualization
Obj[][] attrLines; //to hold attraction lines visualization
Obj drawObj = new Obj(); //to incrementally draw attraction lines
int framesAddedCount = 0;  //counter for attraction lines


//PARAMETRICS
Param sepWt = new Param(1.4, 0, 2); //parametric weight of separation behavior ~1.4
Param aliWt = new Param(0.6, 0, 2);   //parametric weight of alignment behavior ~1.0 //0.6
Param cohWt = new Param(0.8, 0, 2);   //parametric weight of cohesion behavior ~1.0 //0.8
Param tarWt = new Param(1.8, 0, 5); //parametric weight of target-seeking behavior ~1.6 //1.8
Param topWt = new Param(0.9, 0, 5); //parametric weight of topo navigation behavior ~1.5 //1.7
Param avdWt = new Param(1.0, 0, 5); //parametric weight of non-target-avoiding behavior
Sliders s = new Sliders();          //slider object for interaction
//TOGGLES
Boolean drawBundles = false;
Boolean findAttractions = false;
Boolean bundlePaths = false;
Boolean stopSwarm = false;
Boolean startAttract = false;
Boolean record = false;
int recCt = 1;
Boolean drawPoints = true;
Boolean drawAgents = true;
Boolean drawPaths = true;
Boolean drawAttractions = true;
//CAMERA
//Camera se3D;
//////////
//OR
//////////
//  CAMERA VARIABLES
Camera ccc;
Circle turntable;
Pt camPt;
Param tval = new Param(.3, 0, 1);
Pt origin=Anar.Pt(1325, 325, 120);

//TRACKING OUTPUT
//String[] track; //to hold output strings
//int trackCt = 300; //number of frames to track

void setup() {
  size(1920, 1080, OPENGL);
  Anar.init(this);
  randomSeed(3);
  //Anar.drawAxis();
  //Anar.drawReferenceFrame();

  //CAMERA
  //se3D = new Camera(2075, 1075, 1500, 1325,325,0); - OR
  //PATH ANIMATION SETUP
  //Pt corigin = Anar.Pt(origin.x(), origin.y(), tval.multiply(2000).plus(250)); //previous values 650,750,1200, tval.multiply(3000).plus(500)
  ////turntable= new Circle(corigin,tval.multiply(750).plus(1250) ); //CIRCLE EXPANDS WITH TVAL
  //turntable= new Circle(corigin, 2000 );//CIRCLE WITH CONSTANT RADIUS
  //camPt = new PtCurve(turntable, tval);
  //ccc = new Camera(camPt, origin);
  //ccc.setCamera(camPt);
  //end path animation setup


  //ACCESS POINTS (green circles), initial direction, and temporal hierarchy
  accTxt = loadStrings("accessPoints.txt"); //access points in as text
  println("stPtCt: " + accTxt.length);
  stPtCt = accTxt.length; //should be used for all 'i' (start point) loop lengths
  accPt = new Pt[stPtCt]; //initialize start points
  readTxtData_POINTS(accTxt, accPt); //translate text input to Pt, see tab readTxtData_POINTS
  accCirc = new Circle[stPtCt]; //initialize start circles with correct length
  perpTxt = loadStrings("PerpSpotPt.txt"); //perpendicular vectors in as text
  perpPt = new Pt[perpTxt.length]; //initialize perp points
  perpVec = new PVector[perpTxt.length]; //initialize start directions with correct length
  readTxtData_POINTS(perpTxt, perpPt); //translate text input to Pt, see tab readTxtData_POINTS
  for (int i=0; i<stPtCt; i++) { //loop through all start points
    accCirc[i] = new Circle(accPt[i], 10); //create Circle with a set diameter at each start point
    accCirc[i].fill(0, 255, 0, 100).stroke(0, 255, 0, 100); //color access points green
    ptDraw.add(accCirc[i]); //add circle to context Obj, see draw()
    perpVec[i] = new PVector(perpPt[i].x()-accPt[i].x(), perpPt[i].y()-accPt[i].y(), perpPt[i].z()-accPt[i].z() ); //placeholder vector
  } //end i loop

  //TARGET POINTS (red circles)
  tarTxt = loadStrings("RAK_cercle_center_20110215.txt");
  tarPtCt = tarTxt.length; //should be used for all 'j' (target point) loop lengths
  tarPt = new Pt[tarPtCt]; //initialize target points
  readTxtData_POINTS(tarTxt, tarPt);
  tarCirc = new Circle[tarPtCt]; //initialize target circles with correct length
  for (int j=0; j<tarPtCt; j++) { //loop through all target points
    tarCirc[j] = new Circle(tarPt[j], 24); //create Circle with a set diameter at each target point
    tarCirc[j].fill(255, 0, 0, 75).stroke(255, 0, 0,50); //color target points red
    ptDraw.add(tarCirc[j]); //add circle to context Obj, see draw()
  } //end j loop

  //BOUNDARY POLYLINES (light grey)
  boundTxt = loadStrings("site_Vertex.txt"); //boundary line vertices in as text
  boundPts = new Pts[(boundTxt.length/3)]; //set array length based on text input
  readTxtData_VERTEX(boundTxt, boundPts); //translate text input to Pts, see tab readTxtData_VERTEX
  for (int i=0; i<boundPts.length; i++) { //loop for each Pts
    boundPts[i].stroke(180); //color boundary polylines light grey
    context.add(boundPts[i]); //add each Pts to context Obj, see draw()
  } //end loop for each Pts (i)
  //MESH TOPOGRAPHY (medium grey)
  txtVtx = loadStrings("MeshVertexTSS.txt"); //vertices in as text
  txtNdx = loadStrings("MeshIndexTSS.txt"); //indices in as text
  vCoords= new float[txtVtx.length][3]; //vertex coordinates out as array of x, y, z floats
  ndxList= new ArrayList[txtNdx.length]; //face-vertex indices out
  readTxtData_ARRAYONLY(txtVtx, txtNdx, vCoords, ndxList); //translate text inputs to output array(list)s
  meshInit = new HEM(vCoords, ndxList); //create half-edge mesh

  //SEEKING AGENTS
  hierarchy = new int[stPtCt][tarPtCt]; //initialize priority index with correct length
  blacklines = new MomentumPt[stPtCt][tarPtCt]; //to hold all seeking agents
  ps = new ParticleSystem[stPtCt][tarPtCt]; //to hold all bundled paths
  attrLines = new Obj[stPtCt][tarPtCt];
  for (int i=0; i<stPtCt; i++) { //loop for each start point
    for (int j=0; j<tarPtCt; j++) { //loop for each target point
      if (i != j) { //only needed if start points and target points are same
        hierarchy[i][j] = (int)random(1, 500); //create random priority for each start point, corresponds to frame when agents are launched
        blacklines[i][j] = new MomentumPt(new PVector(accPt[i].x(), accPt[i].y(), accPt[i].z() ), PVector.add(perpVec[i], new PVector(random(-1, 1), random(-1, 1), 0) ), hierarchy[i][j], tarPt[j], random(1, 1.5) ); //new MomentumPt at start points, random direction and mass
        blacklines[i][j].id = i + "_" + j;
        total++; //increment counter
        //BUNDLED PATHS
        ps[i][j] = new ParticleSystem(0, 0.01); //create new ParticleSystem within ps array
        drop(ps[i][j], blacklines[i][j]);
        ps[i][j].getParticle(0).makeFixed();
        //println(blacklines[i][j].id + " " + ps[i][j].getParticle(0).isFixed() );
        //ps[i][j].makeParticle(blacklines[i][j].mass, blacklines[i][j].pos.x, blacklines[i][j].pos.y, blacklines[i][j].pos.z); //create first particle in each bundled path
        //stepMark.add(new Square(Anar.Pt(blacklines[i][j].pos.x, blacklines[i][j].pos.y, blacklines[i][j].pos.z), blacklines[i][j].mass*15));
      } //end i!=j comparison, comment if point sets are distinct
    } //end target point loop (j)
  } //end start point loop (i)
  println(total + " seeking agents initilized"); //print total # of MomentmPts
  //track = new String[trackCt]; //initialize tracking array
  //track[0] = "frame id mass mSpd mFrc posX posY posZ velX velY velZ targetX targetY targetZ sepW sepX sepY sepZ aliW aliX aliY aliZ cohW cohX cohY cohZ tarW tarX tarY tarZ"; //create headings

  //SLIDERS
  sepWt.tag("SEPARATION"); //add tags
  aliWt.tag("ALIGNMENT");
  cohWt.tag("COHESION");
  tarWt.tag("SEEKING");
  topWt.tag("TOPOGRAPHY");
  avdWt.tag("AVOIDANCE");
  s.fontSize = 12; //make more legible
  s.leftMargin = 200; //ensure tag is visible
  s.add(sepWt); //add parameters to slider object
  s.add(aliWt);
  s.add(cohWt);
  s.add(tarWt);
  s.add(topWt);
  s.add(avdWt);
  //s.add(tVal); //camera path slider
} //end setup()

void draw() {
  if (record) {
    beginRaw(DXF, "siteCirc-TEST" + recCt + ".dxf");
    recCt++;
  }
  background(255); //white background
  camera(1325,200,2000,1325,200,0,0,1,0); //top view -OR-
  //se3D.feed(); //3D view from southeast -OR-
  //ccc.feed(); //path animation
  //if (frameCount>70 && tval.get()<.81) {
  //  tval.set(tval.get()+.0008);
  //}
  //end path animation
  context.draw(); //draw site boundaries

  if (frameCount>50) {
    step(blacklines, ps); //move, calculate update, and draw seeking agents each frame
    makeAttractions(ps);
    bundlePaths(ps);
      stroke(200);
  meshInit.displayE(); //draw mesh as edges
  stroke(0);


  for (int i=0; i<stPtCt; i++) {
    for (int j=0; j<tarPtCt; j++) {
      if ( frameCount == hierarchy[i][j] ) {
        hierarchyCt++;
        println("frame " + frameCount + ": " + hierarchyCt + " of " + total + " agents launched" );
      }
    }
  }


  if (drawPoints) ptDraw.draw();
  if (drawBundles && drawPaths) pathDraw.draw(); //draw particle markers
  if (drawBundles && drawAttractions) { //draw attractions in sequence
    drawObj.draw();
    int linesPerFrame = 2; //attraction lines per path per frame
    int count = 0;
    for (int i=0; i<stPtCt; i++) {
      for (int j=0; j<tarPtCt; j++) {
        if (i != j) {
          for (int p=0; p<attrLines[i][j].numOfFaces(); p++) {
            drawObj.add( attrLines[i][j].getFace(p) );
          }
          for (int k=0; k<linesPerFrame; k++) {
            if ( ( (framesAddedCount * linesPerFrame) + k ) < attrLines[i][j].numOfLines() ) {
              drawObj.add( attrLines[i][j].getLine( (framesAddedCount * linesPerFrame) + k ) );
              count++;
            }
          }
        }
      }
    }
    if (count != 0) {
      println("frame " + frameCount + ": made " + count + " attractions." );
    }
    framesAddedCount++;
  }

  if (record) {
    endRaw();
    record = false;
  }
  
  /*if (frameCount<938) {
   saveFrame("SiteplanRAKHD"+(frameCount-50)+".jpg"); 
  }*/
 }
  //s.draw(); //draw sliders
  //FRAME CAPTURE
//  if(findAttractions || bundlePaths) {
//  }
//  else if (!stopSwarm) {
//    saveFrame("1_swarm-####.jpg");
//  }  
  if(startAttract && !bundlePaths) {
    saveFrame("2_drawAttractions-####.jpg");
  }
  if(bundlePaths) {
    saveFrame("3_bundle-####.jpg");
  }
  //end frame capture
}

//INTERACTIVE TOGGLES
void keyPressed() {
  // 's' = save current frame to JPG
  if (key == 's') {
    save("siteCirc.jpg");
    println("siteCirc.jpg saved");
  } //end 's'
  // 'f' = find attractions
  if (key == 'f') {
    findAttractions = findAttractions ? false:true;
    println("finding attractions");
  }
  // 'b' = run physics
  if (key == 'b') {
    bundlePaths = bundlePaths ? false:true;
    println("computing phyiscs");
  }
  if (key == 'r') {
    record = true;
    println("recording DXF");
  }
  if (key == 'j') drawPoints = drawPoints ? false:true;
  if (key == 'k') drawAgents = drawAgents ? false:true;
  if (key == 'n') drawPaths = drawPaths ? false:true;
  if (key == 'm') drawAttractions = drawAttractions ? false:true;
} //end keyPressed()

