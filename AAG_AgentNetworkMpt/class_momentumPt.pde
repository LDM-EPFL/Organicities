class momentumPt extends PtABS{
    //      VARIABLES USED IN THIS CLASS DEFINITION
    float vX,  vY, vZ;
    float mass;
   int dir;
    Pts trail=new Pts();
    Circle circ;
    Pt pos;
    
    //      CONSTRUCTOR_1
     momentumPt(float x, float y, float z){
       //super(x,y,z);
       vX=0; vY=0; vZ=0;
       mass= 1;
       //pos=Anar.Pt(x,y,z);
       circ=new Circle(Anar.Pt(x,y,z),10f);
     }
   
    //      CONSTRUCTOR_2
     momentumPt(float x, float y, float z, float vecX, float vecY, float vecZ){
       //super(x,y,z);
       vX=vecX; vY=vecY; vZ=vecZ;
       mass=1;
       //pos=Anar.Pt(x,y,z);
       circ=new Circle(Anar.Pt(x,y,z),.5f);
     }
     
     //      CONSTRUCTOR_3
     momentumPt(float x, float y, float z, float vecX, float vecY, float vecZ, float m, int d){
       super(x,y,0f);
       vX=vecX; 
       vY=vecY; 
       vZ=vecZ;
       mass=m;
       dir=d;
       pos=Anar.Pt(x,y,0f);
       circ=new Circle(Anar.Pt(x,y,z),10f);
     }

void setInMotion(float Ff, float maxSpd) {
  x+=Ff * maxSpd*vX;
  y+=Ff * maxSpd*vY;
  //z+=Ff * maxSpd*vZ;
  //trail.add(Anar.Pt(x,y,z));
  circ.translate(Anar.Pt(Ff * maxSpd*vX, Ff * maxSpd*vY,Ff * maxSpd*vZ));
  pos=Anar.Pt(x,y,0);
}

void ping(int ct){
  circ.radius.set( circ.radius.get()+(ct*10));//prtcl[i].circ.radius.get() + 1;
        circ.fill(255,0,0,150);
        circ.draw();
}

void setZ(float newZ){
 circ.translate(Anar.Pt(0,0, newZ-z));
  trail.add(Anar.Pt(x,y,newZ+z));
  //super.translateZ(-super.z());
  z +=newZ ;
 
}


}



  

