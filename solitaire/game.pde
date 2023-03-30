
final int ACTIVE_STACK_COUNT = 7;
final int PLAY_STACK_COUNT = 4;

ArrayList<Card> Deck = new ArrayList<Card>();

CardStack[] ActiveStacks = new CardStack[ACTIVE_STACK_COUNT];
CardStack[] PlayStacks = new CardStack[PLAY_STACK_COUNT];
CardStack DiscardStack;
CardStack DrawStack;
ArrayList<CardStack> Stacks = new ArrayList<CardStack>();
int STACK_COUNT = 0;

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
    PlayStacks[i] = new PlayStack(13, (i * StackWidth) + StackWidthHalved, PlayStackCoordY, StackWidth, PlayStackHeight);
    Stacks.add(PlayStacks[i]);
  }
  
  // create draw and discard stacks
  DiscardStack = new DiscardStack(52, (5 * StackWidth) + StackWidthHalved, PlayStackCoordY, StackWidth, PlayStackHeight);
  DrawStack = new DrawStack(52, (6 * StackWidth) + StackWidthHalved, PlayStackCoordY, StackWidth, PlayStackHeight);
  Stacks.add(DiscardStack);
  Stacks.add(DrawStack);
  
  // create active stacks
  for (int i = 0; i < ACTIVE_STACK_COUNT; i++) {
    ActiveStacks[i] = new ActiveStack(MAX_STACKED_CARDS + i, (i * StackWidth) + StackWidthHalved, ActiveStackCoordY, StackWidth, ActiveStackHeight);
    
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
  var suits = new Suits[] { Suits.DIAMONDS, Suits.CLUBS, Suits.HEARTS, Suits.SPADES };
  for (Suits suit : suits ) {
    for (int num = 1; num <= 13; num++) {
      Deck.add(new Card(0, 0, suit, num));
    }
  }
}

Card dealCard() {
  return Deck.isEmpty() ? null : Deck.remove(int(random(Deck.size())));
}

void checkForWin() {
  var win = true;
  for (int i = 0; i < PLAY_STACK_COUNT; i++) {
    if (!PlayStacks[i].isFull()) {
      win = false;
    }
  }
  
  if (win) {
    println("Win detected");
    GameOver = true;
    
    for (CardStack stack : Stacks) {
      stack.disable();
    }
  }
}

void draw() {
  background(BACKGROUND);
  
  for (CardStack stack : Stacks) {
    stack.display();
  }
  
  // if moving a card, ensure it draws over everything else
  if (SelectedCard != null && SelectedCard.CanMove) {
    SelectedCard.displayAll();
  }
    
  if (GameOver) {
    fill(240);
    textSize(100);
    textAlign(CENTER);
    text("You won!", width / 2, 3 * (height / 4));
  }
}

Card findCardAtMouse() {
 Card card;
 for (CardStack stack : Stacks) {
   card = stack.findCardAt(mouseX, mouseY);
   if (card != null) {
      return card;
   }
 }
 return null;
}

void mousePressed() {
  SelectedCard = findCardAtMouse();
  if (SelectedCard != null) {
    SelectedCard.saveCoords();
  }
}

void mouseReleased() {
  
  // move any selected card to correct spot
  var movedToStack = false;
  for (CardStack stack : Stacks) {
    if (stack.contains(mouseX, mouseY)) {
      
      // with active card
      if (SelectedCard != null) {
        
        // handle click on same stack
        if (stack.ID == SelectedCard.Stack.ID) {
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
  
  if (SelectedCard != null && !movedToStack) {
    SelectedCard.returnHome();
  }
  
  SelectedCard = null;
}

void mouseDragged() {
  if (SelectedCard != null && SelectedCard.CanMove) {
    float dx = mouseX - SelectedCard.CoordX + SelectedCard.MoveDx;
    float dy = mouseY - SelectedCard.CoordY + SelectedCard.MoveDy;
    SelectedCard.moveBy(dx, dy);
  }
}
