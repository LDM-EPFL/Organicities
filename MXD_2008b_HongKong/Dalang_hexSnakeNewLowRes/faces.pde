Obj[] makeFacesToSameChild(Hex a, Hex b){
	return makeFacesToSameChild(a, b, 0);
}
Obj[] makeFacesToSameChild(Hex a, Hex b, int m){
	Obj[] returnFaces = new Obj[4];
	returnFaces[0] = new Obj();	//contains hard faces
	returnFaces[1] = new Obj();	//contains glassed faces
	returnFaces[2] = new Obj();	//contains housing faces
	returnFaces[3] = new Obj();	//contains housing faces
	
	
	for(int i=0; i<6; i++){
		Face myFace = new Face();
		Pt a1 = a.hex.get(i);
		Pt a2 = a.hex.get((i+1)%6);
		Pt b1 = b.hex.get(i);
		Pt b2 = b.hex.get((i+1)%6);
		myFace.add(a1);
		myFace.add(a2);
		myFace.add(b2);
		myFace.add(b1);
		
		if(m==1){//zenithal light
			if(i==5){/*returnFaces[1].add(myFace);*/}
			else{returnFaces[0].add(myFace);if(i!=2 && i!=5){makeHousingExtrusion(a,b,i,returnFaces[2],returnFaces[3]);}}
		}
		else if(m==2){//half pipe
			if(i==4 || i==5 || i==0){/*returnFaces[1].add(myFace);*/}
			else{returnFaces[0].add(myFace);}
		}
		else if(m==3){//open path
			if(i==2){returnFaces[0].add(myFace);if(i!=2 && i!=5){makeHousingExtrusion(a,b,i,returnFaces[2],returnFaces[3]);}}
			/*else{returnFaces[1].add(myFace);}*/
		}
		else if(m==4){//full glass
			returnFaces[1].add(myFace);
		}
		else{//full tunnel
			returnFaces[0].add(myFace);
			if(i!=2 && i!=5){makeHousingExtrusion(a,b,i,returnFaces[2],returnFaces[3]);}
		}
		
		
		
		
		
		
		
	}
	
	
	returnFaces[1].render = new RenderObjFaceOnly(new RenderFaceNormal(new OogColor(125,125,255, 125)));
	
	return returnFaces;
}

void makeHousingExtrusion(Hex a, Hex b, int i, Obj returnFaceA, Obj returnFaceB){
	Pt a1 = a.hex.get(i);
	Pt a2 = a.hex.get((i+1)%6);
	Pt b1 = b.hex.get(i);
	Pt b2 = b.hex.get((i+1)%6);
	Pt a1A = a.hex.get((6+i)%6);
	Pt a1B = a.hex.get((6+i-2)%6);
	Pt a2A = a.hex.get((6+i+1)%6);
	Pt a2B = a.hex.get((6+i+3)%6);
	Pt b1A = b.hex.get((6+i)%6);
	Pt b1B = b.hex.get((6+i-2)%6);
	Pt b2A = b.hex.get((6+i+1)%6);
	Pt b2B = b.hex.get((6+i+3)%6);
	
	Pt tea1 = Pt.create(a1A.x()+0.5*(a1A.x()-a1B.x()) , a1A.y()+0.5*(a1A.y()-a1B.y()) , a1A.z()+0.5*(a1A.z()-a1B.z()));
	Pt tea2 = Pt.create(a2A.x()+0.5*(a2A.x()-a2B.x()) , a2A.y()+0.5*(a2A.y()-a2B.y()) , a2A.z()+0.5*(a2A.z()-a2B.z()));
	Pt teb1 = Pt.create(b1A.x()+0.5*(b1A.x()-b1B.x()) , b1A.y()+0.5*(b1A.y()-b1B.y()) , b1A.z()+0.5*(b1A.z()-b1B.z()));
	Pt teb2 = Pt.create(b2A.x()+0.5*(b2A.x()-b2B.x()) , b2A.y()+0.5*(b2A.y()-b2B.y()) , b2A.z()+0.5*(b2A.z()-b2B.z()));
	
	Pt ea1 = Pt.create((4*tea1.x()+tea2.x()+teb1.x())/6.0,(4*tea1.y()+tea2.y()+teb1.y())/6.0,(4*tea1.z()+tea2.z()+teb1.z())/6.0);
	Pt ea2 = Pt.create((4*tea2.x()+tea1.x()+teb2.x())/6.0,(4*tea2.y()+tea1.y()+teb2.y())/6.0,(4*tea2.z()+tea1.z()+teb2.z())/6.0);
	Pt eb1 = Pt.create((4*teb1.x()+tea1.x()+teb2.x())/6.0,(4*teb1.y()+tea1.y()+teb2.y())/6.0,(4*teb1.z()+tea1.z()+teb2.z())/6.0);
	Pt eb2 = Pt.create((4*teb2.x()+tea2.x()+teb2.x())/6.0,(4*teb2.y()+tea2.y()+teb2.y())/6.0,(4*teb2.z()+tea2.z()+teb2.z())/6.0);
	
	
	Face myExtrudedFace = new Face();
	myExtrudedFace.add(ea1);
	myExtrudedFace.add(ea2);
	myExtrudedFace.add(eb2);
	myExtrudedFace.add(eb1);
	returnFaceA.add(myExtrudedFace);
	
	Face myJoiningFace1 = new Face();
	myJoiningFace1.add(a1);
	myJoiningFace1.add(a2);
	myJoiningFace1.add(ea2);
	myJoiningFace1.add(ea1);
	returnFaceB.add(myJoiningFace1);
	Face myJoiningFace2 = new Face();
	myJoiningFace2.add(a2);
	myJoiningFace2.add(b2);
	myJoiningFace2.add(eb2);
	myJoiningFace2.add(ea2);
	returnFaceB.add(myJoiningFace2);
	Face myJoiningFace3 = new Face();
	myJoiningFace3.add(b2);
	myJoiningFace3.add(b1);
	myJoiningFace3.add(eb1);
	myJoiningFace3.add(eb2);
	returnFaceB.add(myJoiningFace3);
	Face myJoiningFace4 = new Face();
	myJoiningFace4.add(b1);
	myJoiningFace4.add(a1);
	myJoiningFace4.add(ea1);
	myJoiningFace4.add(eb1);
	returnFaceB.add(myJoiningFace4);
}

Obj[] makeFacesToSmallerChildren(Hex base,Hex a,Hex b,Hex c){
	return makeFacesToSmallerChildren(base,a,b,c,false);
}
Obj[] makeFacesToSmallerChildren(Hex base,Hex a,Hex b,Hex c, boolean mirror){
	Obj[] returnFaces = new Obj[1];
	returnFaces[0] = new Obj();
	
	Hex[] n = new Hex[3];
	n[0] = a; n[1] = b; n[2] = c;
	
	
	//ceci génère le pts intermédiaire
	int start;
	if(!mirror){start = 1;}else{start = 2;}
	Pts intPts = new Pts();
	for(int i=0; i<3; i++){
		intPts.add(base.hex.getPt((i*2+start)%6));
		intPts.add(new PtMid(base.hex.getPt((i*2+start)%6),base.hex.getPt((i*2+1+start)%6)));
		intPts.add(new PtMid(base.hex.getPt((i*2+start)%6),base.hex.getPt((i*2+2+start)%6)));
		intPts.add(new PtMid(base.hex.getPt((i*2+1+start)%6),base.hex.getPt((i*2+2+start)%6)));
	}
	
	
	Pt intPtO = Pt.create(base.o);
	intPtO.translate(base.createScaledNormal(0.5));
	intPts.translate(base.createScaledNormal(0.5));
	
	//ceci gnères les polys de hex base au pts intermédiaire
	for(int i=0; i<12; i++){
			Face myFace = new Face();
			myFace.add(base.hex.get(start%6));
			myFace.add(intPts.get((i)%12));
			myFace.add(intPts.get((i+1)%12));	
			if((i)%4==0 || (i+1)%4==0){myFace.add(base.hex.get((start+1)%6));start++;}
			returnFaces[0].add(myFace);
		}

	
	
	
	
	//ceci génère les polys de pts intermédiaire vers les 3 hex
	Face myFace;
	
	
	
	for(int i=2; i>-1; i--){
		Pts othPts = n[i].oppositeHex().hex;
		
		int iS;
		int oS;
		int pS;
		if(!mirror){
			iS = (2+4*i)%12;
			oS = (10+4*i);
			pS = -1;
		}
		else{
			iS = (10-4*i)%12;
			oS = (6-2*i)%6;
			pS = 1;
		}
		
		myFace = new Face();
		myFace.add(intPts.get(iS%12));
		myFace.add(othPts.get((oS+pS*0)%6));
		myFace.add(othPts.get((oS+pS*1)%6));
		myFace.add(intPts.get((iS+1)%12));
		returnFaces[0].add(myFace);
		myFace = new Face();
		myFace.add(intPts.get((iS+1)%12));
		myFace.add(othPts.get((oS+pS*1)%6));
		myFace.add(othPts.get((oS+pS*2)%6));
		myFace.add(intPts.get((iS+2)%12));
		returnFaces[0].add(myFace);
		myFace = new Face();
		myFace.add(intPts.get((iS+2)%12));
		myFace.add(othPts.get((oS+pS*2)%6));
		myFace.add(othPts.get((oS+pS*3)%6));
		myFace.add(intPts.get((iS+3)%12));
		returnFaces[0].add(myFace);
		myFace = new Face();
		myFace.add(intPts.get((iS+3)%12));
		myFace.add(othPts.get((oS+pS*3)%6));
		myFace.add(othPts.get((oS+pS*4)%6));
		myFace.add(intPts.get((iS+4)%12));
		returnFaces[0].add(myFace);
		myFace = new Face();
		myFace.add(intPts.get((iS+4)%12));
		myFace.add(othPts.get((oS+pS*4)%6));
		myFace.add(othPts.get((oS+pS*5)%6));
		myFace.add(intPtO);
		returnFaces[0].add(myFace);
		myFace = new Face();
		myFace.add(intPtO);
		myFace.add(othPts.get((oS+pS*5)%6));
		myFace.add(othPts.get((oS+pS*0)%6));
		myFace.add(intPts.get((iS)%12));
		returnFaces[0].add(myFace);
	}
	
	return returnFaces;
}