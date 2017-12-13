/**
 * Class PCGHandler
 * Trigger Handler for the PCG SObject. This class implements the TriggerHandler interface to help ensure the trigger code is all in one place.
 */
public class PCGHandler extends TriggerHandler{

    public void beforeInsert(List<Partial_Control_Group__c> Solist){
    
        PCGonAccount(Solist);
    }
    
    /*
     *PCGonAccount
     *The system should not allow multiple PCG  on the account (Should only allow 1 FCG for each account)
     */
    public void PCGonAccount(List<Partial_Control_Group__c> Solist){
    
        set<id> accntId = new set<id>();
        Map<id,Boolean> accPCGMap = new Map<id,Boolean>();
        
        /*Creating list of all the accounts associated with the new PCG records*/
        for(Partial_Control_Group__c pc: Solist){
            accntId.add(pc.Account__c);
        }
        
        Map<id,account> accpredef = new Map<id,account>([select id,predefined__c from account where id=:accntId and predefined__c=true]);
        
        /*Creating set of all the PCG records associated with the predefined accounts from above list accntId*/
        List<Partial_Control_Group__c > PCGListold = [Select Id,Account__c,Account__r.Predefined__c from Partial_Control_Group__c 
        where Account__c in :accntId and Account__r.Predefined__c = true ];
        
        /*Creating a map of Predefined Account id and 'True' value if PCG exists*/
        for(Partial_Control_Group__c pcrec : PCGListold) {
            if(!accPCGMap.containsKey(pcrec.Account__c)){
                accPCGMap.put(pcrec.Account__c,True);
            }   
        } 
        
        /*Checking for error to be displayed or not*/
        for(Partial_Control_Group__c PCG : Solist){
            if(accPCGMap.containsKey(PCG.Account__c)){
                PCG.addError(system.Label.PCG_Error); 
            } else {
               if(accpredef.containskey(PCG.Account__c)){
                   accPCGMap.put(PCG.Account__c,True); 
               }else {
               //Do Nothing
               
               }
            }
        }
     } 
 }