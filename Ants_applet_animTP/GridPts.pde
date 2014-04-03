// Defines grid points
class GridPts {
  // Variables
  int[] grPos = new int[2]; // 2D location
  float[] grCriterias = new float[numOfCriterias]; // Levels of criterias
  float[] grTypes = new float[numOfTypes]; // Levels of types

  // Constructor
  GridPts(int i, int j) {
    grPos[0] = i;
    grPos[1] = j;
    for (int k = 0;k < grCriterias.length;k++) {
      color pixel = influenceImages[k].pixels[i + j*influenceImages[k].width];
      grCriterias[k] = brightness(pixel)/5;
      // grCriterias[k] = 0; // Sets all criterias levels to 0
    }
    for (int k = 0;k < grTypes.length;k++) {
      grTypes[k] = 0; // Sets all types levels to 0
    }
  }

  // Methods
  void drawGridPts() {
    if (displayLimits) {
      strokeWeight(2);
      if (displayCriterias) { // Compares points in 4 direction and their maximum level, than draw limit if not of the same criteria
        int index = getMaxIndex(grCriterias);
        if (index != getMaxIndex(gridPoints[grPos[0]-1][grPos[1]].grCriterias)) {
          pushMatrix();
          translate(grPos[0] * gridDef, grPos[1] * gridDef, 0);
          stroke((index/4)%2 * 255, (index/2)%2 * 255, index%2 * 255);
          noFill();
          
          line(-gridDef/3, -gridDef/3, 0, -gridDef/3, gridDef/3, 0);
          popMatrix();
        }
        if (index != getMaxIndex(gridPoints[grPos[0]+1][grPos[1]].grCriterias)) {
          pushMatrix();
          translate(grPos[0] * gridDef, grPos[1] * gridDef, 0);
          stroke((index/4)%2 * 255, (index/2)%2 * 255, index%2 * 255);
          noFill();
          line(gridDef/3, -gridDef/3, 0, gridDef/3, gridDef/3, 0);
          popMatrix();
        }
        if (index != getMaxIndex(gridPoints[grPos[0]][grPos[1]-1].grCriterias)) {
          pushMatrix();
          translate(grPos[0] * gridDef, grPos[1] * gridDef, 0);
          stroke((index/4)%2 * 255, (index/2)%2 * 255, index%2 * 255);
          noFill();
          line(-gridDef/3, -gridDef/3, 0, gridDef/3, -gridDef/3, 0);
          popMatrix();
        }
        if (index != getMaxIndex(gridPoints[grPos[0]][grPos[1]+1].grCriterias)) {
          pushMatrix();
          translate(grPos[0] * gridDef, grPos[1] * gridDef, 0);
          stroke((index/4)%2 * 255, (index/2)%2 * 255, index%2 * 255);
          noFill();
          line(-gridDef/3, gridDef/3, 0, gridDef/3, gridDef/3, 0);
          popMatrix();
        }
      } else { // Compares points in 4 direction and their maximum level, than draw limit if not of the same type
        int index = getMaxIndex(grTypes);
        if (index != getMaxIndex(gridPoints[grPos[0]-1][grPos[1]].grTypes)) {
          pushMatrix();
          translate(grPos[0] * gridDef, grPos[1] * gridDef, 0);
          stroke((index/4)%2 * 255, (index/2)%2 * 255, index%2 * 255);
          noFill();
          line(-gridDef/3, -gridDef/3, 0, -gridDef/3, gridDef/3, 0);
          popMatrix();
        }
        if (index != getMaxIndex(gridPoints[grPos[0]+1][grPos[1]].grTypes)) {
          pushMatrix();
          translate(grPos[0] * gridDef, grPos[1] * gridDef, 0);
          stroke((index/4)%2 * 255, (index/2)%2 * 255, index%2 * 255);
          noFill();
          line(gridDef/3, -gridDef/3, 0, gridDef/3, gridDef/3, 0);
          popMatrix();
        }
        if (index != getMaxIndex(gridPoints[grPos[0]][grPos[1]-1].grTypes)) {
          pushMatrix();
          translate(grPos[0] * gridDef, grPos[1] * gridDef, 0);
          stroke((index/4)%2 * 255, (index/2)%2 * 255, index%2 * 255);
          noFill();
          line(-gridDef/3, -gridDef/3, 0, gridDef/3, -gridDef/3, 0);
          popMatrix();
        }
        if (index != getMaxIndex(gridPoints[grPos[0]][grPos[1]+1].grTypes)) {
          pushMatrix();
          translate(grPos[0] * gridDef, grPos[1] * gridDef, 0);
          stroke((index/4)%2 * 255, (index/2)%2 * 255, index%2 * 255);
          noFill();
          line(-gridDef/3, gridDef/3, 0, gridDef/3, gridDef/3, 0);
          popMatrix();
        }
      }
      strokeWeight(1);
    } else {
      if (displayCriterias) {
        for (int i = 0;i < grCriterias.length;i++) { // Draws a box with height = level of criteria
          pushMatrix();
          int origin = 0;
          if (displayBitmap) origin = i*gridDef*gridSizeX;
          translate(origin + grPos[0] * gridDef, grPos[1] * gridDef, 0);
          stroke((i/4)%2 * 255, (i/2)%2 * 255, i%2 * 255);
          //fill((i/4)%2 * 255, (i/2)%2 * 255, i%2 * 255,50);
          noFill();
          if (grCriterias[i] == max(grCriterias) || !displayMaximum) box(10, 10, max(0, grCriterias[i]));
          popMatrix();
        }
      } else {
        for (int i = 0;i < grTypes.length;i++) { // Draws a box with height = level of type
          pushMatrix();
          int origin = 0;
          if (displayBitmap) origin = i*gridDef*gridSizeX;
          translate(origin + grPos[0] * gridDef, grPos[1] * gridDef, 0);
          stroke((i/4)%2 * 255, (i/2)%2 * 255, i%2 * 255);
          //fill((i/4)%2 * 255, (i/2)%2 * 255, i%2 * 255,50);
          noFill();
          if (grTypes[i] == max(grTypes) || !displayMaximum) box(10, 10, max(0, grTypes[i]));
          popMatrix();
          if (grTypes[i] == max(grTypes) ){
            if ( max(0, grTypes[i])>.5){ 
          Face f=new Face(Anar.Pt((grPos[0]* gridDef)-5,(grPos[1]* gridDef)-5,max(0, grTypes[i])/2),
                          Anar.Pt((grPos[0]* gridDef)-5,(grPos[1]* gridDef)+5,max(0, grTypes[i])/2),
                          Anar.Pt((grPos[0]* gridDef)+5,(grPos[1]* gridDef)+5,max(0, grTypes[i])/2),
                          Anar.Pt((grPos[0]* gridDef)+5,(grPos[1]* gridDef)-5,max(0, grTypes[i])/2));
                                  f.fill((i/4)%2 * 255, (i/2)%2 * 255, i%2 * 255,80);
                                  f.draw();
            }
          }
        }
      }
    }
  }

  void updatePts(int f) {
    for (int i = 0;i < grTypes.length;i++) { // Updates grid point type simulating evaporation
      grTypes[i] *= 1 - (float)1/f;
    }
  }
}

int getMaxIndex(float[] data) { // Gets the index of the maximal value in an array
  int index = 0;
  for (int i = 0;i < data.length;i++) {
    if (data[i] == max(data)) index = i;
  }
  return index;
}
