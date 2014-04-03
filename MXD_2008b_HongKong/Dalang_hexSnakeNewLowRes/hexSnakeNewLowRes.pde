//imports
import processing.opengl.*;
import oog.*;
import processing.dxf.*;
//import gifAnimation.*;

//functionnal declarations
Camera myCamera;
KaiTak kaiTak;
Oog myScene;
Random myRandom;

//exporting declarations
//GifMaker gifExport;
int exportMode = 1;	//0: none, 1: dxf, 2: gif, 3: obj
boolean gifExporting = false;


//main declarations
ArrayList sleepingHexes;
ArrayList activeHexes;
int aggregateCount;
int autoAggregate = 25;		//1 -> one by one; 2 -> two by two, etc..
int[] activeHexesInZone = new int[4];

/*************** SETUP ***************/
void setup(){
	if(exportMode == 2){size(400,400,OPENGL); }
	else{size(800,800,OPENGL); }
	hint(ENABLE_OPENGL_4X_SMOOTH);
	
	myCamera = new Camera();
	kaiTak = new KaiTak(-50,-50);
	myScene = new Oog(this); Face.globalRender = new RenderFaceDefault(new OogColor(255), new OogColor(0));
	myRandom = new Random();
	
	if(exportMode == 2){
		//gifExport = new GifMaker(this, "output/animation.gif");
		//gifExport.setRepeat(0);
	}
	
	reset();
}

void reset(){
	println("");println("");println("");println("");println("* * * * * * * * * * * *");println("");println("");println("");println("");
	sleepingHexes = new ArrayList();
	activeHexes = new ArrayList();
	aggregateCount = 0;
	
	// PLACED ON ROADS
	activeHexes.add(new Hex(Pt.create(500,0,20),		-1*PI/8.0		,	0,	20));
	activeHexes.add(new Hex(Pt.create(0,210,20),		-2*PI/8.0		,	0,	20));
	//activeHexes.add(new Hex(Pt.create(700,200,20),		 4*PI/8.0		,	0,	20));
	
	/*// UNION SAMPLE
	Hex a1 = new Hex(Pt.create(225,0,20),		-0*PI/8.0		,	0,	20);
	Hex a2 = new Hex(Pt.create(225,0,60),		-0*PI/8.0		,	0,	20);
	Hex a3 = new Hex(Pt.create(275,0,35),		-0*PI/8.0		,	0,	20);
	Hex b0 = new Hex(Pt.create(250,40,35),		-0*PI/8.0		,	0,	400);
	Hex b1 = b0.oppositeHex();
	activeHexes.add(a1);
	activeHexes.add(a2);
	activeHexes.add(a3);
	activeHexes.add(b1);
	b1.faces = makeFacesToSmallerChildren(b1,a1,a2,a3,true);*/
	
	/*//TARGET SAMPLE
	Hex a1 = new Hex(Pt.create(0,0,100),	-PI/4.0	,	0,	random(10,100));
	Hex a2 = new Hex(Pt.create(800,800,100),	PI	,	0,	random(10,100));
	a1.target = a2;
	a2.goToSleep = true;
	activeHexes.add(a1);
	activeHexes.add(a2);*/
	/*
	//UNION TRY
	Hex a1 = new Hex(Pt.create(random(0,400),0,40),		-0*PI/8.0		,	0,	20);
	Hex a2 = new Hex(Pt.create(random(0,400),0,40),		-0*PI/8.0		,	0,	20);
	Hex a3 = new Hex(Pt.create(random(0,400),0,40),		-0*PI/8.0		,	0,	20);
	addActiveHex(a1);
	addActiveHex(a2);
	addActiveHex(a3);*/
}


/*************** DRAW ***************/
void draw(){
	myCamera.update(); kaiTak.draw();
	drawHexes();
	
	if(exportMode == 2 && gifExporting){
		//gifExport.setDelay(2);
		//gifExport.addFrame();
		
		aggregate();
	}
	else if(aggregateCount % autoAggregate != 0 && !keyPressed){
		aggregate();
	}
}
void drawHexes(){
	drawHexes(0);
}
void drawHexes(int mode){
	stroke(255,0,0);
	int sleepingHexesSize = sleepingHexes.size();
	for(int i=0; i<sleepingHexesSize; i++){
		Hex curHex = (Hex)sleepingHexes.get(i);
		curHex.draw(mode);
	}
	
	stroke(0,0,0);
	int activeHexesSize = activeHexes.size();
	for(int i=0; i<activeHexesSize; i++){
		Hex curHex = (Hex)activeHexes.get(i);
		if(curHex != null){
			curHex.draw(mode);
		}
	}
}


/*************** AGGREGATE ***************/
void aggregate(){
	aggregateCount++;
	
	
	activeHexesInZone[0] = 0; activeHexesInZone[1] = 0; activeHexesInZone[2] = 0; activeHexesInZone[3] = 0;
	
	
	
	println("aggregation "+aggregateCount);
	int sleeping = 0;
	for(int i=0; i<activeHexes.size(); i++){
		Hex curHex = (Hex)activeHexes.get(i);
		if(curHex != null){
			if(curHex.goToSleep){
				goToSleep(curHex); i--; sleeping++;
			}
			else{
				int z = kaiTak.getZone(curHex);
				if(z == -1){ println("ZONE ERROR AT PT : "+curHex.o);}
				else{activeHexesInZone[z]++;}
			}
		}
	}
	
	//set targets !
	int activeHexesSize = activeHexes.size();
	ArrayList hexesAbleToJoin = new ArrayList();
	for(int i=0; i<activeHexesSize; i++){
		Hex curHex = (Hex)activeHexes.get(i);
		if(curHex != null){
			if(curHex.target == null){
				hexesAbleToJoin.add(curHex);
			}
		}
	}
	unionMaker(hexesAbleToJoin);
	
	for(int i=0; i<activeHexesSize; i++){
		Hex curHex = (Hex)activeHexes.get(i);
		if(curHex != null){
			curHex.aggregate();
		}
	}
}



void addActiveHex(Hex m){
	activeHexes.add(m);
}

void goToSleep(Hex m){
	int activeIndex = activeHexes.indexOf(m);
	activeHexes.remove(activeIndex);
	sleepingHexes.add(m);
}
