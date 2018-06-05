Snake snake;
boolean gameover;
ArrayList<Snack> snacks;

void setup() {
  size(600, 600);
  textAlign(CENTER, CENTER);
  
  // start a new game
  newGame();
}

void newGame() {
  snake = new Snake(color(#0C8311));   // create new snake
  snacks = new ArrayList<Snack>();     // create empty snack list
  gameover = false;                    // clear gameover status
}

void draw() {
  
  // pause briefly and clear background
  delay(50);
  background(255);
  
  // display randomly appearing snacks
  addSnacks();
  for (Snack s : snacks)
    s.display();
  
  // display snake (on top of snacks)
  snake.display();
      
  // display gameover screen if applicable
  if (gameover) {
    displayGameover();
    return;
  }
  
  // move snake and check for snacks to eat
  snake.move();
  snake.checkForSnacks(snacks);
  
  // check for gameover
  if (snake.outOfBounds(width, height) || snake.selfCollision()) {
    gameover = true;
    snake.setColor(color(255, 0, 0));
  }
}

void keyPressed() {
  
  // check for snake movement
  if (key == CODED) {
    if (keyCode == UP)
      snake.setDirection("up");
    else if (keyCode == DOWN)
      snake.setDirection("down");
    else if (keyCode == RIGHT)
      snake.setDirection("right");
    else if (keyCode == LEFT)
      snake.setDirection("left");
  }
  
  // check for new game request
  if (gameover && key == ' ')
    newGame();
}

void addSnacks() {
  
  // don't add more snacks after gameover
  if (gameover)
    return;
    
  // 3% chance of adding randomly placed snack
  int snackSize = 8;
  if (random(1) < 0.03)
    snacks.add(new Snack(int(random(width  - snackSize/2)), 
                         int(random(height - snackSize/2)),
                         snackSize, color(0, 0, 70)));
}

void displayGameover() {
  fill(color(255, 0, 0));  
 
  textSize(64);
  text("GAMEOVER", width/2, height*.25);
  text("Score: " + snake.getScore(), width/2, height*.75);
  
  textSize(18);
  text("Press space to try again.", width/2, height*.9);
}
