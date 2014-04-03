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
    float coreSize = ( (2*totalSize*0.8)/(2*PI) );
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
