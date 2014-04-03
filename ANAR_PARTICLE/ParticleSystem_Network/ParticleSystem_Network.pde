import anar.*;
import processing.opengl.*;
import traer.physics.*;
import traer.anar.*;

Sim sim;
Obj architectureDuFutur;

void setup(){
  size(1000,500,OPENGL);
  Anar.init(this);
  Anar.drawAxis(true);
  Pts.globalRender = new RenderPtsAll();  //Initialize a render for all lines
  Pt.globalRender = new RenderPtShapeConstant(new FatCross(15),new AColor(100),new AColor(255,155),Anar.scene);
  createSimulation();
}

void createSimulation(){
  //Initialization
  sim = new Sim(0,0.1f);
  architectureDuFutur = new Obj();
  Pts pts = new Pts();

  //Create Random Points
  int r = 10;
  for(int i=0; i<100; i++)
    pts.add(new PowerPt(random(-r,r),random(-r,r),random(-r,r)));

  //Create Random Connections
  for(int i=0; i<150; i++)
  {
    PowerPt a = (PowerPt)pts.pt(Anar.rndi(pts.numOfPts()));
    PowerPt b = (PowerPt)pts.pt(Anar.rndi(pts.numOfPts()));
    if(a!=b)
      architectureDuFutur.add(new PowerSpring(a,b));
  }

  //Apply a Repulsor force on each pair of nodes
  for(int i=0; i<pts.size(); i++)
    for(int j=0; j<pts.size(); j++)
    {
      Pt a = pts.get(i);
      Pt b = pts.get(j);
      if(a!=b)
          new PowerAttractor(((PowerPt)a),((PowerPt)b),-100,0.1);
    }
}


void draw(){
  background(150);
  sim.updateSim(); // Update the simulation
  sim.param.draw(); // Draw the sliders
  architectureDuFutur.draw(); // Draw our objects
  Anar.camTarget(architectureDuFutur); // Center the object to the scene
}

void keyPressed(){
  if(key=='s')
    sim.simulate = sim.simulate ? false:true;
  if(key=='p')
    save("screenshot01.jpg");
  if(key==' ')
    createSimulation();    
}


