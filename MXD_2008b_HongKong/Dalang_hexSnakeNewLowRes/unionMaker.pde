class UnionMaker{
	Hex b;
	Hex[] children;
	Hex mirrorB;
	Hex hexA, hexB, hexC;
	float midDist;
	
	UnionMaker(Hex sb, Hex[] schildren, Hex smirrorB, Hex shexA, Hex shexB, Hex shexC, float sMD){
		b = sb;
		children = schildren;
		mirrorB = smirrorB;
		hexA = shexA;
		hexB = shexB;
		hexC = shexC;
		midDist = sMD;
	}
	
	void concretize(){
		Hex childA = children[0].oppositeHex();
		Hex childB = children[1].oppositeHex();
		Hex childC = children[2].oppositeHex();

		b.waiting = 3;
		childA.waiting = 1;
		childB.waiting = 1;
		childC.waiting = 1;
		childA.goToSleep = true;
		childB.goToSleep = true;
		childC.goToSleep = true;

		//addActiveHex(b);
		b.permanentize(b);
		childA.permanentize(childA);
		childB.permanentize(childB);
		childC.permanentize(childC);

		childA.faces = makeFacesToSmallerChildren(mirrorB, childA, childB, childC, true);
		childB.faces = makeFacesToSmallerChildren(mirrorB, childA, childB, childC, true);
		childC.faces = makeFacesToSmallerChildren(mirrorB, childA, childB, childC, true);

		childA.target = b;
		childB.target = b;
		childC.target = b;

		hexA.target = childA;
		hexB.target = childB;
		hexC.target = childC;
	}
}


void unionMaker(ArrayList list){
	
	ArrayList potentialUnions = new ArrayList();
	
	int listSize = list.size();
	for(int i=0; i<listSize; i++){
		Hex hexA = (Hex)list.get(i);
		for(int j=0; j<listSize; j++){
			Hex hexB = (Hex)list.get(j);
			for(int k=0; k<listSize; k++){
				Hex hexC = (Hex)list.get(k);
				boolean notSelfEqual = (hexA != hexB && hexA != hexC && hexB != hexC);
				boolean notNull = (hexA.target == null && hexB.target == null && hexC.target == null);
				boolean notUseless = (targetActiveTreads(hexA)<0 && targetActiveTreads(hexB)<0 && targetActiveTreads(hexC)<0);
				boolean notTooEary = ((hexA.lastSplit > sepBetwSplits(hexA)) && (hexA.lastSplit > sepBetwSplits(hexA)) && (hexA.lastSplit > sepBetwSplits(hexA)));
				boolean notWaiting = (hexA.waiting <= 0 && hexB.waiting <= 0 && hexC.waiting <= 0);
				boolean notIncestualA = (hexA.brotherCheck==-1 || (hexA.brotherCheck != hexB.brotherCheck && hexA.brotherCheck != hexC.brotherCheck));
				boolean notIncestualB = (hexB.brotherCheck==-1 || (hexB.brotherCheck != hexA.brotherCheck && hexB.brotherCheck != hexC.brotherCheck));
				boolean notIncestualC = (hexC.brotherCheck==-1 || (hexC.brotherCheck != hexA.brotherCheck && hexC.brotherCheck != hexB.brotherCheck));
				boolean notIncestual = (notIncestualA || notIncestualB || notIncestualC);
				if( notSelfEqual && notNull && notUseless && notTooEary && notWaiting && notIncestual){
					
					
					
					float distAB = distanceBetween(hexA.o, hexB.o);
					float distAC = distanceBetween(hexA.o, hexC.o);
					float distBC = distanceBetween(hexB.o, hexC.o);
					float midDist = distAB+distAC+distBC;

					Pt targetPtA = Pt.create(0,midDist,0);
					Pt targetPtB = Pt.create(0,midDist,0);
					Pt targetPtC = Pt.create(0,midDist,0);
					
					targetPtA.apply(hexA.getRotationTransform());
					targetPtA.apply(hexA.getDisplacementTransform());
					targetPtB.apply(hexB.getRotationTransform());
					targetPtB.apply(hexB.getDisplacementTransform());
					targetPtC.apply(hexC.getRotationTransform());
					targetPtC.apply(hexC.getDisplacementTransform());
					
					Pt realPt = Pt.create(  (targetPtA.x()+targetPtB.x()+targetPtC.x())/3.0 , (targetPtA.y()+targetPtB.y()+targetPtC.y())/3.0 , (targetPtA.z()+targetPtB.z()+targetPtC.z())/3.0 );
					float[] allu = new float[3]; allu[0]=hexA.u;allu[1]=hexB.u;allu[2]=hexC.u;
					float[] allv = new float[3]; allv[0]=hexA.v;allv[1]=hexB.v;allv[2]=hexC.v;
					float realu = angleMid( allu );
					float realv = angleMid( allv );
					float realr;
					if(kaiTak.getZone(realPt) == 2){
						realr = (hexA.r+hexB.r+hexC.r)/3.0 * 3.0;
					}
					else{
						realr = (hexA.r+hexB.r+hexC.r)/3.0 * 2.0;
					}
					
					
					
					/* OPTIMIZE CHOOSE OF THIS ü!!! */
					Hex firstBig = new Hex(realPt, realu, realv, realr);
					
					/* OPTIMIZATION OF THE BIG HEX *//*
					float bestPoints = 0;
					if(!isAcceptable(firstBig)){bestPoints+=5;}
					bestPoints += abs(firstBig.probeWater(10, 0.5*50.0, 0.5*50.0, true));
					bestPoints += abs(firstBig.probeDirection(6, 0.5*150.0, 0.5*100.0, true));
					bestPoints += firstBig.probeNeighbours(firstBig.r*2, firstBig.r*2)[2] / 10.0;
					
					int tries = 0;
					while(bestPoints > 0 && tries<5){
						double randX = realPt.x() + random(-midDist/6.0,-midDist/6.0);
						double randY = realPt.y() + random(-midDist/6.0,-midDist/6.0);
						double randZ = realPt.z() + random(-midDist/12.0,-midDist/12.0);
						float randU = realu + random(-PI/12.0, PI/12.0);
						float randV = realv + random(-PI/18.0, PI/18.0);
						Hex otherBig = new Hex(Pt.create(randX,randY,randZ), randU, randV, realr);
						float newPoints = 0;
						if(!isAcceptable(otherBig)){newPoints+=5;}
						newPoints += abs(otherBig.probeWater(10, 0.5*50.0, 0.5*50.0, true));
						newPoints += abs(otherBig.probeDirection(6, 0.5*150.0, 0.5*100.0, true));
						newPoints += otherBig.probeNeighbours(firstBig.r*2, firstBig.r*2)[2] / 10.0;
						
						if(newPoints < bestPoints){
							newPoints = bestPoints;
							firstBig = otherBig;
						}
						
						tries++;
					}*/
					
					Hex b = firstBig;
					Hex mirrorB = b.oppositeHex();
					
					Hex[] children = mirrorB.giveSmallerChildren(true);
					
					if(midDist<15.0*realr && midDist>5.0*realr && isAcceptable(b) && isAcceptable(children[0]) && isAcceptable(children[1]) && isAcceptable(children[2])){
						
						
						
						
						UnionMaker myUM = new UnionMaker(b, children, mirrorB, hexA, hexB, hexC,midDist);
						potentialUnions.add(myUM);
						//myUM.concretize();
						
					}
				}
			}
		}
	}
	
	float minDist = -1;
	UnionMaker selectedUnion = null;
	for(int i=0; i<potentialUnions.size();i++){
		UnionMaker curUnion = (UnionMaker)potentialUnions.get(i);
		if(minDist == -1 || curUnion.midDist < minDist){
			minDist = curUnion.midDist;
			selectedUnion = curUnion;
		}
	}
	if(selectedUnion != null){
		selectedUnion.concretize();
	}
}
