class Biomorph {
  int GENOME_SIZE = 10;
  Genotype gt;

  float []phenotype_dx;
  float []phenotype_dy;
  float order;
  
  public Biomorph() {
    Genome genes = new Genome(GENOME_SIZE);
    initialState( genes );
    gt = new Genotype( genes );
    mapPhenotype();
  }
  
  public Biomorph(Genotype _gt) {
    gt = _gt;
    mapPhenotype();
  }
  
  void initialState(Genome _gt) {
    for (int i = 0; i < GENOME_SIZE; i++) {
       _gt.genes[i] = random(5);
    }
    
    // last gene
     _gt.genes[GENOME_SIZE-1] = random(5) + 3;
  }
  
  /**
   * Returns an array of integers that represent the graphical pattern
   * determined by the biomorph's genes.
   * @return A 2-dimensional array containing the 8-element dx and dy
   * arrays required to draw the biomorph.
   */
  void mapPhenotype()
  {
      // Decode the genes as per Dawkins' rules.
      float[] dx = new float[GENOME_SIZE - 1];
      float[] dy = new float[GENOME_SIZE - 1];

      // horizontal axis
      dx[3] = gt.genome.genes[0];
      dx[4] = gt.genome.genes[1];
      dx[5] = gt.genome.genes[2];

      dx[1] = -dx[3];
      dx[0] = -dx[4];
      dx[7] = -dx[5];

      dx[2] = 0;
      dx[6] = 0;
      
      // vertical axis
      dy[2] = gt.genome.genes[3];
      dy[3] = gt.genome.genes[4];
      dy[4] = gt.genome.genes[5];
      dy[5] = gt.genome.genes[6];
      dy[6] = gt.genome.genes[7];

      dy[0] = dy[4];
      dy[1] = dy[3];
      dy[7] = dy[5];
      
      // order
      order = gt.genome.genes[GENOME_SIZE-1];

      //phenotype = new int[][]{dx, dy};
      phenotype_dx = dx;
      phenotype_dy = dy;
  }  

  boolean isDegenerate() {
    return (order < 1);
  }
  
  //private void draw(float i, float j)
//  void draw() {
//    mapPhenotype();
//    //tree(i / 2, j, order, 2);
//    tree(0f, 0f, order, 2);
//  }
  
  void draw(PGraphics gfx) {
    mapPhenotype();
    //tree(i / 2, j, order, 2);
    tree(gfx, 0f, 0f, order, 2);
  }
  
  /// <summary>
  /// Draws the Dawkins bio-morph structure (No segmentation, in this
  /// implementation)
  /// </summary>
  /// <param name="i">The x position to start drawing</param>
  /// <param name="j">The x position to stop drawing</param>
  /// <param name="k">The y position to start drawing</param>
  /// <param name="l">The y position to stop drawing</param>
  void tree(PGraphics gfx, float i, float j, float k, int l) {
    if (l < 0) { l += 8; }
    if (l >= 8) { l -= 8; }
 
    float i1 = i + k * phenotype_dx[l];
    float j1 = j - k * phenotype_dy[l];

    //gfx.stroke(0);
    gfx.strokeWeight(0.5f);
    gfx.line(i, j, i1, j1);

    if (k > 0)
    {
        tree(gfx, i1, j1, k - 1, l - 1);
        tree(gfx, i1, j1, k - 1, l + 1);
    }
  }

}  // class Biomorph
