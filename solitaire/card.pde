enum Suit {
  DIAMONDS, 
  CLUBS,
  HEARTS, 
  SPADES
}

StringDict SUIT_LABELS = new StringDict(new String[][] {
  {"DIAMONDS", "♦"},
  {"CLUBS",    "♣"},
  {"HEARTS",   "❤"},
  {"SPADES",   "♠"},
});

StringDict NUMBER_LABELS = new StringDict(new String[][] {
  {  "1", "A" },
  { "11", "J" },
  { "12", "Q" },
  { "13", "K" },
});

final color RED = #d82e0d;

final int CARD_WIDTH  = 114; // 571
final int CARD_HEIGHT = 178; // 889
final int CARD_STACK_OFFSET_RATIO = 7; // display top 7th of card when stacked

class Card {
  
  Suit suit;
  int number;
  String ID;
  
  ArrayList<Object> faceParts = new ArrayList();
  ArrayList<Object> backParts = new ArrayList();
  
  float coordX;
  float coordY;
  float coordZ;
  
  float origCoordX;
  float origCoordY;
  float origCoordZ;
  
  boolean canMove;
  boolean showFace;
  
  Card child;
  Cardstack stack;
  
  Card(float tempX, float tempY, Suit s, int num) {
    coordX = tempX;
    coordY = tempY;
    coordZ = 1;
    
    suit = s;
    number = num;
    ID = String.format("%s %s", getNumberLabel(), suit);
    
    canMove = true;
    showFace = false;
    
    // add front-facing display objects
    var rightdx = CARD_WIDTH / 3;
    var leftdx = -rightdx;
    var topdy = 22 + (-CARD_HEIGHT / 2);
    var bottomdy = (CARD_HEIGHT / 2) - 7;
    addPart(new Cardstock(CARD_WIDTH, CARD_HEIGHT), true);    
    addPart(new Cardlabel(getSuitLabel(), getColor(), leftdx, topdy), true);
    addPart(new Cardlabel(getNumberLabel(), getColor(), rightdx, topdy), true);
    addPart(new Cardlabel(getNumberLabel(), getColor(), leftdx, bottomdy), true);
    addPart(new Cardlabel(getSuitLabel(), getColor(), rightdx, bottomdy), true);
    for (Object part : faceParts)
      part.moveTo(coordX, coordY);
    
    // add back-facing display objects
    addPart(new Cardback(CARD_WIDTH, CARD_HEIGHT), false);
    for (Object part : backParts)
      part.moveTo(coordX, coordY);
  }
  
  void removeFromStack() {
    stack.removeCard(this);
  }
  
  void addPart(Object part, boolean face) {
    if (face)
      faceParts.add(part);
    else
      backParts.add(part);
  }
  
  void flip() {
    showFace = !showFace;
  }
  
  void hide() {
    showFace = false;
  }
  
  void show() {
    showFace = true;
  }
  
  color getColor() {
    if (suit == Suit.SPADES || suit == Suit.CLUBS)
      return #000000;
    return RED;
  }
  
  String getSuitLabel() {
    return SUIT_LABELS.get("" + suit);
  }
  
  String getNumberLabel() {
    var numberStr = "" + number;
    if (number == 1 || number > 10)
      return NUMBER_LABELS.get(numberStr);
    return numberStr;
  }
  
  void display() {
    if (showFace) {
      for (Object part : faceParts)
        part.display();
    }
    else {
      for (Object part : backParts)
        part.display();
    }
  }
  
  void displayAll() {
    display();
    if (child != null)
      child.displayAll();
  }
  
  void setZ(float z) {
    coordZ = z;
  }
  
  void selected() {
    coordZ = 100;
  }
  
  void deselected() {
    coordZ = 1;
  }
  
  void moveBy(float dx, float dy) {
    
    for (Object part : faceParts)
      part.moveBy(dx, dy);
      
    for (Object part : backParts)
      part.moveBy(dx, dy);
    
    coordX += dx;
    coordY += dy;
    
    // move child as well
    if (child != null)
      child.moveBy(dx, dy);
  }

  void setCoords(float x, float y) {
    for (Object part : faceParts)
      part.moveTo(x, y);
      
    for (Object part : backParts)
      part.moveTo(x, y);
      
    coordX = x;
    coordY = y;
  }

  void moveTo(float x, float y) {
    if (canMove) 
      setCoords(x, y);
  }
  
  void saveCoords() {
    origCoordX = coordX;
    origCoordY = coordY;
    origCoordZ = coordZ;
    
    // update child as well
    if (child != null)
      child.saveCoords();
  }
  
  void clearSavedCoords() {
    origCoordX = coordX;
    origCoordY = coordY;
    origCoordZ = coordZ;
    
    // update child as well
    if (child != null)
      child.clearSavedCoords();
  }
  
  void returnHome() {
    moveTo(origCoordX, origCoordY);
    coordZ = origCoordZ;
    
    // update child card as well
    if (child != null)
      child.returnHome();
  }
  
  boolean contains(int otherX, int otherY) {
    int ULX = int(coordX - CARD_WIDTH/2);
    int ULY = int(coordY - CARD_HEIGHT/2);
    int LRX = int(coordX + CARD_WIDTH/2);
    int LRY = int(coordY + CARD_HEIGHT/2);
    
    return otherX >= ULX && otherX <= LRX &&
           otherY >= ULY && otherY <= LRY;
  }
}
