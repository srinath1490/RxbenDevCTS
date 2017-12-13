/*Purpose: Apex Test Class to test Trigger TRG_Drugbeforeinsertupdate
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Ayushi         3rd May 2016       Apex Test class to test Trigger TRG_Drugbeforeinsertupdate
======================================================================== */
@isTest
private class TEST_TRG_Drugbeforeinsertupdate{   
    
    static testMethod void TEST_DrugrecordInsert(){
    
        FDA__c FDArec = new FDA__C();
        FDArec.NDC__c = '12341';
        FDArec.FDA_Application_Type__c = 'A';
        FDArec.FDA_Application_Type_Effective_Date__c = date.newinstance(2016,5,3);
        FDArec.FDA_Application_Type_Termination_Date__c = date.newinstance(2021,6,4);
        insert FDArec;
        
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
        
        Drug__c DrugRecMod = [select FDA__c,FDA_Application_Type_c__c,FDA_Application_Type_Effective_Date__c,FDA_Application_Type_Termination_Date__c from Drug__c where id=:Drugrec.id];
            
        system.assertEquals(DrugRecMod.FDA__c,FDArec.id);        
        system.assertEquals(DrugRecMod.FDA_Application_Type_c__c,FDArec.FDA_Application_Type__c);
        system.assertEquals(DrugRecMod.FDA_Application_Type_Effective_Date__c,FDArec.FDA_Application_Type_Effective_Date__c);
        system.assertEquals(DrugRecMod.FDA_Application_Type_Termination_Date__c,FDArec.FDA_Application_Type_Termination_Date__c);
        
    }
    
    
    static testMethod void TEST_DrugrecordUpdate1(){
    
        FDA__c FDArec = new FDA__C();
        FDArec.NDC__c = '12341';
        FDArec.FDA_Application_Type__c = 'D';
        FDArec.FDA_Application_Type_Effective_Date__c = date.newinstance(2016,5,3);
        FDArec.FDA_Application_Type_Termination_Date__c = date.newinstance(2021,6,4);
        insert FDArec;
        
        FDA__c FDArec1 = new FDA__C();
        FDArec1.NDC__c = '456709';
        FDArec1.FDA_Application_Type__c = 'S';
        FDArec1.FDA_Application_Type_Effective_Date__c = date.newinstance(2016,4,9);
        FDArec1.FDA_Application_Type_Termination_Date__c = date.newinstance(2019,7,8);
        insert FDArec1;
        
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
        
        Drugrec.NDC__c = '456709';
        update Drugrec;
        
        Drugrec.Product_Name__c = 'ProdTest1';
        update Drugrec;
                
        Drug__c DrugRecMod = [select FDA__c,FDA_Application_Type_c__c,FDA_Application_Type_Effective_Date__c,FDA_Application_Type_Termination_Date__c from Drug__c where id=:Drugrec.id];
            
        system.assertEquals(DrugRecMod.FDA__c,FDArec1.id);
        system.assertEquals(DrugRecMod.FDA_Application_Type_c__c,FDArec1.FDA_Application_Type__c);
        system.assertEquals(DrugRecMod.FDA_Application_Type_Effective_Date__c,FDArec1.FDA_Application_Type_Effective_Date__c);
        system.assertEquals(DrugRecMod.FDA_Application_Type_Termination_Date__c,FDArec1.FDA_Application_Type_Termination_Date__c);
        
    }
    
    
    static testMethod void TEST_DrugrecordUpdate2(){
    
        FDA__c FDArec = new FDA__C();
        FDArec.NDC__c = '12341';
        FDArec.FDA_Application_Type__c = 'D';
        FDArec.FDA_Application_Type_Effective_Date__c = date.newinstance(2016,5,3);
        FDArec.FDA_Application_Type_Termination_Date__c = date.newinstance(2021,6,4);
        insert FDArec;
        
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
        
        Drugrec.NDC__c = '456709';
        update Drugrec;
                
        Drug__c DrugRecMod = [select FDA__c,FDA_Application_Type_c__c,FDA_Application_Type_Effective_Date__c,FDA_Application_Type_Termination_Date__c from Drug__c where id=:Drugrec.id];
            
        system.assertEquals(DrugRecMod.FDA__c,null);
        system.assertEquals(DrugRecMod.FDA_Application_Type_c__c,null);
        system.assertEquals(DrugRecMod.FDA_Application_Type_Effective_Date__c,null);
        system.assertEquals(DrugRecMod.FDA_Application_Type_Termination_Date__c,null);
        
    }
    
}