
// CARD SIZES //
const ACTIVE_STACK_COUNT = 7;
const PLAY_STACK_COUNT = 4;

const MAX_STACKED_CARDS = 19;

const CARD_WIDTH  = 114; // standard: 571
const CARD_HEIGHT = 178; // standard: 889
const CARD_STACK_OFFSET_RATIO = 7; // display top 7th of card when stacked

const MARGIN = 20;

// COLORS //
const BLACK = 0;
const RED = '#d82e0d';

const BACKGROUND = '#0c6006';
const BACKGROUND_TINT = '#0a4f05';
const SYMBOL_TINT = '#083305';

const CARD_BACKGROUND_COLOR = '#231d77';
const CARDSTOCK_COLOR = 250;

const BUTTON_COLOR = '#bababa';

// ENUMS //
const Suits = {
  Diamonds: "♦",
  Clubs   : "♣",
  Hearts  : "❤",
  Spades  : "♠"
};

const CardStackTypes = {
  Active : "Active",
  Play   : "Play",
  Draw   : "Draw",
  Discard: "Discard"
};

const Numbers = {
   1: "A",
   2: "2",
   3: "3",
   4: "4",
   5: "5",
   6: "6",
   7: "7",
   8: "8",
   9: "9",
  10: "10",
  11: "J",
  12: "Q",
  13: "K"
}

// HELPER FUNCTIONS //
function getSuitLabel(suit) {
  return Suits[suit];
}
  
function getNumberLabel(number) {
  return Numbers[number];
}

function contains(x, y, width, height, otherX, otherY) {
  let ULX = int(x - width/2);
  let ULY = int(y - height/2);
  let LRX = int(x + width/2);
  let LRY = int(y + height/2);
  
  return otherX >= ULX && otherX <= LRX &&
         otherY >= ULY && otherY <= LRY;
}
