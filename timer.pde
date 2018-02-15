class Timer {
  int startTime = 0;
  int stopTime = 0;
  int turnDuration;
  boolean running = false;
  
  Timer(int tempTurnDuration){
    turnDuration = tempTurnDuration;
  }
  
  void start(){
    startTime = millis();
    running = true;
  }
  
  void stop() {
    stopTime = millis();
    running = false;
  }
  
  int getElapsedTime() {
    int elapsed;
    if(running){
      elapsed = (millis() - startTime);
    }else{
      elapsed = (stopTime - startTime);
    }
    return elapsed;
  }
  
  int getRemainingTime(){
    return (turnDuration - getElapsedTime());
  }
  
  int second(){
    return (getRemainingTime() / 1000) % 60;
  }
  int minute(){
    return (getRemainingTime() / (1000*60)) % 60;
  }
}