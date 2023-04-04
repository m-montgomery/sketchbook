
var Deck = [];
var ActiveStacks = [];
var PlayStacks = [];
var TheDiscardStack;
var TheDrawStack;
var Stacks = [];
var STACK_COUNT = 0;

var GameOver = false;

var TheNewGameButton;
var SelectedCard;


function setup() {
  createCanvas(1050, 920);
  newGame();
}

function draw() {
  background(BACKGROUND);
  
  // display card stacks
  for (var stack of Stacks) {
    stack.display();
  }
  
  // if moving a card, ensure it draws over everything else
  if (SelectedCard != null && SelectedCard.CanMove) {
    SelectedCard.displayAll();
  }
  
  // display buttons
  TheNewGameButton.display();
  
  // display win scenario
  if (GameOver) {
    fill(240);
    textSize(100);
    textAlign(CENTER);
    text("You won!", width / 2, 3 * (height / 4));
  }
}

function newGame() {
  
  initDeck();
  Stacks = [];
  STACK_COUNT = 0;
  
  // define size of areas
  var StackWidth = width / 7;
  var StackWidthHalved = StackWidth / 2;
  var ActiveStackHeight = MARGIN + CARD_HEIGHT + ((CARD_HEIGHT / CARD_STACK_OFFSET_RATIO) * (MAX_STACKED_CARDS - 1));
  var PlayStackHeight = height - ActiveStackHeight;
  var PlayStackCoordY = PlayStackHeight / 2;
  var ActiveStackCoordY = height - (ActiveStackHeight / 2);
  
  // create play stacks
  PlayStacks = [];
  var suits = Object.keys(Suits);
  for (let i = 0; i < PLAY_STACK_COUNT; i++) {
    PlayStacks[i] = new PlayStack(13, (i * StackWidth) + StackWidthHalved, PlayStackCoordY, StackWidth, PlayStackHeight, suits[i]);
    Stacks.push(PlayStacks[i]);
  }
  
  // create draw and discard stacks
  TheDiscardStack = new DiscardStack(52, (5 * StackWidth) + StackWidthHalved, PlayStackCoordY, StackWidth, PlayStackHeight);
  TheDrawStack = new DrawStack(52, (6 * StackWidth) + StackWidthHalved, PlayStackCoordY, StackWidth, PlayStackHeight);
  Stacks.push(TheDiscardStack);
  Stacks.push(TheDrawStack);
  
  // create active stacks
  ActiveStacks = [];
  for (let i = 0; i < ACTIVE_STACK_COUNT; i++) {
    ActiveStacks[i] = new ActiveStack(MAX_STACKED_CARDS + i, (i * StackWidth) + StackWidthHalved, ActiveStackCoordY, StackWidth, ActiveStackHeight);
    
    // deal hidden card stacks
    for (let j = 0; j < i; j++) {
      var card = dealCard(); 
      card.hide();
      ActiveStacks[i].addCard(card);
    }
    
    // deal shown card
    var card1 = dealCard();
    card1.show();
    ActiveStacks[i].addCard(card1);
    
    Stacks.push(ActiveStacks[i]);
  }
  
  // deal remaining deck to draw stack
  let card2 = dealCard();
  while (card2 != null) {
    TheDrawStack.addCard(card2);
    card2.hide();
    card2 = dealCard();
  }
  
  // set up buttons
  TheNewGameButton = new NewGameButton(TheDrawStack.CoordX + (StackWidth / 4), TheDrawStack.TopCardCoordY - (CARD_HEIGHT / 2), BUTTON_COLOR);
  
  SelectedCard = null;
  GameOver = false;

  print("Ready to play");
}

function initDeck() {
  Deck = [];
  for (let suit of Object.keys(Suits)) {
    for (let num = 1; num <= 13; num++) {
      Deck.push(new Card(0, 0, suit, num));
    }
  }
  print("Initialized deck");
}

function dealCard() {
  if (Deck.length == 0)
    return null;
  
  let idx = int(random(Deck.length));
  let card = Deck[idx];
  Deck.splice(idx, 1);
  return card;
}

function checkForWin() {
  var win = true;
  for (let i = 0; i < PLAY_STACK_COUNT; i++) {
    if (!PlayStacks[i].isFull()) {
      win = false;
    }
  }
  
  if (win) {
    print("Win detected");
    GameOver = true;
    
    for (var stack of Stacks) {
      stack.disable();
    }
  }
}

function findCardAtMouse() {
 let card;
 for (var stack of Stacks) {
   card = stack.findCardAt(mouseX, mouseY);
   if (card != null) {
      return card;
   }
 }
 return null;
}

function mousePressed() {
  SelectedCard = findCardAtMouse();
  if (SelectedCard != null) {
    SelectedCard.saveCoords();
  }
}

function mouseReleased() {
  
  // start over
  if (TheNewGameButton.contains(mouseX, mouseY)) {
    print("Starting new game...");
    newGame();
    return;
  }
  
  // move any selected card to correct spot
  var movedToStack = false;
  for (var stack of Stacks) {
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

function mouseDragged() {
  if (SelectedCard != null && SelectedCard.CanMove) {
    let dx = mouseX - SelectedCard.CoordX + SelectedCard.MoveDx;
    let dy = mouseY - SelectedCard.CoordY + SelectedCard.MoveDy;
    SelectedCard.moveBy(dx, dy);
  }
}
