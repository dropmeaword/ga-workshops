/**
 * This is is a basic design for a creature that needs to be brought to life through a GA.
 * This creature lives in an environment in which the temperature is decreasing constantly throughout time
 * the creature "dies" when the temperature goes past 0 degrees.
 *
 * The creature is defined by a number of parameters that define basic aspects of the way it looks. These
 * parameters can be affected by a GA.
 *
 * As an exercise you can try and design a GA that have different species of these creatures that develop different
 * strategies to deal with the temperature decrease of their environments. 
 *
 *  (cc-a-nc-sa) 2012 Luis Rodil-Fernandez
 */
PFont font;

float gInitialTemperature = 80;  // in degrees
float gMediumDensity = 1.2;  // in degrees

HelloCell cell;
LiquidWorld petri;


void setup() {
  size(500, 500);

  // load and set font so taht we can print text on screen
  font = loadFont("Dialog-10.vlw");
  textFont(font);
  
  petri = new LiquidWorld(gInitialTemperature, gMediumDensity);
  cell = new HelloCell();
  color c = color(255, 255, 0);

  // params: iradius, oradius, granules, cillia density, shell type, shell thickness, color
  cell.setParameters(80.0f, 40.0f, 5, 140, 1, 4.2, c);
}

void update() {
  // update the world in which the creature lives
  petri.update(0.0);  // the param is an external temperature differential (0 = temperature in the world behaves normally)

  // update the creature in relation to the world
  cell.update( petri );
}

void draw() {
  smooth();

  update();

  // draw the world  
  petri.draw();
  
  // position in the center and draw the creature(s)  
  pushMatrix();
    translate(width*.5, height*.5);
    cell.draw();
  popMatrix();
}

