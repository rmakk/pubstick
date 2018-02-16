import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;
import java.util.Map;
//import ddf.minim.*;

// ** Audio config
//Minim minim;
//AudioPlayer holeSuccessAlert;

// ** Arduino config
Arduino arduino;
int lastTime;                                // timer for target switches to reset
final int DELAY_TIME = 1000;                 // Time for switch reset

// ** Game config vars
final int holePins[] = { 3, 4, 5, 6, 7 };     // the pins that the sensors are attached to 
final int holeValues[] = { 1, 3, 5, 7, 10 };
final int ballCount = 10;                     // total balls per turn
final int bustPenalty = 14;
final int turnDuration = 180000;             // duration of each turn
int numberOfPlayers = 1;

// ** Game and player state
Player players[];                            // Holds the player objects
int currentPlayerIndex;                      // index of current player in the Player array

// Only of of these will be true at a time. ONLY update using the updateGameStateBooleanToTrue() method
boolean gameOnStandby = false;
boolean showingGameRules = false;
boolean selectingPlayers = false;
boolean gameRunning = false;
boolean gameFinished = false;


// ** Visual and animation vars
PFont font;

int gameIntroAnimationTime;
final int GAME_INTRO = 2500;

int advancePlayerAnimationTime;
final int ADVANCE_PLAYER = 2500;

int shotMadeAnimationTime;
final int SHOT_MADE = 2500;

int shotMissedAnimationTime;
final int SHOT_MISSED = 2500;

int gameOverAnimationTime;
final int GAME_OVER = 2500;



// TODO: Not sure of the official way to make the game run with the visuals and hardware input.
// Code below will made a new game with 4 players and 10 putts per turn
void setup(){
  // Visual setup
  size(500, 500);
  background(255);
  frameRate(30);
  font = createFont("Arial", 16, true);
  textFont(font);
  stroke(255);     // Set stroke color to white
  
  // Arduino initializer
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  for (int i = 0; i < holePins.length; i++){
    int pinHit = holePins[i];
    arduino.pinMode(pinHit, Arduino.INPUT);
  }
  arduino.pinMode(13, Arduino.OUTPUT); // Pin 13 is an indicator light
  
  // Audio setup
  //minim = new Minim(this);
  
  // Game vars setup
  lastTime = millis();
  updateGameState("gameOnStandby");
}

void draw() {
  
  if(isAnimationRunning()){
    // Run animations
    gameIntroAnimation();
    advancePlayerAnimation();
    shotMadeAnimation();
    shotMissedAnimation();
    gameOverAnimation();
  
  // Show standby screen
  }else if(gameOnStandby){
    showStandbyScreen();
  
  // Showing rules screen
  }else if(showingGameRules){
    showRulesScreen();
    
  // Selecting players actions
  }else if(selectingPlayers){
    showPlayerSelect();
    
  // Game running actions
  }else if(gameRunning){
    showScores();
    
    // checking all sensors in the holes for a successful putt
    for(int i = 3; i <= 3; i++){
      if(arduino.digitalRead(i) == Arduino.LOW && currentPlayer().ballsLeft > 0 && (millis() - lastTime >= DELAY_TIME)){
        //shotMade(i);
      }
    }
    
    if(currentPlayer().isTimerOver()){
      advancePlayer();
    }
  
  // Game over actions
  }else if(gameFinished){
    showGameOverStats();
    
    // Start button function, resets all variables
    // TODO: Assuming 9 is the pin for the start button
    if (arduino.digitalRead(9) == Arduino.LOW) {
      //updateGameState("gameOnStandby");
    }
  }
}

void shotMade(int pinNumber){
  //successful put into hole sound effect goes below
  //holeSuccessAlert = minim.loadFile("chaChing.wav");
  //holeSuccessAlert.play();

  // Updating game vars
  lastTime = millis();
  currentPlayer().madeShot(pinNumber);
  shotMadeAnimationTime = millis();
  
  if(currentPlayer().ballsLeft == 0 || currentPlayer().score == 21){
    advancePlayer();
  }
}

void shotMissed(){
  shotMissedAnimationTime = millis();
}

// Actions when a players turn is over
void advancePlayer(){
  
  currentPlayer().endTurn();
  
  // Two scenarios when advancing player
  // 1. More players left, so advance to next player
  // 2. This is the last player, game over
  if(currentPlayerIndex < (players.length-1)){
    currentPlayerIndex++;
    currentPlayer().startPlayerTimer();
    advancePlayerAnimationTime = millis();
  } else if(currentPlayerIndex == (players.length-1)){
    gameOverAnimationTime = millis();
    updateGameState("gameFinished");
  }
}

Player currentPlayer(){
  return players[currentPlayerIndex];
}

// Simulating mouse click is start game
void mousePressed(){
  if(gameOnStandby){
    updateGameState("showingGameRules");
  }else if(showingGameRules){
    updateGameState("selectingPlayers");
  }else if(selectingPlayers){
    startTheGame(numberOfPlayers, ballCount);
  }else if(gameFinished){
    updateGameState("gameOnStandby");
  }
}

// If selecting players: Simulating 1-5 as selecting number of players
// If game is running: Simulating 1-5 on the keyboard are holes 1-5
void keyPressed() {
  int keyVal = Character.getNumericValue(key);
  if(keyVal >= 1 && keyVal <= 5){
    if(gameRunning){
      int pinHit = holePins[keyVal-1]; // Dummy conversion to the pin value from the key pressed.
      shotMade(pinHit);
    }else if(selectingPlayers && keyVal < 5){
      numberOfPlayers = keyVal;
    }
  }
}

void stop(){
  // always stop Minim before exiting
  //minim.stop();
  //hole_chaching.close();
  //super.stop();
}