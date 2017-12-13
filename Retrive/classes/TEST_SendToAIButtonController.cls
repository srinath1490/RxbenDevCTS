/*Purpose: Apex Test Class for VFP_SendToAIButtonController.
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Anuj                 10/24/2011       Apex Test Class for VFP_SendToAIButtonController.
======================================================================== 
*/
@isTest
private class TEST_SendToAIButtonController
{
    static testmethod void testSendToAIButtonController()
    {
        GC_UtilityClassTestData testdata=new GC_UtilityClassTestData();
      /* CRD_Pricing__c  crdPricing =testdata.createcrdPricing();--> commented by Nitish request No 4882         
        insert crdPricing;
        */
        
        CRD__c testCrd=new CRD__c();
        testCrd.crd_automated__c=True;
        //commented by Nitish request No 4882         
        //testCrd.CRD_Pricing__c = crdPricing.Id;
        insert testCrd;
        
        
       /* Copay_Tier__c newcopay=new Copay_Tier__c();
        newcopay.CRD__c=testCrd.Id;
        insert newcopay;
        
        Drug_Specific_Copay__c newDrugCopay=new Drug_Specific_Copay__c();
        newDrugCopay.CRD_ID__c=testCrd.Id;
        insert newDrugCopay;
        
        Accumulations__c newAccum=new Accumulations__c();
        newAccum.CRD_ID__c=testCrd.Id;
        insert newAccum;*/


         List<Schema.RecordTypeInfo> DrugListRtInfo = Drug_List__c.sObjectType.getDescribe().getRecordTypeInfos();
         Id DrugListid;
         for(Schema.Recordtypeinfo thisInfo : DrugListRtInfo ){
            if(thisInfo.Name == 'Drug List'){
                DrugListid= thisInfo.getRecordTypeId();
            }
        }
        Drug_List__c druglist=testdata.createDrugList();
         druglist.RecordTypeId =DrugListid;
         insert druglist;
         
         Drug_Group__c druggroup=testdata.createDrugGroup();
         insert druggroup;
         
        Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Retail'];
        Drug_Specific_Copay__c drug = testdata.createDrugCopay(testCrd.Id,druggroup.Id,druglist.Id,rt.Id);
            insert drug;
        
        
        /* Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
         Recordtype rt=[select id from RecordType where SobjectType='Drug_Specific_Copay__c' and developername='Retail'];
         drug.recordTypeId=rt.Id;
         drug.CRD_ID__c=testCrd.Id;
         drug.Drug_Group__c=druggroup.Id;
         drug.Drug_List__c=druglist.Id;
         drug.Stepped_Copay__c=true;
         
         
         Drug_Specific_Stepped_Copay__c drugsteppedcopay=new Drug_Specific_Stepped_Copay__c();
         //drugsteppedcopay.CRD_ID__c=testCrd.Id;
         drugsteppedcopay.Drug_Specific_Copay_ID__c =drug.Id;
         drugsteppedcopay.Dollar_Amount__c=100;
         drugsteppedcopay.Number_of_Steps__c='1';
         drugsteppedcopay.Drug_Specific_Copay_ID__c=drug.Id;
         drugsteppedcopay.Beginning_Range__c=1;
         drugsteppedcopay.End_Range__c=2;
         drugsteppedcopay.Percent__c=100;
         drugsteppedcopay.Copay_Calculation__c='1. Lower of the Copay or precentage';
         insert drugsteppedcopay;*/

         Drug_Specific_Stepped_Copay__c drugsteppedcopay = testdata.createDrugSteppedCopay(drug.Id);
         insert drugsteppedcopay;
         
         Copay_Tier__c mailTier = testdata.createCopayTier(testCrd.id);
         insert mailTier;
        // mailTier.CRD__c=testCrd.id;  
        //  mailTier.Stepped_Copay__c=true;
         //mailTier.recordtypeId =drug.recordTypeId;      
         
         
          SteppedCopay__c steppedCopay=new SteppedCopay__c(); 
         steppedCopay.Copay_Tier__c=mailTier.id;
         steppedCopay.Min_Range__c=10;
         steppedCopay.Max_Range__c=10;         
         steppedCopay.Dollar_Amount__c=10;
         insert steppedCopay;
         
        Accumulations__c newAccum=new Accumulations__c();
        newAccum.CRD_ID__c=testCrd.Id;
        insert newAccum;
        
        AccumulationSpecificDrug__c newAccumDrug=new AccumulationSpecificDrug__c();
        newAccumDrug.Drug_List__c=druglist.id;
        newAccumDrug.Drug_Group__c=druggroup.id;                 
       // newAccumDrug.No_of_Family_Members_to_Meet_Maximum__c=null;
        newAccumDrug.Accumulations_ID__c=newAccum.Id;
        insert newAccumDrug;
        
        Accumulation_Change_Copay__c ACC = new Accumulation_Change_Copay__c();
        ACC.Accumulation_ID__c = newAccum.id;
        insert ACC;
        
        Accumulation_Change_Copay_Stepped__c accs = new Accumulation_Change_Copay_Stepped__c();
        accs.Accumulation_Change_Copay_ID__c = ACC.id;
        insert accs;
        
        DAW_Specific_Copay__c dsc = new DAW_Specific_Copay__c();
        dsc.CRD_ID__c = testCrd.id;
        insert dsc;
        
        DAW_Specific_Stepped_Copay__c dssc = new DAW_Specific_Stepped_Copay__c();
        dssc.DAW_Specific_Copay_ID__c = dsc.id;
        insert dssc;
        
        Waiver_Of_Deductible__c wod = new Waiver_Of_Deductible__c();
        wod.CRD_ID__c = testCrd.id;
        insert wod;
        
        CRD_NPL_Junction__c cnj = new CRD_NPL_Junction__c();
        cnj.CRD_ID__c = testCrd.id;
        insert cnj ;
        
        CRD_PriorAuth_Junction__c cpj = new CRD_PriorAuth_Junction__c();
        cpj.CRD_ID__c = testCrd.id;
        insert cpj;
        
        CRD_Quantity_Limit_Junction__c cqlj = new CRD_Quantity_Limit_Junction__c();
        cqlj.CRD_ID__c = testCrd.id; 
        insert cqlj;
        
        AHA_Junction__c AHAJunc = new AHA_Junction__c();
        AHAJunc.CRD_ID__c = testCrd.id;
        insert AHAJunc;
            
        
        list <RecordType> rtlist= new list<RecordType>([Select Id,Name from RecordType where sobjecttype='Drug_Coverage__c']);
        Drug_Coverage__c drugCoverateItem=new Drug_Coverage__c();
        drugCoverateItem.CRD_ID__c = testCrd.id;
        drugCoverateItem.RecordTypeId=rtlist.get(0).id;
        drugCoverateItem.Do_you_have_Choose_Generic__c ='Yes';
        drugCoverateItem.Choose_Generic_Copay_Diff_Exclusion__c='No';
        insert drugCoverateItem;
        
          Clinical_Program__c testPrograme =testdata.createClinicalPrograme('RxCheck');
          testPrograme.RxCheck_Effective_Date__c = system.today()-7;
          testPrograme.RxCheck_Termination_Date__c =system.today()+7;
          insert  testPrograme; 
        
        RxCheck_Junction__c newRx=new RxCheck_Junction__c();
        newRx.CRD__c=testCrd.Id;
        insert newRx;
        
        Save_A_Copay_Junction__c saveAcopay =new Save_A_Copay_Junction__c();
        saveAcopay.CRD_ID__c=testCrd.Id;
        insert  saveAcopay;
        
        PSP_Junction__c newPsp=new PSP_Junction__c();
        newPsp.CRD_ID__c=testCrd.Id;
        insert newPsp;
        
        CRD_Step_Therapy_Junction__c newStepTherapy = new CRD_Step_Therapy_Junction__c();
        newStepTherapy.CRD_ID__c=testCrd.Id;
        insert newStepTherapy;
        
        Network_Junction__c network =new Network_Junction__c();
        network.CRD_ID__c=testCrd.Id;
        insert network;
        
        VFP_SendToAIButtonController controller=new VFP_SendToAIButtonController();
        controller.sendToAIString(testCrd.Id);
        controller.SendToAI(testCrd.Id);
    }
}