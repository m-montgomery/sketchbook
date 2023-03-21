
final int ACTIVE_STACK_COUNT = 7;
final int PLAY_STACK_COUNT = 4;
final int MAX_STACKED_CARDS = 19;
final int MARGIN = 20;
int STACK_COUNT = 0;

ArrayList<Card> Deck = new ArrayList<Card>();

Cardstack[] ActiveStacks = new Cardstack[ACTIVE_STACK_COUNT];
Cardstack[] PlayStacks = new Cardstack[PLAY_STACK_COUNT];
Cardstack DiscardStack;
Cardstack DrawStack;
ArrayList<Cardstack> Stacks = new ArrayList<Cardstack>();

boolean GameOver = false;

Card SelectedCard;


void setup() {
  size(1050, 920);
  
  initDeck();
  
  // define size of areas
  var StackWidth = width / 7;
  var StackWidthHalved = StackWidth / 2;
  var ActiveStackHeight = MARGIN + CARD_HEIGHT + ((CARD_HEIGHT / CARD_STACK_OFFSET_RATIO) * (MAX_STACKED_CARDS - 1));
  var PlayStackHeight = height - ActiveStackHeight;
  var PlayStackCoordY = PlayStackHeight / 2;
  var ActiveStackCoordY = height - (ActiveStackHeight / 2);
  
  // create play stacks
  for (int i = 0; i < PLAY_STACK_COUNT; i++) {
    PlayStacks[i] = new Cardstack(CardStackType.Play, 13, true, true, false, (i * StackWidth) + StackWidthHalved, PlayStackCoordY, StackWidth, PlayStackHeight);
    
    Stacks.add(PlayStacks[i]);
  }
  
  // create draw and discard stacks
  DiscardStack = new Cardstack(CardStackType.Discard, 52, false, false, false, (5 * StackWidth) + StackWidthHalved, PlayStackCoordY, StackWidth, PlayStackHeight);
  DrawStack = new Cardstack(CardStackType.Draw, 52, true, false, false, (6 * StackWidth) + StackWidthHalved, PlayStackCoordY, StackWidth, PlayStackHeight);
  Stacks.add(DiscardStack);
  Stacks.add(DrawStack);
  
  // create active stacks
  for (int i = 0; i < ACTIVE_STACK_COUNT; i++) {
    ActiveStacks[i] = new Cardstack(CardStackType.Active, MAX_STACKED_CARDS + i, false, true, true, (i * StackWidth) + StackWidthHalved, ActiveStackCoordY, StackWidth, ActiveStackHeight);//85 + (i * StackWidth), PlayStackHeight, StackWidth, ActiveStackHeight);
    
    // deal hidden card stacks
    for (int j = 0; j < i; j++) {
      var card = dealCard(); 
      card.hide();
      ActiveStacks[i].addCard(card);
    }
    
    // deal shown card
    var card = dealCard();
    card.show();
    ActiveStacks[i].addCard(card);
    
    Stacks.add(ActiveStacks[i]);
  }
  
  // deal remaining deck to draw stack
  Card card = dealCard();
  while (card != null) {
    DrawStack.addCard(card);
    card.hide();
    card = dealCard();
  }
}

void initDeck() {
  var suits = new Suit[] { Suit.DIAMONDS, Suit.CLUBS, Suit.HEARTS, Suit.SPADES };
  for (Suit suit : suits ) {
    for (int num = 1; num <= 13; num++) {
      Deck.add(new Card(0, 0, suit, num));
    }
  }
}

Card dealCard() {
  if (Deck.isEmpty())
    return null;
  
  return Deck.remove(int(random(Deck.size())));
}

void checkForWin() {
  var win = true;
  for (int i = 0; i < PLAY_STACK_COUNT; i++) {
    if (!PlayStacks[i].isFull())
      win = false;
  }
  
  if (win) {
    println("Win detected");
    GameOver = true;
    
    for (Cardstack stack : Stacks) {
      stack.disable();
    }
  }
}

void draw() {
  background(#0c6006);
  
  for (Cardstack stack : Stacks)
    stack.display();
  
  // if moving a card, ensure it draws over everything else
  if (SelectedCard != null && SelectedCard.canMove)
    SelectedCard.displayAll();
    
  if (GameOver) {
    fill(240);
    textSize(100);
    textAlign(CENTER);
    text("You won!", width / 2, height / 2);
  }
}

Card findCardAtMouse() {
 Card card;
 for (Cardstack stack : Stacks) {
   card = stack.findCardAt(mouseX, mouseY);
   if (card != null) {
      return card;
   }
 }
 return null;
}

void mousePressed() {
  SelectedCard = findCardAtMouse();
  if (SelectedCard != null)
    SelectedCard.saveCoords(); 
}

void mouseReleased() {
  
  // move any selected card to correct spot
  var movedToStack = false;
  for (Cardstack stack : Stacks) {
    if (stack.contains(mouseX, mouseY)) {
      
      // with active card
      if (SelectedCard != null) {
        
        // handle click on same stack
        if (stack.ID == SelectedCard.stack.ID) {
          stack.handleClick(SelectedCard);
        }
      
        // try to move to other stack
        else if (stack.canAddCard(SelectedCard)) {
          SelectedCard.removeFromStack();
          stack.addCard(SelectedCard);
          movedToStack = true;
          checkForWin();
        }
        break;
      }
      
      // handle stack click without card
      else {
        stack.handleClick(null);
      }
    }
  }
  
  if (SelectedCard != null && !movedToStack)
    SelectedCard.returnHome();
  
  SelectedCard = null;
}

void mouseDragged() {
  if (SelectedCard != null && SelectedCard.canMove) {
    float dx = mouseX - SelectedCard.coordX;
    float dy = mouseY - SelectedCard.coordY;
    SelectedCard.moveBy(dx, dy);
  }
}
