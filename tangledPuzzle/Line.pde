class Line {

  // endpoint coordinates
  int x1;
  int y1;
  int x2;
  int y2;
  
  color c = 50;
  
  int ID;
  
  Line(int _x1, int _y1, int _x2, int _y2, int id) {
    init(_x1, _y1, _x2, _y2, id, 50);
  }
  
  Line(int _x1, int _y1, int _x2, int _y2, int id, color _c) {
    init(_x1, _y1, _x2, _y2, id, _c);
  }
  
  void init(int _x1, int _y1, int _x2, int _y2, int id, color _c) {
    c = _c;
    ID = id;
    setLocation(_x1, _y1, _x2, _y2);
  }
  
  void display() {
    stroke(c);
    strokeWeight(2);
    line(x1, y1, x2, y2);
  }
  
  void setLocation(int _x1, int _y1, int _x2, int _y2) {
    x1 = _x1;
    y1 = _y1;
    x2 = _x2;
    y2 = _y2;
  }
  
  void updateEndPt(int _x1, int _y1, int _x2, int _y2) {
    if (_x1 == x1 && _y1 == y1) {
      x1 = _x2;
      y1 = _y2;
    }
    else {
      x2 = _x2;
      y2 = _y2;
    }
  }
  
  boolean crosses(Line other) {
    
    // lines that share an endpoint do not cross
    if ((x1 == other.x1 && y1 == other.y1) ||
        (x2 == other.x1 && y2 == other.y1))
      return false;
        
    // check for intersection (see if x1,y1 and x2,y2 are on opposite
    // sides of the other Line)
    float left  = (other.x2 - other.x1) * (y1 - other.y2) - 
                  (other.y2 - other.y1) * (x1 - other.x2);
    float right = (other.x2 - other.x1) * (y2 - other.y2) - 
                  (other.y2 - other.y1) * (x2 - other.x2);
    return (left < 0 && right >= 0) || (left >= 0 && right < 0);
  }
}
