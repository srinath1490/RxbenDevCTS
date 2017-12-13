@isTest
private class objectPermissionClass_Test {
  static testMethod void TestSave() {
   // Create dummy data for test purposes.
            ObjectPermission__c obj= new ObjectPermission__c(
                    Name__c= 'Test obj'
                );         
            try{
                  insert obj;
            }catch(Exception ex){
                  system.debug('Exception --'+ex);
            }
            
            Test.startTest();
            PageReference pageRef = Page.objectPermissionPage;
            Test.setCurrentPageReference(pageRef);
                //  ApexPages.currentPage().getParameters().put('delRow', '1');
                // ApexPages.currentPage().getParameters().put('CF00N90000002c5LV_lkid','CF00N90000002c5LV_lkid') ;
            ApexPages.currentPage().getParameters().put('delId','1');
            ApexPages.StandardController controller = new ApexPages.StandardController(obj); 
            objectPermissionClass objPer= new objectPermissionClass(controller);
            objectPermissionClass.profDelWrapper profDelWrapper  = new objectPermissionClass.profDelWrapper();
            objPer.objectPermissionList.add(profDelWrapper);
            objPer.save();
            objPer.add();
            objPer.del();
            objPer.clear();
            profDelWrapper.getCount();
            profDelWrapper.getProfileWrapper();
            Test.stopTest();

  }
  static testmethod void testObjectPermissionClass_Excep(){
        
            // Create dummy data for test purposes.
            ObjectPermission__c obj= new ObjectPermission__c(
                Refrence_No__c= 'Test ObjectPermision'
                );         
            try{
              insert obj;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
            
            PageReference pageRef = Page.objectPermissionPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', obj.Id+'Hi');
        // ApexPages.currentPage().getParameters().put('retURL', sec.Id); 
            ApexPages.StandardController controller = new ApexPages.StandardController(obj); 
            objectPermissionClass objPer= new objectPermissionClass(controller);
            objectPermissionClass.profDelWrapper profDelWrapper  = new objectPermissionClass.profDelWrapper();
            objPer.objectPermissionList.add(profDelWrapper);                 
            objPer.del();
            objPer.save();    
    
        }   
        
        static testmethod void testObjectPermissionClass_AddExcep(){
        
            // Create dummy data for test purposes.
            ObjectPermission__c obj= new ObjectPermission__c(
                Refrence_No__c= 'Test ObjectPermision'
                );         
            try{
              insert obj;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
            
            PageReference pageRef = Page.objectPermissionPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', obj.Id+'Hi');
        // ApexPages.currentPage().getParameters().put('retURL', sec.Id); 
            ApexPages.StandardController controller = new ApexPages.StandardController(obj); 
            objectPermissionClass objPer= new objectPermissionClass(controller);
            objectPermissionClass.profDelWrapper profDelWrapper  = new objectPermissionClass.profDelWrapper();
            objPer.objectPermissionList.add(profDelWrapper);                 
            objPer.objectPermissionList= null;
            objPer.add();    
    
        }  
        
        static testmethod void testObjectPermissionClass_ExcepSave(){
         list <ObjectPermission__c> records =  new list<ObjectPermission__c>();
            ObjectPermission__c obj= new ObjectPermission__c(
                Refrence_No__c= 'Test ObjectPermision'
                );          
            try{
              records.add(obj);
              records.add(obj);
              insert records;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
            
            ApexPages.StandardController controller = new ApexPages.StandardController(obj); 
            objectPermissionClass objPer= new objectPermissionClass(controller);
            objectPermissionClass.profDelWrapper profDelWrapper  = new objectPermissionClass.profDelWrapper();                         
            objPer.save();
        }                         
}