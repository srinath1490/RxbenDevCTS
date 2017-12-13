/*Purpose: Apex Class for Cloning the Max Pay                                       
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    Anuj                 02/23/2012       Apex Class for Cloning the Max Pay
   1.1 -    Sourabh              09/17/2012       Added the field Record Type
   1.2 -    Rahul                08/28/2013       Hix field added as per Request 01100
======================================================================== */
public class VFP_CloneMaxPayController {
    public Max_Pay__c originalMaxPay{get;set;}
    public string maxPayId;  
    Max_Pay__c cloneMaxPay;
    List<Exception__c> exceptionList = new List<Exception__c>();
    List<Max_Pay_Limitation__c> maxPayLimitList = new List<Max_Pay_Limitation__c>();
    
    public VFP_CloneMaxPayController(ApexPages.StandardController controller) {
        originalMaxPay = (Max_Pay__c)controller.getRecord();
        maxPayId = originalMaxPay.Id;
        //Hix field added as per Request 01100, By Rahul Nasa
        originalMaxPay = [select m.Id,m.Name,m.Date_Marked_for_Deletion__c,m.Deletion_Reason__c,m.Deletion_Requestor__c,m.Begin_Date__c,m.Mark_for_Deletion__c,
                          m.MP_Name__c,m.Message__c,m.End_Date__c,m.Record_Type__c,Hix__c,(select Id,Name,Begin_Days_Supply__c,End_Days_Supply__c,Max_Pay_Limit__c,
                          Max_Pay__c from Step_Max_Pay__r),(select Id,Name,Begin_Days_Supply__c,Effective_Date__c,End_Days_Supply__c,GPI__c,
                          Max_Pay_Limit__c,Message__c,Max_Pay_c__c,Termination_Date__c from Exception__r) from Max_Pay__c m where Id =:maxPayId ]; 
        
        cloneMaxPay = new Max_Pay__c ();  
        cloneMaxPay = originalMaxPay.clone(false); 
        maxPayLimitList = originalMaxPay.Step_Max_Pay__r;
    }
    public pagereference redirect(){
        List<Max_Pay_Limitation__c> clonemaxPayLimit = new List<Max_Pay_Limitation__c>();
        List<Exception__c> cloneException = new List<Exception__c>();
        Savepoint sp = Database.setSavepoint();
        try{
            insert cloneMaxPay ;
            if(maxPayLimitList.size()>0){
                for(Max_Pay_Limitation__c maxPayLimit:maxPayLimitList){
                    Max_Pay_Limitation__c payLimit = new Max_Pay_Limitation__c();
                        payLimit = maxPayLimit.clone(false);
                        payLimit.Max_Pay__c = cloneMaxPay.Id;
                    clonemaxPayLimit.add(payLimit);             
                }   
                insert  clonemaxPayLimit;
            }
            for(Exception__c exp: [select Id,Name,Begin_Days_Supply__c,Effective_Date__c,End_Days_Supply__c,GPI__c,
                          Max_Pay_Limit__c,Message__c,Max_Pay_c__c,Termination_Date__c from Exception__c where Max_Pay_c__c =: maxPayId]){
                    Exception__c cloneExp = new Exception__c();
                    cloneExp = exp.clone(false);
                    cloneExp.Max_Pay_c__c = cloneMaxPay.Id;
                    cloneException.add(cloneExp);
            }
            insert cloneException;
            
            Pagereference pageref= new Pagereference('/'+cloneMaxPay.Id+'/e?retURL='+cloneMaxPay.Id);
            return pageref ;   
         }catch(exception e){
                // roll everything back in case of error
                 Database.rollback(sp);
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.info,e.getMessage());
                 ApexPages.addMessage(myMsg);  
                 return null;
        }
    }
    
  Public Pagereference previouspage(){
         Pagereference pageref= new Pagereference('/'+originalMaxPay.Id+'/d?retURL='+originalMaxPay.Id);
         return pageref; 
    }
}