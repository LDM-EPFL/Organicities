
/*************** SIZE QUESTIONS ***************/
float baseSize(){
	return 3.0;
}
float baseSize(Hex m){
	int z = kaiTak.getZone(m);
	switch(z){
		case 0:
			return 15;				//8
		case 1:
			return 10;		//9	//6	//8
		case 2:
			return 6;		//10	//6
		case 3:
			return 6;		//10	//6
		default:
			return 3.0;
	}
}

/*************** AGGREGATION RULES ***************/
int getAggregationType(Hex m){
	int returnVal = 0;
	if(m.waiting > 0){
		returnVal = 0;
	}
	else{
		returnVal = 1;
		if(m.lastSplit>sepBetwSplits(m) && random(0,1)<0.2)
		{
			if(targetActiveTreads(m)>0 && m.r>2.0*baseSize(m)){
				returnVal = 2;
			}
		}
	}
	
	return returnVal;
}

int sepBetwSplits(Hex m){
	int z = kaiTak.getZone(m);
	switch(z){
		case 0:
			return 30 - 10 + myRandom.nextInt(20);
		case 1:
			return 15 - 3 + myRandom.nextInt(6);
		case 2:
			return 10 - 1 + myRandom.nextInt(2);
		case 3:
			return 10 - 1 + myRandom.nextInt(2);
		default:
			return 10 - 3 + myRandom.nextInt(6);
	}
}

int targetActiveTreads(Hex m){
	int z = kaiTak.getZone(m);
	switch(z){
		case 0:
			//print(activeHexesInZone[z]+" active hexes in zone 0, target : ");
			if(activeHexesInZone[z]<2){return +1;}
			else if(activeHexesInZone[z]>5){return -1;}
			else{return 0;}
		case 1:
			//print(activeHexesInZone[z]+" active hexes in zone 1, target : ");
			if(activeHexesInZone[z]<3){return +1;}		//16	//50
			else if(activeHexesInZone[z]>3){return -1;}	//8		//40
			else{return 0;}
		case 2:
			//print(activeHexesInZone[z]+" active hexes in zone 2, target : ");
			if(activeHexesInZone[z]<12){return +1;}		//15		//50
			else if(activeHexesInZone[z]>10){return -1;}	//10	//40
			else{return 0;}
		case 3:
			//print(activeHexesInZone[z]+" active hexes in zone 2, target : ");
			if(activeHexesInZone[z]<15){return +1;}		//15		//50
			else if(activeHexesInZone[z]>10){return -1;}	//10	//40
			else{return 0;}
		default:
		return 0;
		/*
		case 0:
			if(activeHexes.size()<2){return +1;}
			else if(activeHexes.size()>5){return -1;}
			else{return 0;}
		case 1:
			if(activeHexes.size()<5){return +1;}		//16	//50
			else if(activeHexes.size()>7){return -1;}	//8		//40
			else{return 0;}
		case 2:
			if(activeHexes.size()<50){return +1;}		//15
			else if(activeHexes.size()>40){return -1;}	//10
			else{return 0;}
		default:
		return 0;
		*/
	}
}

int targetHousingUnits(Hex m){
	int z = kaiTak.getZone(m);
	switch(z){
		case 0:
			return 0;
		case 1:
			return +1;
		case 2:
			return +1;
		case 3:
			return +1;
		default:
		return 0;
	}
}



/*************** SIZE RULES ***************/


/*************** FUNDAMENTAL RULES ***************/
boolean isAcceptable(Hex m){
	return isAcceptable(m.o);
}
boolean isAcceptable(Pt p){
	boolean retVal = true;
	if(!kaiTak.getWater(p)){
		retVal = false;
	}
	int z = kaiTak.getZone(p);
	if(z == 0 && activeHexes.size()>10 && aggregateCount>50){
		retVal = false;
	}
	if(p.z() < 0){
		retVal = false;
	}
	
	return retVal;
}
