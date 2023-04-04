class Card {
  
  constructor(x, y, suit, number) {
    this.CoordX = x;
    this.CoordY = y;
    
    this.Suit = suit;
    this.Number = number;

    var numberLabel = getNumberLabel(this.Number);
    var suitLabel = getSuitLabel(this.Suit);

    this.Color = (suitLabel == Suits.Spades || suitLabel == Suits.Clubs) ? BLACK : RED;
    this.ID = `${numberLabel} ${suitLabel}`;
    
    this.CanMove = true;
    this.ShowFace = false;
    
    this.FaceParts = [];
    this.BackParts = [];

    this.addParts(numberLabel, suitLabel);
  }
  
  removeFromStack() {
    this.Stack.removeCard(this);
  }
  
  addPart(part, face) {
    if (face) {
      this.FaceParts.push(part);
    }
    else {
      this.BackParts.push(part);
    }
  }
  
  addParts(numberLabel, suitLabel) {
    
    // add front-facing display objects
    var rightDx = CARD_WIDTH / 3;
    var leftDx = -rightDx;
    var topDy = 22 + (-CARD_HEIGHT / 2);
    var bottomDy = (CARD_HEIGHT / 2) - 7;
    
    this.addPart(new Cardstock(CARD_WIDTH, CARD_HEIGHT), true);    
    this.addPart(new Cardlabel(suitLabel, this.Color, leftDx, topDy), true);
    this.addPart(new Cardlabel(numberLabel, this.Color, rightDx, topDy), true);
    this.addPart(new Cardlabel(numberLabel, this.Color, leftDx, bottomDy), true);
    this.addPart(new Cardlabel(suitLabel, this.Color, rightDx, bottomDy), true);
    for (var part1 of this.FaceParts)
      part1.moveTo(this.CoordX, this.CoordY);
    
    // add back-facing display objects
    this.addPart(new Cardback(CARD_WIDTH, CARD_HEIGHT), false);
    for (var part2 of this.BackParts)
      part2.moveTo(this.CoordX, this.CoordY);
  }
  
  
  flip() {
    this.ShowFace = !this.ShowFace;
    this.Stack.setCardMovement(this);
  }
  
  hide() {
    this.ShowFace = false;
  }
  
  show() {
    this.ShowFace = true;
  }
    
  display() {
    let part;
    if (this.ShowFace) {
      for (part of this.FaceParts) {
        part.display();
      }
    }
    else {
      for (part of this.BackParts) {
        part.display();
      }
    }
  }
  
  displayAll() {
    this.display();
    if (this.Child != null) {
        this.Child.displayAll();
    }
  }
  
  moveBy(dx, dy) {
    let part;
    for (part of this.FaceParts) {
      part.moveBy(dx, dy);
    }
      
    for (part of this.BackParts) {
      part.moveBy(dx, dy);
    }
    
    this.CoordX += dx;
    this.CoordY += dy;
    
    // move child as well
    if (this.Child != null) {
        this.Child.moveBy(dx, dy);
    }
  }

  setCoords(x, y) {
    let part;
    for (part of this.FaceParts) {
      part.moveTo(x, y);
    }
      
    for (part of this.BackParts) {
      part.moveTo(x, y);
    }
      
    this.CoordX = x;
    this.CoordY = y;
  }

  moveTo(x, y) {
    if (this.CanMove) {
      this.setCoords(x, y);
    }
  }
  
  saveCoords() {
    this.MoveDx = this.CoordX - mouseX;
    this.MoveDy = this.CoordY - mouseY;
    this.CoordXHistory = this.CoordX;
    this.CoordYHistory = this.CoordY;
    
    // update child as well
    if (this.Child != null) {
        this.Child.saveCoords();
    }
  }
  
  clearSavedCoords() {
    this.MoveDx = 0;
    this.MoveDy = 0;
    this.CoordXHistory = this.CoordX;
    this.CoordYHistory = this.CoordY;
    
    // update child as well
    if (this.Child != null) {
        this.Child.clearSavedCoords();
    }
  }
  
  returnHome() {
    this.moveTo(this.CoordXHistory, this.CoordYHistory);
    
    // update child card as well
    if (this.Child != null) {
        this.Child.returnHome();
    }
  }
  
  contains(otherX, otherY) {
    return contains(this.CoordX, this.CoordY, CARD_WIDTH, CARD_HEIGHT, otherX, otherY);
  }
}
