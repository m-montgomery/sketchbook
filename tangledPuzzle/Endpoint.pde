class Endpoint {
  
  int x;
  int y;
  
  int diameter;
  int radius;
  
  color c;
  boolean followingMouse;
  Line line1;
  Line line2;
  
  Endpoint(int _x, int _y, int d) {
    c = color(255, 0, 0);
    init(_x, _y, d);
  }
  
  Endpoint(int _x, int _y, int d, color _c) {
    c = _c;
    init(_x, _y, d);
  }
  
  void init(int _x, int _y, int d) {  
    x = _x;
    y = _y;
    diameter = d;
    radius = diameter / 2;
  }

  void update() {
    if (followingMouse)
      setLocation(mouseX, mouseY);
  }
  
  void display() {
    strokeWeight(1);
    ellipseMode(CENTER);
    fill(c);
    ellipse(x, y, diameter, diameter);
  }
  
  void setLocation(int _x, int _y) {

    line1.updateEndPt(x, y, _x, _y);
    line2.updateEndPt(x, y, _x, _y);

    x = _x;
    y = _y;
  }
  
  boolean contains(int x1, int y1) {
    return sqrt(pow((x1 - x), 2) + pow((y1 - y), 2)) < radius;
  }
  
  void followMouse() {
    followingMouse = true;
  }
  
  void unfollowMouse() {
    followingMouse = false;
  }
}
