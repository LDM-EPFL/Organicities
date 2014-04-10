import anar.*;
import processing.opengl.*;
import traer.physics.*;
import traer.anar.*;
import processing.dxf.*;

Sim sim;
Obj minimalSurface;
boolean record;

void setup() {
  size(1000,500,OPENGL);
  Anar.init(this);
  Anar.drawAxis(true);
  Pts.globalRender = new RenderPtsAll();  //Initialize a render for all lines
  createSimulation();
}

void createSimulation() {
  minimalSurface = new Obj();
  sim = new Sim(0,0.1f);
  Face f = new Rect(100,66);
  f.pt(0).translateZ(33).translateX(33);

  //Divide the distance on two sides of the rectangle
  Pts segment1 = new PtsMid(f.pt(0),f.pt(1),10);
  Pts segment2 = new PtsMid(f.pt(3),f.pt(2),10);
  //We then have two sets with the same number of points

  //We create an array of PowerPt
  PowerPt[][] nodes = new PowerPt[segment1.numOfPts()][10];

  // Init the points somewhere in space
  for (int i = 0; i<nodes.length; i++)
    for (int j = 0; j<nodes[i].length; j++)
      if(j==0)
        nodes[i][j] = new PowerPt(segment1.pt(i)).fixed();
      else
        if(j==nodes[i].length-1)
          nodes[i][j] = new PowerPt(segment2.pt(i)).fixed();
        else
          nodes[i][j] = new PowerPt(Anar.PtRnd(100));

  //Create Springs between lines in one direction
  for (int i = 1; i<nodes.length; i++)
    for (int j = 0; j<nodes[i].length; j++)
      minimalSurface.add(new PowerSpring(nodes[i-1][j],nodes[i][j],0));

  //Create Springs between lines in the other direction
  for (int i = 0; i<nodes.length; i++)
    for (int j = 1; j<nodes[i].length; j++)
      minimalSurface.add(new PowerSpring(nodes[i][j-1],nodes[i][j],0));
}

void draw() {
  if(record) {
    beginRaw(DXF,"output.dxf");
  }
  background(155);
  sim.updateSim(); // Update the simulation
  //sim.param.draw(); // Draw the sliders
  minimalSurface.draw(); // Draw our objects
  Anar.camTarget(minimalSurface); // Center the object to the scene
  if(record) {
    endRaw();
    record = false;
  }
}

void keyPressed() {
  if(key=='s')
    sim.simulate = sim.simulate ? false:true;
  if(key=='r')
    record = true;
  if(key==' ')
    createSimulation();
}

