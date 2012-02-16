/**
 * This class get's your creature's genome and freezes it to store it for posterity
 * do you remember Jurassic Park. This is like the amber stone then.  :)
 *
 * (cc-aa-nc-sa) 2012 Luis Rodil-Fernandez
 */
public class StoreFreezer {
   String[] data;
   
   public void freeze(String fname, Genome g) {
     data = new String[1];
     data[0] = g.toString();
     saveStrings(fname, data);
   }
   
   public Genome defrost(String fname) {
     data = loadStrings(fname);
     
     // create a null genome to parse (note for hackers this should be static but processing is picky about static stuff)
     Genome retval = new Genome(0);
     retval = retval.parseFromString( data[0] );
     //println( retval.toString() );
     return retval;
   }
 } // public StoreFreezer
