class DiscardStack extends CardStack {
 
  DiscardStack(int maxCapacity, float x, float y, float w, float h) {
    super(CardStackType.Discard, maxCapacity, x, y, w, h);
  }
  
  void addCard(Card card) {
    
    // update card movement
    if (!isEmpty()) {
      topCard().CanMove = false;
      card.CanMove = true;
    }
    
    // handle card location
    var coordY = TopCardCoordY - OffsetY;
    for (int idx = max(Count - 2, 0); idx < Count; idx++) {
      Cards[idx].setCoords(CoordX, coordY);
      coordY += OffsetY;
    }
    card.setCoords(CoordX, coordY);
    card.clearSavedCoords();
    
    super.addCard(card);
  }
  
  void removeCard(Card card) {
    
    super.removeCard(card);
    
    // re-enable movement of card beneath
    if (!isEmpty()) {
      var topCard = topCard();
      topCard.Child = null;
      topCard.CanMove = true;
    }
  }
  
  void display() {
    
    //debugDisplay();
    
    displayBackgrounds();
    
    // display max 3 at a time
    for (int idx = max(Count - 3, 0); idx < Count; idx++) {
      Cards[idx].display();
    }
  }
  
  boolean canAddCard(Card card) {
    return false;
  }
}
