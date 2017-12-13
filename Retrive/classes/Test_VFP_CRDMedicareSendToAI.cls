/*
Purpose: Apex Test Class for VFP_CRDMedicareSendToAI
===================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE                DETAIL
------------------------------------------------------------------------------------------------------
1.0         sushant         04/23/2013          Apex Test Class for VFP_CRDMedicareSendToAI
*/
@isTest
private class Test_VFP_CRDMedicareSendToAI {

        static testMethod void myUnitTest() {

        /* Creation of Test CRDMedicare */
        crd_medicare__c CRDMedicareSendToAI = new crd_medicare__C();
        CRDMedicareSendToAI.Custom_BEN_ID__c = '123456';
        CRDMedicareSendToAI.Do_mandates_apply_to_all_states__c = 'Yes';
        CRDMedicareSendToAI.Funding_Type__c = 'Fully Insured';
        CRDMedicareSendToAI.Remove_States_List_for_Mandate__c = NULL;
        CRDMedicareSendToAI.Request_Type__c = 'HMO';
        CRDMedicareSendToAI.Risk_Indicator__c = 'R';
        CRDMedicareSendToAI.RxPlan_ID__c = '654321';
        CRDMedicareSendToAI.State_List_for_Mandate__c = NULL;
        CRDMedicareSendToAI.Y_Schedule__c = 'Y2';
        insert CRDMedicareSendToAI;

        test.starttest();

        id SendToAIID = VFP_CRDMedicareSendToAI.sendAiRequest(CRDMedicareSendToAI.id);        // Call sendairequest method and passing ID of newly created CRDMedicare
        CRD_Medicare_AI_Request__c AIRequest = [Select CRD_Medicare_Id__c from CRD_Medicare_AI_Request__c WHERE Id = :SendToAIID];
        system.assertEquals(AIRequest.CRD_Medicare_Id__c, CRDMedicareSendToAI.Id);
        VFP_CRDMedicareSendToAI.callout(SendToAIID);

        test.stoptest();
    }
}