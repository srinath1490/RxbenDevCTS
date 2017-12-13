@isTest
private class ReportController_Test {
         
        
        static testmethod void testReportController(){
        
            // Create dummy data for test purposes.
            Report__c sec = new Report__c(
                Report_Name__c = 'Test Report',Fields__c='test'
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
            ReportController bsExt = new ReportController(controller);                       
            ReportController.ReportWrapper wrp = new ReportController.ReportWrapper ();
            wrp.getReport();
            wrp.getIndex();
            bsExt.ReportList.add(wrp);
            bsExt.getReportList();
            bsExt.addNewRecord();
            bsExt.clear();
            bsExt.deleteRow();         
                
         Test.stoptest();
        }  
         static testmethod void testReportController_ExcepSave(){
         List<Report__c> tempList = new List<Report__c>();
         Report__c sec = new Report__c(Report_Name__c = 'Test Report',Fields__c='test');
         try{
         	tempList.add(sec);
              insert sec;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
         Test.startTest();
            PageReference pageRef = Page.ReportPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', '1');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            ReportController bsExt = new ReportController(controller);                       
            ReportController.ReportWrapper wrp = new ReportController.ReportWrapper ();
            bsExt.ReportList.add(wrp);
            bsExt.save();
/*********************************************************/
         List<Report__c> tempList1 = new List<Report__c>();
         Report__c sec1 = new Report__c(Report_Name__c = 'Test Report',Fields__c='test');
         try{
         	tempList1.add(sec1);
         	tempList1.add(sec1);
              insert sec1;
            }catch(Exception ex){
              system.debug('Exception --'+ex);
            }
         

            PageReference pageRef1 = Page.ReportPage;
         Test.setCurrentPageReference(pageRef1);
         ApexPages.currentPage().getParameters().put('delRow', '1');
            ApexPages.StandardController controller1 = new ApexPages.StandardController(sec1); 
            ReportController bsExt1 = new ReportController(controller1);                       
            ReportController.ReportWrapper wrp1 = new ReportController.ReportWrapper ();
            bsExt1.ReportList.add(wrp1);
            bsExt1.save();
        }                
         static testmethod void testReportController_Excep1(){
         Report__c sec = new Report__c(Report_Name__c = 'Test Report');
         Test.startTest();
            PageReference pageRef = Page.ReportPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', '1');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            ReportController bsExt = new ReportController(controller);                       
            ReportController.ReportWrapper wrp = new ReportController.ReportWrapper ();
            bsExt.ReportList.add(wrp);
            bsExt.deleteRow();
         ApexPages.currentPage().getParameters().put('delRow', sec.Id+'Hi');
            bsExt.deleteRow();
        }           
         static testmethod void testReportController_ExcepAddFunc(){
         Report__c sec = new Report__c(Report_Name__c = 'Test Report');
         Test.startTest();
            PageReference pageRef = Page.ReportPage;
         Test.setCurrentPageReference(pageRef);
         ApexPages.currentPage().getParameters().put('delRow', '1');
            ApexPages.StandardController controller = new ApexPages.StandardController(sec); 
            ReportController bsExt = new ReportController(controller);                       
            ReportController.ReportWrapper wrp = new ReportController.ReportWrapper ();
            bsExt.ReportList = null;            
            bsExt.addNewRecord();        }           
          
           
}