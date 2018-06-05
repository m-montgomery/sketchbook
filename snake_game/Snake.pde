class Snake {
  
  ArrayList<Scale> scales = new ArrayList<Scale>();
  String direction = "down";
  int score = 0;
  Scale head;     // first scale in the list

  Snake(color c) {
    head = new Scale(width/2, height/2, 10);
    head.setDirection(direction);
    head.setColor(c);
    scales.add(head);
  }
  
  void display() {
    for (Scale s : scales)
      s.display();
  }
  
  void move() {
    for (Scale s : scales)
      s.move();
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
    int x = end.x - (end.dx * end.size);
    int y = end.y - (end.dy * end.size);
    
    // make new scale with same direction and color
    Scale newScale = new Scale(x, y, end.size);
    newScale.setDirection(end.dx, end.dy);
    newScale.setColor(end.getColor());
    
    // copy end scale's turn queue
    for (int i = 0; i < end.turns.size(); i += 4)
      newScale.addTurn(end.turns.get(i),   end.turns.get(i+1), 
                       end.turns.get(i+2), end.turns.get(i+3));
    
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
    
    // update all scales
    for (Scale s : scales)
      s.addTurn(head.x, head.y, dir);
  }
  
  boolean outOfBounds(int maxX, int maxY) {
    for (Scale s : scales) {
      if (s.outOfBounds(maxX, maxY))
        return true;
    }
    return false;
  }
  
  boolean selfCollision() {
    for (int i = 0; i < scales.size(); i++) {
      for (int j = i + 1; j < scales.size(); j++) {
        if (scales.get(i).overlaps(scales.get(j)))
          return true;
      }
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
