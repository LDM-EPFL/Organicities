import physics.*;
import processing.opengl.*;
import anar.*;

System system;
float oRange = 500;

ParticleSystem physics;
Parser parser;

int floors = 45;
float storeyHeight = 5;
float coreSize = 12;
float coreHeight = 5;

Obj boxes = new Obj();
Pt[] spiralPoints;

Param origins[][];
Param angle = new Param(0.11,-5,5);
Sliders mySliders = new Sliders();

boolean updateCoreSize = true;

//boxMode
//0 => circle in square; 1 => square in circle;
int boxMode = 0;

boolean stop = false;

boolean cam1 = false;
boolean cam2 = false;
boolean cam3 = false;
boolean cam4 = false;

void setup()
{
  size( 3000, 2000, OPENGL);
  Anar.init(this);
  Anar.drawAxis(true);
  strokeWeight(1);
  system = new System();
  physics = new ParticleSystem( 0, 0, 0, 0, 0.06);
  physics.collisionMODE(SQUARE);
  parser = new Parser();
  createTower();
  initSliders();
  initBoxesParams();
  makeBoxes();
  makeSpiral2();  
}


void draw() {
  background( 255,255,255,0 ); 
  camera();
  if (stop == false)
  {
  physics.tick();
  //translateToCore();
  updateBoxesParams();
  attractors();
  }
  noStroke();
  //stroke(200);
  boxes.draw();
  drawNetwork();
  mySliders.draw();
}

//////////////////////DISPLAY
void drawNetwork()
{      
  // draw edges 
   stroke(200,200,200);
   beginShape( LINES );
   for ( int i = 0; i < physics.numberOfSprings(); i++ )
   {
   Spring e = physics.getSpring( i );
   TraerParticle a = e.getOneEnd();
   TraerParticle b = e.getTheOtherEnd();
   vertex( a.position().x(), a.position().y(),a.position().z() );
   vertex( b.position().x(), b.position().y(),b.position().z() );
   }
   endShape();
}


//////////////////////SYSTEM STABILITY
void check()
{
for (int i =0; i<system.numOfNodes(); i++)
{
TraerParticle p = system.node(i).particle();
println(p.position().x()+" "+p.position().y()+" "+p.position().z());
}
}


void translateToCore()
{
Tower t = system.tower(0);

for (int i = 0; i < t.numOfStoreys(); i++)
{ 
  float ox = 0;
  float oy = 0;
  float oz = i*storeyHeight;
  
  Node c = t.storey(i).core();
  float x = c.particle().position().x();
  float y = c.particle().position().y();
  float z = c.particle().position().z();
  
  float dx = ox-x;
  float dy = oy-y;
  float dz = oz-z;
  
  c.particle().position().set(ox,oy,oz);
  
  for (int j = 0; j < t.storey(i).numOfNodes(); j++)
  {
    Node p = t.storey(i).node(j);
    float px = p.particle().position().x();
    float py = p.particle().position().y();
    float pz = p.particle().position().z();
  
    p.particle().position().set(px+dx,py+dy,pz+dz);
  }
  } 
}

//////////////////////BOXES

void initBoxesParams()
{
  origins = new Param[system.numOfNodes()][3];
  for ( int i = 0; i < system.numOfNodes(); i++ )
  {
    origins[i][0] = new Param (system.node(i).particle().position().x()-system.node(i).size()/2);
    origins[i][1] = new Param (system.node(i).particle().position().y()-system.node(i).size()/2);
    origins[i][2] = new Param (system.node(i).particle().position().z()-system.node(i).height()/2);
  }
}

void makeBoxes()
{
  for ( int i = 0; i < system.numOfNodes(); i++ )
  {
    Pt origin = Anar.Pt (origins[i][0],origins[i][1],origins[i][2]);
    float size = system.node(i).size();
    float height = system.node(i).height();
    if (boxMode == 0)
    {
    Box bbox = new Box(origin,size,size,height);
    bbox.fill(system.node(i).colour()[0],system.node(i).colour()[1],system.node(i).colour()[2],system.node(i).colour()[3]);
    boxes.add(bbox);
    }else if (boxMode == 1)
    {
    Box bbox = new Box(origin,size/sqrt(2),size/sqrt(2),height);
    bbox.fill(system.node(i).colour()[0],system.node(i).colour()[1],system.node(i).colour()[2],system.node(i).colour()[3]);
    boxes.add(bbox);
    }
  }
}

void updateBoxesParams()
{
  for ( int i = 0; i < system.numOfNodes(); i++ )
  {
    origins[i][0].set(system.node(i).particle().position().x()-system.node(i).size()/2);
    origins[i][1].set(system.node(i).particle().position().y()-system.node(i).size()/2);
    origins[i][2].set(system.node(i).particle().position().z()-system.node(i).height()/2);
  }
}

//////////////////////ATTRACTORS

void makeSpiral()
{
  Tower t = system.tower(0);
  spiralPoints = new Pt[system.attractor(0).numOfNodes()];
  Pt origin = Anar.Pt(0,0,0);
  for (int i = 0; i<t.numOfStoreys() ;i++)
  {
  Storey s = t.storey(i);
  for (int j = 0; j<s.numOfAttractors() ;j++)
  {
    RotateZ rot = new RotateZ(origin, angle.multiply(s.alt()/storeyHeight));
    Pt p = Anar.Pt(0,100,s.alt());
    p.apply(rot);
    spiralPoints[i]=p;
  }
  }
}

void makeSpiral2()
{
  Tower t = system.tower(0);
  spiralPoints = new Pt[system.attractor(0).numOfNodes()];
  Pt origin = Anar.Pt(0,0,0);
  for (int i = 0; i<10 ;i++)
  {
  Storey s = t.storey(i);
  for (int j = 0; j<s.numOfAttractors() ;j++)
  {
    //RotateZ rot = new RotateZ(origin, angle.multiply(s.alt()/storeyHeight));
    Pt p = Anar.Pt(0,100,s.alt());
    //p.apply(rot);
    spiralPoints[i]=p;
  }
  }
  for (int i = 10; i<40 ;i++)
  {
  Storey s = t.storey(i);
  for (int j = 0; j<s.numOfAttractors() ;j++)
  {
    RotateZ rot = new RotateZ(origin, angle.multiply((s.alt() - 10*storeyHeight)/storeyHeight));
    Pt p = Anar.Pt(0,100,s.alt());
    p.apply(rot);
    spiralPoints[i]=p;
  }
  }
  for (int i = 40; i<45 ;i++)
  {
  Storey s = t.storey(i);
  for (int j = 0; j<s.numOfAttractors() ;j++)
  {
    Param angle2 = new Param(4.0);
    RotateZ rot = new RotateZ(origin, angle2);
    Pt p = Anar.Pt(0,100,s.alt());
    p.apply(rot);
    spiralPoints[i]=p;
  }
  }
}

void makeSpiral3()
{
  Tower t = system.tower(0);
  spiralPoints = new Pt[system.attractor(0).numOfNodes()];
  Pt origin = Anar.Pt(0,0,0);
  for (int i = 0; i<10 ;i++)
  {
  Storey s = t.storey(i);
  for (int j = 0; j<s.numOfAttractors() ;j++)
  {
    //RotateZ rot = new RotateZ(origin, angle.multiply(s.alt()/storeyHeight));
    Pt p = Anar.Pt(0,100,s.alt());
    //p.apply(rot);
    spiralPoints[i]=p;
  }
  }
  for (int i = 10; i<45 ;i++)
  {
  Storey s = t.storey(i);
  for (int j = 0; j<s.numOfAttractors() ;j++)
  {
    RotateZ rot = new RotateZ(origin, angle);
    Pt p = Anar.Pt(0,100,s.alt());
    p.apply(rot);
    spiralPoints[i]=p;
  }
  }
}

void makeSpiral4()
{
  Tower t = system.tower(0);
  spiralPoints = new Pt[system.attractor(0).numOfNodes()];
  Pt origin = Anar.Pt(0,0,0);
  for (int i = 0; i<45 ; i=i+2)
  {
  Storey s = t.storey(i);
  for (int j = 0; j<s.numOfAttractors() ;j++)
  {
    //RotateZ rot = new RotateZ(origin, angle.multiply(s.alt()/storeyHeight));
    Pt p = Anar.Pt(0,100,s.alt());
    //p.apply(rot);
    spiralPoints[i]=p;
  }
  }
  for (int i = 1; i<45 ; i=i+2)
  {
  Storey s = t.storey(i);
  for (int j = 0; j<s.numOfAttractors() ;j++)
  {
    RotateZ rot = new RotateZ(origin, angle);
    Pt p = Anar.Pt(0,100,s.alt());
    p.apply(rot);
    spiralPoints[i]=p;
  }
  }
}


void attractors()
{
Tower t = system.tower(0);
for (int i = 0; i<t.numOfStoreys() ;i++)
{
  float x = spiralPoints[i].x();
  float y = spiralPoints[i].y();
  float z = spiralPoints[i].z();
  
  Storey s = t.storey(i);
  
  for (int j = 0; j<s.numOfAttractors() ;j++)
  {
  s.attractor(j).particle().position().set(x,y,z);
  }
} 
}


//////////////////////INTERACTIVITY

void camera()
{
if (cam1 == true)
{
camera(25,25,25,0,0,0,0,0,-1);
}else if(cam2 == true)
{
camera(50,50,50,0,0,0,0,0,-1);
}else if(cam3 == true)
{
camera(200,200,200,0,0,125,0,0,-1);
}else if(cam4 == true)
{
camera(-20,400,0,0,0,25,0,0,-1);
}
}

void initSliders()
{
  mySliders.add(angle);
}


void keyPressed()
{
  if (keyCode == UP)
  {
  save("screenshot.jpeg");
  }else if (keyCode == DOWN)
  {
  stop = stop ? false:true;
  }else if (keyCode == RIGHT)
  {
  RhinoScript.export(boxes, "topological_tower");
  }else if (key == '1')
  {
  cam1 = cam1 ? false:true;
  cam2 = false;
  cam3 = false;
  cam4 = false;
  }else if (key == '2')
  {
  cam2 = cam2 ? false:true;
  cam1 = false;
  cam3 = false;
  cam4 = false;
  }else if (key == '3')
  {
  cam3 = cam3 ? false:true;
  cam1 = false;
  cam2 = false;
  cam4 = false;
  }else if (key == '4')
  {
  cam4 = cam4 ? false:true;
  cam1 = false;
  cam2 = false;
  cam3 = false;
  }
}

