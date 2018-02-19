// Resets game variables for a fresh start
void startNewGame(int numberOfPlayers, int ballsPerTurn) {
  // Setting up new players
  players = new Player[numberOfPlayers];
  for(int i = 0; i < players.length; i++){
    players[i] = new Player(ballsPerTurn, i);
  }
  
  // Starting first player and their countdown clock
  currentPlayerIndex = 0;
  players[currentPlayerIndex].startPlayerTimer();
  
  // Universal game vars
  advancePlayerAnimationTime = millis();
  updateGameState("gameRunning");
  lastShotMade = millis();
  
  // Init score display to zero
  setScoreImageToZero();
  lastUpdatedTimeAt = millis();
}

// Updates one of our game-flow booleans to be true and makes sure the others are set to false
void updateGameState(String bool){  
  switch (bool) {
    case "gameOnStandby": gameOnStandby = true; showingGameRules = false; selectingPlayers = false; gameRunning = false; gameFinished = false; break;
    case "showingGameRules": gameOnStandby = false; showingGameRules = true; selectingPlayers = false; gameRunning = false; gameFinished = false; break;
    case "selectingPlayers": gameOnStandby = false; showingGameRules = false; selectingPlayers = true; gameRunning = false; gameFinished = false; break;
    case "gameRunning": gameOnStandby = false; showingGameRules = false; selectingPlayers = false; gameRunning = true; gameFinished = false; break;
    case "gameFinished": gameOnStandby = false; showingGameRules = false; selectingPlayers = false; gameRunning = false; gameFinished = true; break;
  }
}