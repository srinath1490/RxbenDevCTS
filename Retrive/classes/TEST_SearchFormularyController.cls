/*Purpose: Apex Test Class for VFP_SearchFormularyController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/6/2011       Apex Test Class for VFP_SearchFormularyController.
======================================================================== 
*/
@isTest
Private class TEST_SearchFormularyController{
    static testmethod void testDrugGroupSearch(){
        set<id> testSet =new set<id>();
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData(); 
         Option_Code__c testOptionCode =  testdata.newoptionCode();
         
         insert testOptionCode;
         testSet.add(testOptionCode.Id);
        
        Formulary_List__c testformularyList = testdata.newFormularyList(testOptionCode.id);
        insert testformularyList;
        testSet.add(testformularyList.Id);
        
       Formulary_List_Entry__c testFormularyEntry =testdata.newFormularyListEntry(5,testformularyList.id );
       testFormularyEntry.GPI__c ='1234*';
       testFormularyEntry.NDC__c ='12345*';       
        insert testFormularyEntry;
        testSet.add(testFormularyEntry.Id);
        // Instanciate  Drug search Page
        PageReference formularySearch = Page.VF_SearchFormulary  ;
        Test.setCurrentPage(formularySearch);             
        
        
        //Instanciate Controller         
        ApexPages.StandardController s = new ApexPages.standardController(new Formulary__c());
        VFP_SearchFormularyController controller = new VFP_SearchFormularyController (s);
        controller.getcriteia();
        //controller.getOptionCode();
        controller.redirectToNewFOrmularyList();
        controller.clearFields();
        controller.gpi = '1234*'; 
        controller.ndc ='12345*';
        controller.searchFormulary();
        controller.sort();

        controller.gpi = ''; 
        controller.ndc ='';
        boolean last = controller.isLast;
        boolean First = controller.isFirst;
        boolean Previous = controller.hasPrevious;
        boolean Next = controller.hasNext;
        
        controller.searchFormulary();
        
        
        controller.formularyNameCriteria = 'Starts';        
        controller.cvsCaremarkIdCriteria = 'Starts';        
        controller.formularyDescriptionCriteria = 'Starts';

        
        controller.gpi = '1234.56789*'; 
        controller.ndc ='1234.5678*';
        controller.searchFormulary();
        
        
        controller.formularyNameCriteria = 'Starts';        
        controller.cvsCaremarkIdCriteria = 'Starts';        
        controller.formularyDescriptionCriteria = 'Starts';
        controller.formularyListCriteria ='Starts';
        controller.formularyName = 'test';        
        controller.cvsCaremarkId = 'test';        
        controller.formularyDescription = 'test';
        controller.formularyList='test';
        controller.formularyListOptionCode.Option_Code__c = testOptionCode.Id;
        controller.gpi = '12345678901234'; 
        controller.ndc ='12345678901';
        controller.searchFormulary();
        controller.first();
        controller.last();
        controller.previous();
        controller.next();
        Integer i = controller.pageNumber;
        
        controller.clearFields();
        controller.formularyNameCriteria = 'Includes';        
        controller.cvsCaremarkIdCriteria = 'Includes';        
        controller.formularyDescriptionCriteria = 'Includes';
        controller.formularyListCriteria ='Includes';
        controller.formularyName = 'test';        
        controller.cvsCaremarkId = 'test';        
        controller.formularyDescription = 'test';

        controller.formularyList='test';
        controller.formularyListOptionCode.Option_Code__c = testOptionCode.Id;
        controller.gpi = '12345678901234'; 
        controller.ndc ='12345678901';
        controller.searchFormulary();
        
        controller.formularyName = ''; controller.cvsCaremarkId ='';controller.formularyDescription ='';controller.formularyList ='';controller.formularyListOptionCode =null;controller.GPI ='';controller.NDC ='';
        controller.validation();
        controller.cvsCaremarkId ='test';
        controller.formularyNameCriteria = 'Includes';
        controller.validation();
        controller.setToString(testSet);


        
    }
}