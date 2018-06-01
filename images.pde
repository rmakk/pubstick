PImage rulesScreenImage;
PImage playerSelectImage;
PImage lightGolfBall;
PImage darkGolfBall;
PImage allPlayerScreens[] = new PImage[4];

void initImages(){
  rulesScreenImage = loadImage("pubstick_rules.png");
  playerSelectImage = loadImage("pubstick_playerselection.png");  
  lightGolfBall = loadImage("golf_ball_light.png");
  darkGolfBall = loadImage("golf_ball_dark.png");
}

void initBackgroundScreenImages(){
  // Loading up all the number images, 0-9, into program and then into the image array
  for (int i = 0; i < 4; i++) { 
    String imageToLoad = "pubstick_playerscreen_" + i + ".png";
    allPlayerScreens[i] = loadImage(imageToLoad);
  }
}

void displaySvgRulesScreen(){
  image(rulesScreenImage, 0, 0);
}

void displayPlayerSelectImage(){
  image(playerSelectImage, 0, 0);
}

void displayPlayerScreen(int playerId) {
  int id = playerId - 1;
  image(allPlayerScreens[id], 0, 0);
  //draw a layer of dark balls
  int xLocation = 1780;
  int yLocation = 965;
  for(int i = 0; i < 10; i++) {
     image(darkGolfBall, xLocation, yLocation);
     yLocation = yLocation - 90;
   }
}

void displayImageBallsRemaining(){
  int xLocation = 1780;
  int yLocation = 965;

  
  for(int i = 0; i < currentPlayer().ballsLeft; i++){
    image(lightGolfBall, xLocation, yLocation);
    yLocation = yLocation - 90;
  }  
  

}
