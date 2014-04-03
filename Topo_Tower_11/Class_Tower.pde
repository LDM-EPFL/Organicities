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
