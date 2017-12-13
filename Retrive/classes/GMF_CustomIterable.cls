/**
*Purpose: Apex Custom iterator for creating XML for GMF objects
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR          DATE                DETAIL                                 
*   1.0 -    Ankur           14 July 2015       Apex Custom iterator for creating XML for GMF objects
*======================================================================== 
**/
global class GMF_CustomIterable 
   implements Iterator<id>, Iterable<id>{ 

   //Variable declartion
   List<id> Ids{get; set;} 
   Integer i {get; set;} 

   //Constructor for iterator
   public GMF_CustomIterable (list<id> passedids){ 
       Ids= passedids;
   }   

   //Check if list has more records
   global boolean hasNext(){ 
       if(i >= Ids.size()) {
           return false; 
       } else {
           return true; 
       }
   }    

   //Return next record.
   global Id next(){ 

       i++; 
       return Ids[i-1]; 
   } 
   global Iterator<id> Iterator()
   {
      return this;   
   }   
}