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
  system.makeAttractor(to, 0.02, 0.1, p);
  //light
  //system.makeAttractor(to, 0.005, 0.1, p);
}

void updateCoreSize()
{
  for (int i = 0; i<system.tower(0).numOfStoreys(); i++)
  {
    system.tower(0).storey(i).updateCoreSize();
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

void towerMIXED(Tower t)
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

void towerONETYPE(Tower t)
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

void towerTWOTYPES(Tower t)
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

void towerPYRAMID(Tower t)
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

void towerBIGMAMA(Tower t)
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

