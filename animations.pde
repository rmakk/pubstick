Movie shotMadeOnePoint;

void initAnimations(){
  shotMadeOnePoint = new Movie(this, "1_point.mov");
}

// Checks if any animation running. Used to prevent standard screens 
// from showing while an animation is running
boolean isAnimationRunning(){
  if (millis() - gameIntroAnimationStartTime <= GAME_INTRO ||
      millis() - advancePlayerAnimationStartTime <= ADVANCE_PLAYER ||
      millis() - shotMadeAnimationStartTime <= SHOT_MADE ||
      millis() - shotMissedAnimationStartTime <= SHOT_MISSED ||
      millis() - gameOverAnimationStartTime <= GAME_OVER){
     return true;
  }else{
    return false;
  }
}

void runAnimations(){
  // Run animations
  gameIntroAnimation();
  advancePlayerAnimation();
  shotMadeAnimation();
  shotMissedAnimation();
  gameOverAnimation();
}

// ** Animations & transition screen functions below

void baseAnimationSetup(String message){
  background(255, 204, 0);
  textAlign(CENTER, CENTER);
  fill(255);
  text(message, 250, 50); 
}

// Game intro animation 
// TODO: not used right now, do we want?
void gameIntroAnimation() {
  if (millis() - gameIntroAnimationStartTime <= GAME_INTRO) {
    baseAnimationSetup("Welcome!");
  }
}

void advancePlayerAnimation(){
  if (millis() - advancePlayerAnimationStartTime <= ADVANCE_PLAYER) {
    baseAnimationSetup("Now for Player "+currentPlayer().id);
  }
}

void shotMadeAnimation(){
  if (millis() - shotMadeAnimationStartTime <= SHOT_MADE) {
    image(shotMadeOnePoint, 0, 0);
  }
}

void shotMissedAnimation(){
  if (millis() - shotMissedAnimationStartTime <= SHOT_MISSED) {
    baseAnimationSetup("Missed a shot!");
  } 
}

void gameOverAnimation(){
  if (millis() - gameOverAnimationStartTime <= GAME_OVER) {
    baseAnimationSetup("Game Over!");
  }
}