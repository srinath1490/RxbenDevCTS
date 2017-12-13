/*Purpose: Apex Class for Cloning the Object List                                        
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                    
    1.0 -    Rashi                 02/24/2012       Apex Class for Cloning the Object List
========================================================================
 */           
 @isTest            
 private class TEST_CloneObjectListController{       
    static testMethod void testCloneObjectList(){ 
       GC_UtilityClassTestData testdata = new GC_UtilityClassTestData(); 
             
          //Test data
          Object_List__c ol = testdata.createObjectList();
              ol.Standard__c = true;       
          insert ol;
          Object_List_Item__c oli = testdata.createObjectListItem(ol.Id);
          insert oli;
          
          // Instanciate  the VF page     
          PageReference  VFPage= Page.VF_CloneObjectList;        
              Test.setCurrentPage(VFPage); 
                      
          //instanciate Apex Controller                
          ApexPages.StandardController s = new ApexPages.standardController(ol);       
          VFP_CloneObjectListController controllerClass = new VFP_CloneObjectListController(s);    
                  controllerClass.redirect();        
                  controllerClass.previouspage();      
    }  
 }