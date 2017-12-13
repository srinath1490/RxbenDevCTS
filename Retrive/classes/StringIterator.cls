global class StringIterator  implements Iterator<string>, Iterable<string>{ 

   List<String> allData {get; set;} 
   Integer i {get; set;} 

   public StringIterator(List<String> allData){ 
       this.allData = allData;
       i = 0; 
   }   
   public StringIterator(){ 
       this.allData = new List<String>();
       i = 0; 
   }

   global boolean hasNext(){ 
       if(i >= allData.size()) {
           return false; 
       } else {
           return true; 
       }
   }    

   global String next(){ 
       // 8 is an arbitrary 
       // constant in this example
       // that represents the 
       // maximum size of the list.
       if(i == allData.size()){return null;} 
       i++; 
       return allData[i-1]; 
   } 
   
   global Iterator<String> Iterator(){
      return this;
   }
}