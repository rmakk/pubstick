import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;
import java.util.Map;
import java.util.Arrays;
//import ddf.minim.*;

// ** Audio config
//Minim minim;
//AudioPlayer holeSuccessAlert;

// ** Arduino config
Arduino arduino;
int lastShotMade;                             // used for target switches to reset, log shot made time
final int DELAY_TIME = 1000;                  // Time for switch reset after shot is made

// ** Game config vars
final int holePins[] = { 3, 4, 5, 6, 7 };     // the pins that the sensors are attached to 
final int holeValues[] = { 1, 3, 5, 7, 10 };
final int ballCount = 10;                     // total balls per turn
final int bustPenalty = 14;
final int turnDuration = 180000;              // duration of each turn
final int maxNumberOfPlayers = 4;
int numberOfPlayers = 1;                      // number of players per game

// ** Player state
Player players[];                             // Holds the player objects
int currentPlayerIndex;                       // index of current player in the Player array

// ** Game state
// Only of of these will be true at a time. ONLY update using the updateGameStateBooleanToTrue() method
// Each has a corresponding screen, displayed with a method using the naming convention
// show[gamestate]Screen (eg. showGameOnStandbyScreen())
boolean gameOnStandby = false;
boolean showingGameRules = false;
boolean selectingPlayers = false;
boolean gameRunning = false;
boolean gameFinished = false;

// ** Visual and animation vars
PFont font;

int gameIntroAnimationStartTime;
final int GAME_INTRO = 2500;

int advancePlayerAnimationStartTime;
final int ADVANCE_PLAYER = 2500;

int shotMadeAnimationStartTime;
final int SHOT_MADE = 1000;

int shotMissedAnimationStartTime;
final int SHOT_MISSED = 2500;

int gameOverAnimationStartTime;
final int GAME_OVER = 2500;

void setup(){
  // Visual setup
  size(500, 500);
  frameRate(30);
  font = createFont("Arial", 16, true);
  textFont(font);
  initSvgDrawing();
  
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
  updateGameState("gameOnStandby");
}

void draw() {
  
  if(isAnimationRunning()){
    runAnimations();
  
  // Show standby screen
  }else if(gameOnStandby){
    showGameOnStandbyScreen();
  
  // Showing rules screen
  }else if(showingGameRules){
    showGameRulesScreen();
    
  // Selecting players actions
  }else if(selectingPlayers){
    showSelectingPlayersScreen();
    
  // Game running actions
  }else if(gameRunning){
    showGameRunningScreen();
    
    // checking all sensors in the holes for a successful putt
    for(int i = 3; i <= 3; i++){
      if(arduino.digitalRead(i) == Arduino.LOW && currentPlayer().ballsLeft > 0 && (millis() - lastShotMade >= DELAY_TIME)){
        //shotMade(i);
      }
    }
    
    if(currentPlayer().isTimerOver()){
      advancePlayer();
    }
  
  // Game over actions
  }else if(gameFinished){
    showGameFinishedScreen();
    
    // Start button function, resets all variables
    // TODO: Assuming 9 is the pin for the start button
    if (arduino.digitalRead(9) == Arduino.LOW) {
      //updateGameState("gameOnStandby");
    }
  }
}

void shotMade(int pinNumber){
  // non-game-state variables
  lastShotMade = millis();
  shotMadeAnimationStartTime = millis();
  // holeSuccessAlert = minim.loadFile("chaChing.wav");
  // holeSuccessAlert.play();

  // Updating game vars
  currentPlayer().madeShot(pinNumber);
  if(currentPlayer().ballsLeft == 0 || currentPlayer().score == 21){
    advancePlayer();
  }
}

void shotMissed(){
  shotMissedAnimationStartTime = millis();
}

// Actions when a players turn is over
void advancePlayer(){
  
  currentPlayer().endTurn();
  
  // Two scenarios when advancing player
  // 1. More players left, so advance to next player
  // 2. This is the last player, game over
  if(currentPlayerIndex < (players.length-1)){
    setScoreImageToZero();
    currentPlayerIndex++;
    currentPlayer().startPlayerTimer();
    advancePlayerAnimationStartTime = millis();
  } else if(currentPlayerIndex == (players.length-1)){
    gameOverAnimationStartTime = millis();
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
    startNewGame(numberOfPlayers, ballCount);
  }else if(gameFinished){
    updateGameState("gameOnStandby");
  }
}

// If selecting players: Simulating 1-5 as selecting number of players
// If game is running: Simulating 1-5 on the keyboard are holes 1-5
void keyPressed() {
  int keyVal = Character.getNumericValue(key);
  if(keyVal >= 1 && keyVal <= 5 && !isAnimationRunning()){
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