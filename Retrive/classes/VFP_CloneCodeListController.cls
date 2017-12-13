/*Purpose: Apex Class for Cloning the CodeList                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 01/06/2012       Apex Class for Cloning the codeList
   1.1      Anuj                 02/24/2012       error handling logic implemented.
======================================================================== */
public class VFP_CloneCodeListController {
    
    public Codes_List__c originalCodeList{get;set;}
    public string codeListId{get;set;}
    Public List<Codes__c> listOfCodes;    
    Codes_List__c cloneCodeList;
    
    public VFP_CloneCodeListController(ApexPages.StandardController controller) {
        this.originalCodeList = (Codes_List__c)controller.getRecord();
        listOfCodes = new List<Codes__c>();
        codeListId = originalCodeList.id;
        //Hix field added as per Request 01100, By Rahul Nasa
        originalCodeList =[Select Id,Name,Account__c,Code_List_Name__c,Code_List_Description__c,Date_Marked_for_Deletion__c,Deletion_Reason__c,Deletion_Requestor__c,
                           Effective_Date__c, Funding_Type__c,Inactive__c,Mark_for_Deletion__c,Standard__c,Termination_Date__c,Hix__c,(Select RecordTypeId,
                           Related_Code_List__c,POS_Dose_Optimization__c,Result_of_Service_Codes__c,Professional__c from Codes__r) from Codes_List__c  where Id =:codeListId ];
       
        listOfCodes = originalCodeList.Codes__r;
        cloneCodeList = new Codes_List__c();
        cloneCodeList =originalCodeList.clone(false);

    }
    
    //Method to create the cloned data and redirect to the new cloned record
    Public Pagereference redirect(){
        Savepoint sp = Database.setSavepoint();
        try{
           insert cloneCodeList;
           List<Codes__c> newCodes = new List<Codes__c>();
           if(listOfCodes.size() != 0){
               for(Codes__c Codes :listOfCodes){
                  Codes__c tempCodes = new Codes__c();
                    tempCodes = Codes.clone(false);
                    tempCodes.Related_Code_List__c = cloneCodeList.Id;
                    newCodes.add(tempCodes);
                }
                insert newCodes ;
           }
          Pagereference pageref= new Pagereference('/'+cloneCodeList.Id+'/e?retURL='+cloneCodeList.Id);
           return pageref ;
        }catch(exception e){
               // roll everything back in case of error
                Database.rollback(sp);
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,e.getMessage());
                 ApexPages.addMessage(myMsg);  
                 return null;   
        }
    }
    
    public Pagereference previouspage(){
             Pagereference pageref= new Pagereference('/'+originalCodeList.Id+'/d?retURL='+originalCodeList.Id);
              return pageref; 
     }
}