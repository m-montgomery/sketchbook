
////////////////////////////////////////////////////
// GraphicObject: generic base class
class GraphicObject {
  
  constructor() {
    this.CoordX = mouseX;
    this.CoordY = mouseY;
  }
  
  display() {}
  
  moveTo(x, y) {
    this.CoordX = x;
    this.CoordY = y;
  }
  
  moveBy(dx, dy) {
    this.CoordX += dx;
    this.CoordY += dy;
  }
}

////////////////////////////////////////////////////
// Cardstock: card background (face)
class Cardstock extends GraphicObject {
  
  constructor(_width, _height) {
    super();
    this.Color = color(CARDSTOCK_COLOR);
    this.CornerAngle = 15;
    this.Width = _width;
    this.Height = _height;
  }
  
  setLocation(x, y) {
    this.CoordX = x;
    this.CoordY = y;
  }
  
  display() {
    rectMode(CENTER);
    fill(this.Color);
    rect(this.CoordX, this.CoordY, this.Width, this.Height, this.CornerAngle);
  }
}

////////////////////////////////////////////////////
// Cardback: card background (back)
class Cardback extends Cardstock {
    constructor(_width, _height) {
    super(_width, _height);
    this.Color = color(CARD_BACKGROUND_COLOR);
  }
}

////////////////////////////////////////////////////
// Cardlabel: text label of card value
class Cardlabel extends GraphicObject {
  
  constructor(text, c, dx, dy) {
    super();
    this.Text = text;
    this.Color = color(c);
    this.Dx = dx;
    this.Dy = dy;
  }
  
  display() {
    fill(this.Color);
    textAlign(CENTER);
    textSize(24);
    text(this.Text, this.CoordX + this.Dx, this.CoordY + this.Dy);
  } 
}

////////////////////////////////////////////////////
// Button
class Button extends GraphicObject {
  
  constructor(x, y, w, h, c) {
    super();
    this.CoordX = x;
    this.CoordY = y;
    this.Width = w;
    this.Height = h;
    this.Color = color(c);
    this.RectAngle = 5;
  }
  
  display() {
    rectMode(CENTER);
    fill(this.Color);
    rect(this.CoordX, this.CoordY, this.Width, this.Height, this.RectAngle);
  }
  
  contains(otherX, otherY) {
    return contains(this.CoordX, this.CoordY, this.Width, this.Height, otherX, otherY);
  }
}

////////////////////////////////////////////////////
// NewGameButton
class NewGameButton extends Button {
  
  constructor(x, y, c) {
    super(x, y, 30, 20, c);
    this.Width = 30;
    this.Height = 20;
    this.CoordY -= this.Height;
  }
  
  display() {
    super.display();
    
    fill(BLACK);
    textAlign(CENTER);
    textSize(12);
    text("New", this.CoordX, this.CoordY + 5);
  }
}
