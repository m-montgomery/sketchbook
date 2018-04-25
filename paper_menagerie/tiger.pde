class Tiger {
  
  int x;
  int y;
  PShape fullShape;
    
  int dx = 1;    // left/right speed
  int dy = 0;    // up/down speed
  int h = 170;   // height
  int w = 250;   // width
  
  boolean moving = false;      // currently moving?
  boolean onProbation = false; // allowed to be offscreen?
  
  float scaleX = 1.0;  // for flipping
  float theta = 0;     // angle for rotating
  float dr = 0.005;    // rotate speed
  int moveCount = 0;   // tracks when to alternate rotate direction
  
  color normal = color(255, 0, 0);
  color darker = color(200, 0, 0);
  color darkest = color(150, 0, 0);
  
  Tiger(int xpos, int ypos) {
    
    x = xpos;
    y = ypos;

    PShape outline = createShape();
    outline.beginShape();
      outline.fill(normal);
      outline.vertex(20, 5);
      outline.vertex(25, 35);
      outline.vertex(30, 45);
      outline.vertex(40, 60);
      outline.vertex(65, 50);
      outline.vertex(170, 70);
      outline.vertex(180, 58);
      outline.vertex(190, 60);
      outline.vertex(205, 50);
      outline.vertex(220, 65);
      outline.vertex(230, 70);
      outline.vertex(245, 110);
      outline.vertex(225, 125);
      outline.vertex(215, 115);
      outline.vertex(205, 120);
      outline.vertex(230, 130);
      outline.vertex(210, 135);
      outline.vertex(240, 165);
      outline.vertex(215, 165);
      outline.vertex(175, 142);
      outline.vertex(150, 130);
      
      // underbelly spikes
      outline.vertex(140, 125);
      outline.vertex(144, 115);
      outline.vertex(122, 130);
      outline.vertex(112, 115);
      outline.vertex(95, 125);
      outline.vertex(85, 112);
      
      outline.vertex(75, 120);
      outline.vertex(92, 152);
      outline.vertex(85, 155);
      outline.vertex(90, 160);
      outline.vertex(60, 155);
      outline.vertex(30, 120);
      outline.vertex(35, 95);
      outline.vertex(30, 90);
      outline.vertex(5, 75);
      outline.vertex(65, 50);
      outline.vertex(5, 75);
      outline.vertex(20, 5);
    outline.endShape();
    
    PShape upperLeg = createShape();
    upperLeg.beginShape();
      upperLeg.fill(darker);
      upperLeg.vertex(30, 90);
      upperLeg.vertex(35, 95);
      upperLeg.vertex(37, 83);
      upperLeg.vertex(80, 58);
      upperLeg.vertex(65, 55);
    upperLeg.endShape(CLOSE);
    
    PShape innerHead = createShape();
    innerHead.beginShape();
      innerHead.fill(darkest);
      innerHead.vertex(215, 115);
      innerHead.vertex(195, 100);
      innerHead.vertex(196, 104);
      innerHead.vertex(175, 95);
      innerHead.vertex(201, 122);
    innerHead.endShape(CLOSE);
    
    PShape upperFrontLeg = createShape();
    upperFrontLeg.beginShape();
      upperFrontLeg.fill(darker);
      upperFrontLeg.vertex(175, 95);
      upperFrontLeg.vertex(170, 100);
      upperFrontLeg.vertex(201, 125);
      upperFrontLeg.vertex(210, 135);
    upperFrontLeg.endShape(CLOSE);
    
    PShape lowerFrontLeg = createShape();
    lowerFrontLeg.beginShape();
      lowerFrontLeg.fill(darker);
      lowerFrontLeg.vertex(175, 142);
      lowerFrontLeg.vertex(170, 145);
      lowerFrontLeg.vertex(140, 125);
    lowerFrontLeg.endShape();
    
    PShape underBelly = createShape();
    underBelly.beginShape();
      underBelly.fill(darkest);
      underBelly.vertex(75, 120);
      underBelly.vertex(150, 130);
      underBelly.vertex(150, 110);
      underBelly.vertex(70, 110);
    underBelly.endShape(CLOSE);
    
    PShape backLeg = createShape();
    backLeg.beginShape();
      backLeg.fill(darker);
      backLeg.vertex(75, 120);
      backLeg.vertex(67, 128);
      backLeg.vertex(85, 155);
      backLeg.vertex(92, 152);
    backLeg.endShape(CLOSE);
    
    // compile body parts into shape
    fullShape = createShape(GROUP);
    fullShape.addChild(underBelly);
    fullShape.addChild(outline);
    fullShape.addChild(upperLeg);
    fullShape.addChild(innerHead);
    fullShape.addChild(upperFrontLeg);
    fullShape.addChild(lowerFrontLeg);
    fullShape.addChild(backLeg);
    
    // inner head lines
    stroke(darker);
    fullShape.addChild(createShape(LINE, 195, 100, 230, 70));
    fullShape.addChild(createShape(LINE, 225, 125, 220, 65));
    fullShape.addChild(createShape(LINE, 190, 60, 220, 65));
    
    // back leg detail
    fullShape.addChild(createShape(LINE, 30, 120, 67, 128));
    
    // inner shoulder lines
    fullShape.addChild(createShape(LINE, 145, 100, 155, 80));
    fullShape.addChild(createShape(LINE, 155, 80, 170, 70));
    fullShape.addChild(createShape(LINE, 145, 100, 170, 100));
    fullShape.addChild(createShape(LINE, 170, 100, 155, 80));
    stroke(darkest);
    fullShape.addChild(createShape(LINE, 144, 115, 145, 100));
    fullShape.addChild(createShape(LINE, 175, 95, 205, 50));

    // back leg folds
    fullShape.addChild(createShape(LINE, 30, 120, 70, 90));
    fullShape.addChild(createShape(LINE, 85, 155, 54, 103));
    fullShape.addChild(createShape(LINE, 70, 90, 80, 58));

    // torso folds
    fullShape.addChild(createShape(LINE, 132, 63, 125, 105));
    fullShape.addChild(createShape(LINE, 125, 105, 95, 125));
    fullShape.addChild(createShape(LINE, 105, 59, 100, 100));
    fullShape.addChild(createShape(LINE, 100, 100, 75, 120));
    fullShape.addChild(createShape(LINE, 155, 80, 155, 68));
    
    // tail details
    stroke(darker);
    fullShape.addChild(createShape(LINE, 5, 75, 23, 50));
    fullShape.addChild(createShape(LINE, 23, 50, 40, 60));
    fullShape.addChild(createShape(LINE, 23, 50, 20, 5));
}
  
  void display() {
    pushMatrix();
 
      // set coordinate system based on flipped status
      if (scaleX < 0)
        translate(x + w/2, y - h/2);
      else
        translate(x - w/2, y - h/2);
      
      // flip, rotate, and display the shape
      scale(scaleX, 1.0);
      rotate(theta);
      shape(fullShape);
      
    popMatrix();
  }
  
  void move() {
    if (!moving)
      return;
      
    // update location
    x += dx;
    y += dy;
    stayInBounds();
    
    // update wobbling tilt
    theta += dr;
    moveCount++;
    if (moveCount > 10) {
      dr *= -1;
      moveCount = 0;
    }
  }
  
  void stayInBounds() {
    
    // wander all the way off screen horizontally, then flip
    if (!onProbation && x + w/2 < 0 || x - w/2 > width) {
      dx *= -1;
      scaleX *= -1;
      onProbation = true;
    }
    
    // check if finished moving back onscreen
    else if (onProbation) 
      onProbation = false;
    
    // just bounce off top and bottom
    if (y - h/2 < 0 || y + h/2 > height)
      dy *= -1;
  }
  
  boolean wasClicked(int mx, int my) {
    return x - w/2 <= mx && x + w/2 >= mx &&
           y - h/2 <= my && y + h/2 >= my;
  }
  
  void startStop() {
    // toggle movement
    moving = !moving;
    
    // pick random direction
    if (moving) {
      dy = int(random(-2, 3));
      dx = int(random(-2, 3));
      dx = dy == 0 && dx == 0 ? 1 : dx; // ensure some movement
      
      // better chance of moving forwards (depends on flip status)
      if (random(1) > 0.3)
        dx = (scaleX > 0) ? abs(dx) : (dx > 0 ? -dx : dx);
    }
  }
  
  void moveOnce() {
    moving = true;
    move();
    moving = false;
  }
  
  void moveUp() {
    dy = -2;
    dx = 0;
    moveOnce();
  }
  
  void moveDown() {
    dy = 2;
    dx = 0;
    moveOnce();
  }
  
  void moveRight() {
    dy = 0;
    dx = 2;
    moveOnce();
  }
  
  void moveLeft() {
    dy = 0;
    dx = -2;
    moveOnce();
  }
}
