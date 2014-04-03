import processing.core.*; 
import processing.xml.*; 

import physics.*; 
import processing.opengl.*; 
import anar.*; 
import java.util.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Topo_Tower_11 extends PApplet {





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
Param angle = new Param(0.11f,-5,5);
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

public void setup()
{
  size( 3000, 2000, OPENGL);
  Anar.init(this);
  Anar.drawAxis(true);
  strokeWeight(1);
  system = new System();
  physics = new ParticleSystem( 0, 0, 0, 0, 0.06f);
  physics.collisionMODE(SQUARE);
  parser = new Parser();
  createTower();
  initSliders();
  initBoxesParams();
  makeBoxes();
  makeSpiral2();  
}


public void draw() {
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
public void drawNetwork()
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
public void check()
{
for (int i =0; i<system.numOfNodes(); i++)
{
TraerParticle p = system.node(i).particle();
println(p.position().x()+" "+p.position().y()+" "+p.position().z());
}
}


public void translateToCore()
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

public void initBoxesParams()
{
  origins = new Param[system.numOfNodes()][3];
  for ( int i = 0; i < system.numOfNodes(); i++ )
  {
    origins[i][0] = new Param (system.node(i).particle().position().x()-system.node(i).size()/2);
    origins[i][1] = new Param (system.node(i).particle().position().y()-system.node(i).size()/2);
    origins[i][2] = new Param (system.node(i).particle().position().z()-system.node(i).height()/2);
  }
}

public void makeBoxes()
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

public void updateBoxesParams()
{
  for ( int i = 0; i < system.numOfNodes(); i++ )
  {
    origins[i][0].set(system.node(i).particle().position().x()-system.node(i).size()/2);
    origins[i][1].set(system.node(i).particle().position().y()-system.node(i).size()/2);
    origins[i][2].set(system.node(i).particle().position().z()-system.node(i).height()/2);
  }
}

//////////////////////ATTRACTORS

public void makeSpiral()
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

public void makeSpiral2()
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
    Param angle2 = new Param(4.0f);
    RotateZ rot = new RotateZ(origin, angle2);
    Pt p = Anar.Pt(0,100,s.alt());
    p.apply(rot);
    spiralPoints[i]=p;
  }
  }
}

public void makeSpiral3()
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

public void makeSpiral4()
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


public void attractors()
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

public void camera()
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

public void initSliders()
{
  mySliders.add(angle);
}


public void keyPressed()
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

public class Attractor
{
  Tower tower;
  ArrayList nodes = new ArrayList();
  ArrayList links = new ArrayList();
  ArrayList positions = new ArrayList();
  float strength = 0.05f;
  float damping = 0.1f;
  float[] c = new float[3];
  
  ///// CONSTRUCTOR /////
  
  // Tower, strength, damping, positions
  public Attractor(Tower t, float s, float d, ArrayList p)
  {
    println("Constructing the attractor");
    tower = t;
    strength = s;
    damping = d;
    positions = p;
    String type = "attractor";
    c = parser.setColour(type);
    this.createMe();
  }
  
  public void createMe()
  {
    for (int i=0; i<tower.numOfStoreys(); i++)
    {
      float z = tower.storey(i).alt();
      
      
      for (int j=0; j<tower.storey(i).numOfUnits(); j++)
      {
        Unit u = tower.storey(i).unit(j);
        float[] aPos = (float[]) positions.get(nodes.size());
        
        Node a = new Node(1, aPos[0], aPos[1], aPos[2], 5, 5, "attractor", c, "attractor");
        a.particle().makeFixed();
        nodes.add(a);
        tower.storey(i).addAttractor(a);
        u.setAttractor(a);
        for (int k = 0; k<u.numOfNodes(); k++)
        {
          Node n = u.node(k);
          if (n.connexion.equals("attractor"))
          {
          float restLength = ( (a.size()/2) + (n.size()/2) );
          String t = "attractor";
          Link l = new Link(a, n, strength, damping, restLength, "attractor");
          links.add(l);
          tower.storey(i).addLinkToAttractor(l);
          }
        }
      }
    }
  }
  
  ///// GETTERS /////
  
  public Node node(int i)
  {
    return (Node) nodes.get(i);
  }
  
  public Link link(int i)
  {
    return (Link) links.get(i);
  }
  
  public int numOfNodes()
  {
    return nodes.size();
  }
  
  public int numOfLinks()
  {
    return links.size();
  }
  
  public ArrayList positions()
  {
    return positions;
  }
  
  public void setPositions(ArrayList p)
  {
    for (int i=0; i<nodes.size(); i++)
    {
      Node n = (Node) this.nodes.get(i);
      float[] newPos = (float[]) p.get(i);
      n.particle().position().set(newPos[0], newPos[1], newPos[2]);
    }
  }
}
public class Link
{
  Spring spring;
  String type;
  Node from;
  Node to;
  
  //Types: hardcore, softcore, unit, attractor
  
  public Link (Node a, Node b, float ks, float d, float r, String t)
  {
    spring = physics.makeSpring(a.particle(), b.particle(), ks, d, r);
    type = t;
    from = a;
    to = b;
  }
  
  ///// GETTERS /////
  
  public Spring spring()
  {
    return spring;
  }
  
  public String type()
  {
    return type;
  }
  
  public void setType(String t)
  {
    type = t;
  }
  
  public Node from()
  {
    return from;
  }
  
  public Node to()
  {
    return to;
  }
  
  public float strength()
  {
    return spring.strength();
  }
  
  public void setStrength(float s)
  {
    spring.setStrength(s);
  }
  
  public float damping()
  {
    return spring.damping();
  }
  
  public void setDamping(float s)
  {
    spring.setDamping(s);
  }
  
  public float restLength()
  {
    return spring.restLength();
  }
  
  public void setRestLength(float r)
  {
    spring.setRestLength(r);
  }
}
public class Node
{
  TraerParticle particle;
  String tag;
  float[] colour = new float[3];
  String connexion;
  
  public Node(float m, float x, float y, float z, float s, float h, String t, float[] c, String co)
  {
    particle = physics.makeParticle(m, x, y, z, s, h);
    tag = t;
    colour = c;
    connexion = co;
    system.addNode(this);
  }
  
  
  ///// GETTERS /////
  
  public TraerParticle particle()
  {
    return particle;
  }
  
  public String tag()
  {
    return tag;
  }
  
  public void setTag(String t)
  {
    tag = t;
  }
  
  public float[] colour()
  {
    return colour;
  }
  
  public void setColour(float[] c)
  {
    colour = c;
  }
  
  public float mass()
  {
    return particle.mass();
  }
  
  public void setMass(float m)
  {
    particle.setMass(m);
  }
  
  public float height()
  {
    return particle.height();
  }
  
  public void setHeight(float h)
  {
    particle.setHeight(h);
  }

  public float size()
  {
    return particle.size();
  }
  
  public void setSize(float s)
  {
    particle.setSize(s);
  }
  
  public String connexion()
  {
    return connexion;
  }
  
  public void setConnexion(String c)
  {
    connexion = c;
  }
  
}
public class Parser
{
  float hardCoreStrength = 1.5f;
  float softCoreStrength = 1;
  float defaultDamping = 0.01f;
  float coreDamping = 0.01f;
  float attractorDamping = 0.05f;
  
  public Parser()
  {
    
  }
  
  
  ///// PARSING METHODS /////  
  public ArrayList parseUnit(XMLElement xml, float z, float oRange, Node core) 
  {
    ArrayList elements = new ArrayList();
    ArrayList nodes = new ArrayList();
    ArrayList links = new ArrayList();
    ArrayList linksToCore = new ArrayList();
    
    XMLElement myType = xml.getChild(0);
      
    //Process the nodes
    XMLElement nds = myType.getChild(0);
    int numNodes = nds.getChildCount();
    
    for (int i=0; i<numNodes; i++)
    {
      XMLElement node = nds.getChild(i);
      
      //Getting the attributes
      float nSize = node.getFloatAttribute("size");
      float nHeight = node.getFloatAttribute("height");
      String connexion = node.getStringAttribute("connexion");
      String tag = node.getStringAttribute("tag");
      float[] colour = this.setColour(tag);
      
      //Creating the node
      Node n = new Node(1,random(-oRange,oRange),random(-oRange,oRange), z, nSize, nHeight, tag, colour, connexion);
      nodes.add(n);
      
      //Link to core
      if (connexion.equals("core") && (tag.equals("foyer") || tag.equals("great")))
      {
        String type = "hardcore";
        float restLength = (core.size()/2+n.size()/2);
        Link l = new Link( n, core, hardCoreStrength, coreDamping, restLength, type);
        linksToCore.add(l);
        
      } 
      else if (connexion.equals("core") && tag.equals("water")) 
      {
        String type = "softcore";
        float restLength = (core.size()/2+n.size()/2);
        Link l = new Link( n, core, softCoreStrength, coreDamping, restLength, type);
        linksToCore.add(l);
        
      }
    }
    
    //Process the links
    XMLElement lks = myType.getChild(1);
    int numLinks = lks.getChildCount();
    for (int i=0; i<numLinks; i++)
    {
      XMLElement theLink = lks.getChild(i);
      
      //Getting the attributes
      int from       = theLink.getIntAttribute("from");
      int to         = theLink.getIntAttribute("to");
      float strength = theLink.getFloatAttribute("strength");
      float damping  = theLink.getFloatAttribute("damping");
      
      Node fromNode = (Node) nodes.get(from);
      Node toNode = (Node) nodes.get(to);
      float restLength = ( (fromNode.size()/2) + (toNode.size()/2) );
      String type = "unit";
      
      Link l = new Link( fromNode, toNode, strength, damping, restLength, type);
      links.add(l);
    }
    
    //Filling the elements list
    elements.add(nodes);
    elements.add(links);
    elements.add(linksToCore);
    return elements;
}
  
  public float[] setColour(String tag)
  {
    float col[] = new float[3];
    if (tag.equals("core"))
    {
      float[] c = {0,0,0,255};
      col = c;
    } else if (tag.equals("great")) {
      float[] c = {190,190,190,140};
      col = c;
    }else if (tag.equals("water")) {
      float[] c = {44,44,44,220};
      col = c;
    }else if (tag.equals("attractor")) {
      float[] c = {255,20,147,100};
      col = c;
    } else {
      float[] c = {100,100,100,180};
      col = c;
    }
    return col;
  }
  
}
public class Storey
{
  
  ArrayList units = new ArrayList();
  ArrayList linksToCore = new ArrayList();
  ArrayList attractors = new ArrayList();
  ArrayList linksToAttractors = new ArrayList();
  Node core;
  float myAlt;

  public Unit makeUnit(XMLElement xml)
  {
    ArrayList elements = new ArrayList();
    elements = parser.parseUnit(xml, myAlt, oRange, core);
    ArrayList newLinksToCore = (ArrayList) elements.get(2);
    
    for (int i=0; i<newLinksToCore.size(); i++)
    {
      linksToCore.add(newLinksToCore.get(i));
    }
    
    ArrayList nodes = new ArrayList();
    ArrayList links = new ArrayList();
    nodes = (ArrayList) elements.get(0);
    links = (ArrayList) elements.get(1);
    Unit u = new Unit(nodes, links);
    units.add(u);
    return u;
  }
  
  public Node makeCore()
  {
    float[] colour = parser.setColour("core");
    core = new Node(1, 0, 0, myAlt, coreSize, coreHeight, "core", colour, "");
    core.particle().makeFixed();
    return core;
  }

  public void updateCoreSize()
  {
    float totalSize = 0;
    for (int i=0; i<this.numOfLinksToCore(); i++)
    {
      Node from = this.linkToCore(i).from();
      totalSize = totalSize + from.size();
    }
    float coreSize = ( (2*totalSize*0.8f)/(2*PI) );
    core.setSize(coreSize);
    
    for (int i=0; i<this.numOfLinksToCore(); i++)
    {
      Node from = this.linkToCore(i).from();
      float restLength = (core.size()/2+from.size()/2);
      linkToCore(i).setRestLength(restLength);
    }    
    
  }  
  
  ///// GETTERS /////
  
  public Unit unit(int i) 
  {
    return (Unit) units.get(i);
  }
  
  public int numOfUnits()
  {
    return units.size();
  }
  
  public Node core()
  {
    return core;
  }
  
  public float alt()
  {
    return myAlt;
  }
  
  public void setAlt(float a)
  {
    myAlt = a;
  }
  
  public float numOfNodes()
  {
    ArrayList nodes = new ArrayList();
    for (int i = 0; i<units.size(); i++)
    {
      Unit u = (Unit) units.get(i);
      for (int j=0; j<u.numOfNodes(); j++)
      {
        nodes.add(u.node(j));
      }
    }    
    return nodes.size();
  }
  
  public Node node(int i)
  {
    ArrayList nodes = new ArrayList();
    for (int k = 0; k<units.size(); k++)
    {
      Unit u = (Unit) units.get(k);
      for (int j=0; j<u.numOfNodes(); j++)
      {
        nodes.add(u.node(j));
      }
    }    
    return (Node) nodes.get(i);
  }
  
  public void addAttractor(Node n)
  {
    attractors.add(n);
  }
  
  public float numOfAttractors()
  {
    return attractors.size();
  }
  
  public Node attractor(int i)
  {
    return (Node) attractors.get(i);
  }

  public void addLinkToAttractor(Link l)
  {
    linksToAttractors.add(l);
  }
  
  public float numOfLinksToAttractor()
  {
    return linksToAttractors.size();
  }
  
  public Link linkToAttractor(int i)
  {
    return (Link) linksToAttractors.get(i);
  }

  //
  public void addLinkToCore(Link l)
  {
    linksToCore.add(l);
  }
  
  public float numOfLinksToCore()
  {
    return linksToCore.size();
  }
  
  public Link linkToCore(int i)
  {
    return (Link) linksToCore.get(i);
  }
  
}
public class System
{
  
  ArrayList nodes = new ArrayList();
  ArrayList towers = new ArrayList();
  ArrayList attractors = new ArrayList();
  
  boolean translateToCore = true;
  
  public System() {

  }

  public Tower makeTower(float h) {
    Tower t = new Tower(h);
    towers.add(t);
    return t;
  }
  
  public Attractor makeAttractor(Tower t, float s, float d, ArrayList p) {
    Attractor a = new Attractor(t, s, d, p);
    attractors.add(a);
    return a;
  }
  
  ///// GETTERS /////
  
  public Tower tower(int i) 
  {
    return (Tower) towers.get(i);
  }
  
  public int numOfTowers()
  {
    return towers.size();
  }

  public Attractor attractor(int i)
  {
    return (Attractor) attractors.get(i);
  }
  
  public float numOfAttractors()
  {
    return attractors.size();
  }

  public void addNode(Node n)
  {
    nodes.add(n);
  }
  
  public int numOfNodes()
  {
    return nodes.size();
  }
  
  public Node node(int i)
  {
    return (Node) nodes.get(i);
  }
  
}
public class Tower {

  ArrayList storeys = new ArrayList();
  Attractor attractor;
  
  float storeyHeight;
  
  public Tower()
  {

  }

  public Tower(float sH)
  {
    storeyHeight = sH;
  }
  
  public Storey makeStorey()
  {
    Storey s = new Storey();
    storeys.add(s);
    
    s.setAlt( (storeys.size())*storeyHeight );
    return s;
  }
  
  
  ///// GETTERS /////
  
  
  //Storeys
  public Storey storey(int i)
  {
    return (Storey) storeys.get(i);
  }
  
  public int numOfStoreys()
  {
    return storeys.size();
  }
  
  //floorHeight
  public float storeyHeight()
  {
    return storeyHeight;
  }
  
  public void setStoreyHeight(float sH)
  {
    storeyHeight = sH;
  }
  
}


public class Unit 
{
  ArrayList nodes = new ArrayList();
  ArrayList links = new ArrayList();

  Node attractor;
  float area = 0;

  ///// CONSTRUCTORS /////
  public Unit(ArrayList n, ArrayList l)
  {
    nodes = n;
    links = l;
    area = computeArea();
  }

  ///// METHODS /////
  public float computeArea(){
    float a = 0;
    for (int i=0; i<nodes.size(); i++)
    {
      Node n = (Node) nodes.get(i);
      a = a + (sq(n.size()));
    } 
    
    return a;
  }


  ///// GETTERS /////

  public float area()
  {
    return area;
  }

  public Node node(int i)
  {
    return (Node) nodes.get(i);
  }
  
  public Link link(int i)
  {
    return (Link) links.get(i);
  }
  
  public int numOfNodes()
  {
    return nodes.size();
  }
  
  public int numOfLinks()
  {
    return links.size();
  }

  public Node attractor()
  {
    return attractor;
  }
  
  public void setAttractor(Node n)
  {
    attractor = n;
  }

}
//This should be eventually replaced by a global XML parser


public void createTower() 
{
  
  //Tower
  Tower t = system.makeTower(storeyHeight);
 
  //Storey
  for (int i=0; i<floors; i++)
  {
    t.makeStorey();
  }
  
  //Cores and units
  XMLElement type_SMALL = new XMLElement(this, "type_SMALL.xml");
  XMLElement type_MEDIUM = new XMLElement(this, "type_MEDIUM.xml");
  XMLElement type_KING = new XMLElement(this, "type_KING.xml");
  
  //t.storey(0).makeCore();
  //t.storey(0).makeUnit(type_SMALL);
  //t.storey(0).makeUnit(type_SMALL);
  //t.storey(0).makeUnit(type_MEDIUM);
  //t.storey(0).makeUnit(type_MEDIUM);
  //t.storey(0).makeUnit(type_MEDIUM);
  //t.storey(0).makeUnit(type_KING);
  //t.storey(0).makeUnit(type_KING);
  //t.storey(0).makeUnit(type_KING);*/
  
  towerMIXED(t);
  //towerONETYPE(t);
  //towerTWOTYPES(t);
  //towerPYRAMID(t);
  //towerBIGMAMA(t);
  
  //Attractor
  
  updateCoreSize();
  
  ArrayList p = new ArrayList();
  for (int i = 0; i<t.numOfStoreys();i++)
  {
    float x = 100;
    float y = 100;
    float z= t.storey(i).alt();
    
    for (int j = 0; j<t.storey(i).numOfUnits(); j++)
    {
      float[] thisP = {x, y, z};
      p.add(thisP);
      
    }
  }
  
  Tower to = (Tower) system.tower(0);
  //strong
  system.makeAttractor(to, 0.02f, 0.1f, p);
  //light
  //system.makeAttractor(to, 0.005, 0.1, p);
}

public void updateCoreSize()
{
  for (int i = 0; i<system.tower(0).numOfStoreys(); i++)
  {
    system.tower(0).storey(i).updateCoreSize();
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

public void towerMIXED(Tower t)
{
//Cores and units
  XMLElement type_SMALL = new XMLElement(this, "type_SMALL.xml");
  XMLElement type_MEDIUM = new XMLElement(this, "type_MEDIUM.xml");
  XMLElement type_KING = new XMLElement(this, "type_KING.xml");
  for(int i = 0; i < 10; i++)
  {
    t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_SMALL);
  }

  for(int i = 10; i < 15; i++)
  {
    t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_MEDIUM);
  }
  
  for(int i = 15; i < 20; i++)
  {
    t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
  }
  
  for(int i = 20; i < 25; i++)
  {
    if(i % 2 == 0)
    {
      t.storey(i).makeCore();
      t.storey(i).makeUnit(type_SMALL);
      t.storey(i).makeUnit(type_SMALL);
      t.storey(i).makeUnit(type_KING);
    } else {
      t.storey(i).makeCore();
      t.storey(i).makeUnit(type_MEDIUM);
      t.storey(i).makeUnit(type_KING);
    }
  }

  for(int i = 25; i < 35; i++)
  {
    t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
  }

  for(int i = 35; i < 40; i++)
  {
    t.storey(i).makeCore();
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_SMALL);
  }

  for(int i = 40; i < 45; i++)
  {
    t.storey(i).makeCore();
    t.storey(i).makeUnit(type_KING);
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

public void towerONETYPE(Tower t)
{
//Cores and units
  XMLElement type_SMALL = new XMLElement(this, "type_SMALL.xml");
  XMLElement type_MEDIUM = new XMLElement(this, "type_MEDIUM.xml");
  XMLElement type_KING = new XMLElement(this, "type_KING.xml");
  for(int i = 0; i < 45; i++)
  {
    t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_SMALL);
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

public void towerTWOTYPES(Tower t)
{
//Cores and units
  XMLElement type_SMALL = new XMLElement(this, "type_SMALL.xml");
  XMLElement type_MEDIUM = new XMLElement(this, "type_MEDIUM.xml");
  XMLElement type_KING = new XMLElement(this, "type_KING.xml");
  for(int i = 0; i < 20; i++)
  {
    t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_SMALL);
  }
  for(int i = 20; i < 45; i++)
  {
    t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

public void towerPYRAMID(Tower t)
{
//Cores and units
  XMLElement type_SMALL = new XMLElement(this, "type_SMALL.xml");
  XMLElement type_MEDIUM = new XMLElement(this, "type_MEDIUM.xml");
  XMLElement type_KING = new XMLElement(this, "type_KING.xml");
  //0
    int i=0;
    t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
   
   //1
   i=1;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //2
   i=2;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
     //3
   i=3;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //4
   i=4;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //5
   i=5;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //6
   i=6;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //7
   i=7;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //8
   i=8;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //9
    i=9;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //10
    i=10;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //11
    i=11;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //12
    i=12;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //13
    i=13;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //14
    i=14;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //15
    i=15;
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
  
  for(i = 16; i < 45; i++)
  {
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////

public void towerBIGMAMA(Tower t)
{
//Cores and units
  XMLElement type_SMALL = new XMLElement(this, "type_SMALL.xml");
  XMLElement type_MEDIUM = new XMLElement(this, "type_MEDIUM.xml");
  XMLElement type_KING = new XMLElement(this, "type_KING.xml");
  
  int i=0;
  for(i = 0; i < 25; i++)
  {
   t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_SMALL);
  }
  
  //25
  i=25;
  t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    
    
    //26
  i=26;
  t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //27
  i=27;
  t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //28
  i=28;
  t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //29
  i=29;
  t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
      //30
  i=30;
  t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //31
  i=31;
  t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_KING);
    t.storey(i).makeUnit(type_KING);
    
    //32
  i=32;
  t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    t.storey(i).makeUnit(type_MEDIUM);
    
    
  
  for(i = 33; i < 45; i++)
  {
  t.storey(i).makeCore();
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_SMALL);
    t.storey(i).makeUnit(type_SMALL);
  }
}

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#F0F0F0", "Topo_Tower_11" });
  }
}
