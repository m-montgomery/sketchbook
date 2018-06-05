class Snack {

  int x;       // center
  int y;
  int size;    // diameter  
  color c;     // color
  
  Snack(int newX, int newY, int newSize, color newColor) {
    x = newX;
    y = newY;
    size = newSize;
    c = newColor;
  }
  
  void display() {
    noStroke();
    fill(c);
    ellipseMode(CENTER);
    ellipse(x, y, size, size);
  }
}
