class Arrow {

  int x;                 // center x
  int y;                 // center y
  float theta = 0.0;     // rotation angle
  float origTheta = 0.0; // original angle (used to track movement)
  float Dtheta = 0.01;   // rotation speed
  
  int size;              // radius
  color c;               // fill color
  PShape arrowShape;     // the arrow shape
  
  Arrow(int newX, int newY, int newSize, float speed, color newC) {
   
    // save all values
    x = newX;
    y = newY;
    size = newSize;
    Dtheta = speed;
    c = newC;
    
    // create the arrow shape
    arrowShape = createShape();
    arrowShape.beginShape();
      arrowShape.noStroke();               // no outline
      arrowShape.fill(c);                  // fill with designated colors
      
      arrowShape.vertex( 0,      -size);   // top point
      arrowShape.vertex( size,    0);
      arrowShape.vertex( size/2,  0);
      arrowShape.vertex( size/2,  size);   // bottom right corner
      arrowShape.vertex(-size/2,  size);   // bottom left corner
      arrowShape.vertex(-size/2,  0);
      arrowShape.vertex(-size,    0);
      
    arrowShape.endShape(CLOSE);
  }
  
  void display() {
    pushMatrix();
      translate(x, y);      // move to arrow center
      rotate(theta);        // rotate by arrow angle
      shape(arrowShape);    // display the shape
    popMatrix();
  }
  
  void move() {
    theta += Dtheta;        // update rotation angle by speed
  }
  
  void flip() {
    theta += PI;            // rotate 180 degrees
  }
  
  void startRotation() {
    origTheta = theta;      // track starting angle
  }
  
  boolean rotated(float angle) {
    // true if angle rotated since started tracking >= given angle
    return abs(theta - origTheta) >= angle;
  }
   
  color getColor() {
    return c;
  }
}
