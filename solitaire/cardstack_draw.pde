class Drawstack extends Cardstack {
 
  Drawstack(CardStackType type, int maxCapacity, float x, float y, float w, float h) {
    super(type, maxCapacity, x, y, w, h);
  }
    
  void addCard(Card card) {
    
    card.canMove = false;
    
    // handle card location
    card.setCoords(CoordX, TopCardCoordY);
    card.clearSavedCoords();
    
    super.addCard(card);
  }
  
  boolean canAddCard(Card card) {
    return false;
  }
  
  void handleClick(Card card) {
    
    super.handleClick(card);
    
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
