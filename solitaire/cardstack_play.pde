class Playstack extends Cardstack {
 
  Playstack(CardStackType type, int maxCapacity, float x, float y, float w, float h) {
    super(type, maxCapacity, x, y, w, h);
  }
  
  void addCard(Card card) {
    
    card.canMove = false;
    
    // handle card location
    card.setCoords(CoordX, TopCardCoordY);
    card.clearSavedCoords();
    
    super.addCard(card);
  }
  
  void displayBackgrounds() {
    fill(PlayStackColor);
    noStroke();
    rect(CoordX, TopCardCoordY, CARD_WIDTH + MARGIN / 3, CARD_HEIGHT + MARGIN / 3, 10);
    stroke(0);
  }
  
  boolean canAddCard(Card card) {
    
    println(String.format("%s stack %s checking logic for playing ", StackType, ID, card.ID));
      
    if (!card.showFace)
     return false;
    
    if (card.child != null)
      return false;
      
    if (isEmpty())
      return card.number == 1;
        
    var topCard = topCard();
    return topCard.suit == card.suit && topCard.number + 1 == card.number;
  }
}
