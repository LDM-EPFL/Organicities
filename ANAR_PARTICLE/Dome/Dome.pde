import anar.*;
import processing.opengl.*;
import traer.physics.*;
import traer.anar.*;

Sim sim;
Obj constrainedDome;

void setup(){
  size(1000,500,OPENGL);
  Anar.init(this);
  Anar.drawAxis(true);
  Pts.globalRender = new RenderPtsAll();  //Initialize a render for all lines
  createSimulation();
}

public void createSimulation(){
  constrainedDome = new Obj();
  sim = new Sim(1,0.1f);

  sim.traer.setIntegrator(ParticleSystem.VERLET);
  Face f = new Rect(100,66);
  f.translateZ(1);

  int nDiv = 11;

  //Divide the distance on two sides of the rectangle
  Pts segment1 = new PtsMid(f.pt(0),f.pt(1),nDiv);
  Pts segment2 = new PtsMid(f.pt(3),f.pt(2),nDiv);
  //We then have two sets with the same number of points

  // we draw lines of points between the two sets
  for (int i=0; i<segment1.numOfPts(); i++) {
    constrainedDome.add(PowerSpring.makeFrom(new PtsMid(segment1.pt(i),segment2.pt(i),10)));
    ((PowerPt) constrainedDome.line(i).pt(0)).fixed();
    ((PowerPt) constrainedDome.line(i).ptEnd()).fixed();
  }

  Obj constrains = new Obj();
  // we draw constrains between even lines
  for (int i=0; i<constrainedDome.numOfLines()-1; i++) {
    for (int j=1; j<constrainedDome.line(0).numOfPts()-1; j++) { 
      PowerPt a = (PowerPt) constrainedDome.line(i).pt(j); 
      PowerPt b = (PowerPt) constrainedDome.line(i+1).pt(j);
      if (i==0) a.fixed();
      if (i+1==constrainedDome.numOfLines()-1) b.fixed();
      if (i%2==1) constrains.add(new PowerSpring( a, b, 0f, 0f, 2f*a.length(b)).stroke(255,0,0));
      else constrains.add(new PowerSpring( a, b, PowerSpring.defaultStrength, 20*PowerSpring.defaultDamping, 0f).stroke(255,255,0));
    }
  }    
  constrainedDome.add(constrains);

}

void draw(){
  background(155);
  sim.updateSim(); // Update the simulation
  sim.param.draw(); // Draw the sliders
  constrainedDome.draw(); // Draw our objects
  Anar.camTarget(constrainedDome); // Center the object to the scene
}

void keyPressed(){
  if(key=='s')
    sim.simulate = sim.simulate ? false:true;
  if(key=='p')
    save("screenshot40.jpg");
  if(key==' ')
    createSimulation();     
}

