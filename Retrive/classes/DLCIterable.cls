global class DLCIterable implements iterable<Drug_List_Criteria__c>{
    List<Drug_List_Criteria__c> DLCTempList;
    global DLCIterable(List<Drug_List_Criteria__c> dlcArg){

        DLCTempList=dlcArg;
    }
   global Iterator<Drug_List_Criteria__c> Iterator(){
      return new DLCCustomIterable(DLCTemPList);
   }
   
    //===Test cases===
    @isTest(SeeAllData=true)
   static void myUnitTest() {

		DLCIterable dlcIterable=new DLCIterable([select Id from Drug_list_criteria__c LIMIT 5]);
        system.assert(dlcIterable.Iterator()!=NULL);
    }
}