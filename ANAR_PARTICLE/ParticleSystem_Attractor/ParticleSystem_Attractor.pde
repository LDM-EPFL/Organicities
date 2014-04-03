import anar.*;
import processing.opengl.*;
import traer.physics.*;
import traer.anar.*;

Sim sim = new Sim(0,0.1f);
Obj world = new Obj();

public void setup(){
  size(1000,500,OPENGL);
  Anar.init(this);
  createSimulation();
  Pt.globalRender = new RenderPtShapeOriented(new FatCross(15),new AColor(100),new AColor(255,155),Anar.scene);
}

void createSimulation(){
  world.add(new PowerPt(Anar.PtRnd(100)).fixed());
  PowerAttractor.globalForce(world,2,0.1f);
}

int nParticle = 30;

public void draw(){
  background(155);
  sim.updateSim();
  sim.param.draw();
  if ((frameCount%10==0)&&(frameCount<nParticle*10)) {
    PowerPt p = new PowerPt(Anar.PtRnd(100));
    world.add(p);
    PowerAttractor.globalForce(world,10,0.1f);
  }
  world.draw();
}

public void keyPressed(){
  if(key=='s')
    sim.simulate = sim.simulate ? false:true;
  if(key=='p')
    save("screenshot50.jpg");
  if(key==' ')
    createSimulation();   
}
