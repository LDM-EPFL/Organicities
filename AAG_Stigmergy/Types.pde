String[] typesTags = new String[numOfTypes];
String[] criteriasTags = new String[numOfCriterias];
int[] typesRates = new int[numOfTypes];
int[][] typesToCriterias = new int[numOfTypes][numOfCriterias];
int[][] typesToTypes = new int[numOfTypes][numOfTypes];

void typesSettings() {
  typesTags[0] = "Core"; // Tags for types
  typesTags[1] = "Foyer";
  typesTags[2] = "Living";
  typesTags[3] = "Rooms";
  typesTags[4] = "Services";

  criteriasTags[0] = "Light"; // Tags for criterias
  criteriasTags[1] = "View";
  criteriasTags[2] = "Noise";

  typesRates[0] = 15; // Rates in %, should reach 100%
  typesRates[1] = 10;
  typesRates[2] = 20;
  typesRates[3] = 45;
  typesRates[4] = 10;

  typesToCriterias[0][0] = -1; typesToCriterias[0][1] = -1; typesToCriterias[0][2] = 1; // Set relations between types and criterias
  typesToCriterias[1][0] = 0; typesToCriterias[1][1] = 0; typesToCriterias[1][2] = 0;
  typesToCriterias[2][0] = 1; typesToCriterias[2][1] = 1; typesToCriterias[2][2] = 0;
  typesToCriterias[3][0] = 1; typesToCriterias[3][1] = 1; typesToCriterias[3][2] = -1;
  typesToCriterias[4][0] = 1; typesToCriterias[4][1] = -1; typesToCriterias[4][2] = 0;

  typesToTypes[0][0] = 1; typesToTypes[0][1] = 0; typesToTypes[0][2] = -1; typesToTypes[0][3] = -1; typesToTypes[0][4] = 0; // Set relations between types themselves
  typesToTypes[1][0] = 0; typesToTypes[1][1] = 1; typesToTypes[1][2] = 0; typesToTypes[1][3] = 0; typesToTypes[1][4] = -1;
  typesToTypes[2][0] = -1; typesToTypes[2][1] = 0; typesToTypes[2][2] = 1; typesToTypes[2][3] = 0; typesToTypes[2][4] = -1;
  typesToTypes[3][0] = -1; typesToTypes[3][1] = 0; typesToTypes[3][2] = 0; typesToTypes[3][3] = 1; typesToTypes[3][4] = 0;
  typesToTypes[4][0] = 0; typesToTypes[4][1] = -1; typesToTypes[4][2] = -1; typesToTypes[4][3] = 0; typesToTypes[4][4] = 1;
}
