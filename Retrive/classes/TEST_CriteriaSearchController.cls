/*Purpose: Apex Test Class for VFP_CriteriaSearchController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/1/2011       Apex Test Class for VFP_CriteriaSearchController.
======================================================================== 
*/
@isTest
Private class TEST_CriteriaSearchController{

    static testmethod void testCriteriaSearch(){
    GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
    
     // Instanciate  Drug search Page
        PageReference drugListSearch = Page.VF_DrugListSearch;
        Test.setCurrentPage(drugListSearch);
        
     //Instanciate Controller
         ApexPages.StandardController s = new ApexPages.standardController(new Drug_List__c());
         VFP_CriteriaSearchController controller = new  VFP_CriteriaSearchController (s);
         controller.doDrugListSearch();
         controller.doPriorAuthSearch();
         controller.doQuantLimitSearch();
         controller.doStepTherapySearch();
         
         /*Sample search criteria*/
         controller.listValue = system.label.CL0000003;
         controller.codeValue = '1234';
         controller.doDrugListSearch();
         controller.doPriorAuthSearch();
         controller.doQuantLimitSearch();
         controller.doStepTherapySearch();
         controller.codeValue = '1234*';
         controller.doDrugListSearch();
         controller.doPriorAuthSearch();
         controller.doQuantLimitSearch();
         controller.doStepTherapySearch();
         controller.codeValue = '12345*';
         controller.doPriorAuthSearch();
         controller.doQuantLimitSearch();
         controller.doDrugListSearch();
         controller.doStepTherapySearch();
         controller.codeValue = '123456789*';
         controller.doStepTherapySearch();
         controller.codeValue = '12345678911';
         controller.doDrugListSearch();
         controller.doPriorAuthSearch();
         controller.doQuantLimitSearch();
         controller.doStepTherapySearch();
         controller.codeValue = '12345a78911';
         controller.doDrugListSearch();
         controller.doPriorAuthSearch();
         controller.doQuantLimitSearch();
         controller.doStepTherapySearch();
         controller.codeValue = '1234578911*';
         controller.doQuantLimitSearch();
         
         controller.listValue = system.label.CL0000004;
         controller.codeValue = '123';
         controller.doDrugListSearch();
         controller.doPriorAuthSearch();
         controller.doQuantLimitSearch();
         controller.doStepTherapySearch();
         controller.codeValue = '1234*';
         controller.doDrugListSearch();
         controller.doPriorAuthSearch();
         controller.doQuantLimitSearch();
         controller.doStepTherapySearch();
         controller.codeValue = '12345*';
         controller.doPriorAuthSearch();
         controller.doQuantLimitSearch();
         controller.doDrugListSearch();
         controller.doStepTherapySearch();
         controller.codeValue = '1234578911*';
         controller.doQuantLimitSearch();
         controller.codeValue = '1234578911*';
         controller.doStepTherapySearch();
         controller.codeValue = '12345678911234';
         controller.doDrugListSearch();
         controller.doPriorAuthSearch();
         controller.doQuantLimitSearch();
         controller.doStepTherapySearch();
         controller.codeValue = '12345a78911234';
         controller.doDrugListSearch();
         controller.doPriorAuthSearch();
         controller.doQuantLimitSearch(); 
         controller.doStepTherapySearch();
         controller.sort();
         controller.clearfields();
         controller.getcriteia();
         controller.gettypeCode();
         controller.first();
         controller.last();
         controller.previous();
         controller.next();
         boolean check;
         check =controller.isFirst;
         check =controller.hasPrevious;
         check =controller.isLast;
         check =controller.hasNextRecord;
         check =controller.hasNext;
         integer i =controller.pageNumber;
         controller.getDrugTypeCode();
         controller.redirectToNewDrugList();
         controller.redirectToNewPriorAuth();
         controller.redirectToNewQuantLimit();
         controller.redirectToNewStepTherapy();
         
                  
    }
}