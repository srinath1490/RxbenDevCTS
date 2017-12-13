/*Purpose: Apex Test Class to test Trigger TRG_FDAafterinsertupdate
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Ayushi         3rd May 2016       Apex Test class to test Trigger TRG_FDAafterinsertupdate
======================================================================== */
@isTest
private class TEST_TRG_FDAafterinsertupdate{   
    
    static testMethod void TEST_FDArecordInsert(){
    
        Drug__c Drugrec = new Drug__c();
        Drugrec.NDC__c = '12341';
        Drugrec.GPI__c = '1234*';
        Drugrec.Label_Name__c = 'TestLabel';
        Drugrec.Product_Name__c = 'ProdTest';
        Drugrec.GPI_Generic_Name__c = 'Azithromycin';
        Drugrec.Manufacturer_Labeler_Name__c ='LabelName';
        Drugrec.Labeler_Code__c = '34123';
        Drugrec.Package_Description__c = 'Testdesc';
        insert Drugrec;
        
        FDA__c FDArec = new FDA__C();
        FDArec.NDC__c = '12341';
        FDArec.FDA_Application_Type__c = 'A';
        FDArec.FDA_Application_Type_Effective_Date__c = date.newinstance(2016,5,3);
        FDArec.FDA_Application_Type_Termination_Date__c = date.newinstance(2021,6,4);
        insert FDArec; 
        
        Drug__c DrugRecMod = [select FDA__c,FDA_Application_Type_c__c,FDA_Application_Type_Effective_Date__c,FDA_Application_Type_Termination_Date__c from Drug__c where id=:Drugrec.id];
            
        system.assertEquals(DrugRecMod.FDA__c,FDArec.id);        
        system.assertEquals(DrugRecMod.FDA_Application_Type_c__c,FDArec.FDA_Application_Type__c);
        system.assertEquals(DrugRecMod.FDA_Application_Type_Effective_Date__c,FDArec.FDA_Application_Type_Effective_Date__c);
        system.assertEquals(DrugRecMod.FDA_Application_Type_Termination_Date__c,FDArec.FDA_Application_Type_Termination_Date__c);
        
    }
    
    
    static testMethod void TEST_FDArecordUpdate(){
    
        Drug__c Drugrec = new Drug__c();
        Drugrec.NDC__c = '12341';
        Drugrec.GPI__c = '1234*';
        Drugrec.Label_Name__c = 'TestLabel';
        Drugrec.Product_Name__c = 'ProdTest';
        Drugrec.GPI_Generic_Name__c = 'Azithromycin';
        Drugrec.Manufacturer_Labeler_Name__c ='LabelName';
        Drugrec.Labeler_Code__c = '34123';
        Drugrec.Package_Description__c = 'Testdesc';
        insert Drugrec;
        
        Drug__c Drugrec1 = new Drug__c();
        Drugrec1.NDC__c = '12342';
        Drugrec1.GPI__c = '1534*';
        Drugrec1.Label_Name__c = 'TestLabel';
        Drugrec1.Product_Name__c = 'ProdTest';
        Drugrec1.GPI_Generic_Name__c = 'Azithromycin';
        Drugrec1.Manufacturer_Labeler_Name__c ='LabelName';
        Drugrec1.Labeler_Code__c = '34124';
        Drugrec1.Package_Description__c = 'Testdesc';
        insert Drugrec1;
        
        FDA__c FDArec = new FDA__C();
        FDArec.NDC__c = '12341';
        FDArec.FDA_Application_Type__c = 'A';
        FDArec.FDA_Application_Type_Effective_Date__c = date.newinstance(2016,5,3);
        FDArec.FDA_Application_Type_Termination_Date__c = date.newinstance(2021,6,4);
        insert FDArec; 
        
        FDArec.NDC__c = '12342';
        update FDArec;
        
        FDArec.FDA_Application_Type_Effective_Date__c = date.newinstance(2016,7,4);
        update FDArec;
        
        Drug__c DrugRecMod = [select FDA__c,FDA_Application_Type_c__c,FDA_Application_Type_Effective_Date__c,FDA_Application_Type_Termination_Date__c from Drug__c where id=:Drugrec.id];
        Drug__c DrugRecMod1 = [select FDA__c,FDA_Application_Type_c__c,FDA_Application_Type_Effective_Date__c,FDA_Application_Type_Termination_Date__c from Drug__c where id=:Drugrec1.id];        
            
        system.assertEquals(DrugRecMod.FDA__c,FDArec.id);
        system.assertEquals(DrugRecMod.FDA_Application_Type_c__c,FDArec.FDA_Application_Type__c);
        system.assertEquals(DrugRecMod.FDA_Application_Type_Effective_Date__c,FDArec.FDA_Application_Type_Effective_Date__c);
        system.assertEquals(DrugRecMod.FDA_Application_Type_Termination_Date__c,FDArec.FDA_Application_Type_Termination_Date__c);
        
        system.assertEquals(DrugRecMod1.FDA__c,FDArec.id);        
        
    }
    
}