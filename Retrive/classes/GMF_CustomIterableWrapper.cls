/**
*Purpose: Apex Custom iterator for creating XML for GMF objects
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR          DATE                DETAIL                                 
*   1.0 -    Ankur           14 July 2015       Apex Custom iterator to iterate on wrapper for creating XML for GMF objects
*======================================================================== 
**/
global class GMF_CustomIterableWrapper 
   implements Iterator<GMF_XMLWrapper>, Iterable<GMF_XMLWrapper>{ 

   //Variable declartion
   List<GMF_XMLWrapper> Ids{get; set;} 
   Integer i {get; set;} 

   //Constructor for iterator
   public GMF_CustomIterableWrapper (list<GMF_XMLWrapper> passedids){ 
        i = 0;
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
   global GMF_XMLWrapper next(){ 

       i++; 
       return Ids[i-1]; 
   } 
   global Iterator<GMF_XMLWrapper> Iterator()
   {
      return this;   
   }   
}