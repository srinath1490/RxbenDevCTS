/*Purpose: Apex Class for Cloning the Drug List                                      
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                    
   1.0 -    Rashi                 02/24/2012       Apex Class for Cloning the Drug List
   1.1 -    Bhaskar Arora         04/07/2016	   Updating Code Coverage
======================================================================== */        
 @isTest
   private class TEST_CloneDrugListController{
     static testMethod void testCloneDrugListController(){ 
       GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();      
             // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
             //Test data
             Drug_List__c dl =  testdata.createDrugList(); 
               dl.Standard__c = true; 
                 insert dl;
             Forms__c f =  testdata.CriteriaForm();    
                  insert f;

             Drug_List_Criteria__c dlc =  testdata.newDrugListcriteria(dl.Id,3);
         	 	 dlc.Drug_Type_Code__c='GPI'; //Bhaskar  
             	 dlc.Drug_Code_Value__c='941000300061*'; //Bhaskar
                 insert dlc; system.debug('Drug_List_Criteria__c-----'+dlc);
             Denial_Letter_Junction__c dlj =  testdata.createdenialLetter(f.Id,dlc.Id);
                   insert dlj;
             Step_Therapy_PreRequisite_Drug__c stpd =  testdata.preRequisite();  
                 stpd.Step_Therapy_Pre_Requisite_Drug_Name__c ='Rashi' ;
                 stpd.Related_Drug_List_Criteria__c = dlc.Id;
                 insert stpd;
                 system.debug(stpd.id);
             //Added by bhaskar
             Restricted_NDC_List__c RNDC=testdata.createRestricted_NDC_List(stpd.id,dlc.id);
         	 	insert RNDC;
             Step_Therapy_PreRequisite_Drug__c stpdchild =  testdata.preRequisite(); 
                 stpdchild.Step_Therapy_Pre_Requisite_Drug_Name__c ='Rashi1' ;
                 stpdchild.Step_Therapy_Pre_Requisite_Drug_Parent__c = stpd.id;
                 insert stpdchild;
             Stepped_Over_Time__c sqot = testdata.createstepQuantityOverTym(dlc.Id);
                 insert sqot;
                  
              // Instanciate  the VF page        
                  PageReference  VFPage= Page.VF_CloneDrugList;   
                       Test.setCurrentPage(VFPage);    
               //instanciate Apex Controller           
                  ApexPages.StandardController s = new ApexPages.standardController(dl); 
                     VFP_CloneDrugListController controllerClass = new VFP_CloneDrugListController(s);      
                         controllerClass.redirect();       
                             controllerClass.previouspage();
                             
                Drug_List__c dl2 =  new Drug_List__c(); 
                   dl2.Standard__c = true; 
                 insert dl2;
                 Drug_List_Criteria__c dlc2 =  new Drug_List_Criteria__c();    
                 dlc2.drug_list__c = dl2.id;
                 dlc2.Effective__c = system.today();
                 dlc2.Term__c = system.today() + 1;
                  insert dlc2;  
                  Step_Therapy_PreRequisite_Drug__c stpd2 =  new Step_Therapy_PreRequisite_Drug__c();  
                 stpd2.Step_Therapy_Pre_Requisite_Drug_Name__c ='Rashi' ;
                 stpd2.Related_Drug_List_Criteria__c = dlc2.Id;
                 insert stpd2;
                 Step_Therapy_PreRequisite_Drug__c stpdchild2 =  new Step_Therapy_PreRequisite_Drug__c(); 
                 stpdchild2.Step_Therapy_Pre_Requisite_Drug_Name__c ='Rashi1' ;
                 stpdchild2.Step_Therapy_Pre_Requisite_Drug_Parent__c = stpd2.id;
                 insert stpdchild2; 
                 
                 ApexPages.StandardController s3 = new ApexPages.standardController(stpd2); 
                 GMF_GenericCloning controllerClass3 = new GMF_GenericCloning(s3);
                 controllerClass3.cancelAndBack();
                               
                 PageReference  VFPage2= Page.VF_CloneSTPreReqDrug;   
                 Test.setCurrentPage(VFPage2);
                 ApexPages.currentPage().getParameters().put('Id', stpd2.Id);  
                 ApexPages.StandardController s2 = new ApexPages.standardController(stpd2); 
                 
                     GMF_GenericCloning controllerClass2 = new GMF_GenericCloning(s2);     
                         controllerClass2.saveMe();       
                             controllerClass2.cancelAndBack();
                 
                 Formulary_List__c fl = new Formulary_List__c();
                 fl.Effective_Date__c = system.today();
                 fl.Termination_Date__c = system.today()+1;
                 fl.Formulary_List_Description__c = 'test';
                 fl.Formulary_List_Name__c = 'fl1';
                 insert fl;
                 
                 Formulary_List_Entry__c fle = new Formulary_List_Entry__c();
                 fle.Formulary_List__c = fl.id;
                 fle.Effective_Date__c = system.today();
                 fle.Termination_Date__c = system.today()+1;
                 fle.NDC__c = '12345*';
                 insert fle;
                            
                 PageReference  VFPage3= Page.VF_CloneFormularyListEntry;   
                 Test.setCurrentPage(VFPage3);
                 ApexPages.currentPage().getParameters().put('Id', fle.Id);  
                 ApexPages.StandardController s4 = new ApexPages.standardController(fle); 
                 
                     GMF_GenericCloning controllerClass4 = new GMF_GenericCloning(s4);     
                         controllerClass4.saveMe();       
                             controllerClass4.cancelAndBack(); 
                             
                 Opportunity op = new Opportunity();
                 op.Type='new';
                 op.Name = 'First';
                 op.StageName = 'first';
                 op.CloseDate = system.today().addDays(3);
                 insert op;
                 
                 op.StageName= 'In-Progress';
                 update op;
                 
                 Case cs = new case ();
            //cs.contact name = cont.id;
            //cs.Type_Oyster__c = 'Ineed';
            cs.Type = 'Test1';
            //cs.Request_Sub_Type__c ='test2';
            //cs.Workflow__c ='test3';
            cs.Status = 'test4';
            //cs.Pending_With__c ='test2';
            //cs.Case Origin = 'Email';


        insert cs;

        FeedItem post = new FeedItem();
        post.body = '[Welcome to test Knowledge]';
        Post.parentid = cs.Id;       

        insert post;
                   
   } 
 }