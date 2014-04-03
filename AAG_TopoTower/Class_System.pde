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
