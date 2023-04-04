class CardStack {
 
  constructor(type, maxCapacity, x, y, w, h) {
    this.ID = STACK_COUNT++;
    this.StackType = type;
    this.MaxCapacity = maxCapacity;
    this.Count = 0;
    this.CoordX = x;
    this.CoordY = y;
    this.TopCardCoordY = y;
    this.Width = w;
    this.Height = h;
    this.OffsetY = CARD_HEIGHT / CARD_STACK_OFFSET_RATIO;
    this.Cards = [];
  }
  
  hasRoom() {
    return this.Count < this.MaxCapacity;
  }
  
  isEmpty() {
    return this.Count == 0;
  }
  
  isFull() {
    return !this.hasRoom();
  }
  
  disable() {
    for (let i = 0; i < this.Count; i++) {
      this.Cards[i].CanMove = false;
    }
  }
  
  addCard(card) {
    
    card.Stack = this;
    this.Cards[this.Count++] = card;
    
    //print(`Added card ${card.ID} to stack ${this.StackType} ${this.ID}`);
    
    if (card.Child != null) {
      this.addCard(card.Child);
    }
  }
  
  removeCard(card) {
    
    print(`Removing card ${card.ID} ${(card.Child == null ? "" : " and children")} from stack ${this.StackType} ${this.ID}`);
    
    // locate card to remove
    let idx;
    var foundCard = false;
    for (idx = this.Count - 1; idx >= 0 && !foundCard; idx--) {
      if (this.Cards[idx].ID == card.ID) {
        foundCard = true;
        idx++;
      }
    }
    if (!foundCard) {
      print("Card not found");
      return;
    }
    
    // remove card and its children
    for (var count = this.Count; idx < count; idx++, this.Count--) {
        this.Cards[idx] = null;
    }
  }
  
  findCardAt(x, y) {
    for (let i = this.Count - 1; i >= 0; i--) {
        if (this.Cards[i].contains(x, y)) {
          return this.Cards[i];
        }
      }
    return null;
  }

  setCardMovement(card) {}
  
  debugDisplay() {
    
    // draw border around boundaries
    fill(215);
    if (this.contains(mouseX, mouseY)) {
      fill(150);
    }
    rectMode(CENTER);
    rect(this.CoordX, this.CoordY, this.Width, this.Height);
    
    // draw stack ID
    fill(0);
    textSize(18);
    text(this.ID, this.CoordX - (this.Width / 2) + 9, this.CoordY - (this.Height / 2) + 16);
  }
  
  displayBackgrounds() {
    
    if (!this.isEmpty()) {
      return;
    }
      
    fill(BACKGROUND_TINT);
    noStroke();
    rect(this.CoordX, this.TopCardCoordY, CARD_WIDTH + MARGIN / 3, CARD_HEIGHT + MARGIN / 3, 10);
    stroke(0);
  }
  
  display() {
    
    //this.debugDisplay();
    
    this.displayBackgrounds();
    
    for (let i = 0; i < this.Count; i++) {
        this.Cards[i].display(); // will draw atop each other
    }
  }
  
  topCard() {
    return this.isEmpty() ? null : this.Cards[this.Count - 1];
  }
  
  drawCard() {
    var card = this.topCard();
    if (card != null) {
        this.Cards[--this.Count] = null;
    }
    return card;
  }
  
  flipDeck() {
    var cards = [];
    for (let i = 0; i < this.Count; i++) {
      cards[i] = this.Cards[this.Count - i - 1];
      cards[i].flip();
    }
    this.Cards = cards;
  }
  
  contains(otherX, otherY) {
    return contains(this.CoordX, this.CoordY, this.Width, this.Height, otherX, otherY);
  }
  
  canAddCard(card) {
    return true;
  }
  
  handleClick(card) {
    print(`Stack ${this.StackType} ${this.ID} clicked`);
  }
}
