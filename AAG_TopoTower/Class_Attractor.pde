public class Attractor
{
  Tower tower;
  ArrayList nodes = new ArrayList();
  ArrayList links = new ArrayList();
  ArrayList positions = new ArrayList();
  float strength = 0.05;
  float damping = 0.1;
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
