@isTest
private class PicklistClass_Test {
         
        
        static testmethod void testPicklistClass(){
        
            // Create dummy data for test purposes.
            Picklist_Details__c sec = new Picklist_Details__c(
                Name__c= 'Test Picklist'
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
            PicklistClass bsExt = new PicklistClass(controller);                       
            PicklistClass.PicklistWrapper wrp = new PicklistClass.PicklistWrapper();
            wrp.getPicklist();
            wrp.getIndex();
            bsExt.PLList.add(wrp);
            bsExt.getPLList();
            bsExt.save();
            bsExt.addNewRecord();
            //bsExt.checkHistoryTracking();
             bsExt.deleteRow();
            bsExt.clear();
                    
                
         Test.stoptest();
         }
         
         static testmethod void testObjectPermissionClass_Excep(){
        
            // Create dummy data for test purposes.
            Picklist_Details__c obj= new Picklist_Details__c(
                Name__c= 'Test Object'
                );         
            try{
              insert obj;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
            
            PageReference pageRef = Page.ReportPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', obj.Id+'Hi');
         ApexPages.currentPage().getParameters().put('retURL', 'hi'); 
            ApexPages.StandardController controller = new ApexPages.StandardController(obj); 
            PicklistClass picklistClass= new PicklistClass(controller);
            PicklistClass.PicklistWrapper  picklistWrapper = new PicklistClass.PicklistWrapper();                           
            picklistClass.deleteRow();
    
    
        }           
         static testmethod void testObjectPermissionClass_ExcepSave(){
         list <Picklist_Details__c> records =  new list<Picklist_Details__c>();
            Picklist_Details__c obj= new Picklist_Details__c(Name__c= 'test');         
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
            PicklistClass picklistClass= new PicklistClass(controller);
            PicklistClass.PicklistWrapper  picklistWrapper = new PicklistClass.PicklistWrapper();                           
            picklistClass.save();
        }        
           
         static testmethod void testObjectPermissionClass_ExcepAddFunc(){
            Picklist_Details__c obj= new Picklist_Details__c(Object__c= '');         
            try{
              insert obj;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
            
            PageReference pageRef = Page.ReportPage;
            Test.setCurrentPageReference(pageRef);
            ApexPages.StandardController controller = new ApexPages.StandardController(obj); 
            PicklistClass picklistClass= new PicklistClass(controller);
            PicklistClass.PicklistWrapper  picklistWrapper = new PicklistClass.PicklistWrapper();                           
            picklistClass.PLList = null;
            picklistClass.addNewRecord();
        }           
}