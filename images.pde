PImage rulesScreenImage;
PImage playerSelectImage;
PImage lightGolfBall;

void initImages(){
  rulesScreenImage = loadImage("pubstick_rules.png");
  rulesScreenImage.resize(SCREEN_WIDTH, SCREEN_HEIGHT);
  playerSelectImage = loadImage("pubstick_playerselection.png");
  playerSelectImage.resize(SCREEN_WIDTH, SCREEN_HEIGHT);
  
  lightGolfBall = loadImage("golf_ball_light.png");
}

void displaySvgRulesScreen(){
  image(rulesScreenImage, 0, 0);
}

void displayPlayerSelectImage(){
  image(playerSelectImage, 0, 0);
}

void displayImageBallsRemaining(){
  int xLocation = 800;
  int yLocation = 500;
  for(int i = 0; i < currentPlayer().ballsLeft; i++){
    image(lightGolfBall, xLocation, yLocation);
    yLocation = yLocation - 50;
  }
}