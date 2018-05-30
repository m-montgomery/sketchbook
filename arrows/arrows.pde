/*
   AUTHOR:  Maya Montgomery
   DATE:    5/30/18
   
   Inspired by a GIF of rotating arrows on Reddit (posted on 
   r/oddlysatisfying by u/WhosTheRealRobot). Wanted to see if
   I could replicate the movement - think I managed it! 
   
   Play with values under "setup arrow values" (line 19) for fun. 
*/

ArrayList< ArrayList<Arrow> > allArrows = new ArrayList< ArrayList<Arrow> >();
int currArrows;     // index of current arrow set
color currColor;    // current background color

void setup() {
  size(800, 800);
  
  // setup arrow values
  color colorOne = color(255);
  color colorTwo = color(0);
  int size = 80;
  float speed = 0.015;

  // make first set of arrows
  allArrows.add(new ArrayList<Arrow>());
  for (int x = 0; x <= width; x += 2 * size) {
    for (int y = 0; y <= height; y += 2 * size) {
      Arrow newArrow = new Arrow(x, y, size, speed, colorOne);
      newArrow.startRotation();       // start tracking rotation angle
      allArrows.get(0).add(newArrow);
    }
  }
  
  // make second set of arrows
  allArrows.add(new ArrayList<Arrow>());
  for (int x = size; x <= width; x += 2 * size) {
    for (int y = size; y <= height; y += 2 * size) {
      Arrow newArrow = new Arrow(x, y, size, speed, colorTwo);
      newArrow.flip();                // start facing downwards
      allArrows.get(1).add(newArrow);
    }
  }
  
  // setup starting values
  currArrows = 0;            // start with first set of arrows
  currColor = colorTwo;      // start with second arrow color
}


void draw() {
  
  // background matches inactive arrow color
  background(currColor);
  
  // update and display current arrows
  for (Arrow a : allArrows.get(currArrows)) {
    a.display();
    a.move();
  }
  
  // update location of inactive arrows
  for (Arrow a : allArrows.get((currArrows + 1) % allArrows.size()))
    a.move();
  
  // switch active arrows after one rotation (90 deg)
  if (allArrows.get(currArrows).get(0).rotated(PI/2)) {
    currColor = allArrows.get(currArrows).get(0).getColor();
    currArrows = (currArrows + 1) % allArrows.size();
    
    // set active arrows to start tracking angle rotated
    for (Arrow a : allArrows.get(currArrows))
      a.startRotation();
  }
}
