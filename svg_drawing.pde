// ** General SVG vars
PShape allSvgNumbers[] = new PShape[10];
PShape allSvgTimers[] = new PShape[10];
PShape svgPlayerSelectIndicator;
PShape svgColon;

final int svgScoreWidth = 360;
final int svgScoreHeight = 432;

final int svgTimerWidth = 80;
final int svgTimerHeight = 96;

final int svgTimerSpacing = 60;
final int svgScoreSpacing = 263;

// ** SVG score vars
PShape scoreSvgNumbers[] = new PShape[2];
PShape tempscoreSvgNumbers[] = new PShape[2];

int scoreLocationX = 620;
int scoreLocationY = 440;

int bottomscoreLocationX = 450;
int bottomscoreLocationY = 950;

// ** SVG timer vars
PShape timerSvgNumbers[] = new PShape[3]; 
int timerLocationX = 1410;
int timerLocationY = 650;

void initSvgDrawing(){
  // Loading up all the number images, 0-9, into program and then into the image array
  for (int i = 0; i < 10; i++) {
    String imageToLoad1 = "pubstick_scorenumber_" + i + ".svg";
    String imageToLoad2 = "pubstick_timer_" + i + ".svg";
    allSvgNumbers[i] = loadShape(imageToLoad1);
    allSvgTimers[i] = loadShape(imageToLoad2);
  }
  svgPlayerSelectIndicator = loadShape("bonusball_pointer_50_l.svg");
  svgColon = loadShape("pubstick_timer_colon.svg");
  svgColon.disableStyle();
}

void displaySvgTimer(){
    
    fill(255,254,103);
    shape(timerSvgNumbers[0], 1395, timerLocationY);
    shape(svgColon, 1475, 670);
    shape(timerSvgNumbers[1], 1515, timerLocationY);
    shape(timerSvgNumbers[2], 1575, timerLocationY);
}

// Updates values to display in timer SVG array
// Only update timer every second, too expensive and unnecessary to draw more than that
void updateTimerSvgValues(){
  if(millis() - lastUpdatedTimeAt >= TIMER_DRAW_INTERVAL){
    lastUpdatedTimeAt = millis();
    char[] currentTime = currentPlayer().timer.formattedRemainingTimeForSvg().toCharArray();
    for(int i = 0; i < currentTime.length; i++){
      int numberToRender = Character.getNumericValue(currentTime[i]);
      timerSvgNumbers[i] = allSvgTimers[numberToRender];
      timerSvgNumbers[i].disableStyle();
    }
  }
}

//shows the score
void scoreDisplay(){
  for (int i = 0; i < scoreSvgNumbers.length ; i++) {
    int xLocation = scoreLocationX + (svgScoreSpacing * i);
    scoreSvgNumbers[i].disableStyle();
    fill(255);
    shape(scoreSvgNumbers[i], xLocation, scoreLocationY, svgScoreWidth, svgScoreHeight);
  }
}

void bottomScoreDisplay() {
  for (int i = 0; i < players.length; i++) {
    Player tempPlayer = players[i];
    int playerScore = tempPlayer.score;
    setBottomScoreImage(playerScore);
    bottomscoreLocationX =  665 + 225 * i;
     for (int j = 0; j < tempscoreSvgNumbers.length ; j++) {
      int xLocation = (bottomscoreLocationX + (60 * j));
      tempscoreSvgNumbers[j].disableStyle();
      fill(255);
      shape(tempscoreSvgNumbers[j], xLocation, bottomscoreLocationY, 80, 96);
    }
  } 
}

void setScoreImageToZero(){
  scoreSvgNumbers[0] = loadShape("pubstick_scorenumber_null.svg");
  scoreSvgNumbers[1] = loadShape("pubstick_scorenumber_0.svg");
}

//assigns number images to scoreImage array
void setScoreImage(int scoreAmount){
  int firstDigit = floor(scoreAmount/10);
  int secondDigit = scoreAmount % 10;
  // Skip first zero so we don't print '01' for a score of 1
  if(firstDigit == 0){
    scoreSvgNumbers[0] = loadShape("pubstick_scorenumber_null.svg");
  }else{
    scoreSvgNumbers[0] = allSvgNumbers[firstDigit];
  }
  scoreSvgNumbers[1] = allSvgNumbers[secondDigit];
}

void setBottomScoreImage(int scoreAmount){
  int firstDigit = floor(scoreAmount/10);
  int secondDigit = scoreAmount % 10;
  // Skip first zero so we don't print '01' for a score of 1
  if(firstDigit == 0){
    tempscoreSvgNumbers[0] = loadShape("pubstick_scorenumber_null.svg");
  }else{
    tempscoreSvgNumbers[0] = allSvgNumbers[firstDigit];
  }
  tempscoreSvgNumbers[1] = allSvgNumbers[secondDigit];
}

// Draw the indicator under the number of players selected
void drawPlayerSelectIndicator(){
  svgPlayerSelectIndicator.disableStyle();
  fill(255,254,103);
  if (numberOfPlayers == 1) {
    shape(svgPlayerSelectIndicator, 200, 700);
  } else if (numberOfPlayers == 2) {
    shape(svgPlayerSelectIndicator, 503, 700);
  } else if (numberOfPlayers == 3) {
     shape(svgPlayerSelectIndicator, 942, 700);
  } else if (numberOfPlayers == 4) {
    shape(svgPlayerSelectIndicator, 1470, 700);
  }
}
