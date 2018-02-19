// ** General SVG vars
PShape allSvgNumbers[] = new PShape[10];
final int svgNumberWidth = 80;
final int svgNumberHeight = 96;
final int svgNumberSpacing = 60;

// ** SVG score vars
PShape scoreSvgNumbers[] = new PShape[2];

int scoreLocationX = 150;
int scoreLocationY = 70;

// ** SVG timer vars
PShape timerSvgNumbers[] = new PShape[3]; //TODO: will probably need to be 4 with an SVG colon maybe, or have colon in background
int timerLocationX = 50;
int timerLocationY = 300;

void initSvgDrawing(){
  // Loading up all the number images, 0-9, into program and then into the image array
  for (int i = 0; i < 10; i++) {
    String imageToLoad = "carnival_numbers_" + i + ".svg";
    allSvgNumbers[i] = loadShape(imageToLoad);
  }
}

void displaySvgTimer(){
  for (int i = 0; i < timerSvgNumbers.length ; i++) {
    int xLocation = timerLocationX + (svgNumberSpacing * i);
    shape(timerSvgNumbers[i], xLocation, timerLocationY, svgNumberWidth, svgNumberHeight);
  }
}

// Updates values to display in timer SVG array
// Only update timer every second, too expensive and unnecessary to draw more than that
void updateTimerSvgValues(){
  if(millis() - lastUpdatedTimeAt >= TIMER_DRAW_INTERVAL){
    lastUpdatedTimeAt = millis();
    char[] currentTime = currentPlayer().timer.formattedRemainingTimeForSvg().toCharArray();
    for(int i = 0; i < currentTime.length; i++){
      int numberToRender = Character.getNumericValue(currentTime[i]);
      timerSvgNumbers[i] = allSvgNumbers[numberToRender];
    }
  }
}

//shows the score
void scoreDisplay(){
  for (int i = 0; i < scoreSvgNumbers.length ; i++) {
    int xLocation = scoreLocationX + (svgNumberSpacing * i);
    shape(scoreSvgNumbers[i], xLocation, scoreLocationY, svgNumberWidth, svgNumberHeight);
  }
}

void setScoreImageToZero(){
  scoreSvgNumbers[0] = loadShape("carnival_numbers_null.svg");
  scoreSvgNumbers[1] = loadShape("carnival_numbers_0.svg");
}

//assigns number images to scoreImage array
void setScoreImage(int scoreAmount){
  int firstDigit = floor(scoreAmount/10);
  int secondDigit = scoreAmount % 10;
  
  // Skip first zero so we don't print '01' for a score of 1
  if(firstDigit == 0){
    scoreSvgNumbers[0] = loadShape("carnival_numbers_null.svg");
  }else{
    scoreSvgNumbers[0] = allSvgNumbers[firstDigit];
  }
  
  scoreSvgNumbers[1] = allSvgNumbers[secondDigit];
}