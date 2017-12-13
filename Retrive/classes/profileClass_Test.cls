@isTest
private class profileClass_Test {
         
        
        static testmethod void testqueueController(){
        
            // Create dummy data for test purposes.
            Profile__c sec = new Profile__c(
                Profile_Name__c= 'Test ProfileName'
                );         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.ReportPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delId', '1');
         ApexPages.currentPage().getParameters().put('retURL', 'hi');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            profileClass bsExt = new profileClass(controller);                       
            profileClass.profDelWrapper wrp = new profileClass.profDelWrapper();
            wrp.getProfileWrapper();
            wrp.getCount();
            bsExt.ProfileList.add(wrp);
            bsExt.getProfileList();
            bsExt.save();
            bsExt.add();           
            bsExt.clear();
            wrp.count = 1;
            bsExt.ProfileList.add(wrp);
            bsExt.del();         
                
         Test.stoptest();
         }
         
         static testmethod void testqueueController_exp(){
        
            // Create dummy data for test purposes.
            Profile__c sec = new Profile__c(
                Profile_Name__c= 'Test ProfileName'
                );         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.ReportPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delId', 'hi');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            profileClass bsExt = new profileClass(controller);                       
            profileClass.profDelWrapper wrp = new profileClass.profDelWrapper();
            bsExt.ProfileList.add(wrp);
            bsExt.del();         
                
         Test.stoptest();
         }
         
     static testmethod void testObjectPermissionClass_ExcepAddFunc(){
            // Create dummy data for test purposes.
            Profile__c sec = new Profile__c(
                Profile_Name__c= 'Test ProfileName'
                );         
            try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.ReportPage;
            Test.setCurrentPageReference(pageRef);
            ApexPages.currentPage().getParameters().put('delId', '1');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            profileClass bsExt = new profileClass(controller);                       
            profileClass.profDelWrapper wrp = new profileClass.profDelWrapper();                         
            bsExt.profileList = null;
            bsExt.add();
        }             
}