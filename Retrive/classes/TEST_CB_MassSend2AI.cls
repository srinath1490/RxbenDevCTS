/*Purpose: Apex Test Class to test MassSend2AI
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Amit            7 Oct 2014       Apex Test class to test MassSend2AI
======================================================================== */
@isTest(Seealldata = true)
private class TEST_CB_MassSend2AI {
    static testMethod void TEST_CB_MassSend2AI(){
        List<CRD__c> listCrd = new List<CRD__c>();
        CRD__c newCRD = new CRD__c();
        newCRD.CRD_Automated__c = True; 
        newCRD.Are_you_creating_a_Package_Plan__c = 'No';
        newCRD.Plan_Platform__c = 'Traditional/PPO';
        newCRD.Control__c = '1234556';
        newCRD.Plan__c = 'CB';
        newCRD.Sub_segment__c = 'ASB';
        newCRD.Platform_Information__c = 'T';
        newCRD.Predefined__c = True;
        insert newCRD;               
        listCrd.add(newCRD);
        case c = new case();
        c.RecordTypeId = '01250000000UJ20';
        c.Aetna_Case_Type__c = 'Account Manager Case';
        c.Status = 'New';
        c.Product__c = 'PPO';
        c.Description = 'Test';
        insert c;
        CRDBuildOrder__c newCrdBuilder = new CRDBuildOrder__c();
        newCrdBuilder.valid__c = true;
        newCrdBuilder.Build__c = true;
        newCrdBuilder.Complete__c = true;
        newCrdBuilder.CRD__c = newCRD.id;
        newCrdBuilder.FalloutCase__c = c.id;
        insert newCrdBuilder;
        
        
        Account ac = new Account();
        ac.Name = 'test1';
        insert ac;
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '1234556';
        pcg.CSAP_Plan_ID__c = 'CB';
        pcg.Subsegment__c = 'ASB';
        pcg.Account__c= ac.id;
        insert pcg;
        CB_MassSend2AI classMass = new CB_MassSend2AI();
       // classMass.massSend2AI(listCrd);
        List<string> ysch = GC_Utils_Method.calculateYSchedule(newCRD, newCRD.Sub_segment__c);
        List<String> yScheduleList = new List<String>();
        yScheduleList = ysch;
        VFP_SendToAIButtonController sendToAI = new VFP_SendToAIButtonController();
        List < string > RxPlanData = new list< string >() ;
        RxPlanData = sendToAI.SendToAI(newCRD.Id);
        BAC_CB_MassSend2AI.execute();
        
    }
    
    }