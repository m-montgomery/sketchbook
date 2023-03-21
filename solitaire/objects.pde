
////////////////////////////////////////////////////
// Object: generic base class
class Object {
  float coordX;
  float coordY;
  float coordZ;
  
  Object() {
    coordX = mouseX;
    coordY = mouseY;
  }
  
  void display() {}
  
  void moveTo(float x, float y) {
    coordX = x;
    coordY = y;
  }
  
  void moveBy(float dx, float dy) {
    coordX += dx;
    coordY += dy;
  }
}

////////////////////////////////////////////////////
// Cardstock: card background
class Cardstock extends Object {
  color Color = 250;
  float Width;
  float Height;
  
  int Corner = 15;
  
  Cardstock(float _width, float _height) {
    Width = _width;
    Height = _height;
  }
  
  void setLocation(float xx, float yy) {
    coordX = xx;
    coordY = yy;
  }
  
  void display() {
    rectMode(CENTER);
    fill(Color);
    rect(coordX, coordY, Width, Height, Corner);
  }
}

////////////////////////////////////////////////////
// Cardback: card background of flipped card
class Cardback extends Cardstock {
  
  Cardback(float _width, float _height) {
    super(_width, _height);
    Color = #231d77;
  }
}

////////////////////////////////////////////////////
// Cardlabel: text label of card value
class Cardlabel extends Object {
  
  String Text;
  color Color;
  float Dx;
  float Dy;
  
  Cardlabel(String text, color c, float dx, float dy) {
    Text = text;
    Color = c;
    Dx = dx;
    Dy = dy;
  }
  
  void display() {
    fill(Color);
    textAlign(CENTER);
    textFont(createFont("SansSerif", 24));
    text(Text, coordX + Dx, coordY + Dy);
  } 
}
