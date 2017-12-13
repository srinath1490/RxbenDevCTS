/*Purpose: Apex Class for TEST_DrugList Page.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 8/25/2011       Apex Class for TEST_DrugList Page.
======================================================================== 
*/
@isTest
Private Class TEST_DrugListController{

    static testmethod void testDrugListCreation(){ 
    Account testacc= new Account();
    testacc.Name= 'druglist account';
    testacc.A_c_Email__c='a@a.com';
    insert testacc;
          GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
          Drug_List__c DrugList1 = testdata.createDrugList();
        DrugList1.Account__c = testacc.id;
        DrugList1.Special_Use__c = 'MAC List';
        DrugList1.Clinical_Edit_Code__c= NULL;
        DrugList1.Standard__c= True;
        DrugList1.Non_GPI_Non_NDC_Check__c= True;
        DrugList1.Description__c = 'test druglist';
        DrugList1.Drug_List_Name__c  = 'test record';
         insert  DrugList1;                     
          ApexPages.StandardController s1 = new ApexPages.standardController(DrugList1);
          VFP_DrugListController controller1 = new  VFP_DrugListController(s1);
          controller1.addCriteria();
        controller1.CustomSave();
       Drug_List_Criteria__c newdrugList =testdata.newDrugListcriteria(DrugList1.Id,1);  
       insert newdrugList ;
                  //Controller of Drug search Page on drug List Criteria
         ApexPages.StandardController s2 = new ApexPages.standardController(DrugList1);
         VFP_DrugSearchController  controller2 = new VFP_DrugSearchController (s2);
        controller2.first();
        controller2.last();
        controller2.previous();
        controller2.next();
        
        boolean checking;
        checking = controller2.hasNextRecord; 
        checking = controller2.hasPrevious;
        checking = controller2.isFirst;
        checking = controller2.isLast;
        Integer i = controller2.pageNumber;                                   
    }

}