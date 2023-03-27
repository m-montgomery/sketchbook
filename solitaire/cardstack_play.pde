class PlayStack extends CardStack {
 
  PlayStack(int maxCapacity, float x, float y, float w, float h) {
    super(CardStackType.Play, maxCapacity, x, y, w, h);
  }
  
  void addCard(Card card) {
    
    card.CanMove = false;
    
    // handle card location
    card.setCoords(CoordX, TopCardCoordY);
    card.clearSavedCoords();
    
    super.addCard(card);
  }
  
  void displayBackgrounds() {
    fill(BACKGROUND_TINT);
    noStroke();
    rect(CoordX, TopCardCoordY, CARD_WIDTH + MARGIN / 3, CARD_HEIGHT + MARGIN / 3, 10);
    stroke(0);
  }
  
  boolean canAddCard(Card card) {
    
    println(String.format("%s stack %s checking logic for playing ", StackType, ID, card.ID));
      
    if (!card.ShowFace) {
     return false;
    }
    
    if (card.Child != null) {
      return false;
    }
      
    if (isEmpty()) {
      return card.Number == 1;
    }
        
    var topCard = topCard();
    return topCard.Suit == card.Suit && topCard.Number + 1 == card.Number;
  }
}
