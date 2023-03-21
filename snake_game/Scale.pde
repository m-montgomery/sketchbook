// A single scale (piece) of the snake

class Scale {

  int x;       // center
  int y;
  int size;    // diameter
  
  color c;     // color
  
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
