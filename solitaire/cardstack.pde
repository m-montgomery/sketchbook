enum CardStackType {
  Active,  // 7 active stacks for moving cards around
  Play,    // 4 stacks for achieving win state
  Draw,    // deck of remaining cards
  Discard  // discard of Draw deck
} 

class Cardstack {
 
  int ID;
  CardStackType StackType;
  
  boolean StackedAtop;    // whether cards are stacked directly atop each other
  boolean CanReceive;     // whether pile can have cards dropped to it
  boolean StackAlternate; // whether to stack red/black descending
  
  int MaxCapacity;
  int Count = 0;
  
  float CoordX;
  float CoordY;
  float OffsetY;       // distance between cards when not stacked
  float Width;
  float Height;
  float TopCardCoordY;
  
  color PlayStackColor = #0a4f05;
  
  Card[] Cards;
  
  Cardstack(CardStackType type, int maxCapacity, boolean stack, boolean canReceive, boolean stackAlternate, float x, float y, float w, float h) {
    ID = STACK_COUNT++;
    StackType = type;
    
    MaxCapacity = maxCapacity;
    StackedAtop = stack;
    CoordX = x;
    CoordY = y;
    Width = w;
    Height = h;
    
    CanReceive = canReceive;
    StackAlternate = stackAlternate;
    
    OffsetY = CARD_HEIGHT / CARD_STACK_OFFSET_RATIO;
    
    if (StackType == CardStackType.Active) 
      TopCardCoordY = CoordY - (Height / 2) + (MARGIN / 4) + (CARD_HEIGHT / 2);
    else
      TopCardCoordY = CoordY;
    
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
    for (int i = 0; i < Count; i++)
      Cards[i].canMove = false;
  }
  
  void addCard(Card card) {
    
    // assign parent-child relationship
    if (StackType == CardStackType.Active && !isEmpty()) {
      topCard().child = card;
    }
    
    // update card movement
    if (StackType == CardStackType.Draw || StackType == CardStackType.Play)
      card.canMove = false;
    else if (StackType == CardStackType.Discard) {
      if (!isEmpty())
        topCard().canMove = false;
      card.canMove = true;
    }
    
    card.stack = this;
    Cards[Count++] = card;
    
    // handle card location
    var coordY = TopCardCoordY;
    if (!StackedAtop) {
      
      // offset discard cards to top-3
      if (StackType == CardStackType.Discard) {
        coordY -= OffsetY;
        for (int idx = max(Count - 3, 0); idx < Count - 1; idx++) {
          Cards[idx].setCoords(CoordX, coordY);
          coordY += OffsetY;
        }
      }
      // offset cards
      else {
        coordY += (OffsetY * (Count - 1));
      }
    }
    card.setCoords(CoordX, coordY);
    card.setZ(Count);
    card.clearSavedCoords();
    
    println(String.format("Added card %s to %s stack %s", card.ID, StackType, ID));
    
    if (card.child != null)
      addCard(card.child);
  }
  
  void removeCard(Card card) {
    
    println(String.format("Removing card %s%s from %s stack %s", card.ID, (card.child == null ? "" : " and children"), StackType, ID));
    
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
    
    // re-enable movement of card beneath
    if ((StackType == CardStackType.Active ||
         StackType == CardStackType.Discard) && 
         !isEmpty()) {
      var topCard = topCard();
      topCard.child = null;
      topCard.canMove = true;
    }
  }
  
  Card findCardAt(int x, int y) {
    for (int i = Count - 1; i >= 0; i--) {
        if (Cards[i].contains(x, y))
          return Cards[i];
      }
    return null;
  }
  
  void debugDisplay() {
    
    // draw border around boundaries
    fill(215);
    if (contains(mouseX, mouseY))
      fill(150);
    rectMode(CENTER);
    rect(CoordX, CoordY, Width, Height);
    
    // draw stack ID
    fill(0);
    textSize(18);
    text(ID, CoordX - (Width / 2) + 9, CoordY - (Height / 2) + 16);
  }
  
  void displayBackgrounds() {
    
    fill(PlayStackColor);
    noStroke();
    
    if (StackType == CardStackType.Play || isEmpty()) {
      rect(CoordX, TopCardCoordY, CARD_WIDTH + MARGIN / 3, CARD_HEIGHT + MARGIN / 3, 10);
    }
    
    stroke(0);
  }
  
  void display() {
    
    //debugDisplay();
    
    displayBackgrounds();
    
    if (isEmpty())
      return;
    
    // display discard stack 3 at a time
    if (StackType == CardStackType.Discard) {
      for (int idx = max(Count - 3, 0); idx < Count; idx++) {
        Cards[idx].display();
      }
    }
    
    // display cards as 1 stack
    else if (StackedAtop) {
      if (Count > 1)
        Cards[Count-2].display(); // display 2nd top card as well in case of top card movement
      Cards[Count-1].display();
    }
    
    // display cards as offset stack
    else {
      for (int i = 0; i < Count; i++) {
        Cards[i].display(); // will draw atop each other
      }
    }
  }
  
  Card drawCard() {
    var card = topCard();
    if (card != null)
      Cards[--Count] = null;
    return card;
  }
  
  Card topCard() {
    if (isEmpty())
      return null;
    return Cards[Count - 1];
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
    if (!CanReceive) {
      println(String.format("%s stack %s can't receive cards", StackType, ID));
      return false;
    } //<>//
    
    // active stack logic: cards alternate color, descending order
    var topCard = topCard();
    if (StackType == CardStackType.Active) {
      println(String.format("%s stack %s checking logic for receiving ", StackType, ID, card.ID));
      
      if (isEmpty()) {
        println("Empty stack; card must be a king");
        return card.number == 13;
      }
      
      if (!topCard.showFace) {
        println("Top card needs to be flipped over");
        return false;
      }
      
      if (topCard.number - 1 != card.number) {
        println(String.format("Card %s does not match top card %s", card.number, topCard.number));
        return false;
      }
      
      if (topCard.getColor() == card.getColor()) {
        println(String.format("Card %s does not match top card %s", card.getColor(), topCard.getColor()));
        return false;
      }
      
      return true;
    }
    
    // play stack logic: cards match suit, ascending order
    else if (StackType == CardStackType.Play) {
      println(String.format("%s stack %s checking logic for playing ", StackType, ID, card.ID));
      
      if (!card.showFace)
        return false;
      
      if (card.child != null)
        return false;
      
      if (isEmpty())
        return card.number == 1;
        
      return topCard.suit == card.suit && topCard.number + 1 == card.number;
    }
    
    return false;
  }
  
  void handleClick(Card card) {
    
    println(String.format("%s stack %s clicked", StackType, ID));
    
    // handle click on active stack
    if (StackType == CardStackType.Active) {
      if (card == null)
        return;
      
      if (!card.showFace && topCard().ID == card.ID)
        card.show();
        println("Flipping top card");
    }
    
    // handle click on draw deck
    else if (StackType == CardStackType.Draw) {
      
      if (isEmpty()) {
        println("Resetting draw deck from discard");
        while (!DiscardStack.isEmpty()) {
          var drawCard = DiscardStack.drawCard();
          drawCard.flip();
          addCard(drawCard);
        }
      }
      
      else {
        println("Drawing from deck");
        for (int i = 0; i < 3; i++) {
          var drawCard = drawCard();
          if (drawCard != null) {
            drawCard.flip();
            DiscardStack.addCard(drawCard);
          }
        }
      }
    }
  }
}
