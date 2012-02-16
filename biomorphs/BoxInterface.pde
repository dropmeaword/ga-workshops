class BoxInterface {

  String []letters = {"A", "B", "C", "D", "E", "F", "G", "H", "I"};  
  
  int numHBoxes = 3;
  int numVBoxes = 3;
  int boxSize = 100;
  int boxClicked = -1;
  PVector []boxes;
  
  BoxInterface() {
    int bw = width / numHBoxes;
    int bh = height / numVBoxes;
    
    boxSize = min(bw, bh);
    boxes = new PVector[numHBoxes*numVBoxes];
    for(int i = 0; i < boxes.length; i++) {
      boxes[i] = new PVector(0, 0, 0);
    }
    init();
  }
  
  boolean isBoxClicked() {
    return (boxClicked > -1);
  }
  
  int whichBox() {
    return boxClicked;
  }
  
  PVector boxCenter(int i) {
    PVector cornr = new PVector(boxes[i].x, boxes[i].y);
    cornr.x += boxSize/2;
    cornr.y += boxSize/2;
    return cornr;
  }
  
  PVector boxCenter() {
    int bx = whichBox();
    return boxCenter( bx );
  }
  
  String boxLetter() {
    int idx = whichBox();
    return letters[idx];
  }
  
  void init() {
    int idx = 0;
    for(int j = 0; j < numVBoxes; j++) {
      for(int i = 0; i < numHBoxes; i++) {
        int xx = i*boxSize;
        int yy = j*boxSize;
        boxes[idx].x = xx;
        boxes[idx].y = yy;
        //println("xx = " + xx + ", yy = "+yy);
        idx++;
      } // for
    } // for
  }
  
  /*
  void update(Biomorph c, Biomorph []pop) {
    current = c;
    population = pop;
  }
  */
  
  void clicked(int mx, int my) {
  }
  
  void draw() {
    //stroke(255);
    noFill();
    int idx = 0;
    for(int j = 0; j < numVBoxes; j++) {
      for(int i = 0; i < numHBoxes; i++) {
        int xx = (int)boxes[idx].x;
        int yy = (int)boxes[idx].y;
        stroke(80, 80, 180);
        strokeWeight(1);
        rect(xx, yy, boxSize, boxSize);
        text(letters[idx], xx+4, yy+12);
        
        if(idx != floor(boxes.length/2)) { // do not highlight the middle box
          // highlight current box
          if( (mouseX > xx) && (mouseX < (xx + boxSize)) 
              && (mouseY > yy) && (mouseY < (yy + boxSize)) ) {
            if(mousePressed) {
              stroke(255, 128, 128);
              boxClicked = ((j*numHBoxes) + i);
            } else {
              boxClicked = -1;
              stroke(128, 128, 255);
            }
            strokeWeight(2);
            rect(xx+4, yy+4, boxSize-8, boxSize-8);
          }
        }
        
        idx++;
        
      } // for
    } // for
  } // draw()
  
} // class BoxInterface
