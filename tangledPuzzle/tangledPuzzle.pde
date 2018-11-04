Puzzle puzzle;
int EASY = 5;
int MEDIUM = 10;
int HARD = 15;
boolean playing = true;
int border = 15;

Button playAgain;
Button success;

void setup() {
  size(600, 600);
  textAlign(CENTER, CENTER);
  
  playAgain = new Button(width/2, (int) (height * .75), 200, 100, 
                         "New game", color(230, 200, 240, 200), 0);
  success   = new Button(width/2, (int) (height * .3), 350, 200, 
                         "Success!", color(230, 200, 240, 200), 0);
  success._textSize = 60;
  newgame();
}

void draw() {
  if (! playing)
    return;
  
  background(color(100, 175, 225, 30));
  puzzle.update();
  puzzle.display();
  if (puzzle.solved())
    gameover();
}

void mousePressed() {
  if (playing)
    puzzle.handleMousePress();
}

void mouseReleased() {
  if (playing)
    puzzle.handleMouseRelease();
    
  else if (playAgain.hovering(mouseX, mouseY))
    newgame();
}

void gameover() {
  playing = false;
  puzzle = null;
  
  success.display();
  playAgain.display();
}

void newgame() {
  playing = true;
  
  // ensure it's not already completed
  while (puzzle == null || puzzle.solved(false)) 
    puzzle = new Puzzle(border, width-border, border, height-border, EASY);
}
