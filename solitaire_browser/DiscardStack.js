class DiscardStack extends CardStack {
 
  constructor(maxCapacity, x, y, w, h) {
    super(CardStackTypes.Discard, maxCapacity, x, y, w, h);
  }
  
  addCard(card) {
    
    // update card movement
    if (!this.isEmpty()) {
      this.topCard().CanMove = false;
      card.CanMove = true;
    }
    
    // handle card location
    var coordY = this.TopCardCoordY - this.OffsetY;
    for (let idx = max(this.Count - 2, 0); idx < this.Count; idx++) {
        this.Cards[idx].setCoords(this.CoordX, coordY);
      coordY += this.OffsetY;
    }
    card.setCoords(this.CoordX, coordY);
    card.clearSavedCoords();
    
    super.addCard(card);
  }
  
  removeCard(card) {
    
    super.removeCard(card);
    
    // re-enable movement of card beneath
    if (!this.isEmpty()) {
      var topCard = this.topCard();
      topCard.Child = null;
      topCard.CanMove = true;
    }
  }
  
  display() {
    
    //this.debugDisplay();
    
    this.displayBackgrounds();
    
    // display max 3 at a time
    for (let idx = max(this.Count - 3, 0); idx < this.Count; idx++) {
        this.Cards[idx].display();
    }
  }
  
  canAddCard(card) {
    return false;
  }
}
