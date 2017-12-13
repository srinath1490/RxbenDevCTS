@isTest
private class recordTypeSettingClass_Test {
         
        
        static testmethod void testrecordTypeSettingClass(){
        
            // Create dummy data for test purposes.
            RecordTypeSetting__c sec = new RecordTypeSetting__c(
                Name__c = 'Test RecordTypeSetting'
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
            recordTypeSettingClass bsExt = new recordTypeSettingClass(controller);                       
            recordTypeSettingClass.settingwrapper wrp = new recordTypeSettingClass.settingwrapper ();
            wrp.getrecordsetting();
            wrp.getIndex();
            bsExt.settinglist.add(wrp);
            bsExt.getsettinglist();
            bsExt.save();
            bsExt.addNewRecord();
            bsExt.deleteRow();
            bsExt.clear();
                     
                
         Test.stoptest();
        }  
         static testmethod void testReportController_ExcepAddNewFunc(){
         RecordTypeSetting__c sec = new RecordTypeSetting__c(Name__c = 'Test RecordTypeSetting'); 
          try{
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
           Test.startTest();
            PageReference pageRef = Page.ReportPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', sec.id+'Hi');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            recordTypeSettingClass bsExt = new recordTypeSettingClass(controller);                       
            recordTypeSettingClass.settingwrapper wrp = new recordTypeSettingClass.settingwrapper ();
            bsExt.settinglist.add(wrp);
             bsExt.deleteRow();
            bsExt.settinglist = null;            
            bsExt.addNewRecord();        
            }                
}