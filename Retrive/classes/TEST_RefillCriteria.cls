/*Purpose: Apex Test Class for VFP_RefillCriteria Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Abhay                 11/2/2011       Apex Test Class for VFP_RefillCriteria Page.
======================================================================== 
*/
@isTest
private class TEST_RefillCriteria{
    static testmethod void testRefillCriteria() {
        Refill_Too_Soon__c refillToSoon=new Refill_Too_Soon__c();        
        refillToSoon.Refill_too_Soon_Description__c='test';
        refillToSoon.Refill_too_Soon_Name__c='test';
        insert refillToSoon;
        
        Refill_Too_Soon_Criteria__c refillCrit=new Refill_Too_Soon_Criteria__c();
        refillCrit.Related_Refill_Too_Soon__c=refillToSoon.id;
        insert refillCrit;
        update refillCrit;  
    }
}