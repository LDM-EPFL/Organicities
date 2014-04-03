class Camera
{
	float pX = 0.0;
	float pY = 0.0;
	float pZ = 0.0;
	
	float distance = 200.0;
	
	float mX = -PI/2.0;
	float mY = 2.5/2.0*PI;
	boolean draggingRot = false;
	float smX = 0;
	float smY = 0;
	
	boolean draggingPan = false;
	float spX = 0;
	float spY = 0;
	
	boolean autoMode = false;
	
	
	Camera()
	{
		addMouseWheelListener(new java.awt.event.MouseWheelListener() { public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { mouseWheel(evt.getWheelRotation());}});
		
		update();
	}
	
	void autoMode(){
		autoMode = !autoMode;
	}
	
	void autoUpdate(){
		int n=0; float x = 0; float y = 0; float z = 0;
		int activeHexesSize = activeHexes.size();
		for(int i=0; i<activeHexesSize; i++){
			Hex curHex = (Hex)activeHexes.get(i);
			if(curHex != null){
				x+=curHex.o.x();
				y+=curHex.o.y();
				z+=curHex.o.z();
				n++;
			}
		}
		if(n>0){
		pX = x/n;
		pY = y/n;
		pZ = z/n;}
	}
	
	
	void update()
	{
		if(autoMode){
			autoUpdate();
		}
		
		if(draggingRot)
		{
			/*
			mX = smX + 2*(float)mouseX-smX / (float)width;
			mY = smY + 2*(float)mouseY-smY / (float)height;
			*/
			
				mX =  smX - (mouseX)/(float)width*TWO_PI;
				mY =  smY - (mouseY)/(float)height*TWO_PI;
		}
		
		if(draggingPan){
			pX = spX - mouseX;
			pY = spY - mouseY;
		}
		
		
		Pt myPt = Pt.create(distance, 0, 0);
		Transform myTrans = new Transform();
		myTrans.rotateY(mY);
		myTrans.rotateZ(mX);
		myTrans.translate(pX, pY, pZ);
		myPt.apply(myTrans);
		
		/*
		float posX = pX + mY * distance * cos(-mX * TWO_PI);
		float posY = pY + mY * distance * sin(-mX * TWO_PI);
		float posZ = pZ + distance * cos(mY * HALF_PI);
	*/	
		float posX = (float)myPt.x();
		float posY = (float)myPt.y();
		float posZ = (float)myPt.z();
		
		camera(posX,posY,posZ,pX,pY,pZ, 0,0,-1.0);
	}

	void zoom(float z)
	{
		distance *= 1+z/100.0;
	}
	
	void mouseWheel(int delta)
	{
	  myCamera.zoom((float)delta); 
	}
	
	void mousePressed(){
		if(mouseButton == LEFT && draggingPan == false){draggingPan = true; spX = pX + mouseX; spY = pY + mouseY;}
		if(mouseButton == RIGHT && draggingRot == false){draggingRot = true; smX = mX + (mouseX)/(float)width*TWO_PI; smY = mY + (mouseY)/(float)height*TWO_PI;}
		
	}
	void mouseReleased(){draggingRot = false;draggingPan = false;}
}

