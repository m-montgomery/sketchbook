class Scale {

  int x;       // center
  int y;
  int size;    // diameter
  
  color c;     // color
    
  int dx = 0;  // direction
  int dy = 0;
  
  // track coordinates & direction of next turn
  ArrayList<Integer> turns = new ArrayList<Integer>();
  
  Scale(int newX, int newY, int newSize) {
    x = newX;
    y = newY;
    size = newSize;
  }
  
  void display() {
    noStroke();
    fill(c);
    rectMode(CENTER);
    rect(x, y, size, size);
  }
  
  void move() {
    
    // check for turn
    if (turns.size() > 0 &&
        x == turns.get(0) &&
        y == turns.get(1)) {
      
      // perform the turn
      dx = turns.get(2);
      dy = turns.get(3);
      
      // remove current turn from queue
      for (int _ = 0; _ < 4; _++)
        turns.remove(0);
    }
    
    // update coordinates
    x += (dx * size);
    y += (dy * size);
  }
  
  void setDirection(int newDx, int newDy) {
    dx = newDx;
    dy = newDy;
  }
  
  void setDirection(String direction) {
    if (direction == "up")
      dy = -1;
    else if (direction == "down")
      dy = 1;
    else if (direction == "left")
      dx = -1;
    else if (direction == "right")
      dx = 1;
  }
  
  void addTurn(int xcoord, int ycoord, int newDx, int newDy) {
    
    // add turn coordinates
    turns.add(xcoord);
    turns.add(ycoord);
    
    // add new direction
    turns.add(newDx);
    turns.add(newDy);    
  }
  
  void addTurn(int xcoord, int ycoord, String direction) {
    
    // calculate new direction
    int newDx = 0;
    int newDy = 0;
    if (direction == "up")
      newDy = -1;
    else if (direction == "down")
      newDy = 1;
    else if (direction == "left")
      newDx = -1;
    else if (direction == "right")
      newDx = 1;
    
    // add turn to queue
    addTurn(xcoord, ycoord, newDx, newDy);
  }
  
  boolean outOfBounds(int maxX, int maxY) {
    return ((x - size/2) < 0     ||
            (x + size/2) > maxX  ||
            (y - size/2) < 0     ||
            (y + size/2) > maxY);
  }
  
  boolean overlaps(Scale other) {
    return x == other.x && y == other.y;
  }
  
  void setColor(color newColor) {
    c = newColor;
  }
  
  color getColor() {
    return c;
  }
}
