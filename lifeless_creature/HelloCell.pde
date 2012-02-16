class HelloCell {
  
  float oradius;  // outer radius of the creature's shell
  float iradius;  // inner radius of the creatures nucleus
  
  int nrGranules; // number of granules in the nucleus
  float cilliaDensity; // density of cillia (0.0 = no cillia)
 
  int shellType; // what kind of shell does the creature have? (not used at the moment but it is drawn as a circle)
  float shellThickness;
  
  color c;
  
  // state
  boolean living;
  float born;
  
  PVector[] granules;
  
  HelloCell() {
    born = millis();
    living = true;
  }
  
  boolean isAlive() {
    return living;
  }
  
  void setParameters(float or, float ir, int gr, float cds, int sht, float shw, color clr) {
    oradius = or;
    iradius = ir;
    
    nrGranules = gr;
    
    cilliaDensity = cds;
    shellType = sht;
    shellThickness = shw;
    
    c = clr;
    
    granules = new PVector[nrGranules];
    // generate granule positions
    for(int i = 0; i < nrGranules; i++) {
      granules[i] = new PVector();
      float a = random(0, iradius*.25);
      float b = random(0, iradius*.25);
      float aa = max(a, b);
      float bb = min(a, b);
      // pick a random point within nucleus
      granules[i].x = random(0.12, 0.35)*iradius *cos(2*PI*aa/bb);
      granules[i].y = random(0.12, 0.35)*iradius *sin(2*PI*aa/bb);
    }
  }
  
  void update(LiquidWorld world) {
    // if the environmental temperature goes bellow 0, creature dies
    if(world.temperature < 0) { living = false;  }
  }
  
  void drawGranules() {
    noStroke();
    for(int i = 0; i < nrGranules; i++) {
      if( isAlive() ) {
        fill(c, 128);
      } else {
        fill(0, 255);
      }
      float sz = (iradius*1.45 / nrGranules);
      ellipse(granules[i].x, granules[i].y, sz, sz);  // 5 = size of granule
    }
  }
  
  void drawCillia() {
    float dt = ((2*PI) / cilliaDensity);
    for(float theta = 0; theta < 2*PI; theta += dt) {
      float x0 = cos( theta ) * iradius*.5;
      float y0 = sin( theta ) * iradius*.5;    
      float x1 = cos( theta ) * oradius*.6;
      float y1 = sin( theta ) * oradius*.6;
      strokeWeight(0.60);
      if( isAlive() ) {
        stroke(255, 200);
      } else {
        stroke(60, 60, 60, 255);
      }
      line(x0, y0, x1, y1);    
    }
  }
  
  void draw() {
    //println("oradius: "+oradius);
    //pushMatrix();
      if( isAlive() ) {
        fill(128, 128, 128, 128);
        stroke(255, 255, 255);
      } else {
        fill(60, 60, 60, 200);
        stroke(100, 100, 100, 255);
      }
      
      strokeWeight(shellThickness);
      ellipse(0, 0, oradius, oradius);
      
      if( isAlive() ) {
        fill(80, 80, 80, 200);
        stroke(255, 255, 255);
      } else {
        fill(60, 60, 60, 200);
        stroke(100, 100, 100, 255);
      }
      
      strokeWeight(1);
      ellipse(0, 0, iradius, iradius);
      
      drawGranules();
      drawCillia();
    //popMatrix();
  }
} // class HelloCell
