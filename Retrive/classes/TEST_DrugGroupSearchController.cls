/*Purpose: Apex Test Class for VFP_DrugGroupSearchController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/1/2011       Apex Test Class for VFP_DrugGroupSearchController.
======================================================================== 
*/
@isTest
Private class TEST_DrugGroupSearchController{

    static testmethod void testDrugGroupSearch(){
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        Drug_List__c testdrugList = testdata.createDrugList();
        insert testdrugList;
        set<Id> drugListset = new set<Id>();
        drugListset.add(testdrugList.id);
     // Instanciate  Drug search Page
        PageReference drugGroupSearch = Page.VF_DrugGroupSearch  ;
        Test.setCurrentPage(drugGroupSearch);
        
     //Instanciate Controller
         ApexPages.StandardController s = new ApexPages.standardController(new Drug_List_Junction__c());
         VFP_DrugGroupSearchController controller = new  VFP_DrugGroupSearchController (s);
        
        
        /******methods*********/
         controller.doDrugGroupSearch();
         controller.sort();
         controller.clearField();         
         controller.newPage();
         controller.first();
         controller.last();
         controller.previous();
         controller.next();
         controller.getTypecode();
         controller.getcriteia();
         controller.codeType = system.label.CL0000003;
         controller.codeValue ='123*';
         controller.listCriteria ='Starts';
         controller.listDescCriteria='Starts';
         controller.drugListName='te';
         controller.listDesc='te';
         controller.doDrugGroupSearch();
         controller.codeValue ='12345*';
         controller.listCriteria ='';
         controller.listDescCriteria='';
         controller.drugListName='';
         controller.listDesc='';
         controller.nameCriteria ='Starts';
         controller.descCriteria='Starts';
         controller.groupName ='te';
         controller.description='te';
         controller.doDrugGroupSearch();
         controller.descCriteria='Starts';
         controller.description='';
         controller.doDrugGroupSearch();
         controller.codeType = system.label.CL0000004;
         Integer i= controller.pageNumber;        
         Boolean testLast =controller.isLast;        
         Boolean testfirst =controller.isFirst;        
         Boolean testPrevious =controller.hasPrevious;        
         Boolean testNextRecord =controller.hasNextRecord;
         controller.setToString(drugListset);
         controller.doDrugGroupSearch();
         
         
        
    }
}