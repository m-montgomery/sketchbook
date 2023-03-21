/*
   AUTHOR:  Maya Montgomery
   UPDATED: 3/31/19
   
   An implementation of the classic Snake game. Control the snake
   with the arrow keys; you can only make a right or a left from
   your current direction (e.g. if you are moving left, only
   the 'down' and 'up' keys will have an effect). Snacks will
   randomly appear on the screen; eat one and you grow slightly
   longer. Don't hit the walls or yourself, or it's game over! 
*/

Snake snake;              // snake controlled by user
boolean gameover;         // game over?
boolean screen;           // showing a display screen?
ArrayList<Snack> snacks;  // list of randomly appearing snacks

// program variables for quick changes
int SNACKSIZE = 8;
int MAXSNACKS = 10;
color SNACKCOLOR = #D88404;
color SNAKECOLOR = #0C8311;


void setup() {
  size(600, 600);
  surface.setResizable(true);
  
  textAlign(CENTER, CENTER);
  gameover = false;
  screen = true;
}


void draw() {
  
  // show start screen
  if (screen && !gameover) {
    displayScreen("SNAKE");
    return;
  }
  
  // pause briefly
  frameRate(20);
  background(255);
  
  // check for game over
  if (snake.outOfBounds(width, height) || snake.selfCollision()) {
    gameover = true;
    displayScreen("GAME OVER");
    return;
  }
  
  // display randomly appearing snacks
  addSnacks();
  for (Snack s : snacks)
    s.display();
  
  // display snake (on top of snacks)
  snake.display();
  
  // move snake and check for snacks to eat
  snake.move();
  snake.checkForSnacks(snacks);  
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
  if (screen && key == ' ')
    newGame();
  else if (key == ' ') {
    setSize(800, 800);
    surface.setSize(800, 800);
    //surface.resize(800, 800);
  }
}


void addSnacks() {
    
  // 3% chance of adding randomly placed snack
  if (random(1) < 0.03 && snacks.size() < MAXSNACKS)
    snacks.add(new Snack(int(random(width  - SNACKSIZE/2)), 
                         int(random(height - SNACKSIZE/2)),
                         SNACKSIZE, 
                         SNACKCOLOR));
}


void newGame() {
  snake = new Snake(SNAKECOLOR);       // create new snake
  snacks = new ArrayList<Snack>();     // create empty snack list
  
  gameover = false;                    // clear game over status
  screen = false;                      // stop displaying screen
  loop();                              // restart processing
}


void displayScreen(String msg) {
  
  // prevent processing
  screen = true;
  noLoop();
  
  // color
  background(SNAKECOLOR);
  fill(#FFFFFF);
 
  // display messages
  textSize(64);
  text(msg, width/2, height*.25);  
  textSize(18);
  text("Press space to start a new game.", width/2, height*.9);
  
  // show score if applicable
  if (gameover)
    text("Score: " + snake.getScore(), width/2, height*.75);
}
