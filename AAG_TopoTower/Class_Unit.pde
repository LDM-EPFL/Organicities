import java.util.*;

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
