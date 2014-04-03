float sideVsR(float ray){
	return 2.0*ray*sin(PI/6.0);
}
float hVsR(float ray){
	return 2.0*ray*cos(PI/6.0);
}
float sign(float n){
	if(n==0){
		return 0;
	}
	else if(n<0){
		return -1;
	}
	else if(n>0){
		return 1;
	}
	else{
		return 0;
	}
}
float sign(int n){
	return sign((float) n);
}
float sign(double n){
	return sign((float) n);
}
float distanceBetween(Pt a, Pt b){
	return sqrt( sq((float)(a.x()-b.x())) + sq((float)(a.y()-b.y())) + sq((float)(a.z()-b.z()))  );
}
Pt nullizeZ(Pt p){
	return Pt.create(p.x(), p.y(), 0);
}
float angleMid(float[] angles){
	
	float cos = 0;
	float sin = 0;
	
	int angleCount = angles.length;
	for(int i=0; i<angleCount; i++){
		float ang = angles[i];
		cos += cos(ang);
		sin += sin(ang);
	}
	
	//cos/=(float)angleCount;
	//sin/=(float)angleCount;
	
	float angle = atan(sin/cos);
	if(cos<0){angle += PI;}
	
	
	return (angle + TWO_PI)%TWO_PI;
}