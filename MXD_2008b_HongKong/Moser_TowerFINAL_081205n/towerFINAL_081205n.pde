/*
NEW flower tower
 
 
 the petal system that is divided in the following stages:
 
 centerfiner: system that finds the center of a specific site
 formfinder: system that finds a form, adapted to site and circulation paths and their importance
 bones: calculation of the backbone of the final tower shape
 floors: calculation of floorshapes
 facade: calculation of facadepanels
 windows: calculation of windowopenings of each facadepanel
 
 
 ///////////
 KEYS
 ///////////
 
 PRESENTATION
 SPACE:   advances presentation
 ALT:     goes back in presentation
 CTRL:    refresh
 
 q:       image ON/OFF
 a:       IMAGE EXCHANGER
 w:       grid dots ON/OFF
 e:       center line ON/OFF
 r:       circulation lines ON/OFF
 t:       formfinder axes&form ON/OFF
 z:       bone structure ON/OFF
 u:       corefloors ON/OFF
 j:       petalfloors ON/OFF
 i:       coreskin ON/OFF
 k:       petalskin ON/OFF

 
 EXPORTER
 7:       .obj export
 8:       .lsp export
 9:       .dxf export
 0:       .tga export
 
 */



/***********
 * IMPORT
 ***********/
import oog.*;
import processing.opengl.*;
import processing.dxf.*;

KaiTak kaiTak;
Oog myScene;


/***********
 * SETUP
 ***********/
void setup() {
  size(900, 700, OPENGL);
  myScene = new Oog(this);
  //hint(ENABLE_OPENGL_4X_SMOOTH);
  Scene.drawAxis = true;
  //oog.Line.globalRender = new RenderPtsAll();

  general();
  present();
}



//////////////////////////////////////////////////////////////////
//GENERAL
//////////////////////////////////////////////////////////////////
void general() {
  kaiTak = new KaiTak(-200,-200);

  /////////////////////
  //sliders
  crot1 = new Param(21*PI/18,0,2*PI,"circrotation1");
  crot2 = new Param(PI/4,0,2*PI,"circrotation2");

  cweight[0] = new Param(0,0,255,"circweight1");
  cweight[1] = new Param(255,0,255,"circweight2");
}



/***********
 * DEFINITIONS
 ***********/
//////////////////////////////////////////////////////////////////
//ON/OFF switches
boolean onoff[] = new boolean[10];
int presentation = 0;
int imageNum = 0;

//////////////////////////////////////////////////////////////////
//helping objects
//1
Obj landpoints;
Obj waterpoints;

//2
Pt center;
Pt center2;
Pts centerline;
Pts circline;

//3
Pts circline1;
Pts circline2;

//4
Obj helpers;
Obj initialForm;
Pts formfinderForm;
boolean formfinderswitch = false;
float refang;
int refnum;

Param crot1;
Param crot2;
Param cweight[] = new Param[2];

//5
Obj bones;
boolean boneswitch = false;

//////////////////////////////////////////////////////////////////
//polygones
//6
Obj petalfloor;
Obj corefloor;
boolean floorswitch = false;
boolean petalfloorswitch = false;
int sub = 2; //subdivision threshold

//7
Group petalfacade;
Group corefacade;
boolean facadeswitch = false;
boolean petalfacadeswitch = false;

//8
Obj windows;
Obj windowglass;



//////////////////////////////////////////////////////////////////
//sliders
Param zero = new Param(0);
Param one = new Param(1);

Sliders circSliders;


//////////////////////////////////////////////////////////////////
//exporter
boolean record = false;
boolean imRecord = false;


void objExport(){
  if (presentation==8){
    ObjExporter.exportObj(corefloor,"corefloor");
    ObjExporter.exportObj(petalfloor,"petalfloor");
    ObjExporter.exportObj(corefacade,"corefacade");
    ObjExporter.exportObj(petalfacade,"petalfacade");

    int j=0;
    Obj windows1 = new Obj();
    for (int i=0;i<windows.numOfFaces();i++){

      windows1.add(windows.face(i));
      j++;
      if (j==2000){
        ObjExporter.exportObj(windows1,"windows"+i);
        windows1 = new Obj();
        j=0;
      }
    }
    ObjExporter.exportObj(windows1,"windows"+" last");
  }
}
