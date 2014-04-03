/*
POUR UTILISER LA CAMERA

0/ ajouter Camera.pde dans le sketch folder

1/ d̩clarer la cam̩ra au d̩but du script :

	Camera myCamera;


2/ initialiser la cam̩ra dans le setup et enlever les reglages par d̩faut :
void setup()

	{
		...
		myCamera = new Camera();
		myScene.defaultScene = false;
		...
	}


3/ actualiser la cam̩ra dans draw, si on met un Obj comme argument, la cam̩ra va le cibler, sinon, elle cible l'origine :

	void draw()
	{
		...
		//myCamera.update(myObj);
		//ou
		myCamera.update();
		...
	}

*/


class Camera
{
	Pt targetPoint = Pt.create(0 , 0);;
	float distance = 200.0;
	
	float mX = 0.5;
	float mY = 0.5;
	
	Camera()
	{
		addMouseWheelListener(new java.awt.event.MouseWheelListener() { public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { mouseWheel(evt.getWheelRotation());}});
		
		update();
	}
	
	void targetObject(Obj obj)
	{
		try
		{
		targetPoint = new PtBaryRedux(new Pts(obj.boundingBox()));
		}
		catch(Exception e)
		{
			//boudingBox vide jette une exception !
		}
	}
	
	void update(Obj tgtObj)
	{
		targetObject(tgtObj);
		update();
	}
	
	void update()
	{
		if(mousePressed && (mouseButton == CENTER))
		{
			mX = (float)mouseX / (float)width;
			mY = (float)mouseY / (float)height;
		}
		
		float posX = mY * distance * cos(-mX * TWO_PI);
		float posY = mY * distance * sin(-mX * TWO_PI);
		float posZ = distance * cos(mY * HALF_PI);
	
		
		camera(posX,posY,posZ,(float)targetPoint.x(),(float)targetPoint.y(),(float)targetPoint.z(), 0,0,-1.0);
	}

	void zoom(float z)
	{
		distance *= 1+z/100.0;
	}
	
	void mouseWheel(int delta)
	{
	 // myCamera.zoom((float)delta); 
	}
}

