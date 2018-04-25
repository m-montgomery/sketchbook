/*
   AUTHOR:  Maya Montgomery
   DATE:    4/24/18
   
   Inspired by 'Paper Menagerie' by Ken Liu. Click the tiger to make him
   start and stop; use the arrow keys to move him around. He'll flip around
   if he runs off screen, but not if you're leading him with the keyboard.  
*/

Tiger Laohu;                    // named from 'Paper Menagerie'
boolean firstKeyPress = true;   // track whether first key press

void setup() {
  size(800, 500);
  Laohu = new Tiger(width/2, 2*height/5);
  
  // set up text - need font that can handle Japanese
  // ('Paper Menagerie' is not Japanese but it's what I know)
  textAlign(CENTER);
  PFont font = createFont("fonts-japanese-mincho.ttf", 64);
  textFont(font, 64);
}

void draw() {
  background(100);
  
  // draw text
  fill(color(200, 0, 0));
  text("虎", width/2, height/4);     // kanji for tiger
  text("とら", width/2, 3*height/4);  // hiragana for tiger
  
  // draw tiger
  Laohu.display();
  Laohu.move();
}

void mouseReleased() {
  // toggle tiger randomly moving
  if (Laohu.wasClicked(mouseX, mouseY))
    Laohu.startStop();
}

void keyPressed() {
  // skip first key pressed to avoid move-pause-move
  //       as keyboard registers key being held down
  if (firstKeyPress) {
    firstKeyPress = false;
    return;
  }
  
  // move tiger based on arrow keys
  if (key == CODED) {
    if (keyCode == UP)
      Laohu.moveUp();
    else if (keyCode == DOWN)
      Laohu.moveDown();
    else if (keyCode == RIGHT)
      Laohu.moveRight();
    else if (keyCode == LEFT)
      Laohu.moveLeft();
  }
}

void keyReleased() {
  // reset first key press tracking
  firstKeyPress = true;
}
