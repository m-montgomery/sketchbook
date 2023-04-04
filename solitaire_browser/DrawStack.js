class DrawStack extends CardStack {
 
  constructor(maxCapacity, x, y, w, h) {
    super(CardStackTypes.Draw, maxCapacity, x, y, w, h);
  }
    
  addCard(card) {
    
    card.CanMove = false;
    
    // handle card location
    card.setCoords(this.CoordX, this.TopCardCoordY);
    card.clearSavedCoords();
    
    super.addCard(card);
  }
  
  canAddCard(card) {
    return false;
  }
  
  handleClick(card) {
    
    super.handleClick(card);
    
    let drawCard;

    if (this.isEmpty()) {
      print("Resetting draw deck from discard");
      while (!TheDiscardStack.isEmpty()) {
        drawCard = TheDiscardStack.drawCard();
        drawCard.flip();
        this.addCard(drawCard);
      }
    }
      
    else {
      print("Drawing from deck");
      for (let i = 0; i < 3; i++) {
        drawCard = this.drawCard();
        if (drawCard != null) {
          drawCard.flip();
          TheDiscardStack.addCard(drawCard);
        }
      }
    }
  }
}
