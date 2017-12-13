@isTest
private class DocumentControlController_Test {
         
        
        static testmethod void testrecordTypeSettingClass(){
        
            // Create dummy data for test purposes.
            DocumentControl__c sec = new DocumentControl__c(
               Name__c = 'Enter name', Details_Of_Change__c = 'Enter details', Reason__c = 'Enter reason',Refrence_No__c='Enter Refer. #' ,Release__c= 0,Version__c = 0
                );         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.ReportPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', '1');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            DocumentControlController bsExt = new DocumentControlController(controller);                       
            DocumentControlController.DocumentControlWrapper wrp = new DocumentControlController.DocumentControlWrapper();
            wrp.getDocumentControl();
            wrp.getIndex();
            bsExt.DocumentControlList.add(wrp);
            bsExt.getDocumentControlList();
            bsExt.save();
            bsExt.addRecord();
             bsExt.deleteRow(); 
            bsExt.clear();
                   
                
         Test.stoptest();
         }
        static testmethod void testObjectPermissionClass_Excep(){
        
           // Create dummy data for test purposes.
            DocumentControl__c sec = new DocumentControl__c(
                Name__c = 'Test Documentname'
                );         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.ReportPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', 'hi');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            DocumentControlController bsExt = new DocumentControlController(controller);                       
            DocumentControlController.DocumentControlWrapper wrp = new DocumentControlController.DocumentControlWrapper();                         
            bsExt.deleteRow();
    
    
        }           
         static testmethod void testObjectPermissionClass_ExcepSave(){
         list <DocumentControl__c> records =  new list<DocumentControl__c>();
             DocumentControl__c obj = new DocumentControl__c(
               Name__c = 'Enter name', Details_Of_Change__c = 'Enter details', Reason__c = 'Enter reason',Refrence_No__c='Enter Refer. #' ,Release__c= 0,Version__c = 0
                );             
            try{
              records.add(obj);
              records.add(obj);
              insert records;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
            
            PageReference pageRef = Page.ReportPage;
            Test.setCurrentPageReference(pageRef);
           ApexPages.StandardController controller = new ApexPages.StandardController(obj); 
            DocumentControlController bsExt = new DocumentControlController(controller);                       
            DocumentControlController.DocumentControlWrapper wrp = new DocumentControlController.DocumentControlWrapper(); 
            bsExt.DocumentControlList.add(wrp);                     
            bsExt.save();
        }        
           
         static testmethod void testObjectPermissionClass_ExcepAddFunc(){
            // Create dummy data for test purposes.
            DocumentControl__c sec = new DocumentControl__c(
                Name__c = 'Test Documentname'
                );         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.ReportPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', 'hi');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            DocumentControlController bsExt = new DocumentControlController(controller);                       
            DocumentControlController.DocumentControlWrapper wrp = new DocumentControlController.DocumentControlWrapper();                        
            bsExt.documentControlList = null;
            bsExt.addRecord();
        }                  
}