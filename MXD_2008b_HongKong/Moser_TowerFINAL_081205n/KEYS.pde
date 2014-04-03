/***********
 * KEYS
 ***********/
void keyPressed() {
  //////////////////////////////////////////////////////////////////
  //presentation
  if (key==' '){
    if (presentation<8){
      presentation+=1;
      present();
    }
  }

  //image exchanger
  if (key=='a'){
    imageNum+=1;
    if (imageNum==3){
      imageNum=0;
    }
    general();
    println(imageNum);

    int now = presentation+1;
    for (int i=0;i<now;i++){
      presentation=i;
      present();
    }
  }

  if (key==CODED){
    if (keyCode==ALT){
      if (presentation>0){
        presentation-=1;
        present();
      }
    }

    if (keyCode==CONTROL){
      int now = presentation+1;
      for (int i=0;i<now;i++){
        presentation=i;
        present();
      }
      println("  (refresh)");
    }
  }

  //////////////////////////////////////////////////////////////////
  //ON/OFF switches
  //site image
  if (key=='q'){
    if (onoff[0])
      onoff[0]=false;
    else
      onoff[0]=true;
  }

  //controlpoints
  if (key=='w'){
    if (onoff[1])
      onoff[1]=false;
    else
      onoff[1]=true;
  }

  //centerline
  if (key=='e'){
    if (onoff[2])
      onoff[2]=false;
    else
      onoff[2]=true;
  }

  //circulation lines
  if (key=='r'){
    if (onoff[3])
      onoff[3]=false;
    else
      onoff[3]=true;
  }

  //formfinder
  if (key=='t'){
    if (onoff[4])
      onoff[4]=false;
    else
      onoff[4]=true;
  }

  //bonestructure
  if (key=='z'){
    if (onoff[5])
      onoff[5]=false;
    else
      onoff[5]=true;
  }

  //floors
  if (key=='u'){
    if (onoff[6])
      onoff[6]=false;
    else
      onoff[6]=true;
  }

  if (key=='j'){
    if (petalfloorswitch)
      petalfloorswitch=false;
    else
      petalfloorswitch=true;
  }  

  //skin
  if (key=='i'){
    if (onoff[7])
      onoff[7]=false;
    else
      onoff[7]=true;
  }

  if (key=='k'){
    if (petalfacadeswitch)
      petalfacadeswitch=false;
    else
      petalfacadeswitch=true;
  }

  //windows
  if (key=='o'){
    if (onoff[8])
      onoff[8]=false;
    else
      onoff[8]=true;
  }



  //////////////////////////////////////////////////////////////////
  //exporter
  if (key == '0') {
    imRecord = true;
    println("imageRecord: true");
  }

  if (key == '9') {
    record = true;
  }

  if(key=='8'){
    Autolisp.exportObj(bones,this);
    println("export autolisp: done");
  }

  if(key=='7'){
    objExport();
    println("export object: done");
  }
}
