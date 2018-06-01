import cc.arduino.*;
import org.firmata.*;
import processing.serial.*;
import java.util.Map;
import java.util.Arrays;
import processing.video.*;
import ddf.minim.*;

// ** Audio config
Minim minim;
AudioPlayer letsPlay;
Minim minim2;
AudioPlayer shotMade;
Minim minim3;
AudioPlayer shotMissed;
Minim minim4;
AudioPlayer playerWinCelebration;
Minim minim5;
AudioPlayer blackjack;

// ** Arduino configx
Arduino arduino;
Arduino arduino2;
int lastShotMade;                             // used for target switches to reset, log shot made time
final int DELAY_TIME = 1000;                  // Time for switch reset after shot is made
int vidIndex;                // Temp Variable
// ** Game config vars
final int holePins[] = { 3, 4, 5, 6, 7};
final int holePins2[] = { 10, 11, 12, 13};// the pins that the sensors are attached to 
final int holeValues[] = { 1, 2, 3, 5, 7 };
final int ballCount = 10;                     // total balls per turn
final int bustPenalty = 14;
final int turnDuration = 177000;              // duration of each turn
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
boolean startPlayerTimerAfterAnimations = false;

// Amount of time to wait before drawing anything
// Prevents issues with attempting to run animations
// before the game has begun
final int GAME_STARTUP_TIME = 3000;
final int ADVANCE_PLAYER = 4000;



final int SCREEN_WIDTH = 1920;
final int SCREEN_HEIGHT = 1080;
ArrayList<Movie> queuedAnimations = new ArrayList<Movie>();
ArrayList<Integer> queuedScores = new ArrayList<Integer>();
Movie currAnim;
int currScorePin;
float startAnimTime;

void setup() {
  // Visual setup
  fullScreen();
  frameRate(30);
  arduino = new Arduino(this, Arduino.list()[1], 57600);
  arduino2 = new Arduino(this, Arduino.list()[0], 57600);
  init();
}

void init() {
  initSvgDrawing();
  initImages();
  initBackgroundScreenImages();
  initAnimations();
  // Arduino initializer
  for (int i = 0; i < holePins.length; i++) {
    int pinHit = holePins[i];
    arduino.pinMode(pinHit, Arduino.INPUT);
  }
  // Arduino2 initializer
  for (int i = 0; i < holePins2.length; i++) {
    int pinHit2 = holePins2[i];
    arduino2.pinMode(pinHit2, Arduino.INPUT);
  }
  arduino2.pinMode(8, Arduino.INPUT);  //MissedPin
  minim = new Minim(this);
  minim2 = new Minim(this);
  minim3 = new Minim(this);
  minim4 = new Minim(this);
  // Game vars setup
  updateGameState("gameOnStandby");
}

void draw() {

  //RESET BUTTON
  if (arduino2.digitalRead(10) == Arduino.HIGH) {
    delay(500);
    launch("C:\\Users\\Pubstick\\Desktop\\RestartPubstick.lnk");
    delay(1000);
  }

  //OK BUTTON
  if (arduino2.digitalRead(11) == Arduino.HIGH) {
    if (gameOnStandby) {
      updateGameState("showingGameRules");
      letsPlay = minim.loadFile("casino.mp3");
      letsPlay.play();
    } else if (showingGameRules) {
      updateGameState("selectingPlayers");
    } else if (selectingPlayers) {
      startNewGame(numberOfPlayers, ballCount);
    } else if (gameFinished) {
      updateGameState("gameOnStandby");
    }
    delay(250);
  }

  //LEFT RIGHT SELECTION
  if (!gameRunning) {
    if (arduino2.digitalRead(13) == Arduino.HIGH && numberOfPlayers < maxNumberOfPlayers) {
      numberOfPlayers = numberOfPlayers + 1;
      delay(150);
    } else if (arduino2.digitalRead(12) == Arduino.HIGH && numberOfPlayers > 1) {
      numberOfPlayers = numberOfPlayers - 1;
      delay(150);
    }
  }

  if (currAnim != null) {
    if (millis() > startAnimTime + currAnim.duration()*1000) {
      currAnim = null;
      queuedAnimations.remove(0);
      if (queuedAnimations.isEmpty() && startPlayerTimerAfterAnimations) {
        currentPlayer().startPlayerTimer();
        startPlayerTimerAfterAnimations = false;
      }
    }
  }
  
  if (queuedScores.size() > 0) {
    currScorePin = queuedScores.get(0);
    shotMade(currScorePin);
    queuedScores.remove(0);
  }
  

    
    

  if (queuedAnimations.size() > 0) {
    if (currAnim == null) {
      currAnim = queuedAnimations.get(0);
      currAnim.play();
      startAnimTime = millis();
    } else if (currAnim != null) {
      image(currAnim, 0, 0);
    }
  } else if (gameOnStandby) {
    showGameOnStandbyScreen();

    // Showing rules screen
  } else if (showingGameRules) {
    showGameRulesScreen();

    // Selecting players actions
  } else if (selectingPlayers) {
    showSelectingPlayersScreen();

    // Game running actions
  } else if (gameRunning) {
    showGameRunningScreen();

    // checking all sensors in the holes for a successful putt
    for (int i = 0; i <= 4; i++) {
      int pin = i + 3;
      if (arduino.digitalRead(pin) == Arduino.LOW && currentPlayer().ballsLeft > 0 ) {
        queueScore(pin);
      }
    }

    if (arduino2.digitalRead(8) == Arduino.LOW) {
      shotMissed();
    }

    if (currentPlayer().isTimerOver()) {
      advancePlayer();
    }

    // Game over actions
  } else if (gameFinished) {
    showGameFinishedScreen();
  }
}

void shotMade(int pinNumber) {
  // non-game-state variables
  lastShotMade = millis();
  shotMade = minim.loadFile("chaChing.wav");
  shotMade.play();

  //trigger different animations based on pinNumber
  int vidToPlay = pinNumber - 3;
  queueAnimation(allScoreVideos[vidToPlay]);

  // Updating game vars
  currentPlayer().madeShot(pinNumber);
  checkTurnStatus();
}

void checkTurnStatus() {
  if (currentPlayer().score == 21) {
    queueAnimation(blackjackAnimation);
    blackjack = minim.loadFile("fireworks.mp3");
    blackjack.play();
  }
  if (currentPlayer().ballsLeft == 0 || currentPlayer().score == 21) {
    advancePlayer();
  }
}

void queueAnimation(Movie m) {
  m.stop();
  queuedAnimations.add(m);
}

void queueScore(Integer i) {
  queuedScores.add(i);
}

void shotMissed() {
  queueAnimation(missAnimation);
  shotMissed = minim.loadFile("whiff.mp3");
  shotMissed.play();
  currentPlayer().missedShot();
  checkTurnStatus();
}

void startPlayer() {
  startPlayerTimerAfterAnimations = true;
  //todo queue animation
  int playerIndex = currentPlayer().id - 1;

  queueAnimation(allPlayerVideos[playerIndex]);
  updateGameState("gameRunning");

  lastShotMade = millis();
  setScoreImageToZero();
  lastUpdatedTimeAt = millis();
}

void advancePlayer() {
  currentPlayer().endTurn();

  // Two scenarios when advancing player
  // 1. More players left, so advance to next player
  // 2. This is the last player, game over


  if (currentPlayerIndex < (players.length-1)) {
    currentPlayerIndex++;
    startPlayer();
  } else if (currentPlayerIndex == (players.length-1)) {
    updateGameState("gameFinished");
  }
}

Player currentPlayer() {
  return players[currentPlayerIndex];
}

// Simulating mouse click is start game
void mousePressed() {
  if (gameOnStandby) {
    updateGameState("showingGameRules");
  } else if (showingGameRules) {
    updateGameState("selectingPlayers");
  } else if (selectingPlayers) {
    startNewGame(numberOfPlayers, ballCount);
  } else if (gameFinished) {
    updateGameState("gameOnStandby");
  }
}

// If selecting players: Simulating 1-5 as selecting number of players
// If game is running: Simulating 1-5 on the keyboard are holes 1-5
void keyPressed() {
  int keyVal = Character.getNumericValue(key);
  if (keyVal >= 1 && keyVal <= 5) {
    if (gameRunning) {
      int pinHit = holePins[keyVal-1]; // Dummy conversion to the pin value from the key pressed.
      vidIndex = keyVal - 1;
      shotMade(pinHit);
    } else if (selectingPlayers && keyVal < 5) {
      numberOfPlayers = keyVal;
    }
  }
}

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
}


void stop() {
  minim.stop();
  minim2.stop();
  minim3.stop();
  minim4.stop();
  minim5.stop();
  letsPlay.close();
  shotMade.close();
  shotMissed.close();
  blackjack.close();
  playerWinCelebration.close();
  super.stop();
}
