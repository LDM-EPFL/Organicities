/***********
 * VOIDS
 ***********/
void present(){
  switch(presentation){

    //site image
  case 0: 
    onoff[0]=true;
    onoff[1]=false;
    onoff[2]=false;
    onoff[3]=false;
    onoff[4]=false;
    onoff[5]=false;
    onoff[6]=false;
    onoff[7]=false;
    onoff[8]=false;
    onoff[9]=false;
    println("presentation: 0");
    break;

    //controlpoints
  case 1: 
    pointer();
    onoff[0]=true;
    onoff[1]=true;
    onoff[2]=false;
    onoff[3]=false;
    onoff[4]=false;
    onoff[5]=false;
    onoff[6]=false;
    onoff[7]=false;
    onoff[8]=false;
    onoff[9]=false;
    println("presentation: 1");
    break;

    //centerline
  case 2:
    centerpoint();
    onoff[0]=true;
    onoff[1]=true;
    onoff[2]=true;
    onoff[3]=false;
    onoff[4]=false;
    onoff[5]=false;
    onoff[6]=false;
    onoff[7]=false;
    onoff[8]=false;
    onoff[9]=false;
    println("presentation: 2");
    break;

    //circulation lines
  case 3: 
    formfinderswitch = false;
    circulation();
    onoff[0]=true;
    onoff[1]=false;
    onoff[2]=true;
    onoff[3]=true;
    onoff[4]=false;
    onoff[5]=false;
    onoff[6]=false;
    onoff[7]=false;
    onoff[8]=false;
    onoff[9]=false;
    println("presentation: 3");
    break;

    //formfinder
  case 4: 
    formfinderswitch = true;
    boneswitch = false;
    formfinder();
    onoff[0]=true;
    onoff[1]=false;
    onoff[2]=true;
    onoff[3]=true;
    onoff[4]=true;
    onoff[5]=false;
    onoff[6]=false;
    onoff[7]=false;
    onoff[8]=false;
    onoff[9]=false;    
    println("presentation: 4");
    break;

    //bones
  case 5:
    formfinderswitch = true;
    boneswitch = true;
    bonestructure();
    onoff[0]=true;
    onoff[1]=false;
    onoff[2]=true;
    onoff[3]=true;
    onoff[4]=true;
    onoff[5]=true;
    onoff[6]=false;
    onoff[7]=false;
    onoff[8]=false;
    onoff[9]=false;
    petalfloorswitch=false;    
    println("presentation: 5");
    break;

    //floors
  case 6: 
    formfinderswitch = true;
    boneswitch = true;
    floorswitch = true;
    facadeswitch = false;
    floors();
    onoff[0]=true;
    onoff[1]=false;
    onoff[2]=true;
    onoff[3]=true;
    onoff[4]=true;
    onoff[5]=false;
    onoff[6]=true;
    onoff[7]=false;
    onoff[8]=false;
    onoff[9]=false;     
    petalfloorswitch=true;
    petalfacadeswitch=false;
    println("presentation: 6");
    break;

    //facade
  case 7:
    formfinderswitch = false;
    boneswitch = false;
    floorswitch = false;
    facadeswitch = false;
    facade();
    onoff[0]=true;
    onoff[1]=false;
    onoff[2]=true;
    onoff[3]=true;
    onoff[4]=true;
    onoff[5]=false;
    onoff[6]=true;
    onoff[7]=true;
    onoff[8]=false;
    onoff[9]=false;
    petalfloorswitch=true;
    petalfacadeswitch=true;
    println("presentation: 7");
    break;

    //windows
  case 8: 
    formfinderswitch = false;
    boneswitch = false;
    floorswitch = false;
    facadeswitch = false;
    windows();
    onoff[0]=true;
    onoff[1]=false;
    onoff[2]=true;
    onoff[3]=true;
    onoff[4]=true;
    onoff[5]=false;
    onoff[6]=true;
    onoff[7]=false;
    onoff[8]=true;
    onoff[9]=true;
    petalfloorswitch=true;
    petalfacadeswitch=false;
    println("presentation: 8");
    break;
  }
}
