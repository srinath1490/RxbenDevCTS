@isTest
private class DesignSettingController_Test {
         
        
        static testmethod void testDesignSettingController(){
        
            // Create dummy data for test purposes.
            Design_Setting__c sec = new Design_Setting__c(
                Name__c = 'Test DesignSetting'
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
            DesignSettingController bsExt = new DesignSettingController(controller);                       
            DesignSettingController.DesignSettingWrapper wrp = new DesignSettingController.DesignSettingWrapper();
            wrp.getDesignSetting();
            wrp.getIndex();
            bsExt.DsList.add(wrp);
            bsExt.getDsList();
            bsExt.save();
            bsExt.addNewRecord();
            bsExt.deleteRow();
            bsExt.clear();
                                    
         Test.stoptest();
         }
        static testmethod void testObjectPermissionClass_Excep(){
        
            // Create dummy data for test purposes.
            Design_Setting__c sec = new Design_Setting__c(
                Name__c = 'Test DesignSetting'
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
            DesignSettingController bsExt = new DesignSettingController(controller);                       
            DesignSettingController.DesignSettingWrapper wrp = new DesignSettingController.DesignSettingWrapper();                       
            bsExt.deleteRow();        
        }  
         static testmethod void testObjectPermissionClass_ExcepAddFunc(){
            // Create dummy data for test purposes.
            Design_Setting__c sec = new Design_Setting__c(
                Name__c = 'Test DesignSetting'
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
            DesignSettingController bsExt = new DesignSettingController(controller);                       
            DesignSettingController.DesignSettingWrapper wrp = new DesignSettingController.DesignSettingWrapper();                           
            bsExt.dsList = null;
            bsExt.addNewRecord();
        }                          
}