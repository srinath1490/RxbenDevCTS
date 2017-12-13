/*Purpose: Apex Test Class for VFP_ObjectListSearchController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/20/2011       Apex Test Class for VFP_ObjectListSearchController.
======================================================================== 
*/
@isTest
Private class TEST_ObjectListSearchController
{
    static testmethod void testobjectlistsearch()
    {
         
        PageReference objectListSearch= Page.VF_ObjectListSearch ;
        Test.setCurrentPage(objectListSearch);
         ApexPages.StandardController stdcontroller = new ApexPages.standardController(new Object_List__c());
         VFP_ObjectListSearchController controller=new VFP_ObjectListSearchController (stdcontroller );
         //RecordType rt = [select id from RecordType where SobjectType='Object_List__c' limit 1];
         RecordType rt = [select id from RecordType where SobjectType='Object_List_Item__c' limit 1];
         //controller.ObjectListrecordtype=rt.Id;
         controller.recordType=rt.Id;

         //controller.recordtype='012P0000000CotM';
         //controller.segment='National';
         //controller.getplateformList();
         //controller.getsegmentList();
         controller.getfundingList();
         //controller.getstateList();
         controller.getcriteia();
         controller.doObjectSearch();
        controller.recordtypeupdate();
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
         //controller.redirectToNewPage();
         

         controller.objectName='d';
         controller.objectNameCriteria ='Starts';
         controller.doObjectSearch();
         
         controller.objectName='O';
         controller.objectNameCriteria='Includes';
         controller.doObjectSearch();
                  
         controller.description='d';
         controller.descriptionCriteria ='Starts';
         controller.doObjectSearch();
         
         controller.description='d';
         controller.descriptionCriteria ='Includes';
         controller.doObjectSearch();
         
         //controller.plateform='Traditional/PPO';
         controller.funding='Fully Insured';
         //controller.state='AL';
         //Object_List_Item__c oli=new Object_List_Item__c();
         controller.searchdata.Qualifiers__c='DEA';
         controller.searchdata.Value__c='O';
         controller.valueCriteria='Starts';
         controller.doObjectSearch();
         
         controller.searchdata.Value__c='O';
         controller.valueCriteria='Includes';
         controller.doObjectSearch();

         controller.searchdata.Value__c='O';
         controller.doObjectSearch();
    }
}