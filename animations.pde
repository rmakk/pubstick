boolean isAnimationRunning(){
  if (millis() - gameIntroAnimationTime <= GAME_INTRO ||
      millis() - advancePlayerAnimationTime <= ADVANCE_PLAYER ||
      millis() - shotMadeAnimationTime <= SHOT_MADE ||
      millis() - shotMissedAnimationTime <= SHOT_MISSED ||
      millis() - gameOverAnimationTime <= GAME_OVER){
     return true;
  }else{
    return false;
  }
}

void baseAnimationSetup(String message){
  background(255, 204, 0);
  textAlign(CENTER, CENTER);
  fill(255);
  text(message, 250, 50); 
}

// Game intro animation 
// TODO: not used right now, do we want?
void gameIntroAnimation() {
  if (millis() - gameIntroAnimationTime <= GAME_INTRO) {
    baseAnimationSetup("Welcome!");
  }
}

// Advance player display
void advancePlayerAnimation(){
  if (millis() - advancePlayerAnimationTime <= ADVANCE_PLAYER) {
    baseAnimationSetup("Now for Player "+currentPlayer().id);
  }
}

void shotMadeAnimation(){
  if (millis() - shotMadeAnimationTime <= SHOT_MADE) {
    baseAnimationSetup("Made a shot for "+currentPlayer().lastScoreAmount+" points!");
  }
}

void shotMissedAnimation(){
  if (millis() - shotMissedAnimationTime <= SHOT_MISSED) {
    baseAnimationSetup("Missed a shot!");
  } 
}

void gameOverAnimation(){
  if (millis() - gameOverAnimationTime <= GAME_OVER) {
    baseAnimationSetup("Game Over!");
  }
}