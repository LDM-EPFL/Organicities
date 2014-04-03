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
