/*Purpose: Apex Test Class for VFP_AccumulationController..
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 9/21/2011       Apex Test Class for VFP_AccumulationController.
======================================================================== 
*/
@isTest
private class TEST_AccumulationController 
{
    static testmethod void testAccumulationController6()
    {

            CRD__c testCrd=new CRD__c();                    
            insert testCrd;
            CRD__c Crdobj =[select Id from CRD__c where Id=:testCrd.Id];
            Accumulations__c acc=new Accumulations__c();
            RecordType rt=[Select Id,Name from RecordType where sobjecttype='Accumulations__c' limit 1];
            acc.RecordTypeId=rt.id;
            acc.CRD_ID__c=testCrd.Id;            
            acc.Carry_Balance_when_member_moves__c='yes';
            acc.Deductible_Amount__c=100.0;
           // acc.What_is_the_In_Network_Deductible_Amount__c=100.0;
           // acc.What_is_the_OON_Deductible_Amount__c=10.0;
            //acc.Cross_Accumulation__c = 'Does Not Apply';
            acc.Deuductible_Accumulation_from_4th_Qtr__c='Yes';
           // acc.Is_this_an_HDHP_plan__c='No';
            acc.Deductible_Period__c='Month';      
            acc.Are_there_any_drug_specific_deductibles__c=true;
            
            insert acc;
                                       
            Test.setCurrentPageReference(new PageReference('Page.VF_AccumulationsStep2')); 
            System.currentPageReference().getParameters().put('crdid', Crdobj.id);
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController (acc);
            VFP_AccumulationController controller =new VFP_AccumulationController(stdcontroller);
            controller.CRD.Client_Effective_Date__c = date.today();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.createClientDate();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.createClientDate();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.createClientDate();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.createClientDate();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.createClientDate();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.createClientDate();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.createClientDate();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.createClientDate();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.createClientDate();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.createClientDate();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.createClientDate();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.createClientDate();
            controller.CRD.Client_Effective_Date__c =controller.CRD.Client_Effective_Date__c.addmonths(1);
            controller.deductibleElementCount =10;
            controller.ElementCount = 13;
            controller.moopElementCount = 14;
            controller.createClientDate();
            controller.accumulation.Are_there_any_drug_specific_MAB__c = true;
            controller.showMabPanel();
            controller.accumulation.Are_there_any_drug_specifc_MOOP__c = true;
            controller.showMoopPanel();
            controller.accumulation.Are_there_any_drug_specific_deductibles__c = false;
            controller.showDeductiblePanel();
            controller.moopAccum = new list < VFP_AccumulationController.AccumsDruglistWrapper >();
            controller.moopAccum.add( new VFP_AccumulationController.AccumsDruglistWrapper());
            controller.saveMoopList(acc.id);
            controller.mabAccum=controller.moopAccum;
            controller.mabAccum.add( new VFP_AccumulationController.AccumsDruglistWrapper());
            controller.saveMabList(acc.id);
            controller.deductibleAccum=controller.moopAccum;
            
            controller.deductibleAccum.add( new VFP_AccumulationController.AccumsDruglistWrapper());
            controller.saveDeductibleList(acc.id);
            VFP_AccumulationController.AccumsDruglistWrapper testrec = new VFP_AccumulationController.AccumsDruglistWrapper();
            testrec .isMarkedForDeletion  = false;
            controller.deductibleAccum.add( testrec );
            controller.deleteSelectedDeductible();
    }
    static testmethod void testAccumulationController()
    {
            CRD__c testCrd=new CRD__c();                    
            insert testCrd;
            CRD__c Crdobj =[select Id from CRD__c where Id=:testCrd.Id];
            Accumulations__c acc=new Accumulations__c();
            RecordType rt=[Select Id,Name from RecordType where sobjecttype='Accumulations__c' limit 1];
            acc.RecordTypeId=rt.id;
            acc.CRD_ID__c=testCrd.Id;            
            acc.Carry_Balance_when_member_moves__c='yes';
            acc.Deductible_Amount__c=100.0;
           // acc.What_is_the_In_Network_Deductible_Amount__c=100.0;
           // acc.What_is_the_OON_Deductible_Amount__c=10.0;
            //acc.Cross_Accumulation__c = 'Does Not Apply';
            acc.Deuductible_Accumulation_from_4th_Qtr__c='Yes';
           // acc.Is_this_an_HDHP_plan__c='No';
            acc.Deductible_Period__c='Month';      
            acc.Are_there_any_drug_specific_deductibles__c=true;
            
            insert acc;
                                       
            Test.setCurrentPageReference(new PageReference('Page.VF_AccumulationsStep2')); 
            System.currentPageReference().getParameters().put('crdid', Crdobj.id);
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController (acc);
            VFP_AccumulationController controller =new VFP_AccumulationController(stdcontroller);
            controller.deductibleElementCount =10;
            controller.ElementCount = 13;
            controller.moopElementCount = 14;
            
            controller.previousStep();
            controller.nextStep();
            controller.redirectToDrugCoverage();  
            controller.redirectToDrugCoverage2();         
            controller.userSelectionRecordTypeName='Individual - All';                         
            controller.redirectToAccumStep3();
            controller.redirectToAccumStep32();
            controller.recordTypeValue=rt.Id;
            controller.userSelectionRecordTypeName=rt.name;
            controller.showNumberField();
            Id rectypeid=controller.getRecordType(rt.Name);
            controller.showDeductiblePanel();
            controller.showMainMoopPanel();
            controller.showMoopPanel();
            controller.showMabPanel();
            controller.showMainMabPanel();
            controller.showMoopValues();           
            delete acc;
            
            Accumulations__c newacc=new Accumulations__c();
            RecordType rtype=[Select Id,Name from RecordType where sobjecttype='Accumulations__c' limit 1];
            newacc.RecordTypeId=rtype.id;
            newacc.CRD_ID__c=testCrd.Id;            
            newacc.Carry_Balance_when_member_moves__c='yes';
            newacc.Deductible_Amount__c=100.0;
            newacc.Deuductible_Accumulation_from_4th_Qtr__c='Yes';
          //  newacc.Is_this_an_HDHP_plan__c='No';
            newacc.Deductible_Period__c='Month';            
            newacc.Are_there_any_drug_specific_deductibles__c=true;
            stdcontroller =new ApexPages.StandardController (newacc);
            controller =new VFP_AccumulationController(stdcontroller);
            controller.recordTypeValue=rt.Id;
            controller.userSelectionRecordTypeName=rt.name;
            controller.saveAndNew();
            controller.saveAndNew();
            controller.redirectToAccumStep3();
            for(VFP_AccumulationController.AccumsDruglistWrapper wraplist:controller.deductibleAccum)
            {
               wraplist.isMarkedForDeletion=true;
            }
             for(VFP_AccumulationController.AccumsDruglistWrapper wraplist:controller.mabAccum)
            {
               wraplist.isMarkedForDeletion=true;
            }
             for(VFP_AccumulationController.AccumsDruglistWrapper wraplist:controller.moopAccum)
            {
               wraplist.isMarkedForDeletion=true;
            }
           
            controller.saveAndNew();
            controller.saveAndNew();
            controller.redirectToAccumStep3(); 
            controller.deleteSelectedDeductible();
            controller.deleteSelectedMab();
            controller.deleteSelectedMoop();
            controller.deleteSelectedAccums();
            newacc=new Accumulations__c();
            newacc.RecordTypeId=rtype.id;
            newacc.CRD_ID__c=testCrd.Id;
            newacc.Are_there_any_drug_specific_deductibles__c=true;
            stdcontroller =new ApexPages.StandardController (newacc);
            controller =new VFP_AccumulationController(stdcontroller);
            controller.recordTypeValue=rt.Id;
            controller.userSelectionRecordTypeName=rt.name;
            controller.redirectToAccumStep3(); 
            controller.saveAndNew();
            controller.saveMabList(newacc.id);
    }
    
        static testmethod void testAccumulationController1()
        {
            CRD__c testCrd=new CRD__c();
            testCrd.Client_Effective_Date__c=date.today();
            insert testCrd;
            CRD__c Crdobj =[select Id from CRD__c where Id=:testCrd.Id];
            Accumulations__c acc=new Accumulations__c();
            RecordType rt=[Select Id,Name from RecordType where sobjecttype='Accumulations__c' limit 1];
            acc.RecordTypeId=rt.id;
            acc.CRD_ID__c=testCrd.Id;
                                                  
            Test.setCurrentPageReference(new PageReference('Page.VF_AccumulationsStep2')); 
            System.currentPageReference().getParameters().put('crdid', Crdobj.id);
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController (acc);
            VFP_AccumulationController controller =new VFP_AccumulationController(stdcontroller);
            controller.accumulation.RecordTypeId=rt.id;     
            controller.userSelectionRecordTypeName=rt.Name;
            controller.deductibleElementCount =10;
            controller.ElementCount = 13;
            controller.moopElementCount = 14;
            controller.AddNewMab();
            controller.AddNewMoop();
            controller.AddNewDeductible();
            controller.saveAndNew();
            controller.createClientDate();
            controller.recordTypeValue='none';
            controller.showNumberField();

            
           }
           
           static testmethod void testAccumulationvalidationsJR()
        {
            GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
            CRD__c testCrd3=new CRD__c();                    
            insert testCrd3; 
            
            CRD__c Crdobj =[select Id from CRD__c where Id=:testCrd3.Id];            
            Accumulations__c acc3=new Accumulations__c();
            Drug_List__c dl =new Drug_List__c();
            dl.Description__c='test';         
            dl = testdata.createDrugList();
            insert dl;
            
            Drug_Group__c dg=testdata.createDrugGroup();             
            insert dg;
            
            AccumulationSpecificDrug__c accumDrug=new AccumulationSpecificDrug__c();
            
             acc3.CRD_ID__c=testCrd3.Id;
            Test.setCurrentPageReference(new PageReference('Page.VF_AccumulationsStep2')); 
            System.currentPageReference().getParameters().put('crdid', Crdobj.id);
            
            
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController(acc3);
            VFP_AccumulationController controller =new VFP_AccumulationController(stdcontroller);
            
            controller.deductibleElementCount =10;
            controller.ElementCount = 13;
            controller.moopElementCount = 14;
            
            /*controller.isValid  =true;
            controller.isDedAccumDrugvalid  = true;
            controller.isMabAccumDrugvalid  = true;
            controller.isMoopAccumDrugvalid   = true;
            controller.isValid2   = true;
            controller.IsValidMNOY   = true;
            */
            
            controller.accumulation.RecordTypeId=controller.getRecordType('Individual - All');
            controller.userSelectionRecordTypeName='Individual - All';
            controller.accumulation.Carry_Balance_when_member_moves__c='yes';
            controller.accumulation.Is_there_a_Maximum_Out_of_Pocket__c='ISMOOP';
            controller.accumulation.DAW_Differential_Penalty_Applies_to_MOOP__c='No';
            controller.accumulation.Deductible_Applies_towards_the_MOOP__c = 'Yes';
            controller.showMoopValues();
            controller.accumulation.Deductible_Amount__c=100.0;
            controller.accumulation.Deuductible_Accumulation_from_4th_Qtr__c='Yes';
           // controller.accumulation.Is_this_an_HDHP_plan__c='No';
            controller.accumulation.Deductible_Period__c='Month';
            controller.saveAndNew();            
            controller.accumulation.Are_there_any_drug_specific_deductibles__c=true;
            controller.accumulation.Are_there_any_drug_specific_MAB__c=true;
            controller.accumulation.Are_there_any_drug_specifc_MOOP__c=true;
            controller.redirectToAccumStep3();
            
            controller.accumulation.Is_there_a_Maximum_Allowable_Benefit__c='Yes';
            controller.accumulation.MAB_Dedictible_Amount__c=10;            
            controller.accumulation.What_happens_when_the_MAB_is_met__c='Test';
            controller.accumulation.MAB_Period__c='Month';
            
            controller.accumulation.MAB_Dedictible_Amount__c=null;
            controller.accumulation.What_happens_when_the_MAB_is_met__c=null;
            controller.accumulation.MAB_Period__c=null;
            controller.redirectToAccumStep3();
            controller.saveAndNew();
            controller.accumulation.MAB_Dedictible_Amount__c=10;
            controller.accumulation.MAB_Period__c='Month';            
            
            
            controller.accumulation.Is_there_a_Maximum_Out_of_Pocket__c='Yes';
            controller.accumulation.MOOP_Dedictible_Amount__c=10;
            controller.accumulation.MOOP_Period__c='Month';
            controller.accumulation.Deductible_Applies_towards_the_MOOP__c='yes';
            
            controller.accumulation.MOOP_Dedictible_Amount__c=null;
            controller.accumulation.Deductible_Applies_towards_the_MOOP__c=null;
            controller.accumulation.MOOP_Period__c=null;
            controller.redirectToAccumStep3();
            controller.saveAndNew();
            controller.accumulation.MOOP_Dedictible_Amount__c=10;
            controller.accumulation.MOOP_Period__c='Month';


           controller.redirectToAccumStep3();
            controller.saveAndNew();
           
            controller.AddNewDeductible();
            AccumulationSpecificDrug__c accumDrug1= new AccumulationSpecificDrug__c();
            
            controller.userSelectionRecordTypeName='Family - All';
            accumDrug1 = controller.deductibleAccum[0].accumsDrugList;
            accumDrug1.Drug_List__c=dl.id;
            accumDrug1.Drug_Group__c=dg.id;                 
           controller.AddNewMab();
            controller.AddNewMoop();                          
            controller.redirectToAccumStep3();
            controller.saveAndNew();
                        
            controller.userSelectionRecordTypeName='Family - All';          
            accumDrug1 = controller.mabAccum[0].accumsDrugList;
            accumDrug1.Drug_List__c=dl.id;
            accumDrug1.Drug_Group__c=dg.id;                 
           // accumDrug1.Family_Members_to_meet_Family_Deduct__c=null;
            controller.redirectToAccumStep3();
            controller.saveAndNew();
            
            controller.userSelectionRecordTypeName='Family - All';
            accumDrug1 = controller.moopAccum[0].accumsDrugList;
            accumDrug1.Drug_List__c=dl.id;
            accumDrug1.Drug_Group__c=dg.id;                 
          //  accumDrug1.Family_Members_to_meet_Family_Deduct__c=null;
            controller.redirectToAccumStep3();
            controller.saveAndNew();  
           


            controller.userSelectionRecordTypeName='Family - All';            
            controller.saveAndNew();
            controller.redirectToAccumStep3();
            
            controller.recordTypeValue='none';
            controller.saveAndNew();
           // accumDrug1.Family_Members_to_meet_Family_Deduct__c=null;
            controller.redirectToAccumStep3();    
            
            controller.userSelectionRecordTypeName='Individual';
            controller.redirectToAccumStep3();
        }
           
           
       static testmethod void testAccumulationvalidations()
        {
            GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
            CRD__c testCrd3=new CRD__c();                    
            insert testCrd3; 
            
            CRD__c Crdobj =[select Id from CRD__c where Id=:testCrd3.Id];            
            Accumulations__c acc3=new Accumulations__c();
            Drug_List__c dl =new Drug_List__c();
            dl.Description__c='test';         
            dl = testdata.createDrugList();
            insert dl;
            
            Drug_Group__c dg=testdata.createDrugGroup();             
            insert dg;
            
            AccumulationSpecificDrug__c accumDrug=new AccumulationSpecificDrug__c();
            
             acc3.CRD_ID__c=testCrd3.Id;
            Test.setCurrentPageReference(new PageReference('Page.VF_AccumulationsStep2')); 
            System.currentPageReference().getParameters().put('crdid', Crdobj.id);
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController(acc3);
            VFP_AccumulationController controller =new VFP_AccumulationController(stdcontroller);
            
            controller.deductibleElementCount =10;
            controller.ElementCount = 13;
            controller.moopElementCount = 14;
            
            controller.accumulation.RecordTypeId=controller.getRecordType('Individual - All');
            controller.userSelectionRecordTypeName='Individual - All';
            controller.accumulation.Carry_Balance_when_member_moves__c='yes';
            controller.accumulation.Deductible_Amount__c=100.0;
            controller.accumulation.Deuductible_Accumulation_from_4th_Qtr__c='Yes';
           // controller.accumulation.Is_this_an_HDHP_plan__c='No';
            controller.accumulation.Deductible_Period__c='Month';
            controller.saveAndNew();            
            controller.accumulation.Are_there_any_drug_specific_deductibles__c=true;
            controller.accumulation.Are_there_any_drug_specific_MAB__c=true;
            controller.accumulation.Are_there_any_drug_specifc_MOOP__c=true;
            controller.redirectToAccumStep3();
            
            controller.accumulation.Is_there_a_Maximum_Allowable_Benefit__c='Yes';
            controller.accumulation.MAB_Dedictible_Amount__c=10;            
            controller.accumulation.What_happens_when_the_MAB_is_met__c='Test';
            controller.accumulation.MAB_Period__c='Month';
            
            controller.accumulation.MAB_Dedictible_Amount__c=null;
            controller.accumulation.What_happens_when_the_MAB_is_met__c=null;
            controller.accumulation.MAB_Period__c=null;
            controller.redirectToAccumStep3();
            controller.saveAndNew();
            controller.accumulation.MAB_Dedictible_Amount__c=10;
            controller.accumulation.MAB_Period__c='Month';            
            
            
            controller.accumulation.Is_there_a_Maximum_Out_of_Pocket__c='Yes';
            controller.accumulation.MOOP_Dedictible_Amount__c=10;
            controller.accumulation.MOOP_Period__c='Month';
            controller.accumulation.Deductible_Applies_towards_the_MOOP__c='ys';
            
            controller.accumulation.MOOP_Dedictible_Amount__c=null;
            controller.accumulation.Deductible_Applies_towards_the_MOOP__c=null;
            controller.accumulation.MOOP_Period__c=null;
            controller.redirectToAccumStep3();
            controller.saveAndNew();
            controller.accumulation.MOOP_Dedictible_Amount__c=10;
            controller.accumulation.MOOP_Period__c='Month';


           controller.redirectToAccumStep3();
            controller.saveAndNew();
           
            controller.AddNewDeductible();
            AccumulationSpecificDrug__c accumDrug1= new AccumulationSpecificDrug__c();
            
            controller.userSelectionRecordTypeName='Family - All';
            accumDrug1 = controller.deductibleAccum[0].accumsDrugList;
            accumDrug1.Drug_List__c=dl.id;
            accumDrug1.Drug_Group__c=dg.id;                 
           controller.AddNewMab();
            controller.AddNewMoop();                          
            controller.redirectToAccumStep3();
            controller.saveAndNew();
                        
            controller.userSelectionRecordTypeName='Family - All';          
            accumDrug1 = controller.mabAccum[0].accumsDrugList;
            accumDrug1.Drug_List__c=dl.id;
            accumDrug1.Drug_Group__c=dg.id;                 
           // accumDrug1.Family_Members_to_meet_Family_Deduct__c=null;
            controller.redirectToAccumStep3();
            controller.saveAndNew();
            
            controller.userSelectionRecordTypeName='Family - All';
            accumDrug1 = controller.moopAccum[0].accumsDrugList;
            accumDrug1.Drug_List__c=dl.id;
            accumDrug1.Drug_Group__c=dg.id;                 
          //  accumDrug1.Family_Members_to_meet_Family_Deduct__c=null;
            controller.redirectToAccumStep3();
            controller.saveAndNew();  
           


            controller.userSelectionRecordTypeName='Family - All';            
            controller.saveAndNew();
            controller.redirectToAccumStep3();
            
            controller.recordTypeValue='none';
            controller.saveAndNew();
           // accumDrug1.Family_Members_to_meet_Family_Deduct__c=null;
            controller.redirectToAccumStep3();    
            
            controller.userSelectionRecordTypeName='Individual';
            controller.redirectToAccumStep3();
        }
        
        //added by JR
        
         static testMethod void testDuplicateAccumulation1(){
             Accumulations__c testAccumulation=new Accumulations__c();
             CRD__c testCrd3=new CRD__c(); 
             testCrd3.Client_Effective_Date__c =system.today();
             insert testCrd3;
             system.debug('client effective date'+testCrd3.Client_Effective_Date__c);
            RecordType rt=[Select Id,Name from RecordType where sobjecttype='Accumulations__c' and name ='Family - All'];
         // testAccumulation.Is_this_an_HDHP_plan__c='No';
            testAccumulation.RecordTypeId=rt.id;
            testAccumulation.CRD_ID__c=testCrd3.id;
            testAccumulation.Carry_Balance_when_member_moves__c='No';
          //  testAccumulation.Deductible_Amount__c=100;
            testAccumulation.Deductible_Period__c='10';
            testAccumulation.Deuductible_Accumulation_from_4th_Qtr__c='10';
            testAccumulation.What_is_the_In_Network_Deductible_Amount__c= 20;
            testAccumulation.What_is_the_OON_Deductible_Amount__c=10;
            testAccumulation.Cross_Accumulation__c = 'Does Not Apply';
            
            insert testAccumulation;
            
            System.currentPageReference().getParameters().put('crdid', testCrd3.id);
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController(testAccumulation);
            VFP_AccumulationController objController =new VFP_AccumulationController(stdcontroller);
 
           // VFP_AccumulationController = new VFP_AccumulationController(testAccumulation);
            objController.saveDeductibleList(String.valueOf(testAccumulation.id));
            objController.saveMoopList(String.valueOf(testAccumulation.id));
            objController.AddNewDeductible();
            objController.AddNewMoop();
            objController.AddNewMab();
            objController.accumulation.Deductible_Amount__c=100;
            objController.accumulation.What_is_the_In_Network_Deductible_Amount__c = 20;

            objController.redirectToAccumStep3();   
            objController.accumulation.Deductible_Amount__c=null;           
            objController.accumulation.What_is_the_OON_Deductible_Amount__c = 20;
            objController.userSelectionRecordTypeName = 'Family';
            objController.redirectToAccumStep3();   
            objController.saveAndNew();
            objController.userSelectionRecordTypeName = 'Family - All';
            objController.redirectToAccumStep3();           
            objController.saveAndNew();
            objController.userSelectionRecordTypeName = 'Individual - All';
            objController.redirectToAccumStep3();   
            objController.accumulation.Cross_Accumulation__c = null;
            objController.saveAndNew();
            //rt=[Select Id,Name from RecordType where sobjecttype='Account' and name ='Individual - All'];
            //bjController.acc.recordtypeid = rt.id;
            objController.userSelectionRecordTypeName = 'Individual';
            objController.redirectToAccumStep3();               
            objController.saveAndNew();
            objController.userSelectionRecordTypeName = 'Individual - All';
            objController.accumulation.What_is_the_In_Network_Deductible_Amount__c = 20;
            objController.saveAndNew();
            //VFP_AccumulationController.AccumslistWrapper testaccum
            objController.lstAccumWrap= new list<VFP_AccumulationController.AccumslistWrapper >();
            objController.lstAccumWrap.add(new  VFP_AccumulationController.AccumslistWrapper ());
            objController.deleteSelectedAccums();
            
         }
         
         
       static testMethod void testDuplicateAccumulation(){           
           
            GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
            CRD__c testCrd3=new CRD__c();  
             testcrd3.lastsent__c = system.now();                 
            insert testCrd3;
            //Test Data to check Duplicate recordType Validation
            RecordType rt=[Select Id,Name from RecordType where sobjecttype='Accumulations__c' and name ='Family - All'];
            Accumulations__c testAccumulation=new Accumulations__c();
         //   testAccumulation.Is_this_an_HDHP_plan__c='No';
            testAccumulation.RecordTypeId=rt.id;
            testAccumulation.CRD_ID__c=testCrd3.id;
            testAccumulation.Carry_Balance_when_member_moves__c='No';
            testAccumulation.Deductible_Amount__c=100;
            testAccumulation.Deductible_Period__c='10';
            testAccumulation.Deuductible_Accumulation_from_4th_Qtr__c='10';
            insert testAccumulation;
            

            Accumulations__c testAccumulation1=new Accumulations__c();
            Test.setCurrentPageReference(new PageReference('Page.VF_AccumulationsStep2')); 
            System.currentPageReference().getParameters().put('crdid', testCrd3.id);
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController(testAccumulation1);
            VFP_AccumulationController controller =new VFP_AccumulationController(stdcontroller);
            controller.accumulation.RecordTypeId =controller.getRecordType('Family - All');
            controller.recordTypeValue=controller.getRecordType('Family - All');
            controller.userSelectionRecordTypeName='Family - All';
            controller.showNumberField();
          //  controller.accumulation.Is_this_an_HDHP_plan__c='No';
            controller.accumulation.Carry_Balance_when_member_moves__c='No';
            controller.accumulation.Deductible_Amount__c=100;
            controller.accumulation.Deductible_Period__c='10';
            controller.accumulation.Deuductible_Accumulation_from_4th_Qtr__c='10';            
            controller.redirectToAccumStep3();
            controller.saveAndNew();

            controller.accumulation.RecordTypeId =controller.getRecordType('Family - Mail');
            controller.recordTypeValue=controller.getRecordType('Family - Mail');
            controller.userSelectionRecordTypeName='Family - Mail';
            controller.redirectToAccumStep3();
            controller.saveAndNew();
       }
    static testMethod void testDuplicateAccumulationss(){           
           
            GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
            CRD__c testCrd3=new CRD__c();  
             testcrd3.lastsent__c = system.now();                 
            insert testCrd3;
            //Test Data to check Duplicate recordType Validation
            RecordType rt=[Select Id,Name from RecordType where sobjecttype='Accumulations__c' and name ='Individual - All'];
            Accumulations__c testAccumulation=new Accumulations__c();
         //   testAccumulation.Is_this_an_HDHP_plan__c='No';
            testAccumulation.RecordTypeId=rt.id;
            testAccumulation.CRD_ID__c=testCrd3.id;
            testAccumulation.Carry_Balance_when_member_moves__c='No';
            testAccumulation.Deductible_Amount__c=100;
            testAccumulation.Deductible_Period__c='10';
            testAccumulation.Deuductible_Accumulation_from_4th_Qtr__c='10';
            insert testAccumulation;
            

            Accumulations__c testAccumulation1=new Accumulations__c();
            Test.setCurrentPageReference(new PageReference('Page.VF_AccumulationsStep2')); 
            System.currentPageReference().getParameters().put('crdid', testCrd3.id);
            ApexPages.StandardController stdcontroller =new ApexPages.StandardController(testAccumulation1);
            VFP_AccumulationController controller =new VFP_AccumulationController(stdcontroller);
            controller.accumulation.RecordTypeId =controller.getRecordType('Individual - All');
            controller.recordTypeValue=controller.getRecordType('Individual - All');
            controller.userSelectionRecordTypeName='Individual - All';
            controller.showNumberField();
          //  controller.accumulation.Is_this_an_HDHP_plan__c='No';
            controller.accumulation.Carry_Balance_when_member_moves__c='No';
            controller.accumulation.Deductible_Amount__c=100;
            controller.accumulation.Deductible_Period__c='10';
            controller.accumulation.Deuductible_Accumulation_from_4th_Qtr__c='10';            
            controller.redirectToAccumStep3();
            controller.saveAndNew();

            controller.accumulation.RecordTypeId =controller.getRecordType('Individual - All');
            controller.recordTypeValue=controller.getRecordType('Individual - All');
            controller.userSelectionRecordTypeName='Individual - All';
            controller.redirectToAccumStep3();
            controller.saveAndNew();
            controller.AddNewMab();
            controller.AddNewMoop();
       }
        
}