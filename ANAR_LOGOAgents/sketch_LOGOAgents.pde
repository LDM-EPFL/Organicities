import processing.opengl.*;
import anar.*;
 
Turtle[] turtleArray = new Turtle[5];

Obj     export        = new Obj();

void setup(){
  size(800,400,OPENGL);
  Anar.init(this); 
  Anar.drawAxis();
 
  // here we initialize the array
  for (int i=0; i<turtleArray.length; i=i+1) {
    turtleArray[i] = new Turtle();
  }
 
 
}
 
float measureDist( Turtle t1, Turtle t2) {
  return t1.head.length(t2.head);
}
 
 
 
float measureNearestTurtle(Turtle t) {
 
  float minDist = 10000f;
 
  for (int i=0; i<turtleArray.length; i=i+1) {
 
    if (turtleArray[i] != t) {
      float distance = measureDist(t, turtleArray[i]);    
      if (distance < minDist) minDist = distance;
    }
 
  }
 
  return minDist;
}
 
 
 
void MOVE(Turtle t) {
   t.FD(random(1));
   t.LT(random(-10,10));  
   t.UP(random(-10,10));  
 
}
 
void draw(){
  background(255,155,155);
 
  for (int i=0; i<turtleArray.length; i=i+1) {
    Turtle t = turtleArray[i];
    float minDistance = measureNearestTurtle(turtleArray[i]);
 
    MOVE(t);
    t.draw();
    t.SETPC(minDistance,minDistance,minDistance);
    
       export.add(t.trace);
  }

 
}


 
void keyPressed(){
  
    switch(key){
  case 'r':
    RhinoScript.export(export);
    break;
  //save("screnShot.jpg"); 
}
}
