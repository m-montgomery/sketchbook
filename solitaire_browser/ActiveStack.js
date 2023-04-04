class ActiveStack extends CardStack {
 
  constructor(maxCapacity, x, y, w, h) {
    super(CardStackTypes.Active, maxCapacity, x, y, w, h);
    
    // set special height for active row stacks
    this.TopCardCoordY = this.CoordY - (this.Height / 2) + (MARGIN / 4) + (CARD_HEIGHT / 2);
  }
  
  addCard(card) {
    
    // assign parent-child relationship
    if (!this.isEmpty()) {
      let topCard = this.topCard();
      topCard.Child = card;
    }

    // handle card location, movement
    var coordY = this.TopCardCoordY + (this.OffsetY * this.Count);
    card.setCoords(this.CoordX, coordY);
    card.clearSavedCoords();
    this.setCardMovement(card);
    
    super.addCard(card);
  }
  
  removeCard(card) {
    
    super.removeCard(card);
    
    // re-enable movement of card beneath
    if (!this.isEmpty()) {
      var topCard = super.topCard();
      topCard.Child = null;
      this.setCardMovement(topCard);
    }
  }
  
  canAddCard(card) {
    
    print(`Stack ${this.StackType} ${this.ID} checking logic for receiving ${card.ID}`);
    
    if (this.isEmpty()) {
      print("Empty stack; card must be a king");
      return card.Number == 13;
    }
    
    var topCard = super.topCard();
    if (!topCard.ShowFace) {
      print("Top card needs to be flipped over");
      return false;
    }
      
    if (topCard.Number - 1 != card.Number) {
      print(`Card ${card.Number} cannot stack on top card ${topCard.Number}`);
      return false;
    }
      
    if (topCard.Color == card.Color) {
      print(`Card color ${card.Color} matches top card color ${topCard.Color}`);
      return false;
    }
      
    return true;
  }
  
  setCardMovement(card) {
    card.CanMove = card.ShowFace;
  }

  handleClick(card) {
    
    super.handleClick(card);
    
    if (card == null) {
        return;
    }
      
    if (!card.ShowFace && super.topCard().ID == card.ID) {
      print("Flipping top card");
      card.flip();
    }
  }
}
