class PlayStack extends CardStack {
 
  constructor(maxCapacity, x, y, w, h, suit) {
    super(CardStackTypes.Play, maxCapacity, x, y, w, h);
    this.Suit = suit;
  }
  
  addCard(card) {
    
    card.CanMove = false;
    
    // handle card location
    card.setCoords(this.CoordX, this.TopCardCoordY);
    card.clearSavedCoords();
    
    super.addCard(card);
  }
  
  displayBackgrounds() {
    fill(BACKGROUND_TINT);
    noStroke();
    rect(this.CoordX, this.TopCardCoordY, CARD_WIDTH + MARGIN / 3, CARD_HEIGHT + MARGIN / 3, 10);

    this.displaySymbol();

    stroke(0);
  }

  displaySymbol() {
    fill(SYMBOL_TINT);
    textAlign(CENTER);
    textSize(50);
    text(getSuitLabel(this.Suit), this.CoordX, this.CoordY + 15);
  }
  
  canAddCard(card) {
    
    print(`Stack ${this.StackType} ${this.ID} checking logic for playing ${card.ID}`);
    
    // don't accept hidden cards or cards with children
    if (!card.ShowFace || card.Child != null) {
      return false;
    }
    
    // first card: Ace logic
    if (this.isEmpty()) {
      return card.Suit == this.Suit && card.Number == 1;
    }
    
    // stacking logic
    var topCard = this.topCard();
    return topCard.Suit == card.Suit && topCard.Number + 1 == card.Number;
  }
}
  