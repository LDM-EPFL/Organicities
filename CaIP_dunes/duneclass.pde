//Class ProtoDune

//      Dune initilisation.
//      1.variable definitions of protodune 
//        Pdx, Pdy, Pda, Pdb, Pdz,Pdo,(Anarpts) position x,y on the site grid
//      2.making faces from the pts, Pdx, Pdy, Pda, Pdb, Pdz
//      3.get the angle alpha(Pdy,Pdb), beta (Pdy,Pda)
//      4.make a grid around the dune according to Pdx,Pdy,Pda,Pdb,Pdz
//        Pda(x value), Pdb(x value)= grid length
//        Pdx(y value),Pdy(y value) =grid heigth
//        min(x value, min y value)= starting point of the grid.
//      5. Set the different type of dunes and their size
//          Barchan
//          Linear
//          Star
//        

//      Dune actions

//        Actions on the site grid

//        1.0 get the wind vector sg from the siteGrid
//        1.1 move Pdx,Pdy,Pda,Pdb according to the wind vector sg
//        1.2 for the surrounding squares of the ProtoDune change the wind vectors sg
//        1.3 move?

//        Actions between Dunes
//        2.0 chek if there is overlapping dune_grid 
//        2.1 Compare size
//        2.1.a if a bigger than b then a eat b
//        2.1.b if a = b change gridwindvector by resultant vectors 
//        
//        



class ProtoDune {
  // variables of the Pdune
  float cox,coy,coz;//position of the Dune
  float Pdx, Pdy, Pda, Pdb, Pdz;//length of the Dune
  //wind from grid
  int windFgrid;
  float beta, gamma,xeta,yeta;
  float brad= radians(beta);

  float grad= radians(gamma);

  float xrad= radians(xeta);

  float yrad= radians(yeta);

  Pt Dunex;//x value

  Pt Duney;//y value

  Pt Dunez;//z value
  Pt Dunea;//a value

  Pt Duneb;//b value

  Pt ctr=Anar.Pt(cox,coy,coz);

  PVector ax= new PVector(cox,Pdx,0);

  PVector Dx= new PVector((cos(radians(xrad-90))*Pdx),(sin(radians(xrad-90))*Pdx),0);
  PVector Dy= new PVector((cos(radians(yrad+90))*Pdy),(sin(radians(yrad+90))*Pdy),0);
  PVector Dz= new PVector(0,0,+Pdz);
  PVector Da= new PVector(-(cos(radians(brad-90))*Pda),(-sin(radians(brad-90))*Pda),0);
  PVector Db= new PVector((cos(radians(grad-90))*Pdb),(sin(radians(grad-90))*Pdb),0);

  Pts CCenter;
  Pts circles;

  //  constructor_1Barchan
  ProtoDune(float xpos, float ypos, float zpos,   float x,float angxeta,   float b,float anggamma,    float y,float angyeta,   float a,float angbeta,   float z   ) {


    //Pts Pctr= Pts(cox,coy,coz);
    cox= xpos;
    coy= ypos;
    coz= zpos;

    Pdx=x;
    Pdy=y;
    Pdz=z;
    Pda=a;
    Pdb=b;

    brad=angbeta;
    grad=anggamma;
    xrad=angxeta;
    yrad=angyeta;
    
    Pt ctr; //centerpoint
    ctr=Anar.Pt(cox,coy,coz);

    Dunex= Anar.Pt(ctr.x()+Dx.x,ctr.y()+Dx.y,ctr.z());
    Duney= Anar.Pt(ctr.x()+Dy.x,ctr.y()+Dy.y,ctr.z());
    Dunez= Anar.Pt(ctr.x(),ctr.y(),ctr.z()+Dz.z);
    Duneb= Anar.Pt(ctr.x()+Da.x,ctr.y()+Da.y,ctr.z()+Da.z);
    Dunea= Anar.Pt(ctr.x()+Db.x,ctr.y()+Db.y,ctr.z()+Db.z);
  }
  // ProtoDune(int Pdx,int Pdy,int Pda,int Pdb,int Pdz,int Pdo,int SiteX,int SiteY);

  // constructor2linear

  //
  // Actions

  //drawing faces
  void drawFaces() {

    PVector ax= new PVector(cox,Pdx,0);

    PVector Dx= new PVector((cos(radians(xrad-90))*Pdx),(sin(radians(xrad-90))*Pdx),0);
    PVector Dy= new PVector((cos(radians(yrad+90))*Pdy),(sin(radians(yrad+90))*Pdy),0);
    //SCALE z-DIRECTION *3
    PVector Dz= new PVector(0,0,3*Pdz);
    PVector Da= new PVector(-(cos(radians(brad-90))*Pda),(-sin(radians(brad-90))*Pda),0);
    PVector Db= new PVector((cos(radians(grad-90))*Pdb),(sin(radians(grad-90))*Pdb),0);

    Pt ctr; //centerpoint
    ctr=Anar.Pt(cox,coy,coz);


    Dunex.set(ctr.x()+Dx.x,ctr.y()+Dx.y,ctr.z());
    Duney.set(ctr.x()+Dy.x,ctr.y()+Dy.y,ctr.z());
    Dunez.set(ctr.x(),ctr.y(),ctr.z()+Dz.z);
    Duneb.set(ctr.x()+Da.x,ctr.y()+Da.y,ctr.z()+Da.z);
    Dunea.set(ctr.x()+Db.x,ctr.y()+Db.y,ctr.z()+Db.z);
    //Dunex.set(ctr.x()+Dx.x,coy,coz);


    //Faces
    Face ayz = new Face(Dunea, Duney, Dunez).fill(250,250,50,50);
    Face byz = new Face(Duneb, Duney, Dunez).fill(250,250,50,50);
    Face bxz = new Face(Duneb, Dunex, Dunez).fill(180,140,0,50);
    Face axz = new Face(Dunea, Dunex, Dunez).fill(180,140,0,50);


    ayz.draw();
    axz.draw();
    bxz.draw();
    byz.draw();
  }

  //change windvec around the dune


  void Deform(PVector windtemp) {
    float  Windde = atan2(windtemp.x,windtemp.y);
    float Winddeg= degrees(Windde);
    //println(Winddeg);
    //conditions
    float sclDeform=4;
    float angDeform=1.25;
    if (windtemp.mag()>5){ angDeform=2; }
    if(Winddeg>157.7 && Winddeg <= 180) {

      //  xrad    +=(atan((windtemp.x/windtemp.y)))*10;
      grad    +=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      // yrad    -=(atan((windtemp.x/windtemp.y)))*10;
      brad    -=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;

      Pdx-=sclDeform* (mag(windtemp.x,windtemp.y)/50);
    }


    if(Winddeg>-180 && Winddeg <= -157.5) {

      //  xrad    +=(atan((windtemp.x/windtemp.y)))*10;
      grad    -=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      // yrad    -=(atan((windtemp.x/windtemp.y)))*10;
      brad    +=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;

      Pdx-=sclDeform* (mag(windtemp.x,windtemp.y)/50);
    }



    else if( Winddeg<= -112.5 && Winddeg > -157.5 ) {

      //xrad    +=(atan((windtemp.x/windtemp.y)))*5;
      grad    -=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      yrad    +=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      // brad    -=(atan((windtemp.x/windtemp.y)))*10;

      Pdb+=sclDeform* (mag(windtemp.x,windtemp.y)/50);
      Pdy+=sclDeform* (mag(windtemp.x,windtemp.y)/50);
    }


    else if( Winddeg<= -67.5 && Winddeg > -112.5  ) {

      xrad    +=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      // grad    +=(atan((windtemp.x/windtemp.y)))*10;
      yrad    -=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      // brad    -=(atan((windtemp.x/windtemp.y)))*10;

      Pda-=sclDeform* (mag(windtemp.x,windtemp.y)/50);
    }


    else if( Winddeg<= -22.5 && Winddeg > -67.5 ) {

      xrad    +=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      grad    -=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      // yrad    -=(atan((windtemp.x/windtemp.y)))*10;
      //  brad    -=(atan((windtemp.x/windtemp.y)))*10;

      Pdx+=sclDeform* (mag(windtemp.x,windtemp.y)/50);
      Pdb+=sclDeform* (mag(windtemp.x,windtemp.y)/50);
    }


    else if( Winddeg>=-22.5 && Winddeg<=22.5  ) {

      //xrad    +=(atan((windtemp.x/windtemp.y)))*10;
     grad    +=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      //yrad    -=(atan((windtemp.x/windtemp.y)))*10;
      brad    -=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;

      Pdy-=sclDeform* (mag(windtemp.x,windtemp.y)/50);
    }


    else if(  Winddeg> 22.5 && Winddeg < 67.5) {

      xrad    +=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      // grad    +=(atan((windtemp.x/windtemp.y)))*10;
      //yrad    -=(atan((windtemp.x/windtemp.y)))*10;
      brad    -=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;

      Pdx+=sclDeform* (mag(windtemp.x,windtemp.y)/50);
      Pda+=sclDeform* (mag(windtemp.x,windtemp.y)/50);
    }


    else if( Winddeg> 67.5 && Winddeg <= 112.5) {
      xrad    +=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      //  grad    +=(atan((windtemp.x/windtemp.y)))*10;
      yrad    -=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      // brad    -=(atan((windtemp.x/windtemp.y)))*10;

      Pdb-=sclDeform* (mag(windtemp.x,windtemp.y)/50);
    }


    else if(  Winddeg> 112.5 && Winddeg <= 157.5 ) {

      //  xrad    +=(atan((windtemp.x/windtemp.y)))*10;
      //  grad    +=(atan((windtemp.x/windtemp.y)))*10;
      yrad    +=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;
      brad    -=angDeform* (atan((windtemp.x/windtemp.y)))*0.8;

      Pdy+=sclDeform* (mag(windtemp.x,windtemp.y)/50);
      Pda+=sclDeform* (mag(windtemp.x,windtemp.y)/50);
    }
  }
}










//changing the windvectors

