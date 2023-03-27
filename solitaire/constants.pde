
final color BLACK = #000000;
final color RED = #d82e0d;

final color BACKGROUND = #0c6006;
final color BACKGROUND_TINT = #0a4f05;

final color CARD_BACKGROUND_COLOR = #231d77;
final color CARDSTOCK_COLOR = 250;

enum Suits {
  DIAMONDS, 
  CLUBS,
  HEARTS, 
  SPADES
}

StringDict SUIT_LABELS = new StringDict(new String[][] {
  {"DIAMONDS", "♦"},
  {"CLUBS",    "♣"},
  {"HEARTS",   "❤"},
  {"SPADES",   "♠"},
});

StringDict NUMBER_LABELS = new StringDict(new String[][] {
  {  "1", "A" },
  {  "2", "2" },
  {  "3", "3" },
  {  "4", "4" },
  {  "5", "5" },
  {  "6", "6" },
  {  "7", "7" },
  {  "8", "8" },
  {  "9", "9" },
  { "10", "10" },
  { "11", "J" },
  { "12", "Q" },
  { "13", "K" },
});

final int CARD_WIDTH  = 114; // standard: 571
final int CARD_HEIGHT = 178; // standard: 889
final int CARD_STACK_OFFSET_RATIO = 7; // display top 7th of card when stacked
