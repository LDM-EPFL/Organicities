void slopeUp(momentumPt mPt, HEM mesh, int fNdx, int dnup){  
    PVector heading = new PVector(mPt.vX, mPt.vY, mPt.vZ);
    heading.normalize();
    //Pt nPt = f.normal();
    //Pt cnt = f.center(); 
    
    //PVector nVec = new PVector(nPt.x()-cnt.x(), nPt.y()-cnt.y(),nPt.z()-cnt.z());
    PVector nVec = new PVector(mesh.fN[fNdx].x(), mesh.fN[fNdx].y(), mesh.fN[fNdx].z());
    PVector crossProd = heading.cross(nVec);
    crossProd.normalize();
    
    //*
    if (crossProd.z>0){ //DIRECTION OF CROSSPRODUCT IS UPHILL
      if (crossProd.z>heading.z){ //DIRECTION OF CROSSPRODUCT IS STEEPER THAN CURRENT DIRECTION
        mPt.vX = (heading.x *.5) + (crossProd.x *1.5 *dnup );
        mPt.vY = (heading.y *.5) + (crossProd.y *1.5 *dnup );
        mPt.vZ = (heading.z *.5) + (crossProd.z *1.5 *dnup );
      } else { //DIRECTION OF CROSSPRODUCT IS UPHILL BUT SHALLOWER
        mPt.vX = (heading.x *.75) + (crossProd.x *1 *dnup );
        mPt.vY = (heading.y *.75) + (crossProd.y *1 *dnup );
        mPt.vZ = (heading.z *.75) + (crossProd.z *1 *dnup );
      }      
    } else if(crossProd.z<0){ //DIRECTION OF CROSSPRODUCT IS DOWNHILL
        if (crossProd.z>heading.z){ //DIRECTION OF CROSSPRODUCT IS DOWNHILL BUT SHALLOWER 
        mPt.vX = (heading.x *.5) + (crossProd.x *-1.5 *dnup );
        mPt.vY = (heading.y *.5) + (crossProd.y *-1.5 *dnup );
        mPt.vZ = (heading.z *.5) + (crossProd.z *-1.5 *dnup );
      } else { //DIRECTION OF CROSSPRODUCT IS STEEPER THAN CURRENT DIRECTION
        mPt.vX = (heading.x *.75) + (crossProd.x * -1 *dnup );
        mPt.vY = (heading.y *.75) + (crossProd.y *-1 *dnup );
        mPt.vZ = (heading.z *.75) + (crossProd.z *-1 *dnup );
      }
    }
    
    //*/
    
    //f.fill(255,0,0);
    //return f;
}
    
