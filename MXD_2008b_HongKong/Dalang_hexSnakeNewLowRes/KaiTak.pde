class KaiTak{
	PImage water, base, zones, direct;
	PImage sWater, sBase, sZones, sDirect;
	
	
	PImage hkwater, hkbase, hkzones, hkdirect;
	PImage hksWater, hksBase, hksZones, hksDirect;
	PImage dubwater, dubbase, dubzones, dubdirect;
	PImage dubsWater, dubsBase, dubsZones, dubsDirect;
	float dx, dy;
	int drawMode;
	
	boolean dubai = false;
	
	KaiTak(){
		drawMode = 0;
		hkwater=loadImage("w.jpg");
		hkbase=loadImage("b.jpg");
		hkzones=loadImage("z.jpg");
		hkdirect=loadImage("d.jpg");
		hksWater=loadImage("SMALLw.jpg");
		hksBase=loadImage("SMALLb.jpg");
		hksZones=loadImage("SMALLz.jpg");
		hksDirect=loadImage("SMALLd.jpg");
		
		
		
		dubwater=loadImage("dubw.jpg");
		dubbase=loadImage("dubb.jpg");
		dubzones=loadImage("dubz.jpg");
		dubdirect=loadImage("dubd.jpg");
		dubsWater=loadImage("dubSMALLw.jpg");
		dubsBase=loadImage("dubSMALLb.jpg");
		dubsZones=loadImage("dubSMALLz.jpg");
		dubsDirect=loadImage("dubSMALLd.jpg");
		
		dubai = true;
		change();
		dx = -water.width/2.0;
		dy = -water.height/2.0;
	}
	KaiTak(float sdx, float sdy){
		this();
		dx = sdx;
		dy = sdy;
	}
	
	void change(){
		dubai = !dubai;
		
		if(!dubai){
			
			water=hkwater;
			base=hkbase;
			zones=hkzones;
			direct=hkdirect;
			sWater=hksWater;
			sBase=hksBase;
			sZones=hksZones;
			sDirect=hksDirect;
		}
		else{
			water=dubwater;
			base=dubbase;
			zones=dubzones;
			direct=dubdirect;
			sWater=dubsWater;
			sBase=dubsBase;
			sZones=dubsZones;
			sDirect=dubsDirect;
		}
	}
	
	void draw(){
		fill(255);
		background(255);
		if(!gifExporting){
			utilDrawGrid();
			utilDrawAxis();
		}
		
			if(drawMode%5 == 1){image(sBase,dx,dy,2500,2500);}
			if(drawMode%5 == 2){image(sWater,dx,dy,2500,2500);}
			if(drawMode%5 == 3){image(sZones,dx,dy,2500,2500);}
			if(drawMode%5 == 4){image(sDirect,dx,dy,2500,2500);}
		
		
		
	}
	
	void drawMode(){
		drawMode++;
	}
	
	boolean getInside(float x, float y){
			x = x -dx;
			y = y -dy;
			if(x < 0 || y < 0 || x > water.width || y > water.height){
				return false;
			}
			else{
				return true;
			}
	}
	boolean getWater(Hex m){
		return getWater(m.o);
	}
	boolean getWater(Pt p){
		return getWater((float)p.x(),(float)p.y());
	}
	boolean getWater(float x, float y){
		x = x -dx;
		y = y -dy;
		if(x < 0 || y < 0 || x > water.width || y > water.height){
			return false;
		}
		else{
			color c = water.get((int)x,(int)y);
			if( brightness(c) < 125){
				return false;
			}
			else{
				return true;
			}
		}
	}
	
	int getZone(Pt p){
		return getZone(p.x(), p.y());
	}
	int getZone(Hex m){
		return getZone(m.o.x(), m.o.y());
	}
	int getZone(double x, double y){
		return getZone((float)x, (float)y);
	}
	int getZone(float x, float y){
		int rVal;
		x = x -dx;
		y = y -dy;
		
		color c = zones.get((int)x,(int)y);
		if( abs(0 - hue(c)) < 30 || abs(0 - hue(c)) > 225){
			rVal = 0;
		}
		else if( abs(255/4 - hue(c)) < 30){
			rVal = 1;
		}
		else if( abs(2*255/4 - hue(c)) < 30){
			rVal = 2;
		}
		else if( abs(3*255/4 - hue(c)) < 30){
			rVal = 3;
		}
		else{
			rVal = -1;
		}
		return rVal;
	}
	float getDirection(Pt p){
		return getDirection((float)p.x(),(float)p.y());
	}
	float getDirection(double x, double y){
		return getDirection((float)x, (float)y);
	}
	float getDirection(float x, float y){
		x = x -dx;
		y = y -dy;
		
		color c = direct.get((int)x,(int)y);
		return norm(brightness(c),0,255);
	}
	
	void transfer(float sdx, float sdy){
		dx = sdx;
		dy = sdy;
	}
}