class Hex{
	/*** BASIC FIELDS ***/
	Pt o; float u,v; float r;
	float odir, osiz;
	
	
	/*** CACHING FIELDS ***/
	Pts hex;
	Obj[] faces;
	
	/*** LIFETIME FIELDS ***/
	int waiting = 0;
	boolean goToSleep = false;
	int finalizing = 0;
	int lastSplit;
	Hex target;
	int brotherCheck = -1;
	
	Hex(Pt so, float su, float sv, float sr){
		this(so,  su,  sv,  sr, 0, null);
	}
	Hex(Pt so, float su, float sv, float sr, int ls, Hex starget){
		o = so;
		u = su; v = sv;
		r = sr;
		
		lastSplit=ls;
		
		hex = createHex();
		
		target = starget;
		
	}
	
	void draw(int mode){
		//hex.draw();
		if(faces != null && waiting <= 0){
			if(faces[0] != null && mode == 0 || mode == 1){faces[0].draw();}
			if(faces.length >= 2){
				if(faces[1] != null && mode == 0 || mode == 2){faces[1].draw();}
			}
			if(faces.length >= 3){
				if(faces[2] != null && mode == 3){faces[2].draw();}
			}
			if(faces.length >= 4){
				if(faces[3] != null && mode == 3){faces[3].draw();}
			}
		}
		
	}
	
	void permanentize(Hex n){
		if(!isAcceptable(n) && target == null){
			if(n.finalizing == 0){
				n.finalizing = 1;
			}
		}
		
		if(n.finalizing <= 3){
			addActiveHex(n);
		}
	}
	
	/*** AGGREGATION MATTERS ***/
	void aggregate(){
		if(waiting <= 0){
			if(finalizing>0){
				aggregateFinalizing();
			}
			else if(!goToSleep){
				int aggregationType = getAggregationType(this);
				switch(aggregationType){
					default:
						aggregateNone();
					break;
					case 1:
						aggregateSame();
					break;
					case 2:
						aggregateSmaller();
					break;
					/*case 3:
						aggregateHousing();
					break;*/
				}
			}
			goToSleep = true;
		}
			
	}
	void aggregateNone(){
		
	}
	void aggregateSame(){
		Hex child = giveSameChild();
		if(child != null){
			int faceType;
			if(kaiTak.getZone(child) == 0 || kaiTak.getZone(child) == 1){if(child.o.z() > child.r*1.2){faceType = 2;}else{faceType = 3;}}
			else{faceType = 0;}
			
			faces = makeFacesToSameChild(this, child, faceType);
			child.brotherCheck = brotherCheck;
			child.brotherCheck = brotherCheck;
			permanentize(child);
		}
	}
	void aggregateSmaller(){
		Hex[] children = giveSmallerChildren();
		faces = makeFacesToSmallerChildren(this, children[0], children[1], children[2]);
		int generateRandomBrotherhoodChecker = myRandom.nextInt(25000);
		children[0].brotherCheck = generateRandomBrotherhoodChecker;
		children[1].brotherCheck = generateRandomBrotherhoodChecker;
		children[2].brotherCheck = generateRandomBrotherhoodChecker;
		permanentize(children[0]);
		permanentize(children[1]);
		permanentize(children[2]);
	}
	void aggregateFinalizing(){
		Hex child = giveFinalizingChild();
		if(child != null){
			faces = makeFacesToSameChild(this, child, 4);
			permanentize(child);
		}
	}
	
	/*Hex giveHousingChild(int num){
		Pt tempBase = Pt.create(0,1,0);
		tempBase.apply(getTotalTransform());
		Pt base = Pt.create(tempBase.x(),tempBase.y(),tempBase.z());
		float newR = (sq(1.5)-sq(num-1.5))*baseSize();
		Hex newChild = new Hex(base,u,v,newR, 0);
		newChild.housing = num + 1;
		return newChild;
	}*/
	Hex giveSameChild(){
		
		//WE MAKE THE BASE POINT
		Pt tempBase = Pt.create(0,1,0);
		tempBase.apply(getTotalTransform());
		Pt base = Pt.create(tempBase.x(),tempBase.y(),tempBase.z());
		
		//if(!isAcceptable(base)){return null;}
		
		// RAYON
		float newR = r;
		
		
		
		if(targetActiveTreads(this)>0){
			if(r<2.0*baseSize(this)){ newR *= 1.1;}
		}
		else{
			if(newR>baseSize(this)){newR *= .93;}
			if(newR<baseSize(this)){newR *= 1.07;}
		}
		
		//if(targetActiveTreads(this)>0 && r<2.0*baseSize(this)){ newR *= 1.1;}
		//else if(targetActiveTreads(this)<0 && r>baseSize(this)){ newR *= .9;}
		
		
		
		float newU = u;
		float newV = v;
		
		if(target != null){
			//TARGET ABSOLUTE !!!
			
			//println(frameCount+" target : "+target);
			
			float dist = distanceBetween(o, target.o);
			
			if(dist < 2*newR){
				goToSleep = true;
				target.gotcha(this);
				return target;
			}
			else{
				Pt tempTargetPt = Pt.create(0,-dist/2.0,0);
				tempTargetPt.apply(target.getRotationTransform());
				tempTargetPt.apply(target.getDisplacementTransform());
				
				Pt thisPt = Pt.create(0,dist/2.0,0);
				thisPt.apply(this.getRotationTransform());
				thisPt.apply(this.getDisplacementTransform());
				
				PtMid targetPt = new PtMid(tempTargetPt, thisPt);
				
				float rmix = constrain(map(dist, 2*newR, 10*newR, 0, 1),0,1);
				newR = rmix*newR + (1-rmix)*target.r;
				
				float dx = (float)(targetPt.x() - o.x());
				float dy = (float)(targetPt.y() - o.y());
				float dz = (float)(targetPt.z() - o.z());
				newU = (TWO_PI - atan( dx / dy ))%TWO_PI;
				if(dy<0){newU -= PI;}
				newV = (TWO_PI + atan( dz / sqrt( sq(dx)+sq(dy)) ))%TWO_PI;
			}
		}
		else{
			//BASE UPON WATER AND FOLLOW DIR
			int zone = kaiTak.getZone(base); float widthFactor = 1.0; float siteDirectionFactor = 1.0;
			
			if(zone != 0){widthFactor = 0.2;}
			else{siteDirectionFactor = 2;}
			
			if(zone == 1){widthFactor = 0.7;}
			newU += probeWater(10, widthFactor*50.0, widthFactor*50.0, true) * PI/6.0 * siteDirectionFactor;	//it avoids water
			newU += probeDirection(6, widthFactor*150.0, widthFactor*100.0, true) * PI/6.0 * siteDirectionFactor;	//it follows dir
			
			//PROBE NEIGHBOURS BEST
			float[] probeNeighbours = probeNeighbours(r*2, r*2);
			
			newU -= probeNeighbours[0] * PI/20.0;
			if(zone != 0){newV += probeNeighbours[1] * PI/12.0;}
			else{newV += probeNeighbours[1] * PI/60.0;}
			if(probeNeighbours[1] == 0){if(newV>0 || base.z()>newR){newV -= PI/12.0;}}

			if(probeNeighbours[2] >= 20){return null;}

			//RANDOMIZATION
			newU += random(-1,1) * PI/36.0;
			newV += random(-1,1) * PI/36.0;

			//ANGLE CORRECTION
			newU = constrain(newU, u-PI/6.0, u+PI/6.0);
			newV = constrain(newV, v-PI/6.0, v+PI/6.0);

			//SLOPE CORRECTION
			//if(zone != 3){
			newV = constrain(newV, -PI/6.0, PI/6.0);//}
			//else{
			//newV = constrain(newV, -PI/3.0, PI/3.0);}
		}
		
		
		//TECHNICAL CORRECTION
		newU = (newU+TWO_PI)%TWO_PI;
		if(base.z()<newR){base.z(newR); if(newV<0){newV = 0.0;}}
		if(base.z()<newR*4.0){if(newV<0){newV /= 2.0;}}
		
		newU = (TWO_PI + newU)%TWO_PI;
		
		return new Hex(base,newU,newV,newR, lastSplit+1, target);
	}
	Hex[] giveSmallerChildren(){
		return giveSmallerChildren(false);
	}
	Hex[] giveSmallerChildren(boolean mirror){
		Hex[] retChi = new Hex[3];
		
		Pt baseA;
		Pt baseB;
		Pt baseC;
		if(!mirror){
			baseA = Pt.create(-sideVsR(r)/4.0,	r,	-hVsR(r)/4.0);
			baseB = Pt.create(-sideVsR(r)/4.0,	r,	hVsR(r)/4.0);
			baseC = Pt.create(sideVsR(r)/2.0,	r,	0);
		}
		else{
			baseA = Pt.create(sideVsR(r)/4.0,	r,	-hVsR(r)/4.0);
			baseB = Pt.create(sideVsR(r)/4.0,	r,	hVsR(r)/4.0);
			baseC = Pt.create(-sideVsR(r)/2.0,	r,	0);
		}
		
		baseA.apply(getRotationTransform());
		baseB.apply(getRotationTransform());
		baseC.apply(getRotationTransform());
		baseA.apply(getDisplacementTransform());
		baseB.apply(getDisplacementTransform());
		baseC.apply(getDisplacementTransform());
		
		float angang = PI/8.0;
		if(!mirror){
			retChi[0] = new Hex(baseA,u+angang/2.0,v-angang/2.0,r/2.0);
			retChi[1] = new Hex(baseB,u+angang/2.0,v+angang/2.0,r/2.0);
			retChi[2] = new Hex(baseC,u-angang,v,r/2.0);
		}
		else{
			retChi[0] = new Hex(baseA,u-angang/2.0,v-angang/2.0,r/2.0);
			retChi[1] = new Hex(baseB,u-angang/2.0,v+angang/2.0,r/2.0);
			retChi[2] = new Hex(baseC,u+angang,v,r/2.0);
		}
		
		return retChi;
	}
	Hex giveFinalizingChild(){
		//WE MAKE THE BASE POINT
		Pt tempBase = Pt.create(0,0.5,0);
		tempBase.apply(getTotalTransform());
		Pt base = Pt.create(tempBase.x(),tempBase.y(),tempBase.z());
		
		float newR;
		if(finalizing == 1){
			newR = r;
		}
		else if(finalizing == 2){
			newR = r*0.8;
		}
		else{
			newR = 0;
		}
		
		float newU = u;
		float newV = v;
		
		Hex newHex = new Hex(base,newU,newV,newR, lastSplit+1, target);
		newHex.finalizing = finalizing+1;
		return newHex;
	}
	
	
	
	void gotcha(Hex m){
		//println("GOTCHA :) ");
		if(target != null && target != m){
			target.gotcha(this);
		}
		if(waiting > 0){
			waiting--;
			//println("WAITING = FALSE !!!!!!!!");
		}
	}
	
	
	/*** PROBING ***/
	float probeWater(int probesCount, float probeWidth, float probeDist, boolean drawimg){

		float balance = 0;
		Pt[] probes = new Pt[probesCount];
		for(int i=0; i<probesCount; i++){
			float coord = probeWidth * map(i,0,probesCount-1, -1, 1);
			probes[i] = Pt.create(coord,probeDist,0);
			probes[i].apply(getRotationTransform());
			probes[i].apply(getDisplacementTransform());
			if(kaiTak.getWater(probes[i])){
				if(drawimg){probes[i].draw();}
				balance -= sign(coord);
			}
			else{
				if(drawimg){probes[i].draw();}
				balance += sign(coord);
			}
		}
		balance /= (probesCount * 2.0);
		
		return constrain(balance,-1,1);
	}
	float probeDirection(int probesCount, float probeWidth, float probeDist, boolean drawimg){
			float balance = 0;
			Pt[] probes = new Pt[probesCount];
			for(int i=0; i<probesCount; i++){
				float coord = probeWidth * map(i,0,probesCount-1, -1, 1);
				probes[i] = Pt.create(coord,probeDist,0);
				probes[i].apply(getRotationTransform());
				probes[i].apply(getDisplacementTransform());
				if(drawimg){probes[i].draw();}
				balance -= sign(coord) * kaiTak.getDirection(probes[i]);
			}
			balance /= (probesCount);

			return constrain(balance * 4.0,-1,1);
	}
	float[] probeNeighbours(float probeDist, float probeWidth){
		float[] returnFloat = {0,0,0};
		
		ArrayList probes = new ArrayList();
		ArrayList coordXAL = new ArrayList();
		ArrayList coordZAL = new ArrayList();
		for(int i=0; i<4; i++){
			for(int j=0; j<4; j++){
				if(!(i==0 && j==0 || i==0 && j==3 || i==3 && j==0 || i==3 && j==3))
				{
					float coordX = map(i,0,3,-probeWidth,probeWidth);
					float coordZ = map(j,0,3,-probeWidth,probeWidth);
				
				
					coordXAL.add(new Float(coordX));
					coordZAL.add(new Float(coordZ));
				
					if(i==0 || i==3 || j==0 || j==3){
						probes.add(Pt.create(coordX,0,coordZ));
						coordXAL.add(new Float(coordX));
						coordZAL.add(new Float(coordZ));
					}
					probes.add(Pt.create(coordX,2*probeDist,coordZ));	
				}
			}
		}
		
		for(int i=0; i<probes.size(); i++){
			
			Pt curProb = (Pt)probes.get(i);
			
			curProb.apply(getRotationTransform());
			curProb.apply(getDisplacementTransform());
			curProb.draw();
			
			float smallestDist = 10000000;
			if(activeHexes.size()>0){
				Hex curHex = (Hex)activeHexes.get(0);
				for(int k=0; k<activeHexes.size() && smallestDist>curHex.r*1.5; k++){
					curHex = (Hex)activeHexes.get(k);
					if(curHex != this){
						float distanceBetweenThem = distanceBetween(curProb, curHex.o);
						if(smallestDist == -1 || distanceBetweenThem<smallestDist){
							smallestDist = distanceBetweenThem;
						}
					}
				}
			}
			if(sleepingHexes.size()>0){
				Hex curHex = (Hex)sleepingHexes.get(0);
				for(int k=0; k<sleepingHexes.size() && smallestDist>curHex.r*1.5; k++){
					curHex = (Hex)sleepingHexes.get(k);
					if(curHex != this){
						float distanceBetweenThem = distanceBetween(curProb, curHex.o);
						if(smallestDist == -1 || distanceBetweenThem<smallestDist){
							smallestDist = distanceBetweenThem;
						}
					}
				}
			}
			
			if(smallestDist < r*2){
				returnFloat[0] -= sign(((Float)coordXAL.get(i)).floatValue());
				returnFloat[1] -= sign(((Float)coordZAL.get(i)).floatValue());
				returnFloat[2]++;
			}
			else{
				returnFloat[0] += sign(((Float)coordXAL.get(i)).floatValue());
				returnFloat[1] += sign(((Float)coordZAL.get(i)).floatValue());
			}
			
		}
				
			
		returnFloat[0] = constrain(returnFloat[0]/8, -1, 1);
		returnFloat[1] = constrain(returnFloat[1]/8, -1, 1);
		if(returnFloat[1] == 0 && returnFloat[2]>0){
			returnFloat[1] = constrain(returnFloat[2]/8, -1, 1);
		}
		
		return returnFloat;
	}
	
	/*** CACHE CREATING ***/
	Pts createHex(){
		Pts tempPts = new Pts();
		for(int i=0; i<6; i++){
			tempPts.add(   Pt.create(sin(TWO_PI/12.0+TWO_PI/6.0*i),0,cos(TWO_PI/12.0+TWO_PI/6.0*i))   );
		}
		tempPts.apply(getTotalTransform());
		return tempPts;
	}
	
	/*** NORMAL STUFF ***/
	Pt createRotatedNormal(){
		return createRotatedNormal(1.0);
	}
	Pt createRotatedNormal(float f){
		Pt tempNorm = Pt.create(0,f,0);
		tempNorm.apply(getRotationTransform());
		return tempNorm;
	}
	Pt createScaledNormal(){
		return createScaledNormal(1.0);
	}
	Pt createScaledNormal(float f){
		Pt tempNorm = createRotatedNormal(f);
		tempNorm.apply(getScaleTransform());
		return tempNorm;
	}
	Pt createDeplacedNormal(){
		return createDeplacedNormal(1.0);
	}
	Pt createDeplacedNormal(float f){
		Pt tempNorm = Pt.create(0,f,0);
		tempNorm.apply(getTotalTransform());
		return tempNorm;
	}
	
	Transform getRotationTransform(){
		Transform tempTrans = new Transform();
		tempTrans.rotateX(v);
		tempTrans.rotateZ(u);
		return tempTrans;
	}
	Transform getDisplacementTransform(){
		Transform tempTrans = new Transform();
		tempTrans.translate(o.x(), o.y(), o.z());
		return tempTrans;
	}
	Transform getScaleTransform(){
		Transform tempTrans = new Transform();
		tempTrans.scale(r);
		return tempTrans;
	}
	Transform getTotalTransform(){
		Transform tempTrans = new Transform();
		tempTrans.apply(getRotationTransform());
		tempTrans.apply(getScaleTransform());
		tempTrans.apply(getDisplacementTransform());
		return tempTrans;
	}

	Hex oppositeHex(){
		return new Hex(o,u+PI,-v,r);
	}
}