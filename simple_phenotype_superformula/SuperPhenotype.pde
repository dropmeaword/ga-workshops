/**
 * This class represents our Phenotype. Phenotypes are normally closely coupled to their graphic representations
 * so we keep this file outside of the Genomatic library for convenience.
 *
 * (cc-aa-nc-sa) 2012 Luis Rodil-Fernandez
 */
public class SuperPhenotype extends Genotype {
  /*
   * This phenotype will have three traits:
   *   1. a visible body type that we will draw as a parametric curve.
   *   2. an age, so we know how old this phenotype is. (we save the birth timestamp and calculate the age)
   *   3. a color.
   */
  SuperFormula2D body;
  color c;
  float born;
  
  SuperPhenotype() {
    genome.randomize();
    developEmbryo();
  }
  
  SuperPhenotype(Genome g) {
    super(g);
    developEmbryo();
  }
  
  float getAge() {
    return (millis() - born);
  }
  
  boolean isDead() {
    return (getAge() >  GeneticVariables.gMaxLife);
  }
  
  SuperPhenotype clone() {
    SuperPhenotype retval = new SuperPhenotype( this.genome );
    return retval;
  }
  
  SuperPhenotype mate(SuperPhenotype other) {
    Genotype offspring = this.mate( (Genotype)other );
    SuperPhenotype retval = new SuperPhenotype( offspring.genome );
    return retval;
  }
  
  /**
   * Develop the genome into a phenotype
   */
  void developEmbryo() {
    float mapping[] = new float[10]; 
    /* we will use ten numbers from our genome to determine the aspect of our creature, the first seven wil be the parrameters to the superformula
       the other three wil be the colour of our creature */
       
    mapping[6] = map(genome.dna[6], 0f, 1.0f, 10.0, 100.0);  // R (radius)
    mapping[0] = map(genome.dna[0], 0f, 1.0f, 0.5, 5.0);  // A
    mapping[1] = map(genome.dna[1], 0f, 1.0f, 0.1, 5.0);  // B
    mapping[2] = map(genome.dna[2], 0f, 1.0f, .0, 20);  // M
    mapping[3] = map(genome.dna[3], 0f, 1.0f, .0, 100);  // N1
    mapping[4] = map(genome.dna[4], 0f, 1.0f, -50.0, 100);  // N2
    mapping[5] = map(genome.dna[5], 0f, 1.0f, -50.0, 100);  // N3
    
    mapping[7] = genome.dna[7];
    mapping[8] = genome.dna[8];
    mapping[9] = genome.dna[9];
       
    body = new SuperFormula2D(mapping[6], mapping[0], mapping[1], mapping[2], mapping[3], mapping[4], mapping[5]);
    c = color(mapping[7]*255, mapping[8]*255, mapping[9]*255);
    born = millis();  // mark this as the point in time of birth of this phenotype
  }
  
  void update() {
    developEmbryo();
  }
  
  void draw() {
    float age = getAge();
    float aa = 255;
    if( !isDead() ) {
      aa = map(age*1.0f, 0f, GeneticVariables.gMaxLife*1.0f, 0, 255.0f); // calculate the transparency according to age
    }
    //println("age =  "+age+"  aa = "+aa);
    colorMode(HSB);
    stroke(c, (255 - aa)); //, aa); // change stroke color to the color of this phenotype
    body.draw(); // draw the body
    colorMode(RGB);
    fill(255);
    text("max. lifetime: "+round(GeneticVariables.gMaxLife/1000), 100, 115); //((width*.5f)+200), (height*.5f) );
    if( !isDead() ) {
      text("age: "+round(age/1000), 100, 100); //((width*.5f)+200), (height*.5f) );
    } else {
      text("creature died of old age! oooh!", 100, 100); //((width*.5f)+200), (height*.5f) );
    }
  }
} // class Phenotype
