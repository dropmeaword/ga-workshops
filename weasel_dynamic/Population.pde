

public class Population {
  public Genotype[] specimens;
  public float topFitness = 0f;
  public Genotype fittest;
  public Genotype secondBest;
  public int generation;
  
  public Population(int sz, Genotype model) {
    this.generation = 0;
    this.specimens = new Genotype[sz];
    int dnaSize = model.dna.length;
    fittest = null;
    // create a first generation
    for(int i =0; i < specimens.length; i++) {
      specimens[i] = new Genotype(dnaSize);
      specimens[i].randomize();
    }
  }
  
  public int size() {
    return specimens.length;
  }
  
  /** Spawn a whole new generation from two chosen genotypes */
  public void repopulate(Genotype a, Genotype b, boolean withMutation) {
    // first two specimens of our new population are the ancestors
    //specimens[0] = a;
    //specimens[1] = b;
    
    // generate the rest of the population out of siblings
    for(int i = 0; i < specimens.length; i++) { 
      // create a new genotype from crossing-over the two ancestors
      Genotype zygote = a.crossover(a, b);
      
      //if(withMutation) {
        // choose a probability of mutation 
        // for each specimen between (1% to 20%)
        float mutationRate = random(0.001, 0.6);
        zygote.mutate( mutationRate );
      //}
      
      // add the new specimen to the population
      specimens[i] = zygote;
    }
    generation++;
  }
  
  /** Gets the fittest specimen in this population */
  public Genotype getFittest(String target) {
    for(int i  = 0; i < specimens.length; i++) {
      float f = specimens[i].fitness(target);
      if(topFitness < f) {
        secondBest = fittest;
        fittest = specimens[i];
        topFitness = f;
      } // if
    } // for
    
    return this.fittest;
  } // getFittest
  
  /** Gets a random specimen in this population */
  public Genotype getRandom() {
    int j = int(random(0, specimens.length));
    return specimens[j];
  }
  
  public Genotype getSecondBest() {
    return this.secondBest;
  }
  
} // class Population
