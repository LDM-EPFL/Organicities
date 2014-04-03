import processing.dxf.*;
boolean record;


//import gifAnimation.*;
//GifMaker gifExport;
boolean begin=false;
import processing.opengl.*;
import anar.*;

Obj allCirc= new Obj();

//       Dune_prototype
//          setup dune class, cf tab Class_dune
//          Place Dune on the site grid
//          site grid
//            1.Make a grid (siteGrid)
//            2.Add a vector direction on all square of the grid depending on wind directions from data
//              each frame will be one line of the data.
//            3.Place Dunes on the site
//            4. move the Dune according to the z value on the sitegrid
//               if the dunes move off the grid, delete the dune.
//            5. replace windvectors of the former position of the dune


int ct=22;
//variable for vector grid
int xCt=40;
int yCt=40;
int Grdspces=20;

Pt[][] grdpt = new Pt[xCt][yCt];
PVector [][] windtemp= new PVector[xCt][yCt];

Pt[][] grdCpt= new Pt[xCt][yCt];
int DuneCt=28;

      //Declaring object dune

        ProtoDune Pd[]= new ProtoDune[DuneCt];
   

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void setup() {
  size(1024,768,OPENGL,P3D);
  Anar.init(this);
  smooth();
  //gifExport = new GifMaker(this, "export.gif");
  //gifExport.setRepeat(0);
 
  
  //BPd[0] = new BIGProtoDune(290,140,0,  50,30, 280,30, 70,-40,190,70,10);

  // load Dunes Array
  //                 xpos,ypos,zpos x,ax   ,a,aa,  y,ya  ,b,ba,    z
/*  Pd[0] = new ProtoDune(50,100,0  ,20,30,  35,40,  20,30,  20,120  ,3);
   Pd[1] = new ProtoDune(210,200,0,30,0,30,90,30,0,30,90,4); 
  //Pd[1] = new ProtoDune(900,300,0,30,0,30,90,30,0,30,90,4); 
  Pd[2] = new ProtoDune(340,350,0,60,0,70,90,70,0,90,90,8);
  ////////////
  ///DUNE SITE//
 */  
  //Y150
  Pd[0] = new ProtoDune(550,120,0  ,20,0,  3,90,  20,10,  40,80  ,7);
  Pd[1] = new ProtoDune(355,150,0  ,20,-10,  35,80,  20,0,  20,60  ,6);
  Pd[2] = new ProtoDune(470,180,0  ,15,-10  ,30,90,  30,-15  ,25,120,6); 

  //Y200
  Pd[3] = new ProtoDune(330,200,0  ,30,-60  ,40,120,  20,-30,  30,60,5); 
  
  Pd[4] = new ProtoDune(410,230,0  ,25,-30,  40,60,  30,-60,  60,70,6); 
  
  Pd[5] = new ProtoDune(450,240,0,  10,-5  ,14,20,  18,-45  ,15,40,3); 
  Pd[6] = new ProtoDune(470,260,0,  10,-5  ,20,90,  10,0,    10,90,3); 
  
  Pd[7] = new ProtoDune(550,200,0,  22,-20  ,30,70,  25,-20,  30,40,5); 
  
  Pd[8] = new ProtoDune(550,255,0,  20,-10,  65,90,  25,5,  50,90,8); 
  
  //Y250

  Pd[9] = new ProtoDune(240,270,0,  30,0,  40,70,  30,30,  50,60,5); 
  Pd[10] = new ProtoDune(330,270,0,  40,-30  ,50,20,  30,-55,  40,80,7); 
  Pd[11] = new ProtoDune(420,280,0,  20,-45  ,20,50,  24,-45  ,20,50,6); 
  Pd[12] = new ProtoDune(570,295,0,  20,0,  50,35,  25,-20  ,55,80,7); 
  
  
  //Y300
 
  Pd[13] = new ProtoDune(140,320,0  ,15,-50,  25,30,  16,-5,  25,70,4); 
  Pd[14] = new ProtoDune(150,345,0,  20,-50  ,13,45,  18,-60,  10,40,3); 
  Pd[15] = new ProtoDune(240,335,0,  15,-45  ,26,30,  27,-20,  30,75,5); 
  Pd[16] = new ProtoDune(370,310,0,  10,0,    30,90,  16,10,  30,90,4); 
  Pd[17] = new ProtoDune(460,340,0,  25,-5,  17,85,  27,-60,  35,80,8); 
  
  //Y350
  Pd[18] = new ProtoDune(540,370,0    ,23,-30,  18,30,  35,-60,  20,85,6); 
  Pd[19] = new ProtoDune(605,365,0,  18,-30,  30,50,  18,-20,  20,40,4); 
  
  //Y400
  Pd[20] = new ProtoDune(490,400,0,  18,0,  30,90,  20,10  ,25,80,5); 
  Pd[21] = new ProtoDune(160,410,0,  35,-10  ,50,55  ,40,-5  ,50,60,10); 
  //450
  Pd[22] = new ProtoDune(390,490,0,  40,20,  50,92,  55,50,  85,85, 10);
  Pd[23] = new ProtoDune(630,440,0,  50,45,  80,135,  30,60  ,90,110,7);
  Pd[24] = new ProtoDune(320,455,0,  24,-10  ,30,50,  15,-20  ,35,40,5);
  //500
   Pd[25] = new ProtoDune(580,510,0,  10,0,  50,90,  15,-5,  55,90,5);
   Pd[26] = new ProtoDune(470,530,0,  18,-7,  20,90,  20,-10,  15,90,4); 
   Pd[27] = new ProtoDune(230,530,0,  10,-10,  20,80,  17,0,  20,90,4);
    // Pd[23] = new ProtoDune(340,350,0,60,0,70,90,70,0,90,90,8);
   //Y450
  
   
  
  //loading grid

  for(int i=0;i<xCt;i++) {
    for(int j=0;j<yCt;j++) {
      //load corner
      grdpt[i][j]= Anar.Pt(i*Grdspces,j*Grdspces,0);
      //load center
      grdCpt[i][j]= Anar.Pt(((i*Grdspces)+(Grdspces/2)), ((j*Grdspces)+(Grdspces/2)),0);
    }
  }
}


/////////////////////////////////////
//dxf_Export
//void keyPressed() {
//  // use a key press so that it doesn't make a million files
//  if (key == 'r') record = true;
//}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


void draw() {
    smooth();
  background(255,200);
  //frameRate(5);
 //camera(300, 300, 300, 100, 100, 1, 1, 1, 0.5); 

  camera(400.0, 700.0, 400.0,     400.0, 450.0, 50.0,     0.0, 1.0, 0.0);
 
  if (frameCount>=50){

   strokeWeight(1);
   for (int i=0; i<allCirc.numOfFaces(); i++){
    allCirc.getFace(i).translate(0,0,-.5); 
   }
   allCirc.draw();
   
  if (record) {
    beginRaw(DXF, "output1.dxf");
  }
  
  
  //SITELINES//
  
  //////////////////////////////////////////////////////////////////////////////////////////
  
  //loading winddata
  String[] txtfile = loadStrings("wind_data_y_27.txt");
  println("*******");
  println(frameCount);
  String [] vals = splitTokens(txtfile[ct], ", ");
  println(vals);
  float a    = float(vals[0]);//data line counter
  float ws   = float(vals[1]);// windspeed
  float ang  = float(vals[2]+36.4711);//angle degree
  float wang = radians (ang);//angle radiant
//
PVector windini = new PVector (cos(wang)*ws,sin(wang)*2*ws,0); 
// PVector windini = new PVector (1,-10,0);
  // println(wang);          
  ct++;

  //////////////////////////////////////////////////////////////////////////////////////////
////LOOP i j 
  ////////////////////////////////////////////////////////////////////////////////////////
  for(int i=0;i<xCt;i++) {
    for(int j=0;j<yCt;j++) {
          ///////////
        ///loading winddata
        //////////  

        windtemp[i][j] = new PVector (cos(wang)*2*ws,sin(wang)*2*ws,0);  

      //  windtemp[i][j] = new PVector (1,-10,0);  
        //drawgrid
        //corner
       // grdpt[i][j].draw();
        //center

      
        
        
   //////////////////////////////////////////////////////////////////////////////////////////
////LOOP k 
  ////////////////////////////////////////////////////////////////////////////////////////
        
      for (int k=0;k<DuneCt;k++) {
  //  println(Pd[k].Dunea.x());

        //Position on the grid

        int xCell= floor(Pd[k].cox/Grdspces);
        int yCell= floor(Pd[k].coy/Grdspces);
        int PaCell= floor(abs(Pd[k].Dunea.x()-Pd[k].cox)/Grdspces+1);
        int PbCell= floor(abs(Pd[k].Duneb.x()-Pd[k].cox)/Grdspces+1);
        int PxCell= floor(abs(Pd[k].Dunex.x()-Pd[k].cox)/Grdspces+1);
        int PyCell= floor(abs(Pd[k].Duney.y()-Pd[k].coy)/Grdspces+1);
        int PzCell= floor(Pd[k].Pdz/Grdspces);
        //CenterPt of the Dunes
        Pt Dctr= Anar.Pt(Pd[k].cox,Pd[k].coy,Pd[k].coz);
        //println(PbCell);
      
        
        //Angle of wind direction
        float  Windde = atan2(windini.x,windini.y);
        float Winddeg= degrees(Windde);
         
      // println( Winddeg);
        

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // Wind deformation around the Dune according to Wind direction
  // Possibility to put it in a class
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  
        //Condition 1:
        //wind direction north
        if(Winddeg>157.7 && Winddeg <= 180) {
          for(int q=0;q<=PaCell;q++) {
            for(int w=0;w<=PxCell+3;w++) {
                    //  println(PaCell);
              windtemp[xCell+q][yCell-w]= new PVector (0.1,0.1,0);  
                  windtemp[xCell-q][yCell-w].limit(ws);
        }}
                  
              for(int e=0;e<=PbCell;e++) {
                for(int r=1;r<=PyCell;r++) {

                  //  println(w);
                  windtemp[xCell-e][yCell+r]= new PVector (-(Pd[k].Duney.x()-+Pd[k].Duneb.x()),(Pd[k].Duneb.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell-e][yCell+r].limit(ws);

                  
               
                }}
                for(int e=0;e<=PbCell;e++) {
                for(int w=0;w<=PxCell+3;w++) {
                   windtemp[xCell-e][yCell-w]= new PVector (0.1,0.1,0);  
                   windtemp[xCell-e][yCell-w].limit(ws);
                }}
                  
                for(int q=0;q<=PaCell;q++) {
                for(int r=1;r<=PyCell;r++) {
                 // windtemp[xCell+q][yCell+r]= new PVector(00,0,0) ;                 
                  windtemp[xCell+q][yCell+r]= new PVector ((Pd[k].Dunea.x()-Pd[k].Duney.x()),(Pd[k].Dunea.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell+q][yCell+r].limit(ws);
               }
              }
            }
         
      
      
          
  ////////////////////////////////////////////
        //condition 2
        //wind direction NNE
        else if(  Winddeg> 112.5 && Winddeg <= 157.5 ) {
                    for(int q=0;q<=PaCell;q++) {
                    for(int w=0;w<=PxCell+3;w++) {
                    //  println(PaCell);
                  windtemp[xCell+q][yCell-w]= new PVector (0.1,0.1,0);  
                  windtemp[xCell-q][yCell-w].limit(ws);
              }}
                  
              for(int e=0;e<=PbCell;e++) {
                for(int r=1;r<=PyCell;r++) {
                  //  println(w);
                  windtemp[xCell-e][yCell+r]= new PVector ((Pd[k].Duney.x()-Pd[k].Duneb.x()),-(Pd[k].Duneb.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell-e][yCell+r].limit(ws); 
                }}
                
                for(int e=0;e<=PbCell;e++) {
                for(int w=0;w<=PxCell+3;w++) {
                   windtemp[xCell-e][yCell-w]= new PVector ((Pd[k].Dunex.x()-Pd[k].Duneb.x()),(Pd[k].Dunex.y()-Pd[k].Duneb.y()),0);  
                   windtemp[xCell-e][yCell-w].limit(ws);
                }}
                  
                for(int q=0;q<=PaCell;q++) {
                for(int r=1;r<=PyCell;r++) {
                 // windtemp[xCell+q][yCell+r]= new PVector(00,0,0) ;                 
                  windtemp[xCell+q][yCell+r]= new PVector ((Pd[k].Dunea.x()-Pd[k].Duney.x()),(Pd[k].Dunea.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell+q][yCell+r].limit(ws);
               }}
         
        }
    ////////////////////////////////////////////
        //condition 3
        //windir E
        else if( Winddeg> 67.5 && Winddeg <= 112.5) {
                              for(int q=0;q<=PaCell;q++) {
                    for(int w=0;w<=PxCell+3;w++) {
                   //   println(PaCell);
              windtemp[xCell+q][yCell-w]= new PVector (0.1,0.1,0);  
                  windtemp[xCell-q][yCell-w].limit(ws);
        }}
                  
              for(int e=0;e<=PbCell;e++) {
                for(int r=1;r<=PyCell;r++) {

                  //  println(w);
                  windtemp[xCell-e][yCell+r]= new PVector ((Pd[k].Duney.x()-Pd[k].Duneb.x()),-(Pd[k].Duneb.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell-e][yCell+r].limit(ws);

                  
               
                }}
                for(int e=0;e<=PbCell;e++) {
                for(int w=0;w<=PxCell+3;w++) {
                   windtemp[xCell-e][yCell-w]= new PVector ((Pd[k].Dunex.x()-Pd[k].Duneb.x()),(Pd[k].Dunex.y()-Pd[k].Duneb.y()),0);  
                   windtemp[xCell-e][yCell-w].limit(ws);
                }}
                  
                for(int q=0;q<=PaCell;q++) {
                for(int r=1;r<=PyCell;r++) {
                 windtemp[xCell+q][yCell+r]= new PVector(0.1,0.1,0) ;                 
                 // windtemp[xCell+q][yCell+r]= new PVector ((Pd[k].Dunea.x()-Pd[k].Duney.x()),(Pd[k].Dunea.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell+q][yCell+r].limit(ws);
               }
              }

        }
  ////////////////////////////////////////////        
        //condition 4
        //windir 
        else if(  Winddeg> 22.5 && Winddeg < 67.5) {
                         for(int q=0;q<=PaCell;q++) {
                    for(int w=0;w<=PxCell+3;w++) {
                   //   println(PaCell);
              windtemp[xCell+q][yCell-w]= new PVector (-(Pd[k].Dunex.x()-Pd[k].Dunea.x()),-(Pd[k].Dunex.y()-Pd[k].Dunea.y()),0);   
                  windtemp[xCell+q][yCell-w].limit(ws);
        }}
                  
              for(int e=0;e<=PbCell;e++) {
                for(int r=1;r<=PyCell;r++) {

                  //  println(w);
                  windtemp[xCell-e][yCell+r]= new PVector(0.1,0.1,0);
                 // windtemp[xCell-e][yCell+r]= new PVector ((Pd[k].Duney.x()-Pd[k].Duneb.x()),-(Pd[k].Duneb.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell-e][yCell+r].limit(ws);

                  
               
                }}
                for(int e=0;e<=PbCell;e++) {
                for(int w=0;w<=PxCell+3;w++) {
                   windtemp[xCell-e][yCell-w]= new PVector (-(Pd[k].Dunex.x()-Pd[k].Duneb.x()),-(Pd[k].Dunex.y()-Pd[k].Duneb.y()),0);  
                   windtemp[xCell-e][yCell-w].limit(ws);
                }}
                  
                for(int q=0;q<=PaCell;q++) {
                for(int r=1;r<=PyCell;r++) {
                   windtemp[xCell+q][yCell+r]= new PVector(0.1,0.1,0);
                 //windtemp[xCell+q][yCell+r]= new PVector ((Pd[k].Dunex.x()-Pd[k].Dunea.x()),(Pd[k].Dunex.y()-Pd[k].Dunea.y()),0);                 
                 
                  windtemp[xCell+q][yCell+r].limit(ws);
               }
              }

        }
  ////////////////////////////////////////////        
        //condition5
        else if( Winddeg>=-22.5 && Winddeg<=22.5  ) {
                                   for(int q=0;q<=PaCell;q++) {
                    for(int w=0;w<=PxCell+3;w++) {
                
                windtemp[xCell+q][yCell-w]= new PVector (-(Pd[k].Dunex.x()-Pd[k].Dunea.x()),-(Pd[k].Dunex.y()-Pd[k].Dunea.y()),0);   
                windtemp[xCell+q][yCell-w].limit(ws);
        }}
                  
              for(int e=0;e<=PbCell;e++) {
                for(int r=1;r<=PyCell;r++) {

                  //  println(w);
                  windtemp[xCell-e][yCell+r]= new PVector(0.1,0.1,0);
                 // windtemp[xCell-e][yCell+r]= new PVector ((Pd[k].Duney.x()-Pd[k].Duneb.x()),-(Pd[k].Duneb.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell-e][yCell+r].limit(ws);

                  
               
                }}
                for(int e=0;e<=PbCell;e++) {
                for(int w=0;w<=PxCell+3;w++) {
                   windtemp[xCell-e][yCell-w]= new PVector (-(Pd[k].Dunex.x()-Pd[k].Duneb.x()),-(Pd[k].Dunex.y()-Pd[k].Duneb.y()),0);  
                   windtemp[xCell-e][yCell-w].limit(ws);
                }}
                  
                for(int q=0;q<=PaCell;q++) {
                for(int r=1;r<=PyCell;r++) {
                   windtemp[xCell+q][yCell+r]= new PVector(0.1,0.1,0);
                 //windtemp[xCell+q][yCell+r]= new PVector ((Pd[k].Dunex.x()-Pd[k].Dunea.x()),(Pd[k].Dunex.y()-Pd[k].Dunea.y()),0);                 
                 
                  windtemp[xCell+q][yCell+r].limit(ws);
               }
              }
        }
  ////////////////////////////////////////////        
        //condition 6
        else if( Winddeg<= -22.5 && Winddeg > -67.5 ) {
                                 for(int q=0;q<=PaCell;q++) {
                    for(int w=0;w<=PxCell+3;w++) {
                      
              windtemp[xCell+q][yCell-w]= new PVector (-(Pd[k].Dunex.x()-Pd[k].Dunea.x()),-(Pd[k].Dunex.y()-Pd[k].Dunea.y()),0);   
                  windtemp[xCell+q][yCell-w].limit(ws);
        }}
                  
              for(int e=0;e<=PbCell;e++) {
                for(int r=1;r<=PyCell;r++) {

                  //  println(w);
                  windtemp[xCell-e][yCell+r]= new PVector(0.1,0.1,0);
                 // windtemp[xCell-e][yCell+r]= new PVector ((Pd[k].Duney.x()-Pd[k].Duneb.x()),-(Pd[k].Duneb.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell-e][yCell+r].limit(ws);

                  
               
                }}
                for(int e=0;e<=PbCell;e++) {
                for(int w=0;w<=PxCell+3;w++) {
                   windtemp[xCell-e][yCell-w]= new PVector (-(Pd[k].Dunex.x()-Pd[k].Duneb.x()),-(Pd[k].Dunex.y()-Pd[k].Duneb.y()),0);  
                   windtemp[xCell-e][yCell-w].limit(ws);
                }}
                  
                for(int q=0;q<=PaCell;q++) {
                for(int r=1;r<=PyCell;r++) {
                   windtemp[xCell+q][yCell+r]= new PVector(0.1,0.1,0);
                 //windtemp[xCell+q][yCell+r]= new PVector ((Pd[k].Dunex.x()-Pd[k].Dunea.x()),(Pd[k].Dunex.y()-Pd[k].Dunea.y()),0);                 
                 
                  windtemp[xCell+q][yCell+r].limit(ws);
               }
              }
        }    
 ////////////////////////////////////////////
        //condition 7
        else if( Winddeg<= -67.5 && Winddeg > -112.5  ) {
                     for(int q=0;q<=PaCell;q++) {
                    for(int w=0;w<=PxCell+3;w++) {
                     
              windtemp[xCell+q][yCell-w]= new PVector ((Pd[k].Dunex.x()-Pd[k].Dunea.x()),(Pd[k].Dunex.y()-Pd[k].Dunea.y()),0);   
                  windtemp[xCell+q][yCell-w].limit(ws);
        }}
                  
              for(int e=0;e<=PbCell;e++) {
                for(int r=1;r<=PyCell;r++) {

                  //  println(w);
                  windtemp[xCell-e][yCell+r]= new PVector(0.1,0.1,0);
                 // windtemp[xCell-e][yCell+r]= new PVector ((Pd[k].Duney.x()-Pd[k].Duneb.x()),-(Pd[k].Duneb.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell-e][yCell+r].limit(ws);

                  
               
                }}
                for(int e=0;e<=PbCell;e++) {
                for(int w=0;w<=PxCell+3;w++) {
                  windtemp[xCell-e][yCell-w]= new PVector (0.1,0.1,0);
                  // windtemp[xCell-e][yCell-w]= new PVector (-(Pd[k].Dunex.x()-Pd[k].Duneb.x()),-(Pd[k].Dunex.y()-Pd[k].Duneb.y()),0);  
                   windtemp[xCell-e][yCell-w].limit(ws);
                }}
                  
                for(int q=0;q<=PaCell;q++) {
                for(int r=1;r<=PyCell;r++) {
                  // windtemp[xCell+q][yCell+r]= new PVector(0,0,0);
                 windtemp[xCell+q][yCell+r]= new PVector ((Pd[k].Dunex.x()-Pd[k].Dunea.x()),-(Pd[k].Dunex.y()-Pd[k].Dunea.y()),0);                 
                 
                  windtemp[xCell+q][yCell+r].limit(ws);
               }
              }
        }  
   ////////////////////////////////////////////  
        //condition 8
        else if( Winddeg<= -112.5 && Winddeg > -157.5 ) {
          for(int q=0;q<=PaCell;q++) {
                    for(int w=0;w<=PxCell+3;w++) {
                    
              windtemp[xCell+q][yCell-w]= new PVector ((Pd[k].Dunex.x()-Pd[k].Dunea.x()),(Pd[k].Dunex.y()-Pd[k].Dunea.y()),0);   
                  windtemp[xCell+q][yCell-w].limit(ws);
        }}
                  
              for(int e=0;e<=PbCell;e++) {
                for(int r=1;r<=PyCell;r++) {

                  //  println(w);
                  windtemp[xCell-e][yCell+r]= new PVector(0.1,0.1,0);
                 // windtemp[xCell-e][yCell+r]= new PVector ((Pd[k].Duney.x()-Pd[k].Duneb.x()),-(Pd[k].Duneb.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell-e][yCell+r].limit(ws);

                  
               
                }}
                for(int e=0;e<=PbCell;e++) {
                for(int w=0;w<=PxCell+3;w++) {
                  windtemp[xCell-e][yCell-w]= new PVector (0.1,0.1,0);
                  // windtemp[xCell-e][yCell-w]= new PVector (-(Pd[k].Dunex.x()-Pd[k].Duneb.x()),-(Pd[k].Dunex.y()-Pd[k].Duneb.y()),0);  
                   windtemp[xCell-e][yCell-w].limit(ws);
                }}
                  
                for(int q=0;q<=PaCell;q++) {
                for(int r=1;r<=PyCell;r++) {
                  // windtemp[xCell+q][yCell+r]= new PVector(0,0,0);
                 windtemp[xCell+q][yCell+r]= new PVector ((Pd[k].Dunex.x()-Pd[k].Dunea.x()),-(Pd[k].Dunex.y()-Pd[k].Dunea.y()),0);                 
                 
                  windtemp[xCell+q][yCell+r].limit(ws);
               }
              }
        }
  ////////////////////////////////////////////
        //condition 9
        else if(Winddeg>-180 && Winddeg <= -157.5) {
             for(int q=0;q<=PaCell;q++) {
            for(int w=0;w<=PxCell+3;w++) {
                      
              windtemp[xCell+q][yCell-w]= new PVector (0.1,0.1,0);  
                  windtemp[xCell-q][yCell-w].limit(ws);
        }}
                  
              for(int e=0;e<=PbCell;e++) {
                for(int r=1;r<=PyCell;r++) {

                  //  println(w);
                  windtemp[xCell-e][yCell+r]= new PVector (-(Pd[k].Duney.x()-+Pd[k].Duneb.x()),(Pd[k].Duneb.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell-e][yCell+r].limit(ws);

                  
               
                }}
                for(int e=0;e<=PbCell;e++) {
                for(int w=0;w<=PxCell+3;w++) {
                   windtemp[xCell-e][yCell-w]= new PVector (0.1,0.1,0);  
                   windtemp[xCell-e][yCell-w].limit(ws);
                }}
                  
                for(int q=0;q<=PaCell;q++) {
                for(int r=1;r<=PyCell;r++) {
                 // windtemp[xCell+q][yCell+r]= new PVector(00,0,0) ;                 
                  windtemp[xCell+q][yCell+r]= new PVector ((Pd[k].Dunea.x()-Pd[k].Duney.x()),(Pd[k].Dunea.y()-Pd[k].Duney.y()),0);  
                  windtemp[xCell+q][yCell+r].limit(ws);
               }
              }
        }
   ////////////////////////////////////////////
  
 //////////////////////////////////////////////////////////////////////////////////////////
 

        
        
        
        
        
        
        
        
        
      }
      
      ///ENDLOOPK///////  
        //////////////////////////////////////////// 
        //windlines
        //if(i==25){ println ("- " + windtemp[i][j].mag() +"  "+ws);} 
        float delta =abs((windtemp[i][j].mag()/2) -ws);
        noStroke();
        //if (delta>1){new Circle(Anar.Pt(grdCpt[i][j].x(), grdCpt[i][j].y(), grdCpt[i][j].z()-.5),  ws*1.5).fill(200-(30*delta),200-(14*delta),200, 30).draw() ;}
        if (delta>1){new Circle(Anar.Pt(grdCpt[i][j].x(), grdCpt[i][j].y(), grdCpt[i][j].z()-.5),  ws*1.5).fill(220,180,0, 50).draw() ;}
        //stroke(120-(30*delta),120-(14*delta),200, 150+(30*delta));
        stroke(180,180-(25*delta),180-(50*delta), 150+(30*delta));
        strokeWeight(1); 
        
        line(grdCpt[i][j].x(), grdCpt[i][j].y(),
        
        grdCpt[i][j].x()+((windtemp[i][j].x)*windtemp[i][j].mag()/6),
        grdCpt[i][j].y()+((windtemp[i][j].y)*windtemp[i][j].mag()/6));

        
        
                //?????
        grdCpt[i][j].fill(150);
        grdCpt[i][j].draw();//draw center for vectors
            stroke(180,120,50);
    
    }
    

    
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //Dune mvt deformation
 //////////////////////////////////////////// 
 println ("---- " + windini.mag() +"  "+ws);
    float sclMvt=1.5;
    if (windini.mag()>5){sclMvt=3;}
    for (int k=0;k<DuneCt;k++) {
    int xCell= floor(Pd[k].cox/Grdspces);
    int yCell= floor(Pd[k].coy/Grdspces);

    //move the dune according to wind directions


        float  Windde = atan2(windini.x,windini.y);
        float Winddeg= degrees(Windde);
       
                // println (Winddeg);
         if(Winddeg>157.7 && Winddeg <= 180) {
            Pd[k].cox+= sclMvt* ((windtemp[xCell][yCell+floor(Pd[k].Pdy/Grdspces)+2].x)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.1));
            Pd[k].coy+= sclMvt* ((windtemp[xCell][yCell+floor(Pd[k].Pdy/Grdspces)+2].y)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.1));
            
             Pd[k].Deform(windtemp[xCell][yCell+floor(Pd[k].Pdy/Grdspces)+2]);
            
     //println(windtemp[xCell][yCell+2].x);
         
         }
        else if(  Winddeg> 112.5 && Winddeg <= 157.5 ) {
            //MVT
            Pd[k].cox+= sclMvt* ((windtemp[xCell-(floor((Pd[k].Pdb/Grdspces)/2))+1][yCell+(floor(Pd[k].Pdy/Grdspces/2))+1].x)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
            Pd[k].coy+= sclMvt* ((windtemp[xCell-(floor((Pd[k].Pdb/Grdspces)/2))+1][yCell+(floor(Pd[k].Pdy/Grdspces/2))+1].y)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
            //DEF
             Pd[k].Deform(windtemp[xCell-(floor(Pd[k].Pdb/Grdspces)/2)][yCell+(floor(Pd[k].Pdy/Grdspces/2))+1]);
          }
          else if( Winddeg> 67.5 && Winddeg <= 112.5) {
            //MVT
           Pd[k].cox+= sclMvt* ((windtemp[xCell-floor(Pd[k].Pdb/Grdspces)+1][yCell].x)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.1));
            Pd[k].coy+= sclMvt* ((windtemp[xCell-floor(Pd[k].Pdb/Grdspces)+1][yCell].y)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
            
            Pd[k].Deform(windtemp[xCell-floor(Pd[k].Pdb/Grdspces)+1][yCell]);
          }
          else if(  Winddeg> 22.5 && Winddeg < 67.5) {
            //MVT
            Pd[k].cox+= sclMvt* ((windtemp[xCell-(floor((Pd[k].Pdb/Grdspces)/2))+1][yCell-(floor(Pd[k].Pdx/Grdspces/2))+1].x)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
            Pd[k].coy+= sclMvt* ((windtemp[xCell-(floor((Pd[k].Pdb/Grdspces)/2))+1][yCell-(floor(Pd[k].Pdx/Grdspces/2))+1].y)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
            //DEF
             Pd[k].Deform(windtemp[xCell-(floor((Pd[k].Pdb/Grdspces)/2))+1][yCell-(floor(Pd[k].Pdx/Grdspces/2))+1]);
          }
          else if( Winddeg>=-22.5 && Winddeg<=22.5  ) {
            //MVT
            Pd[k].cox+= sclMvt* ((windtemp[xCell][yCell-(floor(Pd[k].Pdx/Grdspces))+1].x)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
            Pd[k].coy+= sclMvt* ((windtemp[xCell][yCell-(floor(Pd[k].Pdx/Grdspces))+1].y)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
            //DEF
            Pd[k].Deform(windtemp[xCell][yCell-(floor(Pd[k].Pdx/Grdspces))+1]);
           
          }
          else if( Winddeg<= -22.5 && Winddeg > -67.5 ) {
            //MVT
            Pd[k].cox+= sclMvt* ( (windtemp [xCell- (floor((Pd[k].Pda/Grdspces)/2)) +1] [yCell- (floor(Pd[k].Pdx/Grdspces/2)) +1].x) /((Pd[k].Pdz)*(Pd[k].Pdz)*0.33) );
            Pd[k].coy+= sclMvt* ( (windtemp [xCell- (floor((Pd[k].Pda/Grdspces)/2)) +1] [yCell- (floor(Pd[k].Pdx/Grdspces/2)) +1].y) /((Pd[k].Pdz)*(Pd[k].Pdz)*0.33) );
            //DEF
            Pd[k].Deform(windtemp[xCell-(floor((Pd[k].Pda/Grdspces)/2))+1][yCell-(floor(Pd[k].Pdx/Grdspces/2))+1]);
          }
          else if( Winddeg<= -67.5 && Winddeg > -112.5  ) {
            //MVT
              Pd[k].cox+= sclMvt* ((windtemp[xCell-floor(Pd[k].Pda/Grdspces)+1][yCell].x)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
            Pd[k].coy+= sclMvt* ((windtemp[xCell-floor(Pd[k].Pda/Grdspces)+1][yCell].y)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
            //DEF
            Pd[k].Deform(windtemp[xCell-floor(Pd[k].Pda/Grdspces)+1][yCell]);
          }
          else if( Winddeg<= -112.5 && Winddeg > -157.5 ) {
            //MVT
              Pd[k].cox+= sclMvt* ((windtemp[xCell-(floor((Pd[k].Pda/Grdspces)/2))+1][yCell+(floor(Pd[k].Pdx/Grdspces/2))+1].x)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
            Pd[k].coy+= sclMvt* ((windtemp[xCell-(floor((Pd[k].Pda/Grdspces)/2))+1][yCell+(floor(Pd[k].Pdx/Grdspces/2))+1].y)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
            //DEF
          // Pd[k].Deform(windtemp[xCell+(floor((Pd[k].Pda/Grdspces)/2))+1][yCell+(floor(Pd[k].Pdx/Grdspces/2))+1]);
          }
          else if(Winddeg>-180 && Winddeg <= -157.5) {
            //MVT
                 Pd[k].cox+= sclMvt* ((windtemp[xCell][yCell+floor(Pd[k].Pdy/Grdspces)+2].x)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
                 Pd[k].coy+= sclMvt* ((windtemp[xCell][yCell+floor(Pd[k].Pdy/Grdspces)+2].y)/((Pd[k].Pdz)*(Pd[k].Pdz)*0.33));
           //DEF 
             Pd[k].Deform(windtemp[xCell][yCell+floor(Pd[k].Pdy/Grdspces)+2]);
          }
    

 
 //////////////////////////////////////////// 



     //Deform the Dune
  // println(windtemp[xCell][yCell+3]);
 //////////////////////////////////////////// 
  
    Pd[k].drawFaces();
    
    noFill();
    stroke(180,120,50);
    //strokeWeight(2);
   if(Pd[k].Pda>Pd[k].Pdb && Pd[k].Pda>Pd[k].Pdx && Pd[k].Pda>Pd[k].Pdy ){
     ellipse (Pd[k].cox,Pd[k].coy,Pd[k].Pda*2+(Pd[k].Pdz/3*5),Pd[k].Pda*2+(Pd[k].Pdz/3*5));
     Circle c=new Circle (Anar.Pt(Pd[k].cox,Pd[k].coy,-.5), .5* (Pd[k].Pda*2+(Pd[k].Pdz/3*5)));
     Pts edgeC = new Pts(c).stroke(200,100);
     allCirc.add(edgeC);
     //allCirc.add(new Circle (Anar.Pt(Pd[k].cox,Pd[k].coy,0), .5* (Pd[k].Pda*2+(Pd[k].Pdz/3*5))).fill(200,100));
   }
   else    if(Pd[k].Pdb>Pd[k].Pda && Pd[k].Pdb>Pd[k].Pdx && Pd[k].Pdb>Pd[k].Pdy ){
     ellipse (Pd[k].cox,Pd[k].coy,Pd[k].Pdb*2+(Pd[k].Pdz/3*5),Pd[k].Pdb*2+(Pd[k].Pdz/3*5));
     Circle c=new Circle (Anar.Pt(Pd[k].cox,Pd[k].coy,-.5), .5* (Pd[k].Pdb*2+(Pd[k].Pdz/3*5)));
     Pts edgeC = new Pts(c).stroke(200,100);
     allCirc.add(edgeC);
     //allCirc.add(new Circle (Anar.Pt(Pd[k].cox,Pd[k].coy,0), .5* (Pd[k].Pdb*2+(Pd[k].Pdz/3*5))).fill(200,100));
   }
   else   if(Pd[k].Pdx>Pd[k].Pda && Pd[k].Pdx>Pd[k].Pdb && Pd[k].Pdx>Pd[k].Pdy ){
     ellipse (Pd[k].cox,Pd[k].coy,Pd[k].Pdx,Pd[k].Pdx); 
     Circle c=new Circle (Anar.Pt(Pd[k].cox,Pd[k].coy,-.5), .5* (Pd[k].Pdx));
     Pts edgeC = new Pts(c).stroke(200,100);
     allCirc.add(edgeC);
     //allCirc.add(new Circle (Anar.Pt(Pd[k].cox,Pd[k].coy,0), .5* (Pd[k].Pdx)).fill(200,100));
   }
   else if  (Pd[k].Pdy>Pd[k].Pda && Pd[k].Pdy>Pd[k].Pdb && Pd[k].Pdy>Pd[k].Pdx ){
     ellipse (Pd[k].cox,Pd[k].coy,Pd[k].Pdy*2+(Pd[k].Pdz/3*5),Pd[k].Pdy*2+(Pd[k].Pdz/3*5));
     
     Circle c=new Circle (Anar.Pt(Pd[k].cox,Pd[k].coy,-.5),.5* (Pd[k].Pdy*2+(Pd[k].Pdz/3*5)));
     Pts edgeC = new Pts(c).stroke(200,100);
     allCirc.add(edgeC);
     //allCirc.add(new Circle (Anar.Pt(Pd[k].cox,Pd[k].coy,0),.5* (Pd[k].Pdy*2+(Pd[k].Pdz/3*5))).fill(200,100));
   }
    strokeWeight(1);
///////////////////





Pt Dctr= Anar.Pt(Pd[k].cox,Pd[k].coy,Pd[k].coz);
int Dct1=0;
        int Dct2=0;
        float minDist=150;
    for (int l=0;l<DuneCt;l++){
     Pt D2ctr= Anar.Pt(Pd[l].cox,Pd[l].coy,Pd[l].coz);
        
     
      if(k != l){
       
       
        float ChkDist= Dctr.length(D2ctr);
        //println(ChkDist);
        
        if(ChkDist<minDist){
        minDist=   ChkDist;     
         Dct1=k;
      Dct2=l;
    
     //line(Pd[k].cox,Pd[k].coy,Pd[Dct2].cox,Pd[Dct2].coy);
   
    
     
     
     
        
        }
;
    
     
      }
    }
 /////////////////////////////////////////////////////////   
     
  }

    
 
  /////////////
  
//////////////////////
 saveFrame("dune_Simulation"+(frameCount-50)+".jpg");
  /*gifExport.setDelay(1);
  if(begin==true)
    gifExport.addFrame();
    
    
    
     if (record) {
    endRaw();
    record = false;
  }
  */  
  } else {print(".");}
    
}




   


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void keyPressed() {
  if (key == ' ') save("screenShot.jpg");
  if (key == 'p') noLoop();
  if (key == 's') loop();
  if (key == 'q') begin=true;
 // if (key == 'w') gifExport.finish();
}



void setDelay(int ms) {

  ms=1000;
}


