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
