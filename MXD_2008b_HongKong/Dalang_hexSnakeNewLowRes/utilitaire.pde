void utilDrawGrid(){
	int gSize = 1000;
	int gStep = 100;
	
	stroke(0,0,0,50);
	for(int i=-gSize; i<=gSize; i+=gStep)
	{
		line(i,-gSize,0,i,gSize,0);
		line(-gSize,i,0,gSize,i,0);
	}
	stroke(0);
}
void utilDrawAxis(){
	stroke(255,0,0);
	
	line(myCamera.pX,myCamera.pY,myCamera.pZ,myCamera.pX+100,myCamera.pY,myCamera.pZ);

	stroke(0,255,0);
	line(myCamera.pX,myCamera.pY,myCamera.pZ,myCamera.pX,myCamera.pY+100,myCamera.pZ);

	stroke(0,0,255);
	line(myCamera.pX,myCamera.pY,myCamera.pZ,myCamera.pX,myCamera.pY,myCamera.pZ+100);
}