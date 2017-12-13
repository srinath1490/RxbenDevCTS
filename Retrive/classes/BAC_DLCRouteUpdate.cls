global class BAC_DLCRouteUpdate implements database.Batchable<SObject>,schedulable{
 
    global String query;
    
    //constructor of class
    global BAC_DLCRouteUpdate(){
        Query='select id, Route__c from Drug_List_Criteria__c where Route__c = NULL ';
    }
    
    //Batch start method
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    //Batch execute method
    global void execute(Database.BatchableContext BC,List<SObject> Scope){
        system.debug('-----------------DLC----------- '+Scope.size());
       List<Drug_List_Criteria__C> dlclist =  (List<Drug_List_Criteria__C>)Scope; 
        if(dlclist!=null){
            for( Drug_List_Criteria__c dlc: dlclist ){
                dlc.Route__c='No';
            }
        }
               
        try{
            update dlclist ;
        }catch(exception e){    
        }
    }
    
    //Batch finsh method
    global void finish(Database.BatchableContext BC){

    }
     
    // Batch schedule method
    global void execute(schedulableContext MC){
        database.executeBatch(new BAC_DLCRouteUpdate(), 10000);
    }
         
}