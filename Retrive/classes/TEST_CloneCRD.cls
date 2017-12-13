/*
Class Name: TEST_CloneCRD
* Author: Accenture* Date: 21-Sep-2011
* Requirement/Project Name: <Aetna>
* Requirement/Project Description: Test Class for Apex class 
*/
@isTest
private class TEST_CloneCRD {
  //Test method for the crd cloning functionality
     static testMethod void testCloneCrd() {
        list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where sobjecttype='Drug_Coverage__c']);
        CRD__c testCrd=new CRD__c();
        testCrd.crd_automated__c =True;
        insert testCrd;
        //CRD__c testCrd1=new CRD__c();
        //insert testCrd1;
        Drug_Group__c dg = new Drug_Group__c();
        dg.Drug_Group_Name__c = 'Acne- all- PR 36 y/o';
        dg.Effective_Date__c = system.today();
        dg.Description__c = 'Acne- all- PR 36 y/o';
        dg.Termination_Date__c = system.today()+7;
        insert dg;
        
        Formulary__c frm=new Formulary__c();
        frm.Formulary_Name__c='test';
        frm.Formulary_Description__c='test';
        frm.Effective_Date__c = system.today();
        frm.Termination_Date__c =system.today() +7;
        insert frm; 
        
        Drug_Coverage__c drugCoverateItem1=new Drug_Coverage__c();
        drugCoverateItem1.Formulary__c=frm.id;
        drugCoverateItem1.CRD_ID__c = testCrd.id;
        drugCoverateItem1.RecordTypeId=rt.get(0).id;
        drugCoverateItem1.Do_you_have_Choose_Generic__c ='Yes';
        drugCoverateItem1.Choose_Generic_Copay_Diff_Exclusion__c='No';
        insert drugCoverateItem1;
        
        DC_Drug_List_Group__c dcRecord = new DC_Drug_List_Group__c();
        dcRecord.Related_Drug_Coverage__c = drugCoverateItem1.Id;
        dcRecord.Inclusion_Exclusion__c = 'Exclude';
        dcRecord.Apply_Limitations__c = 'Yes';
        insert dcRecord;
        
        Drug_Specific_Copay__c drugSCopay=new Drug_Specific_Copay__c();
        drugSCopay.CRD_ID__c =  testCrd.id;  
        insert drugSCopay; 
        
        Drug_Specific_Stepped_Copay__c drugSSteppedCopay = new Drug_Specific_Stepped_Copay__c();
        drugSSteppedCopay.Drug_Specific_Copay_ID__c =  drugSCopay.id;  
        drugSSteppedCopay.Dollar_Amount__c=10;
        insert drugSSteppedCopay;
        
        Copay_Tier__c copayTier = new Copay_Tier__c();       
        copayTier.CRD__c = testCrd.id;
        copayTier.Percent__c=10;
        insert  copayTier; 
        
        SteppedCopay__c steppedCopay = new SteppedCopay__c();
        steppedCopay.Copay_Tier__c = copayTier.id;
        steppedCopay.Dollar_Amount__c=10;
        insert SteppedCopay;
        
        CRD_PriorAuth_Junction__c pa=new CRD_PriorAuth_Junction__c();
            pa.CRD_ID__c = testCrd.id;
        insert pa;
        CRD_Quantity_Limit_Junction__c qa=new CRD_Quantity_Limit_Junction__c();
            qa.CRD_ID__c = testCrd.id;
        insert qa;
        /* Commented by Sushant: Req 04937
        MOOP_Bypass__c moopByPass = new MOOP_Bypass__c();
        moopByPass.CRD_ID__c = testCrd.id;
        moopByPass.MOOP_Bypass_Drug_Group__c = dg.Id;
        insert moopByPass;*/
        Drug_List__c dl = new Drug_List__c();
        dl.Description__c = 'Fluoride Dental Products (Covered- Rx only)';
        dl.Drug_List_Name__c = 'Fluoride Dental Products (Covered- Rx only)';
        dl.Effective_Date__c = system.today();
        dl.Termination_Date__c = system.today()+7;
        insert dl;
        
        Accumulations__c accoum=new Accumulations__c();
        accoum.CRD_ID__c=testCrd.id;    
        insert accoum;
        accoum.No_of_Family_Members_to_Meet_Maximum_MAB__c='test';
        update accoum;
    
        AccumulationSpecificDrug__c  accumSpecificDrug = new AccumulationSpecificDrug__c();
        accumSpecificDrug.Accumulations_ID__c=accoum.id;
        accumSpecificDrug.Accumulatoins_Type__c='test';
        insert accumSpecificDrug;
        Accumulation_Change_Copay__c asdRec = new Accumulation_Change_Copay__c();
        asdRec.Accumulation_ID__c=accoum.id;
        insert asdRec;
        Accumulation_Change_Copay_Stepped__c accsRec = new Accumulation_Change_Copay_Stepped__c();
        accsRec.Accumulation_Change_Copay_ID__c = asdRec.id;
        insert accsRec;
        RxCheck_Junction__c rxcRec =  new RxCheck_Junction__c();
        rxcRec.crd__c = testCrd.id;
        
          
          Drug_List_Criteria__c druglst=new Drug_List_Criteria__c();
          druglst.Effective__c=System.today();
          druglst.Drug_List__c=dl.id;
          druglst.Term__c=System.today()+7;
          insert druglst;
         
          Stepped_Over_Time__c steptym=new Stepped_Over_Time__c();
          steptym.Step_Type__c='yes';
          steptym.Related_Drug_List_Criteria__c=druglst.id;
          insert steptym;
          
          CRD_Step_Therapy_Junction__c stJunction=new CRD_Step_Therapy_Junction__c();       
          stJunction.CRD_ID__c=testCrd.id;
          stJunction.Step_Therapy_DrugList_Class__c=dl.id;
          insert stJunction;
          
          AHA_Junction__c aHAJunction = new AHA_Junction__c();
          aHAJunction.CRD_ID__c=testCrd.id;
          aHAJunction.Drug_List_ID__c = dl.Id;
          insert aHAJunction;
          
       Waiver_Of_Deductible__c wod = new Waiver_Of_Deductible__c();
       wod.CRD_ID__c=testCrd.id;
       wod.Drug_Class__c='FOR PREEFRRED GENERIC FOR COSTCO';
       wod.Drug_Group__c=dg.id;
       wod.Delivery_System__c='Mail';
       wod.M__c=true;
       insert wod;
        
          DAW_Specific_Copay__c daw = new  DAW_Specific_Copay__c();
          daw.CRD_ID__c = testCRD.id;
          insert daw;
          
          DAW_Specific_Stepped_Copay__c  dawStep = new DAW_Specific_Stepped_Copay__c ();
          //dawStep.CRD_ID__c = testCRD.id;
          dawStep.DAW_Specific_Copay_ID__c = daw.id; 
          insert dawStep;
          
          RxCheck_Junction__c rxCheck = new RxCheck_Junction__c();
          rxCheck.CRD__c = testCRD.id;
          insert rxCheck;

          Network_Junction__c netJunc = new Network_Junction__c();
          netJunc.CRD_ID__c = testCRD.id;
          insert netJunc;
          
          Save_A_Copay_Junction__c sacJunc = new Save_A_Copay_Junction__c();
          sacJunc.CRD_ID__c = testCRD.id;
          insert sacJunc;
          
          PSP_Junction__c pspJunc = new PSP_Junction__c();
          pspJunc.CRD_ID__c = testCRD.id;
          insert pspJunc;
          
          CRD_Step_Therapy_Junction__c stJunc = new CRD_Step_Therapy_Junction__c();
          stJunc.CRD_ID__c = testCRD.id;
          insert stJunc;
          
          Clinical_Program_Group_Junction__c cpgJunc = new Clinical_Program_Group_Junction__c();
          cpgJunc.CRD_ID__c = testCRD.id;
          insert cpgJunc;
          
          CRD_PriorAuth_Junction__c paJunc = new CRD_PriorAuth_Junction__c();
          paJunc.CRD_ID__c = testCRD.id;
          insert paJunc;
          
          CRD_Quantity_Limit_Junction__c qaJunc = new CRD_Quantity_Limit_Junction__c();
          qaJunc.CRD_ID__c = testCRD.id;
          insert qaJunc;
          
          Aetna_RxStep_Junction__c rxJunc = new Aetna_RxStep_Junction__c();
          rxJunc.CRD_ID__c = testCRD.id;
          insert rxJunc;
          
          Aetna_RxHealthy_Outcomes_Junction__c outJunc = new Aetna_RxHealthy_Outcomes_Junction__c();
          outJunc.CRD_ID__c = testCRD.id;
          insert outJunc;
          
          CRD_Standard_Safety_Edit_Junction__c safetyJunc = new CRD_Standard_Safety_Edit_Junction__c();
          safetyJunc.CRDID__c = testCRD.id;
          insert safetyJunc;
          
          CSAP_CGLP_Junction__c csapJunc = new CSAP_CGLP_Junction__c();
          csapJunc.CRD__c = testCRD.id;
          insert csapJunc;
          
          CRD_NPL_Junction__c nplJunc = new CRD_NPL_Junction__c();
          nplJunc.CRD_ID__c = testCRD.id;
          insert nplJunc;
          
        VFP_CloneCRD ctrl=new VFP_CloneCRD();
          ctrl.currentCRDID='Test';
            try{        
            ctrl.cloneCrdWithItems(testCrd.Id,testCrd, false);
            }
            catch(exception ex){}          
            try{
            ctrl.cloneCrdWithItems(testCrd.Id,null, false);
            }
            catch(exception ex){}
            try{
            ctrl.cloneCrdWithItems(testCrd.Id,null, true);
            }
            catch(exception ex){}
            test.startTest();
            ctrl.cloneCrdWithItems(testCrd.Id,testCrd, false);
           ctrl.clonecopay(testCrd.id);
           ctrl.cloneDrugSpecificCopay(testCrd.id);
           ctrl.cloneAccumulations(testCrd.id);
           ctrl.cloneWOD(testCrd.id);
           ctrl.cloneNPL(testCrd.id);
           
           ctrl.cloneRxStepJunction(testCrd.id);
           ctrl.cloneRXOJunction(testCrd.id);
           ctrl.cloneSSEJunction(testCrd.id);
           ctrl.cloneAHAJunction(testCrd.id);
           test.stopTest();
           
           
          // ctrl.cloneNetworkJunction(testCrd.id);                               
    }    
    static testMethod  void testCloneCrdmethod() {
        list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where sobjecttype='Drug_Coverage__c']);
        CRD__c testCrd=new CRD__c();
        testCrd.crd_automated__c =True;
        insert testCrd;
        //CRD__c testCrd1=new CRD__c();
        //insert testCrd1;
        Drug_Group__c dg = new Drug_Group__c();
        dg.Drug_Group_Name__c = 'Acne- all- PR 36 y/o';
        dg.Effective_Date__c = system.today();
        dg.Description__c = 'Acne- all- PR 36 y/o';
        dg.Termination_Date__c = system.today()+7;
        insert dg;
        
        Formulary__c frm=new Formulary__c();
        frm.Formulary_Name__c='test';
        frm.Formulary_Description__c='test';
        frm.Effective_Date__c = system.today();
        frm.Termination_Date__c =system.today() +7;
        insert frm; 
        
        Drug_Coverage__c drugCoverateItem1=new Drug_Coverage__c();
        drugCoverateItem1.Formulary__c=frm.id;
        drugCoverateItem1.CRD_ID__c = testCrd.id;
        drugCoverateItem1.RecordTypeId=rt.get(0).id;
        drugCoverateItem1.Do_you_have_Choose_Generic__c ='Yes';
        drugCoverateItem1.Choose_Generic_Copay_Diff_Exclusion__c='No';
        insert drugCoverateItem1;
        
        DC_Drug_List_Group__c dcRecord = new DC_Drug_List_Group__c();
        dcRecord.Related_Drug_Coverage__c = drugCoverateItem1.Id;
        dcRecord.Inclusion_Exclusion__c = 'Exclude';
        dcRecord.Apply_Limitations__c = 'Yes';
        insert dcRecord;
        
        Drug_Specific_Copay__c drugSCopay=new Drug_Specific_Copay__c();
        drugSCopay.CRD_ID__c =  testCrd.id;  
        insert drugSCopay; 
        
        Drug_Specific_Stepped_Copay__c drugSSteppedCopay = new Drug_Specific_Stepped_Copay__c();
        drugSSteppedCopay.Drug_Specific_Copay_ID__c =  drugSCopay.id;  
        drugSSteppedCopay.Dollar_Amount__c=10;
        insert drugSSteppedCopay;
        
        Copay_Tier__c copayTier = new Copay_Tier__c();       
        copayTier.CRD__c = testCrd.id;
        copayTier.Percent__c=10;
        insert  copayTier; 
        
        SteppedCopay__c steppedCopay = new SteppedCopay__c();
        steppedCopay.Copay_Tier__c = copayTier.id;
        steppedCopay.Dollar_Amount__c=10;
        insert SteppedCopay;
        
        CRD_PriorAuth_Junction__c pa=new CRD_PriorAuth_Junction__c();
            pa.CRD_ID__c = testCrd.id;
        insert pa;
        CRD_Quantity_Limit_Junction__c qa=new CRD_Quantity_Limit_Junction__c();
            qa.CRD_ID__c = testCrd.id;
        insert qa;
        /* Commented by Sushant: Req 04937
        MOOP_Bypass__c moopByPass = new MOOP_Bypass__c();
        moopByPass.CRD_ID__c = testCrd.id;
        moopByPass.MOOP_Bypass_Drug_Group__c = dg.Id;
        insert moopByPass;*/
        Drug_List__c dl = new Drug_List__c();
        dl.Description__c = 'Fluoride Dental Products (Covered- Rx only)';
        dl.Drug_List_Name__c = 'Fluoride Dental Products (Covered- Rx only)';
        dl.Effective_Date__c = system.today();
        dl.Termination_Date__c = system.today()+7;
        insert dl;
        
        Accumulations__c accoum=new Accumulations__c();
        accoum.CRD_ID__c=testCrd.id;    
        insert accoum;
        accoum.No_of_Family_Members_to_Meet_Maximum_MAB__c='test';
        update accoum;
    
        AccumulationSpecificDrug__c  accumSpecificDrug = new AccumulationSpecificDrug__c();
        accumSpecificDrug.Accumulations_ID__c=accoum.id;
        accumSpecificDrug.Accumulatoins_Type__c='test';
        insert accumSpecificDrug;
        Accumulation_Change_Copay__c asdRec = new Accumulation_Change_Copay__c();
        asdRec.Accumulation_ID__c=accoum.id;
        insert asdRec;
        Accumulation_Change_Copay_Stepped__c accsRec = new Accumulation_Change_Copay_Stepped__c();
        accsRec.Accumulation_Change_Copay_ID__c = asdRec.id;
        insert accsRec;
        RxCheck_Junction__c rxcRec =  new RxCheck_Junction__c();
        rxcRec.crd__c = testCrd.id;
        
          
          Drug_List_Criteria__c druglst=new Drug_List_Criteria__c();
          druglst.Effective__c=System.today();
          druglst.Drug_List__c=dl.id;
          druglst.Term__c=System.today()+7;
          insert druglst;
         
          Stepped_Over_Time__c steptym=new Stepped_Over_Time__c();
          steptym.Step_Type__c='yes';
          steptym.Related_Drug_List_Criteria__c=druglst.id;
          insert steptym;
          
          CRD_Step_Therapy_Junction__c stJunction=new CRD_Step_Therapy_Junction__c();       
          stJunction.CRD_ID__c=testCrd.id;
          stJunction.Step_Therapy_DrugList_Class__c=dl.id;
          insert stJunction;
          
          AHA_Junction__c aHAJunction = new AHA_Junction__c();
          aHAJunction.CRD_ID__c=testCrd.id;
          aHAJunction.Drug_List_ID__c = dl.Id;
          insert aHAJunction;
          
       Waiver_Of_Deductible__c wod = new Waiver_Of_Deductible__c();
       wod.CRD_ID__c=testCrd.id;
       wod.Drug_Class__c='FOR PREEFRRED GENERIC FOR COSTCO';
       wod.Drug_Group__c=dg.id;
       wod.Delivery_System__c='Mail';
       wod.M__c=true;
       insert wod;
        
        
        VFP_CloneCRD ctrl=new VFP_CloneCRD();
          ctrl.currentCRDID='Test';
            try{        
            ctrl.cloneCrdWithItems(testCrd.Id,testCrd, false);
            }
            catch(exception ex){}          
            try{
            ctrl.cloneCrdWithItems(testCrd.Id,null, false);
            }
            catch(exception ex){}
            try{
            ctrl.cloneCrdWithItems(testCrd.Id,null, true);
            }
            catch(exception ex){}
            test.startTest();
           ctrl.cloneRxCheck(testCrd.id);
           
           test.stopTest();
           
           
          // ctrl.cloneNetworkJunction(testCrd.id);                               
    }
       //Test method for the custom history tracking  triggers

       static testMethod void testAfterUpdateTrigger(){
            CRD__c testCrd=new CRD__c();
            testCrd.crd_automated__c =True;
            testCrd.Are_you_creating_a_Package_Plan__c='Yes';
            testCrd.Discount_Rate__c='no';
            testCrd.LastSent__c=system.today();
       Insert testCrd;
            testCrd.Are_you_creating_a_Package_Plan__c='No';
            testCrd.Discount_Rate__c='yes';
        update testCrd;
    
    }
    
      //Test method for the custom history tracking  triggers
      static testMethod void testAccumulationAfterUpdateTrigger(){
         CRD__c testCrd=new CRD__c();
         testCrd.crd_automated__c =True;
         testCrd.LastSent__c=system.today();
     insert testCrd;
     
      Accumulations__c accoum=new Accumulations__c();
         accoum.CRD_ID__c=testCrd.id;    
      insert accoum;
         accoum.No_of_Family_Members_to_Meet_Maximum_MAB__c='test';
      update accoum;
    
    }
    
    //Test method for the custom history tracking  triggers
    static testMethod void testAccumSpecificDrugAfterUpdateTrigger(){
     CRD__c testCrd=new CRD__c();
     testCrd.crd_automated__c =True;
     testCrd.LastSent__c=system.today();
     insert testCrd;
     
     Accumulations__c accoum=new Accumulations__c();
     accoum.CRD_ID__c=testCrd.id;    
     insert accoum;
     accoum.No_of_Family_Members_to_Meet_Maximum_MAB__c='test';
     update accoum;
    
     AccumulationSpecificDrug__c  accumSpecificDrug = new AccumulationSpecificDrug__c();
     accumSpecificDrug.Accumulations_ID__c=accoum.id;
     accumSpecificDrug.Accumulatoins_Type__c='test';
     insert accumSpecificDrug;
        
     accumSpecificDrug.Accumulatoins_Type__c='test1';
     update accumSpecificDrug;
     delete accumSpecificDrug;
    
    }
    
    //Test method for the custom history tracking  triggers 
    static testmethod void testCopayAfterTriggers(){
         CRD__c testCrd=new CRD__c();
         testCrd.crd_automated__c =True;
         testCrd.LastSent__c=system.today();
         insert testCrd;
         
         Copay_Tier__c ct=new Copay_Tier__c();
         ct.CRD__c=testCrd.id;
         Recordtype rt=[select id from RecordType where SobjectType='Copay_Tier__c' and developername='Mail'];
         ct.recordTypeid=rt.id;
         ct.Tier_Type__c='test';
         ct.Stepped_Copay__c=true;       
         insert ct;
         
         rt=[select id from RecordType where SobjectType='Copay_Tier__c' and developername='Retail'];
         ct.recordTypeid=rt.id;
         
         ct.Tier_Type__c='test1';
         update ct;   
        
    }
    
    //Test method for the custom history tracking  triggers 
    static testmethod void testSteppedCopayAfterTriggers(){
        CRD__c testCrd=new CRD__c();
        testCrd.crd_automated__c =True;
        testCrd.LastSent__c=system.today();
        insert testCrd;
        
        Copay_Tier__c ct=new Copay_Tier__c();
        ct.CRD__c=testCrd.id;
        Recordtype rt=[select id from RecordType where SobjectType='Copay_Tier__c' and developername='Mail'];
        ct.recordTypeid=rt.id;
        ct.Tier_Type__c='test';
        ct.Stepped_Copay__c=true;        
        insert ct;
        
        SteppedCopay__c sc=new SteppedCopay__c();       
        sc.Copay_Tier__c=ct.id;
        sc.Number_of_Ranges__c='test';
        
        insert sc;
        sc.Number_of_Ranges__c='test2';
        update sc;      
        
        
    }
    
     //Test method for the custom history tracking  triggers 
    static testmethod void testDrugSpecificCopayAfterTriggers(){
         CRD__c testCrd=new CRD__c();
         testCrd.crd_automated__c =True;
         testCrd.LastSent__c=system.today();
         insert testCrd;
         
         Drug_Specific_Copay__c ct=new Drug_Specific_Copay__c();
         ct.CRD_ID__c=testCrd.id;
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Mail'];
         ct.recordTypeid=rt.id;
        
         ct.Stepped_Copay__c=true;       
         insert ct;
         
         rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Retail'];
         ct.recordTypeid=rt.id;      
         ct.Stepped_Copay__c=false;
         update ct; 
         delete ct;  
        
    }
    
    //Test method for the custom history tracking  triggers 
    static testmethod void testDrugSpecificSteppedCopayAfterTriggers(){
         CRD__c testCrd=new CRD__c();
         testCrd.crd_automated__c =True;
         testCrd.LastSent__c=system.today();
         insert testCrd;
         
         Drug_Specific_Copay__c ct=new Drug_Specific_Copay__c();
         ct.CRD_ID__c=testCrd.id;
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Mail'];
         ct.recordTypeid=rt.id;     
         ct.Stepped_Copay__c=true;       
         insert ct;
         
         Drug_Specific_Stepped_Copay__c sc=new Drug_Specific_Stepped_Copay__c();     
         sc.Drug_Specific_Copay_ID__c=ct.id;
         sc.Number_of_Steps__c='1';        
         insert sc;
         sc.Number_of_Steps__c='2';
         update sc;  
        
    }
    
    //Test method for the custom history tracking  triggers
    static testmethod void testDrugCoverageAfterTriggers(){
         CRD__c testCrd=new CRD__c();
         testCrd.crd_automated__c =True;
         testCrd.LastSent__c=system.today();
         insert testCrd;
         Drug_Coverage__c dc=new Drug_Coverage__c();
         dc.CRD_ID__c=testCrd.id;
         dc.Do_you_have_Choose_Generic__c='no';
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Coverage__c' and developername='Mail'];
         dc.recordTypeid=rt.id;
          insert dc;
          
         rt=[select id from RecordType where SobjectType='Drug_Coverage__c' and developername='Retail'];
         dc.Do_you_have_Choose_Generic__c='no';
         dc.recordTypeid=rt.id;
         dc.Do_you_have_Specialty__c ='Yes';
         dc.Aetna_Specialty_Care_Rx__c='Does not Apply (Insured/not state filed)';
         dc.Speciality_Drug_List__c = null;
         dc.Max_Specialty_Day_Supply__c = null;
         dc.Force_to_Specialty__c='No';
         update dc;
         
    }
    
    static testmethod void testcloneRxCheckAfterTriggers(){
         CRD__c testCrd=new CRD__c();
         testCrd.crd_automated__c =True;
         testCrd.LastSent__c=system.today();
         insert testCrd;
         RxCheck_Junction__c dc= new RxCheck_Junction__c();
        // dc.RxCheck_Junction__c=testCrd.id;
        // dc.Do_you_have_Choose_Generic__c='no';
         //Recordtype rt=[select id from RecordType where SobjectType='Drug_Coverage__c' and developername='Mail'];
         //dc.recordTypeid=rt.id;
         // insert dc;
          
          }
    //Test method for the custom history tracking  triggers 
    static testmethod void testDawSpecificSteppedCopayAfterTriggers(){
         CRD__c testCrd=new CRD__c();
         testCrd.crd_automated__c =True;
         testCrd.LastSent__c=system.today();
         insert testCrd;
         
         DAW_Specific_Copay__c ct=new DAW_Specific_Copay__c();
         ct.CRD_ID__c=testCrd.id;
         Recordtype rt=[select id from RecordType where SobjectType='DAW_Specific_Copay__c' and developername='Mail'];              
         ct.Stepped__c=true;         
         insert ct;
         
         
        DAW_Specific_Stepped_Copay__c sc=new DAW_Specific_Stepped_Copay__c();       
        
        sc.DAW_Specific_Copay_ID__c=ct.id;
        sc.Beginning_Range__c=10;
        sc.End_Range__c=12;
        sc.Copay_Calculation__c='test';
        sc.Minimum_Dollar__c=10;
        sc.Maximum_Dollar__c=11;
        
        insert sc;
        sc.Dollar_Amount__c=11;
        update sc;
        Recordtype retailRt=[select id from RecordType where SobjectType='DAW_Specific_Copay__c' and developername='Mail'];
        ct.RecordTypeId=retailRt.id;
        ct.Stepped__c=false;
        update ct;  
        vfp_cloneCRD cloneCRD = new vfp_cloneCRD();
        cloneCRD.cloneDawCopay(testCRd.id);
        
        
    }
    
    //Test method for the custom history tracking  triggers
    static testmethod void testCrdPriorAuthAfterTriggers(){
          CRD__c testCrd=new CRD__c();
          testCrd.crd_automated__c =True;
          testCrd.LastSent__c=system.today();
          insert testCrd;
          
          Drug_List__c dl =new Drug_List__c();
          dl.Standard__c=true;
          dl.Inactive__c=false;       
          Recordtype rt=[select id from RecordType where SobjectType='Drug_List__c' and name='Prior Authorization' limit 1];                          
          dl.recordTypeId=rt.id;
          dl.Description__c='tyest';
          dl.Clinical_Edit_Code__c='1';            
          insert dl;

          Drug_List__c dl2 =new Drug_List__c();
          dl2.Standard__c=true;
          dl2.Inactive__c=false;          
          Recordtype rt2=[select id from RecordType where SobjectType='Drug_List__c' and name='Prior Authorization' limit 1];                         
          dl2.recordTypeId=rt2.id;
          dl2.Description__c='tyest';
          dl2.Clinical_Edit_Code__c='1';            
          insert dl2;
          
          
          CRD_PriorAuth_Junction__c paJunction=new CRD_PriorAuth_Junction__c();     
          paJunction.CRD_ID__c=testCrd.id;
          paJunction.Precert_Class__c=dl.id;
          insert paJunction;
   
          paJunction.Precert_Class__c=dl2.id;
          update paJunction;
          
                  vfp_clonecrd clone = new vfp_cloneCRD();
                  clone.clonePOStepTherepyJunction(testCRD.id);
          delete paJunction;
       
         
    }
    
     //Test method for the custom history tracking  triggers
    static testmethod void testCrdQlAfterTriggers(){
          CRD__c testCrd=new CRD__c();
          testCrd.crd_automated__c =True;
          testCrd.LastSent__c=system.today();
          insert testCrd;
          
          Drug_List__c dl =new Drug_List__c();
          dl.Standard__c=true;
          dl.Inactive__c=false;       
          Recordtype rt=[select id from RecordType where SobjectType='Drug_List__c' and name='Quantity Limit' limit 1];                       
          dl.recordTypeId=rt.id;
          dl.Description__c='tyest';
          dl.Clinical_Edit_Code__c='1';            
          insert dl;

          Drug_List__c dl2 =new Drug_List__c();
          dl2.Standard__c=true;
          dl2.Inactive__c=false;          
          Recordtype rt2=[select id from RecordType where SobjectType='Drug_List__c' and name='Quantity Limit' limit 1];                          
          dl2.recordTypeId=rt2.id;
          dl2.Description__c='tyest';
          dl2.Clinical_Edit_Code__c='1';            
          insert dl2;
          
          
          CRD_Quantity_Limit_Junction__c qlJunction=new CRD_Quantity_Limit_Junction__c();       
          qlJunction.CRD_ID__c=testCrd.id;
          qlJunction.QL_Class__c=dl.id;
          insert qlJunction;
   
          qlJunction.QL_Class__c=dl2.id;
          update qlJunction;
          
                  vfp_clonecrd clone = new vfp_cloneCRD();
                  clone.cloneQlStepTherepyJunction(testCRD.id);
          
          delete qlJunction;       
         
    }
    
     //Test method for the custom history tracking  triggers
    static testmethod void testCrdStepTherepyAfterTriggers(){
          CRD__c testCrd=new CRD__c();
          testCrd.crd_automated__c =True;
          testCrd.LastSent__c=system.today();
          insert testCrd;
          
          Drug_List__c dl =new Drug_List__c();
          dl.Standard__c=true;
          dl.Inactive__c=false;       
          Recordtype rt=[select id from RecordType where SobjectType='Drug_List__c' and name='Step Therapy' limit 1];                         
          dl.recordTypeId=rt.id;
          dl.Description__c='tyest';
          dl.Clinical_Edit_Code__c='1';            
          insert dl;

          Drug_List__c dl2 =new Drug_List__c();
          dl2.Standard__c=true;
          dl2.Inactive__c=false;          
          Recordtype rt2=[select id from RecordType where SobjectType='Drug_List__c' and name='Step Therapy' limit 1];                        
          dl2.recordTypeId=rt2.id;
          dl2.Description__c='tyest';
          dl2.Clinical_Edit_Code__c='1';            
          insert dl2;
          
          
          CRD_Step_Therapy_Junction__c stJunction=new CRD_Step_Therapy_Junction__c();       
          stJunction.CRD_ID__c=testCrd.id;
          stJunction.Step_Therapy_DrugList_Class__c=dl.id;
          insert stJunction;
          
   
          stJunction.Step_Therapy_DrugList_Class__c=dl2.id;
          update stJunction;
          
          
          delete stJunction;       
         
    }
    
     //Test method for the custom history tracking  triggers for Exception
    static testmethod void testExceptionAfterTriggers(){
            GC_UtilityClassTestData  testdata = new GC_UtilityClassTestData();
            Max_Pay__c testmaxpay1 = testdata.createMaxPay();
            insert testmaxpay1;
            
            Max_Pay__c testmaxpay2 = testdata.createMaxPay();
            insert testmaxpay2;
            
            Exception__c testexcep = testdata.createexception(testmaxpay1.id);  
            insert testexcep;
            
            testexcep.Max_Pay_c__c = testmaxpay2.id;
            update testexcep;
        }   
    static testmethod void testDCDrugListAfterTriggers(){ 
         
         CRD__c testCrd=new CRD__c();
         testCrd.crd_automated__c =True;
         testCrd.LastSent__c=system.today();
         insert testCrd;
         Drug_Coverage__c dc=new Drug_Coverage__c();
         dc.CRD_ID__c=testCrd.id;
         dc.Do_you_have_Choose_Generic__c='test';
         Recordtype dcrt=[select id from RecordType where SobjectType='Drug_Coverage__c' and developername='Mail'];
         dc.recordTypeid=dcrt.id;
         insert dc;

         Drug_List__c dl =new Drug_List__c();
         dl.Standard__c=true;
         dl.Inactive__c=false;       
         Recordtype rt=[select id from RecordType where SobjectType='Drug_List__c' and name='Prior Authorization' limit 1];                          
         dl.recordTypeId=rt.id;
         dl.Description__c='tyest';
         dl.Clinical_Edit_Code__c='1';            
         insert dl;
         DC_Drug_List_Group__c dcdl=new DC_Drug_List_Group__c();
         dcdl.Drug_List__c=dl.id;
         dcdl.Drug_Class_Name__c='test class';
         dcdl.Inclusion_Exclusion__c='yes';
         dcdl.Related_Drug_Coverage__c=dc.id;
         insert dcdl;
         dcdl.Inclusion_Exclusion__c='No';
         update dcdl;
         delete dcdl;
    }
     static testmethod void testSteppedOverTimeAfterTriggers(){ 
         Drug_List__c dl =new Drug_List__c();
          dl.Standard__c=true;
          dl.Inactive__c=false;       
          Recordtype rt=[select id from RecordType where SobjectType='Drug_List__c' and name='Prior Authorization' limit 1];                          
          dl.recordTypeId=rt.id;
          dl.Description__c='tyest';
          dl.Clinical_Edit_Code__c='1';            
          insert dl;
          
          Drug_List_Criteria__c druglst=new Drug_List_Criteria__c();
          druglst.Effective__c=System.today();
          druglst.Drug_List__c=dl.id;
          druglst.Term__c=System.today()+7;
          Recordtype dlcrt=[select id from RecordType where SobjectType='Drug_List_Criteria__c' and name='Prior Authorization'];
          druglst.recordTypeid=dlcrt.id;
          insert druglst;
         
          Stepped_Over_Time__c steptym=new Stepped_Over_Time__c();
          steptym.Step_Type__c='yes';
          steptym.Related_Drug_List_Criteria__c=druglst.id;
          insert steptym;
          steptym.Step_Type__c='No';
          update steptym;
     } 
}