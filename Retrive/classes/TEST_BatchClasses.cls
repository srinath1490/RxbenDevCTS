/*Class Name: TEST_BatchClasses
* Author: Accenture
* Date: 25-01-2012
* Requirement/Project Name: <Aetna> 
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ANUJ              25/12/2011      Test Class for Apex class BAC_DrugDescriptionMapping
   1.1 -    ANUJ               27/01/2012     New methods to cover Apex Classes BAC_StepTherapyDescriptionMapping and BAC_StepTherapyDescriptionMapping
======================================================================== */
@isTest
private class TEST_BatchClasses {

        static testmethod void testDrugDescriptionMapping(){      
            DateTime currTime = DateTime.now();
            Integer min = currTime.minute();
            Integer hour = currTime.hour();
            String sch;
        
            if(min <= 58)
                sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
            else if(hour == 23)    
                 sch = '0 0 0 * * ? '+ currTime.year();     
            else    
                sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
             
            Test.startTest();          
                BAC_DrugDescriptionMapping obj = new BAC_DrugDescriptionMapping ();
                    obj.Query= 'Select Id,Name,Drug_Type_Code__c,Drug_Code_Value__c,NDC__c,Drug_List_Criteria_Description__c,Description_of_NDC_Drug_List_Criteria__c from Drug_List_Criteria__c where Drug_List_Criteria_Description__c = null Limit 4';                
                String jobId = system.schedule('Deployment', sch, obj);        
                CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger where id = :jobId];        
                    System.assertEquals(sch, ct.CronExpression);                                      
               
                try{ 
                    database.executeBatch(obj,40);    
                }catch(exception e){
                }              
             Test.stopTest();
      }
      
      static testmethod void testFormularyListEntryDescriptionMapping(){  
           DateTime currTime = DateTime.now();
           Integer min = currTime.minute();
           Integer hour = currTime.hour();
           String sch;
        
           if(min <= 58)
                 sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
           else if(hour == 23)    
                 sch = '0 0 0 * * ? '+ currTime.year();     
            else          
                 sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
                                 
          Test.startTest();        
              BAC_FormularyListEntryDescriptionMapping obj = new BAC_FormularyListEntryDescriptionMapping ();
                  obj.Query= 'SELECT Description_of_Formulary_List_Entry__c,NDC__c FROM Formulary_List_Entry__c where Description_of_Formulary_List_Entry__c = null Limit 2';                
              String jobId = system.schedule('Aetna', sch, obj);        
              CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger where id = :jobId];        
                   System.assertEquals(sch, ct.CronExpression);                                       
            try{ 
                database.executeBatch(obj,2);    
            }catch(exception e){ 
            }     
          Test.stopTest();
    }
    
    static testmethod void testStepTherapyDescriptionMapping(){        
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else if(hour == 23)    
                 sch = '0 0 0 * * ? '+ currTime.year();     
            else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
          
        Test.startTest();   
            BAC_StepTherapyDescriptionMapping obj = new BAC_StepTherapyDescriptionMapping ();
                obj.Query= 'Select Id,Name,Description_of_Pre_Requisite_Drug__c,Drug_Code_Value__c,Drug_Type_Code__c FROM Step_Therapy_PreRequisite_Drug__c where Description_of_Pre_Requisite_Drug__c = null Limit 2';                
            String jobId = system.schedule('test3', sch, obj);        
            CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger where id = :jobId];        
                System.assertEquals(sch, ct.CronExpression);                                              
            try{ 
                database.executeBatch(obj,2);    
            }catch(exception e){          
            }     
         Test.stopTest();
    }
}