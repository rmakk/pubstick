Movie shotMadeOnePoint;
Movie playerAnimation;
Movie bustAnimation;
Movie blackjackAnimation;
Movie missAnimation;
Movie standby;
Movie allScoreVideos[] = new Movie[5];
Movie allPlayerVideos[] = new Movie[4];
Movie allWinVideos[] = new Movie[5];

void initAnimations(){
  standby = new Movie(this, "press_any_key_beer.mp4");
  bustAnimation = new Movie(this, "pubstick_bust_animation.mp4");
  blackjackAnimation = new Movie(this, "pubstick_blackjack_animation.mp4");
  missAnimation = new Movie(this, "pubstick_miss_animation.mp4");

  standby.loop();
  
  //initializing score animations
  for (int i = 0; i < 5; i++) {
    String videoToLoad1 = i + "_pubstick_score_point" + ".mp4";
    String videoToLoad2 = i + "_pubstick_win.mp4";
    allScoreVideos[i] = new Movie(this, videoToLoad1);
    allWinVideos[i] = new Movie(this, videoToLoad2);
    allScoreVideos[i].stop();
    allWinVideos[i].stop();
  }
  
  //initializing player turn animations
  for (int i = 0; i < 4; i++) {
    String videoToLoad1 = i + "_pubstick_player_turn" + ".mp4";
    allPlayerVideos[i] = new Movie(this, videoToLoad1);
    allPlayerVideos[i].stop();
    
  }
}


void drawAnimations(){
  // Run animations
  image(allScoreVideos[vidIndex], 0, 0);
  image(allPlayerVideos[vidIndex], 0,0);
}

void standbyAnimation() {
  image(standby,0,0);
}
  



 
