/***********
 * DRAW
 ***********/
void draw(){
  background(255);
  if (onoff[0]) kaiTak.draw();

  if (onoff[1]){
    landpoints.draw();
    waterpoints.draw();    
  }

  if (onoff[2]){
    centerline.draw();
  }

  if (onoff[3]){
    circSliders.draw();
    circline1.stroke(0,255-cweight[0].toInt(),255);
    circline1.draw();
    circline2.stroke(0,255-cweight[1].toInt(),255);
    circline2.draw();
  }

  if (formfinderswitch) formfinder();

  if (onoff[4]){
    helpers.draw();
    formfinderForm.draw();
  }

  if (boneswitch) bonestructure();

  if (onoff[5]){
    bones.draw();
  }

  if (floorswitch) floors();

  if (onoff[6]){
    corefloor.draw();
  }

  if (petalfloorswitch) petalfloor.draw();

  if (facadeswitch) facade();

  if (onoff[7]){
    corefacade.draw();    
  }

  if (petalfacadeswitch) petalfacade.draw();

  if (onoff[8]){
    windows.draw();
    //windowglass.draw();
  }
  


  //////////////////////////////////////////////////////////////////
  //exporter
  if (record == true) {
    beginRaw(DXF, "output.dxf"); // Start recording to the file
    camera(0.0,0.1,0.0,0,0,0,0.0,0.0,-1.0);
    petalfloor.draw();
    corefloor.draw();
  }

  if (record == true) {
    endRaw();
    println("output.dxf exported");
    record = false; // Stop recording to the file
  }

  if(imRecord == true){
    saveFrame("tower####.tga"); 
    imRecord = false;
  }

}
