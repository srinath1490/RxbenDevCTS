/**
*Purpose:  Class for updating the Pers Seed Object when request is Sent to AI manually(Request 5431)  
*========================================================================
*History                                                            
*-------                                                            
*VERSION     AUTHOR          DATE                DETAIL                                 
*1.0 -    Joognu Rao     06 January'15       Updating Pers Seed Object when request is Sent to AI manually
*2.0	  Amit			 25 Nov, 2015         Added logic to Format control to 7 digit for Pers Seed, ST# 497
*======================================================================== 
**/
public with sharing class VFP_SeedPersStep {

/**    
* Method :- seedStep( CRD__c crd)
* Description :- Method to create Pers Seed records 
**/   
    public void seedStep(CRD__c crd){
        integer control;
        string plan;
        system.debug('**********JR*********');
        
        list < PERS_Seed__c > lstPersupdate = new list < PERS_Seed__c > ();
        PERS_Seed__c newPERSRow = new PERS_Seed__c();
              
            newPERSRow = new PERS_Seed__c();
            newPERSRow.crd__c = crd.id;
            newPERSRow.RxplanID__c = crd.RxPlanID__c;
            
            if(crd.Integration_1__c!=null){
                control = Integer.valueof((crd.Integration_1__c).substringBefore(','));
                 plan = (crd.Integration_1__c).substringAfter(',');
            }
                    
            newPERSRow.Control__c =  GC_Utils_Method.calculateControl(string.valueof(control));//Modified by Amit for ST# 497       
            newPERSRow.Plan__c = plan;
            newPERSRow.EffectiveDate__c = crd.Effective_Start_Date__c ;
            newPERSRow.Yschedule__c = crd.Y_Schd__c;
            
            
            
            newPERSRow.Key__c = ( newPERSRow.RxplanID__c != null ? newPERSRow.RxplanID__c : '') 
                                + (string.valueof(control) != null ? newPERSRow.Control__c : '')
                                + (plan != null ? plan : '')
                                + (newPERSRow.EffectiveDate__c != null ? DateTime.newInstance(newPERSRow.EffectiveDate__c, Time.newInstance(0,0,0,0)).format('MM/dd/yyyy') : '');
            
            lstPersupdate.add(newPERSRow);
            system.debug('***list**'+lstPersupdate);
             system.debug('**key***'+newPERSRow.Key__c);
                         
        //Insert PERS Seed  records
        try{
            
            Database.UpsertResult[] srList = Database.upsert(lstPersupdate,PERS_Seed__c.fields.Key__c);
        }catch(exception e){
            system.debug(e.getmessage()+'---------'+e.getCause()+'------'+e.getLineNumber());         
        }
        system.debug('^^^^^^^^^^^^'+lstPersupdate);
        
    }
}