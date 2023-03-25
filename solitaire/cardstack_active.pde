class Activestack extends Cardstack {
 
  Activestack(CardStackType type, int maxCapacity, float x, float y, float w, float h) {
    super(type, maxCapacity, x, y, w, h);
    
    TopCardCoordY = CoordY - (Height / 2) + (MARGIN / 4) + (CARD_HEIGHT / 2);
  }
  
  void addCard(Card card) {
    
    // assign parent-child relationship
    if (!isEmpty()) {
      topCard().child = card;
    }
    
    // handle card location
    var coordY = TopCardCoordY + (OffsetY * Count);
    card.setCoords(CoordX, coordY);
    card.clearSavedCoords();
    
    super.addCard(card);
  }
  
  void removeCard(Card card) {
    
    super.removeCard(card);
    
    // re-enable movement of card beneath
    if (!isEmpty()) {
      var topCard = topCard();
      topCard.child = null;
      topCard.canMove = true;
    }
  }
  
  boolean canAddCard(Card card) {
    
    println(String.format("%s stack %s checking logic for receiving ", StackType, ID, card.ID));
    
    if (isEmpty()) {
      println("Empty stack; card must be a king");
      return card.number == 13;
    }
    
    var topCard = topCard();
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
  
  void handleClick(Card card) {
    
    super.handleClick(card);
    
    if (card == null)
        return;
      
    if (!card.showFace && topCard().ID == card.ID) {
      card.show();
      println("Flipping top card");
    }
  }
}
