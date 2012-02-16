/*
 * Simple phenotype using Paul Bourke's superformula as a basis to generate body types.
 *
 * (cc-a-nc-sa) 2012 Luis Rodil-Fernandez
 */

// ////////////////////////////////////////////////////////////////
// What we do with the GA
// ////////////////////////////////////////////////////////////////
SuperFormula2D fshape;
SuperPhenotype original;
SuperPhenotype current;
PFont font;

void setup()  {
  size(800, 600);
  // load and set font so taht we can print text on screen
  font = loadFont("Dialog-10.vlw");
  textFont(font);
  
  //fshape = new SuperFormula2D(32f, 0.71f, 1.20f, 4.10f, 64.0f, -20.0f, 82.75f);
  original = new SuperPhenotype();
  current  = original.clone();
  //original.loadFromFile("super.genotype");
}

void draw() {
  background(0, 0, 40);
  smooth();
  strokeWeight(2);
  //colorMode( HSB );
  
  fill(200, 200, 255);
  text("space key = mutate the genome of this phenotype", 300, 20);
  text("s key = save current genotype", 300, 35);
  text("l key = load last saved genotype", 300, 50);

  // draw our phenotype
  translate(width*0.5f, height*0.5f);
  stroke(255);
  current.draw();
  //fshape.draw();
}

// scan keyboard input
void keyPressed() {
  if(key == ' ') {
    // mutate
    original = current.clone();
    current = current.mate( original );
  } else if (key == 's') {
    current.saveToFile("super.genotype");
  } else if (key == 'l') {
    println("loading file");
    current.loadFromFile("super.genotype");
    current.update();
  }
}


