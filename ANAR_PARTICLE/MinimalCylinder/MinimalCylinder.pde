import anar.*;
import processing.opengl.*;
import traer.physics.*;
import traer.anar.*;

Sim sim;
Obj minimalSurface;

void setup(){
  size(1000,500,OPENGL);
  Anar.init(this);
  Anar.drawAxis(true);
  Pts.globalRender = new RenderPtsAll();  //Initialize a render for all lines
  createSimulation();
}

void createSimulation(){
  minimalSurface = new Obj();
  sim = new Sim(0,0.1f);

  Face f = new Rect(100,66);
  Face ff = f.copy().rotateZ(1).translateZ(100);

  Pts borderF = new Pts();
  Pts borderFF = new Pts();
  //Divide the distance on all sides of both rectangles
  for (int i=0; i<4; i++) {
    borderF.add(new PtsMid(f.ptMod(i),f.ptMod(i+1),10));
    borderFF.add(new PtsMid(ff.ptMod(i),ff.ptMod(i+1),10));
  }
  //close the loop
  borderF.remove(borderF.ptEnd());
  borderFF.remove(borderFF.ptEnd());
  borderF.add(borderF.pt(0));
  borderFF.add(borderFF.pt(0));

  //We then have two sets with the same number of points

  //We create an array of PowerPt
  PowerPt[][] nodes = new PowerPt[borderF.numOfPts()][10];

  // Init the points somewhere in space
  for (int i = 0; i<nodes.length; i++)
    for (int j = 0; j<nodes[i].length; j++)
      if (i==nodes.length-1)
        nodes[i][j] = nodes[0][j];
      else 
        if(j==0)
        nodes[i][j] = new PowerPt(borderF.pt(i)).fixed();
      else
        if(j==nodes[i].length-1)
          nodes[i][j] = new PowerPt(borderFF.pt(i)).fixed();
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

void draw(){
  background(155);
  sim.updateSim(); // Update the simulation
  sim.param.draw(); // Draw the sliders
  minimalSurface.draw(); // Draw our objects
  Anar.camTarget(minimalSurface); // Center the object to the scene
}

public void keyPressed(){
  if(key=='s')
    sim.simulate = sim.simulate ? false:true;
  if(key=='p')
    save("screenshot30.jpg");
  if(key==' ')
    createSimulation();   
}


