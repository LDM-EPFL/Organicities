//STEP THROUGH ALL AGENTS
void step(MomentumPt[][] agents, ParticleSystem[][] bundles) {
  int count = 0;
  for(int i=0; i<stPtCt; i++) { //loop for each start point
    for(int j=0; j<tarPtCt; j++) { //loop for each target point
      if (i != j) { //only needed if start points and target points are same
        if(frameCount >= agents[i][j].priority) { //compare priority to frameCount for delayed start
          if (agents[i][j].stopMoving == false) { //for all agents that have not reached their targets
            swarm(agents[i][j], agents, bundles[i][j]); //weighted calculation of all movement behavior, see swarm() below
            setInMotion(agents[i][j]); //updates position and visualizations according to speed limit, see setInMotion() below
            render(agents[i][j]); //draws representation, see render() below
            //track(agents[i][j]); //writes pertinent data to a TXT file, see track()
            if((frameCount-1)%dropRate == 0) {
              drop(bundles[i][j], agents[i][j]);
            }
          } //end stopMoving if
          else { //for agents already at target
            agents[i][j].trail.stroke(0,220,250,150); //make lighter trace
            if(drawAgents) agents[i][j].trail.draw(); //draw trace
            count++;
          } //end else
        } //end priority if
      } //end i!=j comparison, comment if point sets are distinct
    } //end j loop
  } //end i loop
  if (count > stopped) {
    stopped = count;
    if (stopped < total) {
      println("frame " + frameCount + ": " + count + " stopped agents.");
    }
    if (stopped == total) {
      println("frame " + frameCount + ": all " + total + " agents stopped.");
    }
  }
} //end step()

//WEIGHTED CALCULATION OF MOVEMENT BEHAVIOR
void swarm(MomentumPt agent, MomentumPt[][] agents, ParticleSystem bundle) {
  PVector sep = separate(agent, agents); //get separation vector, see separate() below
  PVector ali = align(agent, agents); //get alignment vector, see align() below
  PVector coh = cohesion(agent, agents); //get cohesion vector, see cohesion() below
  PVector tar = seek(agent, agent.target, bundle); //get target-seeking vector, see seek() below
  PVector top = topoSteer(agent);
  PVector avd = avoid(agent, tarPt);
  sep.mult(sepWt.get()); //multiple by parametric weight factor
  ali.mult(aliWt.get());
  coh.mult(cohWt.get());
  tar.mult(tarWt.get());
  top.mult(topWt.get());
  avd.mult(avdWt.get());
  agent.trSep = sep; //set field value for track()
  agent.trAli = ali;
  agent.trCoh = coh;
  agent.trTar = tar;
  agent.acc.add(sep); //add separation to (empty) acceleration
  agent.acc.add(ali); //add alignment
  agent.acc.add(coh); //add cohesion
  agent.acc.add(tar); //add seeking, acc now holds the weighted calculation of all behaviors
  agent.acc.add(top);
  agent.acc.add(avd);
  agent.trAcc = agent.acc;
} //end swarm()

//UPDATE POSITION AND REPRESENTATION
void setInMotion(MomentumPt agent) {
  agent.vel.add(agent.acc); //add calculated acceleration to current velocity
  agent.vel.limit(agent.maxSpeed); //limit new velocity according to maxSpeed
  agent.pos.add(agent.vel); //effectively update position
  agent.acc.mult(0); //reset acceleration
  agent.head.translate(agent.vel.x, agent.vel.y, agent.vel.z); //update head

  agent.trail.add(Anar.Pt(agent.pos.x, agent.pos.y, agent.pos.z)); //updated trail
} //end setInMotion()

//DRAW REPRESENTATION
void render(MomentumPt agent) {
  agent.trail.draw(); //draws complete trace
  agent.head.draw(); //draws updated position marker
} //end render()

//RULE 1: move away from nearest neighbors
PVector separate (MomentumPt compare, MomentumPt[][] agents) {
  float desiredSeparation = 50.0; //set proximity within which separate() is effective
  PVector steerSep = new PVector(0, 0, 0); //create vector to be returned
  int ctSep = 0; //counter
  for(int k=0; k<stPtCt; k++) { //loop for each start point
    for(int m=0; m<tarPtCt; m++) { //loop for each target point
      if ( (k != m) ) { //only needed if start points and target points are same
        if (agents[k][m].stopMoving == false) { //for all agents that have not reached their targets
          float dS = PVector.dist(compare.pos, agents[k][m].pos); //get distance between current and other agents
          if ( (dS>0) && (dS<desiredSeparation) ) { //proximity check
            PVector diff = PVector.sub(compare.pos, agents[k][m].pos); //calculate vector between the current and each other agent position
            diff.normalize(); //unitize
            diff.div(dS); //possibly redundant, possibly useful when many agents are close together
            steerSep.add(diff); //add all vectors together
            ctSep++; //increment counter
          } //end proximity check
        } //end stopMoving if
      } //end i!=j comparison, comment if point sets are distinct
    } //end m loop
  } // end k loop
  if (ctSep>0) { //if there are neighbors
    steerSep.div((float)ctSep); //average steering vector
  } //end if
  if (steerSep.mag()>0) { //check that vector has magnitude
    steerSep.normalize(); //unitize
    steerSep.mult(compare.maxSpeed); //multiply by maxSpeed
    steerSep.sub(compare.vel); //adjust for current velocity
    steerSep.limit(compare.maxForce); //limit to maxForce
  } //end if
  return steerSep; //return adjusted separation vector
} //end separate()

//RULE 2: match velocity with neighbors
PVector align (MomentumPt compare, MomentumPt[][] agents) {
  float neighborDist = 100.0; //define radius of influence
  PVector steerAli = new PVector(0, 0, 0); //create vector to be returned
  int ctAli = 0; //counter
  for(int k=0; k<stPtCt; k++) { //loop for each start point
    for(int m=0; m<tarPtCt; m++) { //loop for each target point
      if ( (k != m) ) { //only needed if start points and target points are same
        if (agents[k][m].stopMoving == false) { //for all agents that have not reached their targets
          MomentumPt other = agents[k][m]; //redundant?
          float dA = PVector.dist(compare.pos, other.pos); //get distance between agents
          if ( (dA>0) && (dA<neighborDist)) { //proximity check
            steerAli.add(other.vel); //add their velocity to the steering vector
            ctAli++; //increment counter
          } //end proximity check
        } // end stopMoving if
      } //end i!=j comparison, comment if point sets are distinct
    } // end m loop
  } // end k loop
  if (ctAli>0) { //if there are neighbors
    steerAli.div((float)ctAli); //average steering vector
  } //end if
  if (steerAli.mag()>0) { //check that vector has non-zero magnitude
    steerAli.normalize(); //unitize
    steerAli.mult(compare.maxSpeed); //multiply by maxSpeed
    steerAli.sub(compare.vel); //adjust for current velocity
    steerAli.limit(compare.maxForce); //limit to maxForce
  } //end if
  return steerAli; //return adjusted alignment vector
} //end align()

//RULE 3: head towards neighbors' 'center of mass'
PVector cohesion (MomentumPt compare, MomentumPt[][] agents) {
  float neighborDist = 100.0; //define radius of influence
  PVector steerCoh = new PVector(0, 0, 0); //create vector to be returned
  int ctCoh = 0; //counter
  for(int k=0; k<stPtCt; k++) { //loop for each start point
    for(int m=0; m<tarPtCt; m++) { //loop for each target point
      if ( (k != m) ) { //only needed if start points and target points are same
        if (agents[k][m].stopMoving == false) { //for all agents that have not reached their targets
          MomentumPt other = agents[k][m]; //redundant?
          float dC = PVector.dist(compare.pos, other.pos); //get distance between agents
          if ( (dC>0) && (dC<neighborDist)) { //proximity check
            PVector posMass = PVector.mult(other.pos, other.mass); //multiplication by agent's mass
            steerCoh.add(posMass); //add weighted vector to the steering vector
            ctCoh++; //increment counter
          } //end proximity check
        } // end stopMoving if
      } //end i!=j comparison, comment if point sets are distinct
    } //end m loop
  } //end k loop
  if (ctCoh==1) { //if there's exactly one neighbor
    steerCoh.mult(0.5); //halve steering vector to ensure that agents don't get caught in a local equilibrium
  } //end 1 neighbor if
  if (ctCoh>0) { //if there are neighbors
    steerCoh.div((float)ctCoh); //average steering vector to get 'center of mass'
    steerCoh = steer(compare, steerCoh); //adjust according to utility function, see steer() below
  } //end if
  return steerCoh; //return adjusted cohesion vector
} //end cohesion()

//rule 4: seek a goal point
PVector seek(MomentumPt compare, Pt target, ParticleSystem bundle) {
  float targetDist = 50.0; //define proximity for 'arrival'
  PVector tarVec = new PVector(target.x(), target.y(), target.z()); //convert point to PVector
  PVector steerTar; //create vector to be returned
  float dT = PVector.dist(compare.pos, tarVec); //get distance to target
  if (dT>targetDist) { //if the agent has not yet arrived
    steerTar = steer(compare, tarVec); //adjust according to the utility function, see steer() below
  } //end if
  else { //if the agent has arrived
    compare.stopMoving = true; //set field to true, removing agent from further movements or comparisons
    drop(bundle, compare);
    steerTar = new PVector(0,0,0); //return empty vector
  } //end else
  return steerTar; //return adjusted goal-seeking vector
} //end seek()

//rule 5: steer towards most horizontal path across topography
PVector topoSteer(MomentumPt compare) {
  PVector steerTop; //create vector to be returned
  Pt now = Anar.Pt(compare.pos.x, compare.pos.y, compare.pos.z);
  int[] nowID = faceID(now, meshInit);
  steerTop = new PVector(meshInit.fH[nowID[0]].x(), meshInit.fH[nowID[0]].y(), meshInit.fH[nowID[0]].z() );
  if(PVector.angleBetween(compare.vel, steerTop) > PI/2 ) {
    steerTop.mult(-1);
  }
  if (steerTop.mag()>0) { //check that vector has non-zero magnitude
    steerTop.normalize(); //unitize
    steerTop.mult(compare.maxSpeed); //multiply by maxSpeed
    steerTop.sub(compare.vel); //adjust for current velocity
    steerTop.limit(compare.maxForce); //limit to maxForce
  } //end if
  return steerTop;
}

//rule 6: avoid target points that are not the agent's own
PVector avoid(MomentumPt compare, Pt[] avoidPt) {
  PVector steerAvd = new PVector(0,0,0);
  for(int n=0; n<avoidPt.length; n++) {
    if(!compare.target.equalsPt(avoidPt[n])) {
      PVector avoidPtVec = new PVector(avoidPt[n].x(), avoidPt[n].y(), avoidPt[n].z() );
      float d = PVector.dist(compare.pos, avoidPtVec);
      //println(compare.id + " " + avoidPtVec + " " + d);
      if(d<400) {
        PVector steerTmp = steer(compare, avoidPtVec);
        steerTmp.mult(-1);
        steerAvd.add(steerTmp);
      }
    }
  }
  if (steerAvd.mag()>0) { //check that vector has non-zero magnitude
    steerAvd.normalize(); //unitize
    steerAvd.mult(compare.maxSpeed); //multiply by maxSpeed
    steerAvd.sub(compare.vel); //adjust for current velocity
    steerAvd.limit(compare.maxForce); //limit to maxForce
  } //end if
  //println(steerAvd);
  return steerAvd;
}

//utility function: head towards target
PVector steer(MomentumPt compare, PVector target) {
  PVector steer; //declare the steering vector to be returned
  PVector desired = target.sub(target, compare.pos); //PVector form current position to the target
  float d = desired.mag(); //distance to target
  if (d > 0) { //if the agent has not reached the target
    desired.normalize(); //unitize
    desired.mult(compare.maxSpeed); //multiply by maxSpeed
    steer = target.sub(desired, compare.vel); //adjust for current velocity
    steer.limit(compare.maxForce); //limit to maxForce
  } //end if
  else { //if the agent has reached the target
    steer = new PVector(0,0,0); //return empty vector
  } // end else
  return steer; //return adjusted vector
} //end steer()

////utility function: compare to mesh for Z value
//float compareZ(MomentumPt compare, HEM mesh) {
//  Pt now = Anar.Pt(compare.pos.x, compare.pos.y, compare.pos.z);
//  int[] nowID = faceID(now, mesh);
//  PVector axisZ = new PVector(mesh.fN[nowID[0]].x(), mesh.fN[nowID[0]].y(), mesh.fN[nowID[0]].z() );
//  float dZ = intersectVECPLANE(now, zVec, mesh.fC[nowID[0]], axisZ);
//  //  println(compare.id + " " + nowID[0] + ", " + dZ );
//  //  Pts test1 = new Pts();
//  //  test1.add(now);
//  //  test1.add(Anar.Pt(now.x(), now.y(), now.z()+dZ));
//  //  test1.stroke(255,230,230);
//  //  PVector horz = axisZ.cross(z);
//  //  horz.normalize();
//  //  horz.mult(40);
//  //  Pts test2 = new Pts();
//  //  test2.add(Anar.Pt(now.x(), now.y(), now.z()+dZ));
//  //  test2.add(Anar.Pt(now.x() + horz.x, now.y() + horz.y, now.z()+dZ));
//  //  test2.stroke(255,0,0);
//  //  testing.add(test1);
//  //  testing.add(test2);
//  return dZ;
//}

