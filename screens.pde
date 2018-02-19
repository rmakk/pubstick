void showGameOnStandbyScreen() {
  background(100); // Set the background to black
  fill(255);
  textAlign(CENTER);
  text("On Standby, Press Any Button to Begin!", 300, 300);
}

void showGameRulesScreen() {
  background(50); // Set the background to black
  fill(255);
  textAlign(CENTER);
  text("!!!!!! RULES OF THE GAME !!!!!!", 300, 300);
  text("Press Any Button to PLAY!", 300, 400);
}

void showSelectingPlayersScreen(){
  background(0); // Set the background to black
  fill(255);
  
  int xLocation = 100;
  int yLocation = 100;
  
  drawPlayerSelectIndicator(xLocation, yLocation);
  
  for(int i = 0; i < maxNumberOfPlayers; i++){
    text(i+1, xLocation, yLocation);
    xLocation = xLocation + 100;
  }
}

void showGameRunningScreen() {
  background(0); // Set the background to black
  fill(255);
  textAlign(LEFT);
  text("Currently Playing: Player "+(currentPlayerIndex+1), 300, 300);
  text("Balls Remaining: "+currentPlayer().ballsLeft, 300, 350);
  
  // Show timer
  updateTimerSvgValues();
  displaySvgTimer();
  
  // TODO: Display all scores at same time? Or just one?
  scoreDisplay(); // only shows current players score right now
  
  //float y = 200;
  //for(int i = 0; i < players.length; i++){
  //  String msg = players[i].name()+" Score: "+players[i].score+", Balls Used: "+players[i].ballsUsed;
  //  text(msg, 30, y);
  //  y = y + 30;
  //}
}

// Prints out the final scores and winner!
void showGameFinishedScreen() {
  background(0);
  textAlign(CENTER, CENTER);
  fill(255);
  text("Game Over!!", 250, 210);
  
  ArrayList<Player> winners = getWinningPlayer();
  if(winners.size() == 1){
    text("Winner is "+winners.get(0).name()+" with a score of "+winners.get(0).score, 250, 300);
  }else{
    text("TIE GAME :: Winners are", 250, 250);
    int y = 300;
    for(Player winner : winners){
      text(winner.name()+" with a score of "+winner.score, 250, y);
      y = y + 30;
    }
  } 
}