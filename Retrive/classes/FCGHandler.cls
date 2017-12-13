/**
 * Class FCGHandler
 * Trigger Handler for the FCG SObject. This class implements the TriggerHandler interface to help ensure the trigger code is all in one place.
 */
public class FCGHandler extends TriggerHandler{

    public void beforeInsert(List<Full_Control_Group__c> Solist){
         
        FCGonAccount(Solist);
        
    } 
    /*
     *FCGonAccount
     *The system should not allow multiple FCG  on the account (Should only allow 1 FCG for each account)
     */
    public void FCGonAccount(List<Full_Control_Group__c> Solist){
        
        set<id> accntId = new set<id>();
        Map<id,Boolean> accFCGMap = new Map<id,Boolean>();
        
        /*Creating list of all the accounts associated with the new FCG records*/
        for(Full_Control_Group__c fc: Solist){
            accntId.add(fc.Account_Name__c);
        }
        
        Map<id,account> accpredef = new Map<id,account>([select id,predefined__c from account where id=:accntId and predefined__c=true]);
        
        /*Creating set of all the FCG records associated 
         *with the predefined accounts from above list accntId
         */
        List<Full_Control_Group__c> FCGListold = [Select Id,Account_name__c,Account_Name__r.Predefined__c from Full_Control_Group__c
        where Account_Name__c in :accntId and Account_Name__r.Predefined__c= true ];
        
        /*Creating a map of Predefined Account id and 'True' value if FCG exists*/
         
        for(Full_control_group__c fcrec : FCGListold) {
            if(!accFCGMap.containsKey(fcrec.Account_Name__c)){
                accFCGMap.put(fcrec.Account_Name__c,True);
            }   
        } 
        
        /*Checking for error to be displayed or not*/
         
        for(Full_control_group__c fcg : Solist){
            if(accFCGMap.containsKey(fcg.Account_Name__c)){
                fcg.addError(system.Label.FCG_Error); 
            } else {
               if(accpredef.containskey(fcg.Account_Name__c)){
                   accFCGMap.put(fcg.Account_Name__c,True); 
               }else {
               //Do Nothing
               
               }
            }
        }
    } 
}