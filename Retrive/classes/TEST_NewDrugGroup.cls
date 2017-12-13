/*Purpose: Apex Test Class for VFP_NewDrugGroup.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/2/2011       Apex Test Class for VFP_NewDrugGroup.
======================================================================== 
*/
@isTest
Private class TEST_NewDrugGroup{

     static testmethod void testNewDrugGroup(){
     GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();    
         List<Schema.RecordTypeInfo> DrugGroupRtInfo = Drug_Group__c.sObjectType.getDescribe().getRecordTypeInfos();    
        Id DrugListid;
        Id DrugGroupId;
         for(Schema.Recordtypeinfo thisInfo :DrugGroupRtInfo){
            if(thisInfo.Name == 'Drug List'){
                DrugGroupId= thisInfo.getRecordTypeId();
            }
        }
        for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
        }
          // Instanciate  Drug search Page
        PageReference newDrugGroup = Page.VF_NewDrugGroup  ;
        Test.setCurrentPage(newDrugGroup);
        
     //Instanciate Controller
         ApexPages.StandardController s = new ApexPages.standardController(new Drug_List_Junction__c());
         VFP_NewDrugGroupController controller = new  VFP_NewDrugGroupController(s);  
         controller.getRecordType();       
         controller.AddMore();
         controller.wrapperlist[1].check = true;
         controller.delRow();
         controller.CustomSave();
         controller.redirectToSearch();
         Drug_List__c tempDrugList =testdata.createDrugList();
         tempDrugList.RecordtypeId =DrugListid;
         insert tempDrugList;
         
         controller.drugGroup.Drug_Group_Name__c = 'test';
         controller.drugGroup.Description__c = 'test';
         controller.drugGroup.RecordtypeId =DrugGroupId ;
         controller.drugGroup.Effective_Date__c = system.today();
         controller.drugGroup.Termination_Date__c = system.today()+ 7;
         controller.wrapperlist[0].JunctionWrapper.Drug_List__c = tempDrugList.Id;
         controller.CustomSave();
         
         controller.wrapperlist[0].JunctionWrapper.Deletion_Requestor__c = 'test';
         update controller.wrapperlist[0].JunctionWrapper;
         
         Drug_List__c newobj=new Drug_List__c();
         newobj.Inactive__c=false;
         insert newobj;
         
         
     }
 }