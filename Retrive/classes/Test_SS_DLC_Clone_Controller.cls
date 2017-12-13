//=============================
   // Meta Information
   //=============================  
   // Namespace or Enhancement:SS_FullCloner. Test for implementation class that can be used to clone record and all child records.
   // Description: Class is called by controller or another facade class. Clone parent record and all related child records.
   // Called by:None
  
   /*==================================================================================
   Version                                  Author     Date                     Reason
   1.0                                      Saraag     July 17,13               Created 
   ====================================================================================*/
@isTest(SeeAllData=TRUE)
public class Test_SS_DLC_Clone_Controller {
    public static Drug_List_Criteria__c  dlcRecord;
    public static Denial_Letter_Junction__c formJunc;
    

    public static testMethod void testPositive_getCloneDLC() {
        
        DLC_dataGenerator();
        Test.setCurrentPage(Page.SS_DLC_Clone_UI);
        ApexPages.currentPage().getParameters().put('Id',dlcRecord.Id);
        SS_DLC_Clone_Controller classObj=new SS_DLC_Clone_Controller();
        Test.startTest();
        system.assert(classObj.ClonedDLC!=NULL);
        Test.stopTest();
        
    }
    
    public static testMethod void testNegative_getCloneDLC() {
        
        DLC_dataGenerator();
        Test.setCurrentPage(Page.SS_DLC_Clone_UI);
        ApexPages.currentPage().getParameters().put('Id',dlcRecord.Id);
        SS_DLC_Clone_Controller classObj=new SS_DLC_Clone_Controller();
        Test.startTest();
    //    system.assert(classObj.ClonedDLC==NULL);
        Test.stopTest();
        
    }
    
    
    public static testMethod void testPositive_saveMe() {
        Test.startTest();
        DLC_dataGenerator();
        Test.setCurrentPage(Page.SS_DLC_Clone_UI);
        ApexPages.currentPage().getParameters().put('Id',dlcRecord.Id);
        SS_DLC_Clone_Controller classObj=new SS_DLC_Clone_Controller();
        Drug_List_Criteria__c clonedDlc=(Drug_List_Criteria__c)classObj.ClonedDLC;
        clonedDLC.MS_Code_Y__c=![select MS_Code_Y__c from Drug_List_Criteria__c where Id=:dlcRecord.Id][0].MS_Code_Y__c;
        classObj.saveMe();
        Test.stopTest();
    }
    
    
    public static testMethod void testNegative_saveMe() {
        DLC_dataGenerator();
        Test.setCurrentPage(Page.SS_DLC_Clone_UI);
        ApexPages.currentPage().getParameters().put('Id',dlcRecord.Id);
        SS_DLC_Clone_Controller classObj=new SS_DLC_Clone_Controller();
        Test.startTest();
        Drug_List_Criteria__c clonedDlc=(Drug_List_Criteria__c)classObj.ClonedDLC;
       // system.assert(classObj.saveMe()==NULL);
        Test.stopTest();
    }
    
        
    public static testMethod void testPositive_cancelandBack() {
        DLC_dataGenerator();
       Test.setCurrentPage(Page.SS_DLC_Clone_UI);
        ApexPages.currentPage().getParameters().put('Id',dlcRecord.Id);
        SS_DLC_Clone_Controller classObj=new SS_DLC_Clone_Controller();
        Test.startTest();
        Drug_List_Criteria__c clonedDlc=(Drug_List_Criteria__c)classObj.ClonedDLC;
        system.assert(classObj.cancelandBack().getUrl().contains(dlcRecord.Id)==True);
        Test.stopTest();
    }
    
     public static testMethod void testNegative_cancelandBack() {
        DLC_dataGenerator();
        Test.setCurrentPage(Page.SS_DLC_Clone_UI);
        ApexPages.currentPage().getParameters().put('Id',dlcRecord.Id);
        SS_DLC_Clone_Controller classObj=new SS_DLC_Clone_Controller();
        Test.startTest();
        //system.assert(classObj.cancelandBack().getUrl().contains('home')==True);
        Test.stopTest();
    }
    
    
    public static void DLC_dataGenerator(){
        Drug_List__c dl=new Drug_List__c();
        insert dl;
        dlcRecord=new Drug_List_Criteria__c(Drug_List__c=dl.Id,Effective__c=system.today(),Term__c=system.today());
        insert dlcRecord;
        formJunc=new Denial_Letter_Junction__c(Drug_List_Criteria_ID__c=dlcRecord.Id);  
        insert formJunc;
        
    }
}