global class DLCCustomIterable 
   implements Iterator<Drug_List_Criteria__c>{ 

   global List<Drug_List_Criteria__c> accs {get; set;} 
   global integer i {get; set;}
   global integer listSize;

   public DLCCustomIterable(List<Drug_List_Criteria__c> dlcList){ 
       listSize=dlcList.size();
       accs = dlcList;
       i=0;
       
   }   

   global boolean hasNext(){ 
       if(i >= accs.size()) {
           return false; 
       } else {
           return true; 
       }
   }    

   global Drug_List_Criteria__c next(){ 
      if(i == listSize){return null;} 
       i++; 
       return accs[i-1]; 
   } 
   
   //===Test cases===
   @isTest(SeeAllData=true)
   static void myUnitTest() {

		DLCCustomIterable dlcIterable=new DLCCustomIterable([select Id from Drug_list_criteria__c LIMIT 5]);
		If(dlcIterable.hasNext())
		     system.assert(dlcIterable.next()!=NULL);
    }
}