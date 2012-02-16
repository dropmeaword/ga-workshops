/*
 * Simple genome class that you can use in your project (scroll to last bit)
 * and a little program that does a graphic visualization of it.
 *
 * (cc-a-nc-sa) 2012 Luis Rodil-Fernandez
 *
 * 'space' to generate a new family tree
 * 'z' to go to previous page
 * 'x' to go to next page
 */

// ////////////////////////////////////////////////////////////////
// What we do with the GA
// ////////////////////////////////////////////////////////////////
Genome current;
Genome clone;
Genome firstMutant;

Genome child1;
Genome child2;
Genome child3;

int blockSize = 15;
int currentPage = 0;
int PAGE_COUNT = 5;

int xx, yy;

PFont font;

void setup()  {
  size(600, 400);
  // load and set font so taht we can print text on screen
  font = loadFont("Dialog-10.vlw");
  textFont(font);

  // create a new genome (automatically defaults to a random sequence)
  current = new Genome(8);     // 8 loci (positions)
  println("original: " + current.toString());
  generateFamily( current );
}

/**
 * Generate a family from a single individual by producing a clone and then mutating the clone
 * and then mating with the mutant. This is inbreeding. A bit like European royal families do.
 * Inbreeding is genetically stupid.
 */
void generateFamily(Genome seed) {
  println();
  println("--- new generation");
  clone = seed.clone();
  println("clone: " + clone.toString());
  
  firstMutant = seed.clone();
  firstMutant.mutate(0.80); // mutate with a very high probability rate (80%)
  println("firstMutant: " + firstMutant.toString());
  
  child1 = mate(seed, firstMutant);
  println("child1: " + child1.toString());

  child2 = mate(seed, firstMutant);
  println("child2: " + child2.toString());
  
  child3 = mate(child1, child2);
  println("child3: " + child3.toString());
}

/**
 * draw a single genomic sequence as a set of grey squares
 */
void drawOneGenome(String name, Genome g, int x, int y) {
  fill(255);
  text(name, x, y);
  for(int i = 0; i < g.dna.length; i++) {
      // set the color to a tone of grey defined by each locus in the genome (r = g = b ==> grey)
      fill(g.dna[i], g.dna[i], g.dna[i]);
      int xx = x + (i * blockSize);
      rect(xx, y+5, blockSize, blockSize);
  }
}

/**
 * mate two genomes, mating = crossover + mutation
 */
Genome mate(Genome a, Genome b) {
  Genome zygote = a.crossover(a, b);
  zygote.mutate(0.10); //  10% mutation rate
  return zygote;
}

void drawPage0() {
  // initialize printing position
  yy = 10; 
  xx = 10;
  
  drawOneGenome("genome A", current, xx, yy);
}

void drawPage1() {
  yy += 40;
  drawOneGenome("cloned genome", clone, xx, yy);
}

void drawPage2() {
  yy += 40;
  drawOneGenome("genome B", firstMutant, xx, yy);
}

void drawPage3() {
  /*
  yy += 40;
  Genome anotherClone = current.clone();
  anotherClone.mutate(0.60);  // mutate with a probability rate of 60%
  drawOneGenome("mutant (every frame)", anotherClone, xx, yy);
  */
}

void drawPage4() {
  // draw a simple family tree
  yy += 80;
  drawOneGenome("genome A", current, xx, yy);
  
  yy += 30;
  drawOneGenome("genome B", firstMutant, xx, yy);
  
  xx += 140;
  yy -= 15;
  drawOneGenome("1st gen. sibling #1", child1, xx, yy);
}

void drawPage5() {
  xx -= 140;
  
  yy += 80;
  drawOneGenome("genome A", current, xx, yy);
  
  yy += 30;
  drawOneGenome("genome B", firstMutant, xx, yy);
  
  xx += 140;
  yy -= 15;
  drawOneGenome("1st gen. sibling #2", child2, xx, yy);

  xx += 140;
  yy -= 40;
  drawOneGenome("2nd gen. sibling", child3, xx, yy);
}

void draw() {
  background(0, 20, 0);
  fill(128, 255, 128);
  text("press space = generating a new family tree", 300, 20);  
  
  switch(currentPage) {
    case 0:
      drawPage0();
      break;
    case 1:
      drawPage0();
      drawPage1();
      break;
    case 2:
      drawPage0();
      drawPage1();
      drawPage2();
      break;
    case 3:
      drawPage0();
      drawPage1();
      drawPage2();
      drawPage3();
      break;
    case 4:
      drawPage0();
      drawPage1();
      drawPage2();
      drawPage3();
      drawPage4();
      break;
    case 5:
      drawPage0();
      drawPage1();
      drawPage2();
      drawPage3();
      drawPage4();
      drawPage5();
      break;
  }
}

// scan keyboard input
void keyPressed() {
  if(key == ' ') {
    current.mutate(0.80);
    generateFamily(current);
  } else if (key == 'z') {
    println("prev page");
    currentPage--;
    if(currentPage < 0) currentPage = 0;
  } else if (key == 'x') {
    println("next page");
    currentPage++;
    if(currentPage > PAGE_COUNT) currentPage = PAGE_COUNT;
  }
}


// ////////////////////////////////////////////////////////////////
// GA specific stuff
// ////////////////////////////////////////////////////////////////
/**
 * This class will represent our genomic sequence.
 */
class Genome {
  char []dna;

  /**
   * @param len is the legnth of our genomic sequence in number of loci.
   */
  Genome(int len) {
    dna = new char[len];
    // seed our dna
    randomize();
  }
  
  /**
   * @param in pre-existing dna sequence to copy into this genome
   */
  Genome(char[] in) {
    if( (in == null) || (in.length <= 0) ) return;
    
    dna = new char[in.length];
    // copy to this genome the dna provided as parameter
    for (int i = 0; i < in.length; i++) {
      dna[i] = in[i];
    }
  }

  /**
   * create a random dna sequence for this genome
   */  
  void randomize() {
    for (int i = 0; i < dna.length; i++) {
      // pick printable chars
      dna[i] = (char)random(32,128);
    }
  }

  /**
   * Clone this genome (cloning is fun)
   */  
  Genome clone() {
    Genome retval = new Genome(this.dna);
    return retval;
  }

  /**
   * mutate the entire genome randomly, based on a 
   * mutation probability. For example a probability of 0.4 (40%)
   * means that the gene we are about to mutate has a 40% chance 
   * of changing (or 60% of staying the same).
   */
  void mutate(float probability) {
    for (int i = 0; i < dna.length; i++) {
      // the probability is our threshold
      if (random(1) < probability) {
        // mutate randomly
        dna[i] = (char)random(32,128); // 32 - 128 are printable ASCII characters
      } // if
    } // for
  } // mutate

  public Genome crossover(Genome a, Genome b) {
    // pick size of smallest genome of the two 
    int genomesize = min(a.dna.length, b.dna.length);
    Genome child = new Genome( genomesize );
    
    // pick a scission point
    int midpoint = int(random(genomesize));
    
    // a part from each one of te genomes
    for (int i = 0; i < genomesize; i++) {
      if (i > midpoint) 
        child.dna[i] = a.dna[i];
      else 
        child.dna[i] = b.dna[i];
    }
    
    return child;
  }
  
  Genome crossover(Genome partner) {
    return crossover(this, partner);
  } // crossover

  /**
   * Get a string representation of the Genome to print out (maybe for debugging)
   */  
  String toString() {
    return new String( dna );
  }

} // end of class Genome

