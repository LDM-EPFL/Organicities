class MomentumPt {
  //CLASS FIELDS
  String id; //to identify each agent uniquely
  PVector pos; //position
  PVector vel; //velocity
  PVector acc; //acceleration
  int priority;
  Pt target; //agent's target destination
  float mass; //mass, a value between 1.0-2.0 seems to work well
  float maxSpeed; //to limit the maximum displacement per step
  float maxForce; //to limit the maximum acceleration per step
  boolean stopMoving; //false when moving, true when reaches target
  Pts trail = new Pts(); //to hold trace of positions
  Square head; //to mark current position
  //TRACKING FIELDS
  PVector trSep; //makes separation behavior visible to track()
  PVector trAli; //makes alignment behavior visible to track()
  PVector trCoh; //makes cohesion behvaior visible to track()
  PVector trTar; //makes target-seeking behavior visible to track()
  PVector trAcc; //makes accumulated acceleration visible to track()

  //CONSTRUCTOR
  MomentumPt(PVector now, PVector dir, int p, Pt t, float m) {
    pos = now;
    vel = dir; 
    acc = new PVector(0, 0, 0);
    priority = p;
    target = t;
    mass = m;
    maxSpeed = 8.0 + mass; //massive objects can travel faster
    maxForce = 0.1 / mass; //massive objects accelerate less
    boolean stopMoving = false;
    head=new Square(Anar.Pt(pos.x, pos.y, pos.z), mass*0);
    head.fill(0);
  }
}

