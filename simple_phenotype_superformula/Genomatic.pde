/**
 * This is a collection of classes that implement the basics of a GA.  :)
 *
 * (cc-aa-nc-sa) 2012 Luis Rodil-Fernandez
 */
// ////////////////////////////////////////////////////////////////
// GA specific stuff
// ////////////////////////////////////////////////////////////////

/**
 * Global variables that are applicable to all genotypes
 */
public static class GeneticVariables {
  public static float gMutationRate = 0.90; //  10% mutation rate
  public static int gGenomeLength = 12; // length of the genome in locii
  public static long gMaxLife = 30000; // max life time of a phenotype in milliseconds (s = ms / 1000)
}

/**
 * This class will represent our genotype
 * genotypes can "mate", save themselves to a file and restore themselves from a file, that's all.
 */
public class Genotype {
  Genome genome;
  
  Genotype() {
    genome = new Genome( GeneticVariables.gGenomeLength );
    genome.randomize();
  }
  
  Genotype(Genome g) {
    genome = g;
  }
  
  public Genotype mate(Genotype other) {
    Genome heritage = this.genome.crossover(other.genome);
    heritage.mutate( GeneticVariables.gMutationRate );
    return new Genotype( heritage );
  }
  
  public Genotype mate(Genotype a, Genotype b) {
    Genome heritage = genome.crossover(a.genome, b.genome);
    heritage.mutate( GeneticVariables.gMutationRate );
    return new Genotype( heritage );
  }
  
  public Genotype clone() {
    Genotype retval = new Genotype( genome.clone() );
    return retval;
  }
  
  /**
   * Generate a family from a single individual by producing a clone and then mutating the clone
   * and then mating with the mutant. This is inbreeding. A bit like European royal families do.
   * Inbreeding is genetically stupid.
   */
  /*
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
  */

  public void saveToFile(String filename) {
    StoreFreezer freezer = new StoreFreezer();
    freezer.freeze(filename, genome);
  }
  
  public Genotype loadFromFile(String filename) {
    println( "genome before defrosting: " + genome.toString());
    StoreFreezer freezer = new StoreFreezer();
    genome = freezer.defrost(filename);
    println( "genome after defrosting: " + genome.toString());
    return this;
  }
} // Genotype

/**
 * This class will represent our genomic sequence.
 */
class Genome {
  float []dna;

  /**
   * @param len is the legnth of our genomic sequence in number of loci.
   */
  Genome(int len) {
    dna = new float[len];
    // seed our dna
    randomize();
  }
  
  Genome(Genome g) {
    copyFrom( g.dna );
  }
  
  /**
   * @param in pre-existing dna sequence to copy into this genome
   */
  Genome(float[] in) {
    copyFrom( in );
  }
  
  void copyFrom(float[] in) {
    if( (in == null) || (in.length <= 0) ) return;
    
    dna = new float[in.length];
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
      dna[i] = (float)random(0f, 1.0f);
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
        dna[i] = (float)random(0f,1f);
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
   * Load a genome from a string, useful for defrosting a stored genome.
   */
  Genome parseFromString(String ss) {
    String[] nrs = split(ss, " ");
    float[] ff = new float[nrs.length];
    for(int i = 0; i < nrs.length; i++) {
      ff[i] = Float.parseFloat( nrs[i] );
    }
    
    // assign the parsed genome to a genome container 
    Genome retval = new Genome( nrs.length );
    retval.copyFrom( ff );
    return retval;
  }

  /**
   * Get a string representation of the Genome to print out (maybe for debugging)
   */  
  String toString() {
    String ss = "";
    for(int i = 0; i < dna.length; i++) {
      if(i > 0) {
        ss += " "+dna[i];
      } else {
        ss += dna[i];
      }
    }
    
    return ss;
  }

} // end of class Genome

