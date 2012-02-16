import processing.pdf.*;

int currentGeneration = 0;
int POPULATION_SIZE = 9;
// there are a total of 9 biomorphs, the current one and eight more
int CURRENT = floor(POPULATION_SIZE / 2);
Biomorph []population;
BoxInterface iface;

PFont font;
//float xx, yy;
String lastLetter = "";

void setup() {
  size(700, 700);
  font = loadFont("Dialog-10.vlw");
  textFont(font);
  iface = new BoxInterface();
  //xx = width / 2;
  //yy = height / 2;
  
  population = new Biomorph[POPULATION_SIZE];
  for(int i = 0; i < POPULATION_SIZE; i++) {
    population[i] = new Biomorph();
  }
}

Biomorph mate(Biomorph a, Biomorph b) {
    Genotype ngenotype = a.gt.mate( b.gt );
    return new Biomorph( ngenotype );
}

/**
 * this implementation gets the middle individual from last generation and the selected one one from the current generation
 * and produces a new group of offspring.
 *
 * anotherway of going about this that might be more logical is to mate the selected one with all existing population mates
 * and replace the old individuals in place for the offpring they have with selected individual
 */
void repopulate(Biomorph a, Biomorph b) {
  println("---- creating new generation="+currentGeneration);
  noLoop(); // stop the drawing loop while we repopulate to avoid P5 crashing
    population[CURRENT] = b;
    for(int i = 0; i < POPULATION_SIZE; i++) {
      if(i != CURRENT) { // skip middle position
        population[i] = mate(a, b);
        if( population[i].isDegenerate() ) {
          println(">>> degenerate individual found!");
        }
      }
    }
    currentGeneration++;
  loop();
}

void repopulate(Biomorph select) {
  println("---- creating new generation="+currentGeneration);
  noLoop(); // stop the drawing loop while we repopulate to avoid P5 crashing
    population[CURRENT] = select;
    for(int i = 0; i < POPULATION_SIZE; i++) {
      if(i != CURRENT) { // skip middle position
        Biomorph offspring = mate(population[i], select);
        //Genotype offspring = a.gt.mate( b.gt );
        population[i] = offspring;
        if( population[i].isDegenerate() ) {
          println(">>> degenerate individual found!");
        }
      }
    }
    currentGeneration++;
  loop();
}


void mouseClicked() {
  //iface.clicked(mouseX, mouseY);
  if( iface.isBoxClicked() ) {
    lastLetter = iface.boxLetter();
    //repopulate(population[CURRENT], population[iface.whichBox()]);
    repopulate( population[iface.whichBox()] );
  }
}

void draw() {
  smooth();
  background(0, 0, 40);
  
  //iface.update(current, population);
  
  if(currentGeneration > 0) {
    text("this one was "+lastLetter+" in generation "+currentGeneration , ((width/2) - 70), ((height/2) - 100) );
  }
  
  iface.draw();
  for(int i = 0; i < POPULATION_SIZE; i++) {
    PVector bc = iface.boxCenter(i);
    pushMatrix();
      //println("bx.size = "+iface.boxSize);
      float dy = (bc.y + ((float)iface.boxSize/2.20));
      translate(bc.x, dy); //bc.y);
      stroke(255);
      population[i].draw( this.g );
    popMatrix();
  }
}

void keyPressed() {
  if(key == 's') {
    println("saving to PDF nr."+currentGeneration+"...");
    PGraphics pdf = createGraphics(1000, 1000, PDF, "biomorph-"+currentGeneration+".pdf");
    pdf.beginDraw();
    pdf.translate(500, 850);
    stroke(0);
    population[CURRENT].draw( pdf );
    pdf.dispose();
    pdf.endDraw();
  }
}
