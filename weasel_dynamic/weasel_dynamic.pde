/*
 * Example of population dynamics in evolution.
 * (c) 2011 Luis Rodil-Fernandez
 *
 * .random mutations
 * .fitness = levenhstein distance with target string
 * .no match locking
 * .population dynamics
 */
PFont font;
boolean paused = false;

// this string will be what we will be avolving "towards"
String target = "methinks it is like a weasel";

Genotype current;
Genotype[] ancestors;
int MAX_ANCESTORS = 22;
int index = 0;

Population pop;
int POPULATION_SIZE = 500;

void setup()  {
  size(400, 500);
  font = loadFont("Georgia-16.vlw");
  textFont(font);
  
  current = new Genotype(target.length());
  current.randomize();

  pop = new Population(POPULATION_SIZE, current);
  ancestors = new Genotype[MAX_ANCESTORS];
}

void draw() {
  background(0, 20, 0);
  
  // display the number of generations at the top of the screen
  fill(255, 255, 0);
  text("(press the spacebar to pause)   generations:  "+pop.generation, (width/2)-160, 20);

  // get fittest in current population  
  current = pop.getFittest( target );
  
  // draw current genotype at the bottom
  fill(0, 255, 0);
  textFont( font );
  int fitness = int(current.fitness * 100);
  text(current.toString(), 20, height-20);
  text("fitness: "+fitness+"%", width-100, height-20);
  
  // draw ancestors from bottom to top
  fill(0, 150, 0);
  int y = height - 40;
  //print("ancestors=" + ancestors.length+"\n");
  for(int i = 0; i < ancestors.length; i++) {
    Genotype a = ancestors[i];
    if(a != null) {
      text(a.toString(), 20, y);
      // print fitness of this specimen
      int f = int(a.fitness * 100);
      text(""+f+"%", width-100, y);
      /*if(y < 0) break;*/
    }
    y = y - 20;
  }
  
  // if a perfect fit wasn't found, continue evolving
  if(fitness < 100 ) {
    push(current.clone()); // save this genotype as ancestor before next generation
    evolve();
  } else {
    noLoop();
  }
} // draw

void evolve() {
  // mate the fittest with a random sample from the population and repopulate
  Genotype mate = pop.getSecondBest(); //getRandom();
  pop.repopulate( current, mate, true );
  //println("mating '"+current.toString()+"' with '"+mate.toString()+"'");
}

void push(Genotype gt) {
  ancestors[index] = gt;
  index++;
  index = index % MAX_ANCESTORS;
}

void togglePause() {
  paused = !paused;
  if(paused) {
    noLoop();
  } else {
    loop();
  }
}

// scan keyboard input
void keyPressed() {
  if(key == ' ') {
    togglePause();
  }
}

