/*Purpose: Apex Test Class for VFP_SearchFormularyListController..
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/7/2011       Apex Test Class for VFP_SearchFormularyListController.
======================================================================== 
*/
@isTest
Private class TEST_SearchFormularyListController{
    static testmethod void testformularyListSearch(){
            GC_UtilityClassTestData testdata = new GC_UtilityClassTestData(); 
            Option_Code__c testOptionCode =  testdata.newoptionCode();  
            insert testOptionCode;
            Formulary_List__c testFormularyList = testdata.newFormularyList(testOptionCode.id);
            insert testFormularyList;
            Formulary_List_Entry__c testformularyEntry = new Formulary_List_Entry__c();
            testformularyEntry.GPI__c = '12345678910123';
            testformularyEntry.Effective_Date__c = system.today();
            testformularyEntry.Termination_Date__c  =system.today()+7 ;
            testformularyEntry.NDC__c = '12345678901';
            testformularyEntry.Formulary_List__c=testFormularyList.id; 
            insert testformularyEntry;
            
            // Instanciate  Formulary List Search Page 
                   PageReference formularyListSearch = Page.VF_SearchFormularyList ;
                   Test.setCurrentPage(formularyListSearch);
                   
                   //Instanciate Controller                 
                   ApexPages.StandardController s = new ApexPages.standardController(new Formulary__c());
                   VFP_SearchFormularyListController controller = new VFP_SearchFormularyListController (s);
                   controller.getcriteia() ;
                   controller.NDC='';
                   controller.GPI='';
                   controller.doSearch();
                   controller.redirectToNewFormularyList();
                   controller.clearFields();
                   controller.NDC='12345*';
                   controller.GPI='12345678*';                  
                   controller.formularyListName='test';
                   controller.doSearch();
                   controller.sort();
                   controller.next() ;
                   controller.previous() ;
                   controller.last() ;
                   controller.first() ;
                   Boolean check;
                   check =controller.hasNext;
                   check =controller.hasPrevious;
                   check =controller.isFirst;
                   check =controller.isLast;
                   controller.formularyListOptionCode.OptionCode__c =testOptionCode.Id;
                   controller.formularyListDescription ='test' ;
                   controller.NDC='12345678987';
                   controller.GPI='12345678901234'; 
                   controller.doSearch();
                   
                   controller.formularyListOptionCode.OptionCode__c =testOptionCode.Id;
                   controller.NDC='12345a78987';
                   controller.GPI='123456b8901234'; 
                   controller.doSearch();
                   
                   
                   
                    
     }
}