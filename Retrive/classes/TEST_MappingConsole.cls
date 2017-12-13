/*Purpose: Apex Test Class for Mapping Console Functionality.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Joognu Rao                 2/24/2015       Apex Test Class for Mapping Console Functionality.
======================================================================== 
*/
@isTest 
private class TEST_MappingConsole {


    static testMethod void myUnitTest() {
    
            
                List<Mapping_Request__c>lstMR = new List<Mapping_Request__c>();
                Mapping_Request__c objMR= new Mapping_Request__c();
                objMR.Status__c= 'new';
                objMR.Valid__c= false;
                objMR.Approved__c= false;
                objMR.Stage__c = 'level 1';
                objMR.Line_Value_State__c ='New Line Value added';            
                insert objMR;
                    
                lstMR.add(objMR);
                
                Mapping__c mc = new Mapping__c();
                mc.create__c = true;
                mc.Object__c = 'drug_coverage__c';
                insert mc;
                
                Mapping__c mc1 = new Mapping__c();
                mc1.create__c = FALSE;
                mc1.Object__c = 'DC_Drug_List_Group__c';
                insert mc1;
                 
                Mapping_Template__c mt = new Mapping_Template__c();
                mt.MappingColumnID__c = mc.id;
                insert mt;
               
                Mapping_Template__c mt1 = new Mapping_Template__c();
                mt1.MappingColumnID__c = mc1.id;
                insert mt1;
                
                Provision__c pr = new Provision__c();
                pr.name = 'Provision 8888';
                pr.Provision_Text__c = 'Test Class Provision';
                pr.ProvisionNumber__c = 8888;
                pr.active__c = TRUE;
                insert pr;
                
                LineValue__c lv = new LineValue__c();
                lv.active__c = false;
                lv.Line_value__c = 9999;
                lv.name = 'P8888L9999';
                lv.Line_value_text__c = 'Test Class Line Value';
                lv.Provision_ID__c = pr.id;
                lv.Mapping_Request__c=objMR.id;
                insert lv;

                LineValue__c lv1 = new LineValue__c();
                lv1.active__c = true;
                lv1.Line_value__c = 9999;
                lv1.name = 'P8888L9999';
                lv1.Line_value_text__c = 'Test Class Line Value';
                lv1.Provision_ID__c = pr.id;               
                insert lv1; 
                
                objMR.Valid__c = true;
                objMR.ownerid = userInfo.getUserId();
                objMR.stage__c = 'Level 2';
                update objMR;
                
                
                objMR.ownerid = userInfo.getUserId();
                objMR.stage__c = 'Level 3';
                update objMR;
               
                Mapping_Values__c mv = new Mapping_Values__c();
                
                mv.FieldValue__c = 'TestJR';
                mv.Line_ValueID__c = lv.id;
                mv.MappingColumnID__c =mc1.id;
                mv.Start_Date__c = system.today();
                mv.End_Date__c = system.today().addDays(2);
                insert mv;
                
                 
            
            Test.startTest();
            {
                VFP_MappingRequest.onBeforeInsert(lstMR);
                VFP_MappingRequest.onBeforeOwnerUpdate(lstMR,lstMR);
                
                 objMR.Status__c= 'Submitted for first level approval';
                 update objMR;
                 
                 VFP_MappingRequest.onafterUpdate(lstMR,lstMR);
                 
                 objMR.Status__c= 'Submitted for second level approval';
                 objMR.Stage__c = 'level 2';
                 update objMR;
                
                VFP_MappingRequest.onafterUpdate(lstMR,lstMR);
                
                
            }
            Test.stopTest();
    }
    static testMethod void myUnitTest3() {
        List<Mapping_Request__c>lstMR = new List<Mapping_Request__c>();
                Mapping_Request__c objMR= new Mapping_Request__c();
                objMR.Status__c= 'new';
                objMR.Valid__c= false;
                objMR.Approved__c= false;
                objMR.Stage__c = 'level 1';
                objMR.Line_Value_State__c ='New Line Value added';            
                insert objMR;
                    
                lstMR.add(objMR);
                
                Mapping__c mc = new Mapping__c();
                mc.create__c = true;
                mc.Object__c = 'drug_coverage__c';
                insert mc;
                
                Mapping__c mc1 = new Mapping__c();
                mc1.create__c = FALSE;
                mc1.Object__c = 'DC_Drug_List_Group__c';
                insert mc1;
                 
                Mapping_Template__c mt = new Mapping_Template__c();
                mt.MappingColumnID__c = mc.id;
                insert mt;
               
                Mapping_Template__c mt1 = new Mapping_Template__c();
                mt1.MappingColumnID__c = mc1.id;
                insert mt1;
                
                Provision__c pr = new Provision__c();
                pr.name = 'Provision 8888';
                pr.Provision_Text__c = 'Test Class Provision';
                pr.ProvisionNumber__c = 8888;
                pr.active__c = TRUE;
                insert pr;
                
                LineValue__c lv = new LineValue__c();
                lv.active__c = false;
                lv.Line_value__c = 9999;
                lv.name = 'P8888L9999';
                lv.Line_value_text__c = 'Test Class Line Value';
                lv.Provision_ID__c = pr.id;
                lv.Mapping_Request__c=objMR.id;
                insert lv;

                LineValue__c lv1 = new LineValue__c();
                lv1.active__c = true;
                lv1.Line_value__c = 9999;
                lv1.name = 'P8888L9999';
                lv1.Line_value_text__c = 'Test Class Line Value';
                lv1.Provision_ID__c = pr.id;               
                insert lv1; 
                
                objMR.Valid__c = true;
                objMR.ownerid = userInfo.getUserId();
                objMR.stage__c = 'Level 2';
                update objMR;
                
                
                objMR.ownerid = userInfo.getUserId();
                objMR.stage__c = 'Level 3';
                update objMR;
               
                Mapping_Values__c mv = new Mapping_Values__c();
                
                mv.FieldValue__c = 'TestJR';
                mv.Line_ValueID__c = lv.id;
                mv.MappingColumnID__c =mc1.id;
                mv.Start_Date__c = system.today();
                mv.End_Date__c = system.today().addDays(2);
                insert mv;
                
                  Mapping_Values__c insertRecord = new Mapping_Values__c();
                  insertRecord.ExecutebyCode__c = 'prebuild';
                    insertRecord.FieldValue__c = 'Hii';
                    //insertRecord.End_Date__c = ;
                    insertRecord.Line_ValueID__c = lv1.id;
                    insertRecord.LoadDefaults__c = true;
                    insertRecord.MappingColumnID__c = mc.id;
                    insertRecord.Notes__c = 'test';
                    insertRecord.Parent_Field_Value__c = mv.id;
                    insertRecord.ParentMappingValue__c = mv.id;
                    //insertRecord.Record_Create_External_Id__c = Oldinstance.Record_Create_External_Id__c;
                    insertRecord.Newer_mapping_value__c = mv.id;
                    //insertRecord.RecordTypeId__c = Oldinstance.RecordTypeId__c;
                    insertRecord.Start_Date__c = system.now();
                    insertRecord.Version__c = '2.00';
                    insert insertRecord;
                    
                    Test.startTest();
                    {
                        insertRecord.FieldValue__c = 'Hiiiiii';
                        update insertRecord;
                    }
            
                    Test.stopTest();
        
    }
    static testMethod void myUnitTest1() {
    
            Mapping_Request__c objMR1= new Mapping_Request__c();
            objMR1.Status__c= 'new';
            objMR1.Valid__c= false;
            objMR1.Approved__c= false;
            objMR1.Line_Value_State__c ='Modified Existing Line Value';            
            insert objMR1;
            
            Mapping__c mc = new Mapping__c();
            mc.create__c = true;
            mc.Object__c = 'drug_coverage__c';
            insert mc;
            
            Mapping__c mc1 = new Mapping__c();
            mc1.create__c = false;
            mc1.Object__c = 'DC_Drug_List_Group__c';
            insert mc1;
             
            Mapping_Template__c mt = new Mapping_Template__c();
            mt.MappingColumnID__c = mc.id;
            insert mt;
           
            Mapping_Template__c mt1 = new Mapping_Template__c();
            mt1.MappingColumnID__c = mc1.id;
            insert mt1;
            
            Provision__c pr = new Provision__c();
            pr.name = 'Provision 8888';
            pr.Provision_Text__c = 'Test Class Provision';
            pr.ProvisionNumber__c = 8888;
            pr.active__c = TRUE;
            insert pr;
            
            LineValue__c lv = new LineValue__c();
            lv.active__c = TRUE;
            lv.Line_value__c = 9999;
            lv.name = 'P8888L9999';
            lv.Line_value_text__c = 'Test Class Line Value';
            lv.Provision_ID__c = pr.id;
            lv.Mapping_Request__c=objMR1.id;
            insert lv; 
            
            Mapping_Values__c mv = new Mapping_Values__c();
           
            mv.FieldValue__c = 'TestJR';
            mv.Line_ValueID__c = lv.id;
            mv.MappingColumnID__c =mc1.id;
            mv.Start_Date__c = system.today();
            mv.End_Date__c = system.today().addDays(2);
            insert mv;
    }

}