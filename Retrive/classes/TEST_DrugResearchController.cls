/*Purpose: Apex Test Class for VFP_DrugResearchController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/9/2011       Apex Test Class for VFP_DrugResearchController.
======================================================================== 
*/
@isTest
Private class TEST_DrugResearchController{
        static testmethod void testCriteriaSearch(){
             GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        // Instanciate  Drug search Page
           PageReference drugSearch = Page.VF_DrugResearch;
           Test.setCurrentPage(drugSearch);
           
        //Instanciate Controller         
           ApexPages.StandardController s = new ApexPages.standardController(new Drug__c());       
           VFP_DrugResearchController controller = new  VFP_DrugResearchController(s);           
            controller.getcriteia();
            controller.doDrugListSearch();
            controller.ndcValue='123456789*';
            controller.labelName='test';
            controller.productName='test';
            controller.gpiValue='123456*';
            controller.gpiGeneric='test';
            controller.doDrugListSearch();
             
            controller.ndcValue='12345.6789';
            controller.gpiValue='1234.56';
            controller.doDrugListSearch(); 
            
            controller.ndcValue='12345a67891';
            controller.gpiValue='1234a567891234';
            controller.doDrugListSearch(); 
            
            controller.ndcValue='123456789*';
            controller.labelName='test';
            controller.productName='test';
            controller.gpiValue='123456*';
            controller.gpiGeneric='test';
            controller.gciCriteria ='Starts';
            controller.labelCriteria ='Starts';
            controller.prodCriteria ='Starts';
            controller.doDrugListSearch();
            
            controller.ndcValue='12345*';
            controller.labelName='test';
            controller.productName='test';
            controller.gpiValue='12345678*';
            controller.gpiGeneric='test';
            controller.searchdata.Multi_Source_Code__c='test';
            controller.searchdata.Third_Party_Restriction_Code__c='test';
            controller.searchdata.Maintenance_Drug_Code__c='test';
            controller.searchdata.Rx_OTC_Indicator_Code__c='test';
            controller.searchdata.Route_of_Administration__c='test';
            controller.searchdata.Dosage_Form__c='test';
            controller.searchdata.DESI_Code__c='test';
            controller.searchdata.Repack_Code__c='test';
            controller.searchdata.DEA_Class_Code__c='test';            
            controller.gciCriteria ='Includes';
            controller.labelCriteria ='Includes';
            controller.prodCriteria ='Includes';
            controller.doDrugListSearch();
            controller.sort();   
            
                     
            controller.clearFields();
            controller.gciCriteria ='Includes';
            controller.labelCriteria ='Includes';
            controller.prodCriteria ='Includes';
            controller.doDrugListSearch();
          
            
         
            controller.sort();
            controller.first();
            controller.last();
            controller.previous();
            controller.next();
            
            boolean testboolean;
            testboolean = controller.hasNext;
            testboolean = controller.hasPrevious;
            testboolean = controller.isFirst;
            testboolean = controller.isLast;
            
            
            
                        
        }
}