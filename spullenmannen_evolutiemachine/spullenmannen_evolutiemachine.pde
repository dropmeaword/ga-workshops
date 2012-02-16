/**
 * Port of Evolutie Machine to P5
 *
 * Original concept and code by Herman G. Zijp from De Spullenmannen
 * Port to P5 by Luis Rodil-Fernandez
 */
int DISH_COUNT = 4;
PetriDish []dish;

void setup() {
  size(900, 500);
  
  dish = new PetriDish[DISH_COUNT];
  for(int i = 0; i < DISH_COUNT; i++) {
    Genotype genotype = new Genotype();
    genotype.seed();
    Phenotype phenotype = new Phenotype();
    phenotype.grow( genotype );
    dish[i] = new PetriDish( phenotype );
  }
}

void draw() {
  int xx = 10;
  int yy = 10;
  
  for(int i = 0; i < DISH_COUNT; i++) {
    pushMatrix();
      translate(xx, yy);
      stroke(255, 0, 0);
      dish[i].draw();
      xx += 210;
      dish[i].species.live(2);
    popMatrix();
  }
}
// scan keyboard input
void keyPressed() {
  if(key == ' ') {
    println("mutating all petri dishes...");
    for(int i = 0; i < DISH_COUNT; i++) {
      dish[i].species.myGenes.mutate();
      Phenotype phenotype = new Phenotype();
      phenotype.grow( dish[i].species.myGenes );
      dish[i] = new PetriDish( phenotype );
    }
  }
}


int randbool() {
  return (random(0, 1) >= 0.5) ? 1 : 0;
}

char randchar() {
  return (char)random(0, 255);
}

int N = 200;

class Genotype {
  char chromosome[];
  
  void seed() {
    chromosome = new char[2];
    chromosome[0] = randchar();
    chromosome[1] = randchar();
  }
  
  void mutate() {
    chromosome[0] ^= (1 << (randchar() % 8));
    chromosome[1] ^= (1 << (randchar() % 8));
  }
  
  Genotype crossover(Genotype mate) {
    return null;
  }
} // class Genotype

class Phenotype {
  int birth;
  int survive;
  int [][]state;
  Genotype myGenes;

  Phenotype() {
    state = new int[N][N];
  }
  
  void grow(Genotype genotype) {
    myGenes = genotype;
    birth = genotype.chromosome[0];
    survive = genotype.chromosome[1];
    for (int x=0;x<N;x++) { 
      for (int y=0;y<N;y++) { 
        state[x][y] = randbool();
      } // for
    } // for
  } // grow
  
  void live(int timesteps) {
    int i,x,y,xm,xp,ym,yp,nb;
    int [][]moore = new int[N][N];
    for (i=0;i<timesteps;i++) {
      for (x=0;x<N;x++) for (y=0;y<N;y++) {
	  xm=(x==0)?N-1:x-1; xp=(x==(N-1))?0:x+1;
	  ym=(y==0)?N-1:y-1; yp=(y==(N-1))?0:y+1;
	  nb=state[xm][ym]+state[xm][y]+state[xm][yp]+state[x][ym]+state[x][yp]+state[xp][ym]+state[xp][y]+state[xp][yp];
	  moore[x][y]=((nb!=0) ? (1<<nb-1) : 0);
      } // for..for
	
      for (x=0;x<N;x++) for (y=0;y<N;y++) switch (state[x][y]) {
	case 0: state[x][y]=((moore[x][y] & birth) > 0) ? 1 : 0; break;
	case 1: state[x][y]=((moore[x][y] & survive) > 0) ? 1 : 0; break;
      } // for..for..swtich
    } // for
  } // live
  
  void reproduce(Phenotype mate) {
  }
} // class Phenotype

class PetriDish {
  Phenotype species;
  boolean showLabel;
  
  PetriDish(Phenotype phe) {
    showLabel = false;
    species = phe;
  }
  
  void draw() {
    //stroke(255);
    
    for (int x=0;x<N;x++) 
      for (int y=0;y<N;y++) 
        if (species.state[x][y] != 0) point(x, y);
  } // draw

} // class

/*
class World {
Phenotype* species;
bool showLabel;
World(int x, int y, int w, int h, Serial* s);

Serial* serial;
void draw();
};

class Pool {
std::vector<Genotype> genes;
std::vector<Phenotype> species;
std::vector<World*> world;
Pool(int n);
};
*/

