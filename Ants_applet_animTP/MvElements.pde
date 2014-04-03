// Defines moving elements
class MvElements {
  // Variables
  int[] mvPos = new int[2]; // 2D location
  int mvType; // Type of moving element
  int mvLastMove; // Last movement done on the grid

  // Constructor
  MvElements(int i, int j, int type) {
    mvPos[0] = i;
    mvPos[1] = j;
    mvType = type;
    mvLastMove = 0;
  }

  // Methods
  void markGrid() {
    for (int i = 0;i < numOfTypes;i++) {
      gridPoints[mvPos[0]][mvPos[1]].grTypes[i] += typesToTypes[mvType][i]; // Updates each types level of grid regarding relation types-types
    }
    //gridPoints[mvPos[0]][mvPos[1]].grTypes[mvType]++;
  }

  int dirMvElements() {
    int pStay = 0;
    int pLt = 0;
    int pRt = 0;
    int pBk = 0;
    int pFd = 0;

    // Calculates probability to stay on current point
    for (int i = 0;i < numOfTypes;i++) {
      pStay += typesToTypes[mvType][i] * gridPoints[mvPos[0]][mvPos[1]].grTypes[i] * multiplyTypes + k;
    }
    for (int i = 0;i < numOfCriterias;i++) {
      pStay += typesToCriterias[mvType][i] * gridPoints[mvPos[0]][mvPos[1]].grCriterias[i] * multiplyCriterias + k;
    }
    if (mvLastMove == 0) pStay += k * w/100;
    if (pStay < 0) { pStay = 1; pLt -= pStay/4; pRt -= pStay/4; pBk -= pStay/4; pFd -= pStay/4; }

    if (mvPos[0] > 0 && mvLastMove != 2) { // Calculate attirance to left
      for (int i = 0;i < numOfTypes;i++) {
        pLt += typesToTypes[mvType][i] * gridPoints[mvPos[0] - 1][mvPos[1]].grTypes[i] * multiplyTypes + k;
      }
      for (int i = 0;i < numOfCriterias;i++) {
        pLt += typesToCriterias[mvType][i] * gridPoints[mvPos[0] - 1][mvPos[1]].grCriterias[i] * multiplyCriterias + k;
      }
      if (mvLastMove == 1) pLt += k * w/100;
      if (pLt < 0) { pStay -= pLt/4; pLt = 1; pRt -= pLt/4; pBk -= pLt/4; pFd -= pLt/4; }
    }

    if (mvPos[0] < gridPoints.length - 1 && mvLastMove != 1) { // Calculate attirance to right
      for (int i = 0;i < numOfTypes;i++) {
        pRt += typesToTypes[mvType][i] * gridPoints[mvPos[0] + 1][mvPos[1]].grTypes[i] * multiplyTypes + k;
      }
      for (int i = 0;i < numOfCriterias;i++) {
        pRt += typesToCriterias[mvType][i] * gridPoints[mvPos[0] + 1][mvPos[1]].grCriterias[i] * multiplyCriterias + k;
      }
      if (mvLastMove == 2) pRt += k * w/100;
      if (pRt < 0) { pStay -= pRt/4; pLt -= pRt/4; pRt = 1; pBk -= pRt/4; pFd -= pRt/4; }
    }

    if (mvPos[1] > 0 && mvLastMove != 4) { // Calculate attirance to back
      for (int i = 0;i < numOfTypes;i++) {
        pBk += typesToTypes[mvType][i] * gridPoints[mvPos[0]][mvPos[1] - 1].grTypes[i] * multiplyTypes + k;
      }
      for (int i = 0;i < numOfCriterias;i++) {
        pBk += typesToCriterias[mvType][i] * gridPoints[mvPos[0]][mvPos[1] - 1].grCriterias[i] * multiplyCriterias + k;
      }
      if (mvLastMove == 3) pBk += k * w/100;
      if (pBk < 0) { pStay -= pBk/4; pLt -= pBk/4; pRt -= pBk/4; pBk = 1; pFd -= pBk/4; }
    }

    if (mvPos[1] < gridPoints[0].length - 1 && mvLastMove != 3) { // Calculate attirance to forward
      for (int i = 0;i < numOfTypes;i++) {
        pFd += typesToTypes[mvType][i] * gridPoints[mvPos[0]][mvPos[1] + 1].grTypes[i] * multiplyTypes + k;
      }
      for (int i = 0;i < numOfCriterias;i++) {
        pFd += typesToCriterias[mvType][i] * gridPoints[mvPos[0]][mvPos[1] + 1].grCriterias[i] * multiplyCriterias + k;
      }
      if (mvLastMove == 4) pFd += k * w/100;
      if (pFd < 0) { pStay -= pFd/4; pLt -= pFd/4; pRt -= pFd/4; pBk -= pFd/4; pFd = 1; }
    }

    if (mvPos[0] == 0) pLt = 0;
    if (mvPos[0] == gridPoints.length - 1) pRt = 0;
    if (mvPos[1] == 0) pBk = 0;
    if (mvPos[1] == gridPoints[0].length - 1) pFd = 0;

    // Calculate probabilities for each direction to elect it
    int probability = int(random(1, pStay + pLt + pRt + pBk + pFd + 1));
    int direction = 0;
    if (probability <= pStay) direction = 0;
    if (probability > pStay && probability <= pStay + pLt) direction = 1;
    if (probability > pStay + pLt && probability <= pStay + pLt + pRt) direction = 2;
    if (probability > pStay + pLt + pRt && probability <= pStay + pLt + pRt + pBk) direction = 3;
    if (probability > pStay + pLt + pRt + pBk && probability <= pStay + pLt + pRt + pBk + pFd) direction = 4;

    // println("pFd: " + pFd + " pBk: " + pBk + " pRt: " + pRt + " pLt: " + pLt + " sum: " + (pFd + pBk + pRt + pLt) + " probability: " + probability + " direction: " + direction);

    return direction;
  }

  void moveMvElements() { // Moves element
    int direction = dirMvElements();
    if (direction == 1) {
      mvPos[0]--;
    } else if (direction == 2) {
      mvPos[0]++;
    } else if (direction == 3) {
      mvPos[1]--;
    } else if (direction == 4) {
      mvPos[1]++;
    }
    mvLastMove = direction;
  }

  void drawMvElements() { // Draws element as a square on the grid
    rectMode(CENTER);
    stroke((mvType/4)%2 * 255, (mvType/2)%2 * 255, mvType%2 * 255);
    fill((mvType/4)%2 * 255, (mvType/2)%2 * 255, mvType%2 * 255);
    rect(mvPos[0] * gridDef, mvPos[1] * gridDef, 5, 5);
  }

  // Debugger
 String toString() {
    return "mvPos: " + mvPos[0] + "/" + mvPos[1] + " type: " + mvType;
  }
}
