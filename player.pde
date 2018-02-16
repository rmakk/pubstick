class Player{
   int ballsLeft;    // balls remaining
   int ballsUsed;    // balls used -- keeping track in case of visual need
   int score;
   int lastScoreAmount; // track for display purposes in shotMadeAnimation
   int id;
   Timer timer;
   
   Player(int ballsPerTurn, int playerId){
     timer = new Timer(turnDuration);
     ballsLeft = ballsPerTurn;
     ballsUsed = 0;
     score = 0;
     lastScoreAmount = 0;
     id = playerId + 1;
   }
   
   void startPlayerTimer(){
     timer.start();
   }
  
   void stopPlayerTimer(){
     timer.stop();
   }
   
   int getPlayerTimeElapsed(){
     return timer.getElapsedTime();
   }
   
   String formattedRemainingTime(){
    return nf(timer.minute(), 1)+":"+nf(timer.second(), 2);
  }
   
   void madeShot(int pinNumber){
     ballsLeft--; // reducing the number of balls that have been used
     ballsUsed++; // incrementing number of balls that have been used
    
     int holeIndex = pinNumber - 3;
     int scoreAmount = holeValues[holeIndex];
     lastScoreAmount = scoreAmount;
     score = score + lastScoreAmount;
    
     // If player busts, reduce score to 14
     // Otherwise, update score like usual
     if(score > 21){
       score = bustPenalty;
       // TODO: probably trigger some animation here for when a player busts
     }
   }
   
   // At end of player turn, deduct -1 for each ball remaining. 
   // Stop this player's timer
   void endTurn(){
     if(ballsLeft > 0 && isTimerOver()){
       score = score - ballsLeft;
     }
     timer.stop();
   }
   
   boolean isTimerOver(){
     if(timer.getRemainingTime() <= 0){
       return true;
     }else{
       return false;
     }
   }
   
   String name(){
     return "Player "+id;
   }
}

// Method to return the winner player at the end of game.
ArrayList<Player> getWinningPlayer(){
  int winningValue = -1000; // Set to a big negative so our first comparison works
  ArrayList<Player> winners = new ArrayList<Player>();

  // Find player(s) with the highest score
  for(int i = 0; i < players.length; i++){
    Player tempPlayer = players[i];
    int playerScore = tempPlayer.score;
    
    if(tempPlayer.score > winningValue){
      winners.clear();
      winners.add(tempPlayer);
      winningValue = playerScore;
    }else if(playerScore == winningValue){
      winners.add(tempPlayer);
    }
  }
  
  // Find the player with the lowest balls used if there is a tie.
  if(winners.size() > 1){
    int winningBallsUsed = 100;
    ArrayList<Player> ballWinners = new ArrayList<Player>();
    for(Player tempPlayer : winners){
      int playerBallsUsed = tempPlayer.ballsLeft;    
      if(playerBallsUsed < winningBallsUsed){
        ballWinners.clear();
        ballWinners.add(tempPlayer);
        winningBallsUsed = playerBallsUsed;
      }else if(playerBallsUsed == winningBallsUsed){
        ballWinners.add(tempPlayer);
      }
    }
    winners = ballWinners;
  }

  // Find the player with the lowest time used if there is still a tie
  // after checking how many balls were used
  if(winners.size() > 1){
    int winningTime = 1000000000;
    ArrayList<Player> timeWinners = new ArrayList<Player>();
    for(Player tempPlayer : winners){
      int playerTime = tempPlayer.getPlayerTimeElapsed();    
      if(playerTime < winningTime){
        timeWinners.clear();
        timeWinners.add(tempPlayer);
        winningTime = playerTime;
      }else if(playerTime == winningTime){
        timeWinners.add(tempPlayer);
      }
    }
    winners = timeWinners;
  }
  
  return winners;
}