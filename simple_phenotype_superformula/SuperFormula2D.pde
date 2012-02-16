/**
 * Paul Bourke's supershape formula.
 * Derived from Reza Ali's implementation, added some encapsulation to make it neat and nicely decoupled.
 *
 * To learn morea bout the superformula you can go to Paul Bourke's page:
 * 
 * http://paulbourke.net/geometry/supershape/
 * http://paulbourke.net/geometry/supershape3d/
 */
public class SuperFormula2D {
  SuperIntegrator iRadius; 
  SuperIntegrator a;
  SuperIntegrator b;
  SuperIntegrator m;
  SuperIntegrator n1; 
  SuperIntegrator n2; 
  SuperIntegrator n3;
  //Integrator stkWeight;
  float theta = 0;
  
  public SuperFormula2D(float _r, float _a, float _b, float _m, float _n1, float _n2, float _n3) {
    iRadius = new SuperIntegrator(_r , .2f, .2f);
    a = new SuperIntegrator(_a, .2f, .2f);
    b = new SuperIntegrator(_b, .2f, .2f);
    m = new SuperIntegrator(_m, .2f, .2f);
    n1 = new SuperIntegrator(_n1, .2f, .2f);
    n2 = new SuperIntegrator(_n2, .2f, .2f);
    n3 = new SuperIntegrator(_n3, .2f, .2f);
    //stkWeight = new Integrator(22,.2f,.2f);
  }
  
  void draw() {
    //strokeCap(ROUND); 
    noFill();
    //strokeWeight(stkWeight.value); 
    beginShape();
    for(theta = 0; theta <TWO_PI+0.001f; theta+=0.005f)
    {
       float raux = pow(abs(1.0f/a.value)*abs(cos((m.value*theta/4.0f))),n2.value) + pow(abs(1.0f/b.value)*abs(sin(m.value*theta/4.0f)),n3.value);
       float r = iRadius.value*pow(abs(raux),(-1.0f/n1.value));
       float x=r*cos(theta);
       float y=r*sin(theta); 
       vertex(x,y); 
    }    
    endShape(); 
  } // draw
  
} // class SuperFormula2D


/**
 * This code is from Reza Ali as my Breedrs implementation of the superformula is too
 * much spaggethi code.
 *
 * @author Reza Ali http://www.syedrezaali.com
 */
class SuperIntegrator {

  final float DAMPING = 0.5f;
  final float ATTRACTION = 0.2f;

  float value;
  float vel;
  float accel;
  float force;
  float mass = 1;

  float damping = DAMPING;
  float attraction = ATTRACTION;
  boolean targeting;
  float target;


  SuperIntegrator() { }


  SuperIntegrator(float value) {
    this.value = value;
  }


  SuperIntegrator(float value, float damping, float attraction) {
    this.value = value;
    this.damping = damping;
    this.attraction = attraction;
  }


  public void set(float v) {
    value = v;
  }


  public void update() {
    if (targeting) {
      force += attraction * (target - value);      
    }

    accel = force / mass;
    vel = (vel + accel) * damping;
    value += vel;

    force = 0;
  }


  public void target(float t) {
    targeting = true;
    target = t;
  }


  public void noTarget() {
    targeting = false;
  }
} // class SuperIntegrator

