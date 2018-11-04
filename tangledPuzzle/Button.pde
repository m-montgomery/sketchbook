class Button {
  int _x;
  int _y;
  int _width;
  int _height;
  color _color;
  color _textcolor;
  String _text;
  int _textSize;
  
  Button(int x, int y, int w, int h, String t) {
    init(x, y, w, h, t, color(200, 200, 200), 0);
  }
  
  Button(int x, int y, int w, int h, String t, color c1, color c2) {
    init(x, y, w, h, t, c1, c2);
  }
  
  void init(int x, int y, int w, int h, String t, color c1, color c2) {
    _x = x;
    _y = y;
    _width = w;
    _height = h;
    _color = c1;
    _textcolor = c2;
    _text = t;
    _textSize = 20;
  }
  
  void display() {
    rectMode(CENTER);
    fill(_color);
    rect(_x, _y, _width, _height);
    
    textSize(_textSize);
    fill(_textcolor);
    text(_text, _x, _y);
  }
  
  boolean hovering(int x, int y) {
    float rectX1 = _x - (_width/2);
    float rectX2 = rectX1 + _width;
    float rectY1 = _y - (_height/2);
    float rectY2 = rectY1 + _height;
    
    return x >= rectX1 && x <= rectX2 &&
           y >= rectY1 && y <= rectY2;
  }
}
