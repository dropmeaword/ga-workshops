/**
 * This is a model for a liquid medium in a kind of virtual petri dish.
 *
 * Abslute Maxium temperature is +100C and absolute minimum is -100C.
 */
class LiquidWorld {
  // properties
  float temperature;
  float density;

  // internal state
  float tgenesis;
  float tempmin = -100;
  float tempmax =  100;
  float tempini;
  float tfreeze = 15000;  // time (in ms) that it takes the environment to cool down to the absolute minimum
  
  LiquidWorld(float tc, float ds) {
    // decrease temperature gradually over time
    tempini = tc;
    temperature = tempini;
    density = ds;
    tgenesis = millis();
  }
  
  /**
   * @param dtemp is the external temperature differential. There are external factors that can cause temperature differentials.
   */
  void update(float dtemp) {
    float elapsed = millis() - tgenesis;
    //float val = tfreeze - elapsed;
    float val = elapsed/tfreeze;
    //println("t = "+val);
    float decrease = (tempini - tempmin) * (val);
    //println("dec "+decrease);
    temperature = tempini - decrease + dtemp;
    if(temperature <= tempmin) { temperature = tempmin; }
  }
  
  void draw() {
    background(0, 0, 60);
    
    // draw thermometer
    float thermometerH = 100;    
    pushMatrix();
      fill(255);
      text("temp " + int(temperature), width - 55, 15);
      translate(width - 40, 20);
      stroke(40, 40, 80);
      fill(10, 10, 60);
      rect(0, 0, 15, thermometerH);
      // draw mercury bar
      float hh = map(temperature, tempmin, tempmax, 0, thermometerH);
      //hh = thermometerH - hh;
      noStroke();
      fill(128, 128, 200);
      rect(0, (thermometerH - hh), 15, hh);
    popMatrix();
  }
  
} // class LiquidWorld
