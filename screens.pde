void showGameOnStandbyScreen() {
  standbyAnimation();
}

void showGameRulesScreen() {
  displaySvgRulesScreen();
}

void showSelectingPlayersScreen(){
  displayPlayerSelectImage();
  drawPlayerSelectIndicator();
}

void showGameRunningScreen() {
  displayPlayerScreen(currentPlayer().id);
  displayImageBallsRemaining();
  
  // Show timer
  updateTimerSvgValues();
  displaySvgTimer();
  
  // TODO: Display all scores at same time? Or just one?
  scoreDisplay(); // only shows current players score right now
  bottomScoreDisplay();
}

// Prints out the final scores and winner!
void showGameFinishedScreen() {
  playerWinCelebration = minim.loadFile("victory.wav");
  playerWinCelebration.play();
  ArrayList<Player> winners = getWinningPlayer();
  if(winners.size() == 1){
    int playerIndex = winners.get(0).id() - 1;
    queueAnimation(allWinVideos[playerIndex]);
  }else{
    queueAnimation(allWinVideos[4]);
  }
   updateGameState("gameOnStandby");
} 
