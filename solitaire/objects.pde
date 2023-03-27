
////////////////////////////////////////////////////
// Object: generic base class
abstract class Object {
  
  float CoordX;
  float CoordY;
  
  Object() {
    CoordX = mouseX;
    CoordY = mouseY;
  }
  
  void display() {}
  
  void moveTo(float x, float y) {
    CoordX = x;
    CoordY = y;
  }
  
  void moveBy(float dx, float dy) {
    CoordX += dx;
    CoordY += dy;
  }
}

////////////////////////////////////////////////////
// Cardstock: card background (face)
class Cardstock extends Object {
  
  color Color = CARDSTOCK_COLOR;
  
  float Width;
  float Height;
  
  int CornerAngle = 15;
  
  Cardstock(float _width, float _height) {
    Width = _width;
    Height = _height;
  }
  
  void setLocation(float x, float y) {
    CoordX = x;
    CoordY = y;
  }
  
  void display() {
    rectMode(CENTER);
    fill(Color);
    rect(CoordX, CoordY, Width, Height, CornerAngle);
  }
}

////////////////////////////////////////////////////
// Cardback: card background (back)
class Cardback extends Cardstock {
  Cardback(float _width, float _height) {
    super(_width, _height);
    Color = CARD_BACKGROUND_COLOR;
  }
}

////////////////////////////////////////////////////
// Cardlabel: text label of card value
class Cardlabel extends Object {
  
  String Text;
  color Color;
  float Dx;    // offset from card center
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
    text(Text, CoordX + Dx, CoordY + Dy);
  } 
}
