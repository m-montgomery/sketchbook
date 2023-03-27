enum CardStackType {
  Active,  // 7 active stacks for moving cards around
  Play,    // 4 stacks for achieving win state
  Draw,    // deck of remaining cards
  Discard  // discard of Draw deck
} 

abstract class CardStack {
 
  int ID;
  CardStackType StackType;
  
  int MaxCapacity;
  int Count = 0;
  
  float CoordX;
  float CoordY;
  float OffsetY;       // distance between cards when not stacked
  float Width;
  float Height;
  float TopCardCoordY;
  
  Card[] Cards;
  
  CardStack(CardStackType type, int maxCapacity, float x, float y, float w, float h) {
    ID = STACK_COUNT++;
    StackType = type;
    
    MaxCapacity = maxCapacity;
    CoordX = x;
    CoordY = y;
    TopCardCoordY = y;
    Width = w;
    Height = h;
    
    OffsetY = CARD_HEIGHT / CARD_STACK_OFFSET_RATIO;
    
    Cards = new Card[MaxCapacity];
  }
  
  boolean hasRoom() {
    return Count < MaxCapacity;
  }
  
  boolean isEmpty() {
    return Count == 0;
  }
  
  boolean isFull() {
    return !hasRoom();
  }
  
  void disable() {
    for (int i = 0; i < Count; i++) {
      Cards[i].CanMove = false;
    }
  }
  
  void addCard(Card card) {
    
    card.Stack = this;
    Cards[Count++] = card;
    
    println(String.format("Added card %s to %s stack %s", card.ID, StackType, ID));
    
    if (card.Child != null) {
      addCard(card.Child);
    }
  }
  
  void removeCard(Card card) {
    
    println(String.format("Removing card %s%s from %s stack %s", card.ID, (card.Child == null ? "" : " and children"), StackType, ID));
    
    // locate card to remove
    int idx;
    var foundCard = false;
    for (idx = Count - 1; idx >= 0 && !foundCard; idx--) {
      if (Cards[idx].ID == card.ID) {
        foundCard = true;
        idx++;
      }
    }
    if (!foundCard) {
      println("Card not found");
      return;
    }
    
    // remove card and its children
    for (var count = Count; idx < count; idx++, Count--) {
      Cards[idx] = null;
    }
  }
  
  Card findCardAt(int x, int y) {
    for (int i = Count - 1; i >= 0; i--) {
        if (Cards[i].contains(x, y)) {
          return Cards[i];
        }
      }
    return null;
  }
  
  void debugDisplay() {
    
    // draw border around boundaries
    fill(215);
    if (contains(mouseX, mouseY)) {
      fill(150);
    }
    rectMode(CENTER);
    rect(CoordX, CoordY, Width, Height);
    
    // draw stack ID
    fill(0);
    textSize(18);
    text(ID, CoordX - (Width / 2) + 9, CoordY - (Height / 2) + 16);
  }
  
  void displayBackgrounds() {
    
    if (!isEmpty()) {
      return;
    }
      
    fill(BACKGROUND_TINT);
    noStroke();
    rect(CoordX, TopCardCoordY, CARD_WIDTH + MARGIN / 3, CARD_HEIGHT + MARGIN / 3, 10);
    stroke(0);
  }
  
  void display() {
    
    //debugDisplay();
    
    displayBackgrounds();
    
    for (int i = 0; i < Count; i++) {
      Cards[i].display(); // will draw atop each other
    }
  }
  
  Card drawCard() {
    var card = topCard();
    if (card != null) {
      Cards[--Count] = null;
    }
    return card;
  }
  
  Card topCard() {
    return isEmpty() ? null : Cards[Count - 1];
  }
  
  void flipDeck() {
    var cards = new Card[Count];
    for (int i = 0; i < Count; i++) {
      cards[i] = Cards[Count - i - 1];
      cards[i].flip();
    }
    Cards = cards;
  }
  
  boolean contains(float otherX, float otherY) {
    var ULX = CoordX - (Width/2);
    var ULY = CoordY - (Height/2);
    var LRX = CoordX + (Width/2);
    var LRY = CoordY + (Height/2);
    
    return otherX >= ULX && otherX <= LRX &&
           otherY >= ULY && otherY <= LRY;
  }
  
  boolean canAddCard(Card card) {
    return true; //<>//
  }
  
  void handleClick(Card card) {
    println(String.format("%s stack %s clicked", StackType, ID));
  }
}
