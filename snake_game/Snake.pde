// The Snake object

class Snake {
  
  // scales
  ArrayList<Scale> scales = new ArrayList<Scale>();
  Scale head;     // first scale in the list
  
  // movement
  String direction = "down";
  int dx = 0;
  int dy = 1;
  
  int score = 0;

  Snake(color c) {
    setDirection(direction);
    
    head = new Scale(width/2, height/2, 10);
    head.setColor(c);
    scales.add(head);
  }
  
  void display() {
    for (Scale s : scales)
      s.display();
  }
  
  void move() {
    
    // if more than 1 scale
    if (scales.size() > 1) {
      
      // remove last scale
      scales.remove(scales.size()-1);
    
      // add new head scale
      Scale newScale = new Scale(head.x, head.y, head.size);
      newScale.setColor(head.getColor());
      scales.add(0, newScale);
      head = newScale;
    }
    
    // move head based on current direction
    head.x += (dx * head.size);
    head.y += (dy * head.size);
  }
  
  boolean canEat(Snack snack) {
    
    // compare snack to head's location
    int dx = head.x - snack.x;
    int dy = head.y - snack.y;
    return sqrt(dx * dx + dy * dy) < (head.size/2) + (snack.size/2);
  }
  
  void checkForSnacks(ArrayList<Snack> snacks) {
    
    // check if can eat any snack
    for (int i = snacks.size() - 1; i >= 0; i--) {
      if (canEat(snacks.get(i))) {
        
        // eat snack and remove from snack list
        eat();
        snacks.remove(i);
      }
    }
  }
  
  void eat() {
    score++;     // increase total game score
    addScale();  // increase snake length
  }
  
  void addScale() {
    
    // calculate start coordinates from end scale
    Scale end = scales.get(scales.size() - 1);
    int x = end.x - (dx * end.size);
    int y = end.y - (dy * end.size);
    
    // make new scale with same direction and color
    Scale newScale = new Scale(x, y, end.size);
    newScale.setColor(end.getColor());
    
    // add new scale to Snake
    scales.add(newScale);
  }
  
  void setDirection(String dir) {
    
    // don't allow 180 deg (or 360) turns
    if (dir == "up"    && direction == "down"  ||
        dir == "down"  && direction == "up"    ||
        dir == "left"  && direction == "right" ||
        dir == "right" && direction == "left"  ||
        dir == direction)
      return;
    
    // save new direction
    direction = dir;
    dx = 0;
    dy = 0;
    if (direction == "up")
      dy = -1;
    else if (direction == "down")
      dy = 1;
    else if (direction == "left")
      dx = -1;
    else if (direction == "right")
      dx = 1;
  }
  
  boolean outOfBounds(int maxX, int maxY) {
    return head.outOfBounds(maxX, maxY);
  }
  
  boolean selfCollision() {
    for (int i = 1; i < scales.size(); i++) {
      if (scales.get(i).overlaps(head))
        return true;
    }
    return false;
  }
  
  int getScore() {
    return score;
  }
  
  void setColor(color newColor) {
    for (Scale s : scales)
      s.setColor(newColor);
  }
}
