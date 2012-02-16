public class Genotype {
  public char []dna;
  public float fitness;

  public Genotype(int len) {
    dna = new char[len];
    // seed our dna
    for (int i = 0; i < dna.length; i++) {
      // pick printable chars
      dna[i] = (char) random(32,128);
    }
  }
  
  public Genotype(char []in) {
    if( (in == null) || (in.length <= 0) ) return;
    
    dna = new char[in.length];
    // seed our dna
    for (int i = 0; i < in.length; i++) {
      // pick printable chars
      dna[i] = in[i];
    }
  }
  
  public void randomize() {
    for(int i = 0; i < dna.length; i++) {
      dna[i] = (char)random(0, 255);
    }
  }
  
  public Genotype clone() {
    Genotype retval = new Genotype(this.dna);
    retval.fitness = this.fitness;
    return retval;
  }
  
  public String toString() {
    return new String( dna );
  }

  /** 
   * Calculate the Levenshtein distance between two strings. 
   * This distance is the number of substitutions necessary
   * to turn one string into another.
   */
  public int getLevenshteinDistance(String s, String t) {
    if (s == null || t == null) {
      throw new IllegalArgumentException("Strings must not be null");
    }
  		
    int n = s.length(); // length of s
    int m = t.length(); // length of t
  		
    if (n == 0) {
      return m;
    } else if (m == 0) {
      return n;
    }
  
    int p[] = new int[n+1]; //'previous' cost array, horizontally
    int d[] = new int[n+1]; // cost array, horizontally
    int _d[]; //placeholder to assist in swapping p and d
  
    // indexes into strings s and t
    int i; // iterates through s
    int j; // iterates through t
  
    char t_j; // jth character of t
  
    int cost; // cost
  
    for (i = 0; i<=n; i++) {
       p[i] = i;
    }
  		
    for (j = 1; j<=m; j++) {
       t_j = t.charAt(j-1);
       d[0] = j;
  		
       for (i=1; i<=n; i++) {
          cost = s.charAt(i-1)==t_j ? 0 : 1;
          // minimum of cell to the left+1, to the top+1, diagonally left and up +cost				
          d[i] = Math.min(Math.min(d[i-1]+1, p[i]+1),  p[i-1]+cost);  
       }
  
       // copy current distance counts to 'previous row' distance counts
       _d = p;
       p = d;
       d = _d;
    } 
  		
    // our last action in the above loop was to switch d and p, so p now 
    // actually has the most recent cost counts
    return p[n];
  }

  public float fitness(String target) {
     int score = getLevenshteinDistance(this.toString(), target);
     // convert distance
     this.fitness = (float)score / (float)target.length();
     this.fitness = (1.0f - this.fitness);
     return this.fitness;
  } // fitness()

  public Genotype crossover(Genotype a, Genotype b) {
    // pick size of smallest genome of the two 
    int genomesize = min(a.dna.length, b.dna.length);
    Genotype child = new Genotype( genomesize );
    
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
  
  Genotype crossover(Genotype partner) {
    return crossover(this, partner);
  } // crossover
  
  /** if any of the characters matches the target at the 
    * right position, we don't touch it, 
    * the rest we mutate randomly without contemplations. 
    */
  void mutateWithLocking(String target) {
    if(target.length() != dna.length) new IllegalArgumentException("Target and length of DNA must be the same");

    for (int i = 0; i < dna.length; i++) {
      // if letter are different
      if( dna[i] != target.charAt(i) ) {
        // keep mutating
        dna[i] = (char)random(32,128);
      } // if
    } // for
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

} // class
