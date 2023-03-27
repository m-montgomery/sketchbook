class ActiveStack extends CardStack {
 
  ActiveStack(int maxCapacity, float x, float y, float w, float h) {
    super(CardStackType.Active, maxCapacity, x, y, w, h);
    
    // set special height for active row stacks
    TopCardCoordY = CoordY - (Height / 2) + (MARGIN / 4) + (CARD_HEIGHT / 2);
  }
  
  void addCard(Card card) {
    
    // assign parent-child relationship
    if (!isEmpty()) {
      topCard().Child = card;
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
      topCard.Child = null;
      topCard.CanMove = true;
    }
  }
  
  boolean canAddCard(Card card) {
    
    println(String.format("%s stack %s checking logic for receiving ", StackType, ID, card.ID));
    
    if (isEmpty()) {
      println("Empty stack; card must be a king");
      return card.Number == 13;
    }
    
    var topCard = topCard();
    if (!topCard.ShowFace) {
      println("Top card needs to be flipped over");
      return false;
    }
      
    if (topCard.Number - 1 != card.Number) {
      println(String.format("Card %s does not match top card %s", card.Number, topCard.Number));
      return false;
    }
      
    if (topCard.Color == card.Color) {
      println(String.format("Card %s does not match top card %s", card.Color, topCard.Color));
      return false;
    }
      
    return true;
  }
  
  void handleClick(Card card) {
    
    super.handleClick(card);
    
    if (card == null) {
        return;
    }
      
    if (!card.ShowFace && topCard().ID == card.ID) {
      card.show();
      println("Flipping top card");
    }
  }
}
