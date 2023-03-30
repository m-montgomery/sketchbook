class Card {
  
  String ID;
  Suits Suit;
  int Number;
  color Color;  
  
  ArrayList<Object> FaceParts = new ArrayList();
  ArrayList<Object> BackParts = new ArrayList();
  
  float CoordX;
  float CoordY;
  float CoordXHistory;
  float CoordYHistory;
  float MoveDx;
  float MoveDy;
  
  boolean CanMove;
  boolean ShowFace;
  
  Card Child;
  CardStack Stack;
  
  Card(float x, float y, Suits suit, int number) {
    CoordX = x;
    CoordY = y;
    
    Suit = suit;
    Number = number;
    Color = (Suit == Suits.SPADES || Suit == Suits.CLUBS) ? BLACK : RED;
    
    var numberLabel = getNumberLabel();
    var suitLabel = getSuitLabel();
    ID = String.format("%s %s", numberLabel, Suit);    
    
    CanMove = true;
    ShowFace = false;
    
    // add front-facing display objects
    var rightDx = CARD_WIDTH / 3;
    var leftDx = -rightDx;
    var topDy = 22 + (-CARD_HEIGHT / 2);
    var bottomDy = (CARD_HEIGHT / 2) - 7;
    addPart(new Cardstock(CARD_WIDTH, CARD_HEIGHT), true);    
    addPart(new Cardlabel(suitLabel, Color, leftDx, topDy), true);
    addPart(new Cardlabel(numberLabel, Color, rightDx, topDy), true);
    addPart(new Cardlabel(numberLabel, Color, leftDx, bottomDy), true);
    addPart(new Cardlabel(suitLabel, Color, rightDx, bottomDy), true);
    for (Object part : FaceParts)
      part.moveTo(CoordX, CoordY);
    
    // add back-facing display objects
    addPart(new Cardback(CARD_WIDTH, CARD_HEIGHT), false);
    for (Object part : BackParts)
      part.moveTo(CoordX, CoordY);
  }
  
  void removeFromStack() {
    Stack.removeCard(this);
  }
  
  void addPart(Object part, boolean face) {
    if (face) {
      FaceParts.add(part);
    }
    else {
      BackParts.add(part);
    }
  }
  
  void flip() {
    ShowFace = !ShowFace;
  }
  
  void hide() {
    ShowFace = false;
  }
  
  void show() {
    ShowFace = true;
  }
    
  String getSuitLabel() {
    return SUIT_LABELS.get("" + Suit);
  }
  
  String getNumberLabel() {
    return NUMBER_LABELS.get("" + Number);
  }
  
  void display() {
    if (ShowFace) {
      for (Object part : FaceParts) {
        part.display();
      }
    }
    else {
      for (Object part : BackParts) {
        part.display();
      }
    }
  }
  
  void displayAll() {
    display();
    if (Child != null) {
      Child.displayAll();
    }
  }
  
  void moveBy(float dx, float dy) {
    
    for (Object part : FaceParts) {
      part.moveBy(dx, dy);
    }
      
    for (Object part : BackParts) {
      part.moveBy(dx, dy);
    }
    
    CoordX += dx;
    CoordY += dy;
    
    // move child as well
    if (Child != null) {
      Child.moveBy(dx, dy);
    }
  }

  void setCoords(float x, float y) {
    for (Object part : FaceParts) {
      part.moveTo(x, y);
    }
      
    for (Object part : BackParts) {
      part.moveTo(x, y);
    }
      
    CoordX = x;
    CoordY = y;
  }

  void moveTo(float x, float y) {
    if (CanMove) {
      setCoords(x, y);
    }
  }
  
  void saveCoords() {
    MoveDx = CoordX - mouseX;
    MoveDy = CoordY - mouseY;
    CoordXHistory = CoordX;
    CoordYHistory = CoordY;
    
    // update child as well
    if (Child != null) {
      Child.saveCoords();
    }
  }
  
  void clearSavedCoords() {
    MoveDx = 0;
    MoveDy = 0;
    CoordXHistory = CoordX;
    CoordYHistory = CoordY;
    
    // update child as well
    if (Child != null) {
      Child.clearSavedCoords();
    }
  }
  
  void returnHome() {
    moveTo(CoordXHistory, CoordYHistory);
    
    // update child card as well
    if (Child != null) {
      Child.returnHome();
    }
  }
  
  boolean contains(int otherX, int otherY) {
    int ULX = int(CoordX - CARD_WIDTH/2);
    int ULY = int(CoordY - CARD_HEIGHT/2);
    int LRX = int(CoordX + CARD_WIDTH/2);
    int LRY = int(CoordY + CARD_HEIGHT/2);
    
    return otherX >= ULX && otherX <= LRX &&
           otherY >= ULY && otherY <= LRY;
  }
}
