class Puzzle {
  
  ArrayList<Line> lines;
  ArrayList<Endpoint> points;
  color endPtDeselected = color(30, 30, 30);
  color endPtSelected = color(255, 0, 0);
  
  Puzzle(int w, int h, int numLines) {
    init(0, w, 0, h, numLines);
  }
  
  Puzzle(int minX, int maxX, int minY, int maxY, int numLines) {
    init(minX, maxX, minY, maxY, numLines);
  }
    
  void init(int minX, int maxX, int minY, int maxY, int numLines) {
    
    // error check
    if (numLines < 3) {
      println("Cannot create a puzzle with fewer than 3 lines.");
      exit();
    }
    if (minX >= maxX || minY >= maxY || minX < 0 || minY < 0 ||
        maxX > width || maxY > height) {
      println("Cannot create a puzzle with invalid boundaries.");
      exit();
    }
    
    // initialize first coordinate
    int x1, y1, x2, y2, firstX, firstY;
    firstX = x1 = (int) random(minX, maxX);
    firstY = y1 = (int) random(minY, maxY);
    int id = 0;
    
    // initialize endpoints
    points = new ArrayList<Endpoint>();
    Endpoint prevEndPt = null;

    // create list of Lines
    lines = new ArrayList<Line>();
    for (int i = 0; i < numLines - 1; i++) {
      
      // generate random endpoints
      x2 = y2 = -1;
      while (x2 == -1 || (x1 == x2 && y1 == y2)) {
        x2 = (int) random(minX, maxX);        
        y2 = (int) random(minY, maxY);
      }
      
      // create a new Line and Endpoint
      Line line = new Line(x1, y1, x2, y2, id);
      Endpoint endpt = new Endpoint(x2, y2, 10, endPtDeselected);
      endpt.line1 = line;
      if (prevEndPt != null)
        prevEndPt.line2 = line;
        
      lines.add(line);
      points.add(endpt);
      
      // save one endpoint and current line
      x1 = x2;
      y1 = y2;
      prevEndPt = endpt;
      id += 1;
    }
    
    // create final line (connected to first)
    Line line = new Line(x1, y1, firstX, firstY, id);
    Endpoint endpt = new Endpoint(firstX, firstY, 10, endPtDeselected);
    endpt.line1 = line;
    endpt.line2 = lines.get(0);
    prevEndPt.line2 = line;
    
    lines.add(line);
    points.add(endpt);
  }
  
  void update() {
    for (Endpoint e : points)
      e.update();
  }
  
  void display() {
    
    // display lines
    for (Line l : lines)
      l.display();
      
    // display endpoints on top of lines
    for (Endpoint e : points)
      e.display();
  }
  
  void handleMousePress() {
    for (Endpoint pt : points) {
      if (pt.contains(mouseX, mouseY)) {
        pt.c = endPtSelected;
        pt.followMouse();
      }
      else
        pt.c = endPtDeselected;
    }
  }
  
  void handleMouseRelease() {
    for (Endpoint pt : points) {
        pt.unfollowMouse();
        pt.c = endPtDeselected;
    }
  }
  
  boolean solved() {
    return solved(true);
  }
  
  boolean solved(boolean checkMousePressed) {
    
    // can't be in process of moving a point
    if (checkMousePressed && mousePressed)
      return false;
    
    // check each pair of lines
    Line A, B;
    for (int i = 0; i < lines.size() - 1; i++) {
      A = lines.get(i);
      for (int j = i; j < lines.size(); j++) {
        B = lines.get(j);
        
        // not solved if any lines A and B intersect
        if (A.crosses(B) && B.crosses(A))
          return false;
      }
    }
    return true;
  }
}
