public class Parser
{
  float hardCoreStrength = 1.5;
  float softCoreStrength = 1;
  float defaultDamping = 0.01;
  float coreDamping = 0.01;
  float attractorDamping = 0.05;
  
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
