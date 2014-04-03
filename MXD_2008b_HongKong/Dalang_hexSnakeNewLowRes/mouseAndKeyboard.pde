/*************** KEYBOARD ***************/
void keyPressed(){
	if(key==' '){aggregate();}
	if(key=='r'){reset();}
	if(key=='d'){kaiTak.drawMode();}
	if(key=='c'){kaiTak.change();}
	if(key=='a'){myCamera.autoMode();}
	if(key=='e'){
		println("Starting export...");
		if(exportMode == 1){
			camera(1000,0,0,0,0,0,0,-1,0);
			beginRaw(DXF, "output/outputA.dxf");
			drawHexes(1);
			kaiTak.draw();
			endRaw();
			println("33% ...");
			beginRaw(DXF, "output/outputB.dxf");
			drawHexes(2);
			kaiTak.draw();
			endRaw();
			println("66% ...");
			beginRaw(DXF, "output/outputC.dxf");
			drawHexes(3);
			kaiTak.draw();
			endRaw();
			println("100%");
			println("Export successfull");
			//exit();
		}
		else if(exportMode == 2){
			if(!gifExporting){
				gifExporting = true;
				println("START GIF EXPORT !");
			}
			else{
			//	gifExport.finish();
				exit();
			}
		}
		else if(exportMode == 3){
			/*
			Group exportGroup = new Group();
			
			int sleepingHexesSize = sleepingHexes.size();
			for(int i=0; i<sleepingHexesSize; i++){
				Hex curHex = (Hex)sleepingHexes.get(i);
					if(curHex.faces != null){
						exportGroup.add(curHex.faces);
					}
			}

			int activeHexesSize = activeHexes.size();
			for(int i=0; i<activeHexesSize; i++){
				Hex curHex = (Hex)activeHexes.get(i);
				if(curHex != null){
					if(curHex.faces != null){
						exportGroup.add(curHex.faces);
					}
				}
			}
			ObjExporter.exportObj(exportGroup, "~/output/test.obj");
			*/
		}
		
	}
}

void mousePressed(){
	myCamera.mousePressed();
}
void mouseReleased(){
	myCamera.mouseReleased();
}
