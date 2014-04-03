void drop(ParticleSystem bundle, MomentumPt agent) {
  int ndx = bundle.numberOfParticles();
  bundle.makeParticle(agent.mass, agent.pos.x, agent.pos.y, agent.pos.z);
  //pathDraw.add(new Square(Anar.Pt(agent.pos.x, agent.pos.y, agent.pos.z), agent.mass*3).fill(0, 0, 255).stroke(0, 0, 255)); //represent nodes as squares
  pathDraw.add(new Circle(Anar.Pt(agent.pos.x, agent.pos.y, agent.pos.z), 25).fill(220, 0, 0, 20).stroke(220, 0, 0, 1) ); //represent nodes with proximity circles NOTE: relationship to minDist variable below is poorly written
  if(ndx > 0) {
    bundle.makeSpring(bundle.getParticle(ndx), bundle.getParticle(ndx-1), 0.0001, 0.01, 50); //rest length originally 50
    pathDraw.add(new Pts(Anar.Pt(bundle.getParticle(ndx).position().x(),
    bundle.getParticle(ndx).position().y(),
    bundle.getParticle(ndx).position().z() ),
    Anar.Pt(bundle.getParticle(ndx-1).position().x(),
    bundle.getParticle(ndx-1).position().y(),
    bundle.getParticle(ndx-1).position().z() )).stroke(220) );//(150,200,255));
  }
}

void makeAttractions(ParticleSystem[][] bundles) {
  if(findAttractions == true) {
    stopSwarm = true;
    startAttract = true;
    //println("stPtCt = " + stPtCt + ", ps.length = " + bundles.length); //testing
    //println(attrLines.length);
    drawBundles = true;
    float minDist = 49; //was 60
    int count = 0;
    //int[][][] attrCt;
    for(int i=0; i<bundles.length; i++) { //start point index
      //println("tarPtCt = " + tarPtCt + ", ps[" + i + "].length = " + bundles[i].length); //testing
      //println(attrLines[i].length);
      for(int j=0; j<bundles[i].length; j++) { //target point index
        int incCount = 0;
        attrLines[i][j] = new Obj();
        if (i != j) { //only needed if start points and target points are same
          //println("path[" + i + "][" + j + "] has " + bundles[i][j].numberOfParticles() + " particles");
          bundles[i][j].getParticle(bundles[i][j].numberOfParticles()-1 ).makeFixed(); //fix end particle
          for(int k=0; k<bundles[i][j].numberOfParticles(); k++) { //point along path index
            for(int m=0; m<bundles.length; m++) { //m,n,p analogous to i,j,k but for path[m][n], particle (p) against which is compared
              for(int n=0; n<bundles[m].length; n++) {
                if ( (m != n) ) { //only needed if start points and target points are same
                  for(int p=0; p<bundles[m][n].numberOfParticles(); p++) {
                    if( m==i && j==n) { //do nothing if same path
                    }
                    else { //else compare for attraction if closer than minDist
                      //print("finding attractions for path [" + i + "][" + j + "](" + k + "): ");
                      //print("[" + m + "][" + n + "](" + p + ")...");
                      Pt p0 = Anar.Pt(bundles[i][j].getParticle(k).position().x(), bundles[i][j].getParticle(k).position().y(), bundles[i][j].getParticle(k).position().z() );
                      Pt p1 = Anar.Pt(bundles[m][n].getParticle(p).position().x(), bundles[m][n].getParticle(p).position().y(), bundles[m][n].getParticle(p).position().z() );
                      float nowDist = p0.length(p1);
                      //attrLines[i][j].add(new Circle(p0, minDist) );
                      if(nowDist < minDist) {
                        //println("YES!");
                        //println(attrLines[i][j]);
                        attrLines[i][j].add(new Pts(p0, p1));
                        bundles[i][j].makeAttraction(bundles[i][j].getParticle(k), bundles[m][n].getParticle(p), 20, 50);
                        count++;
                        incCount++;
                      }
                      else {
                        //println("no");
                      }
                    }
                  }
                }
              } //end k!=m comparison, comment if point sets are distinct
            }
          }
        } //end i!=j comparison, comment if point sets are distinct
        //println("path[" + i + "][" + j + "] has " + incCount + " connections.");
        //println("attrLines[" + i + "][" + j + "] has " + attrLines[i][j].numOfLines() + " lines.");
        print(".");
      }
    }
    println("made " + count + " attractions");
    findAttractions = false;
  }
}

void bundlePaths(ParticleSystem[][] bundles) {
  if(bundlePaths == true) {
    drawBundles = false;
    for(int i=0; i<bundles.length; i++) {
      for(int j=0; j<bundles[i].length; j++) {
        if (i != j) { //only needed if start points and target points are same
          ps[i][j].tick();
          update(ps[i][j]);
        } //end i!=j comparison, comment if point sets are distinct
      }
    }
  }
}

void update(ParticleSystem bundle) {
  Pt[] ptcl = new Pt[bundle.numberOfParticles()];
  Pts path = new Pts();
  for(int k=0; k<bundle.numberOfParticles(); k++) {
    ptcl[k] = Anar.Pt(bundle.getParticle(k).position().x(), bundle.getParticle(k).position().y(), bundle.getParticle(k).position().z() );
    path.add(ptcl[k]);
  }
  path.stroke(120);
  path.draw();
}

