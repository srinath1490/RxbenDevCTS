/*Purpose: Global Class to create test data
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                    DETAIL                                 
   1.0 -    ANUJ               9/28/2011      Global Class to create test data which can be used in creating dummy records for various test scenarios
   1.1 -    ANUJ              18/01/2012       New methods and new fmandatory fields
   1.2 -    Bhaskar           04/07/2016      New method createRestricted_NDC_List to create record of Restricted_NDC_List__c
											  and createPFR to create PFR for TEST_CB_BuildStep.
======================================================================== */

Public Class GC_UtilityClassTestData{
   
    public static boolean isTestCall=false;
    Public Clinical_Program__c createClinicalPrograme(string recordType){
       List<Schema.RecordTypeInfo> RtInfo =  Clinical_Program__c.sObjectType.getDescribe().getRecordTypeInfos();
       Id recordTypeId ;       
       for(Schema.Recordtypeinfo thisInfo : RtInfo){                           
            if(thisInfo.Name == recordType){                                   
                recordTypeId = thisInfo.getRecordTypeId();                
            } 
        }    
        Clinical_Program__c testPrograme = new Clinical_Program__c();
            testPrograme.RecordTypeId = recordTypeId;
            testPrograme.Clinical_Programs_Name__c ='test';
            testPrograme.LastSent__c = system.now();
            testPrograme.Description__c = 'test';
        return testPrograme; 
    }
    
    Public Clinical_Program_Group__c creteProgrameGroup(string recordType,string funding){       
        List<Schema.RecordTypeInfo> RtInfo =  Clinical_Program_Group__c.sObjectType.getDescribe().getRecordTypeInfos();
        Id recordTypeId ;    
        for(Schema.Recordtypeinfo thisInfo : RtInfo){                           
            if(thisInfo.Name == recordType){                                   
                recordTypeId = thisInfo.getRecordTypeId();                
            } 
         }
         Clinical_Program_Group__c cpgroup = new Clinical_Program_Group__c();         
             cpgroup.Clinical_Program_Group_Name__c = 'test';
             cpgroup.Clinical_Program_Group_Description__c = 'description';
             cpgroup.RecordTypeId =recordTypeId;
             cpgroup.Funding__c = funding;
             cpgroup.LastSent__c = system.now();
             cpgroup.Effective_Date__c = system.today();
             cpgroup.Termination_Date__c = system.today()+7;
         return cpgroup;
    }
    
    Public Drug_Group__c createDrugGroup(){
       Drug_Group__c tempDrugGroup = new  Drug_Group__c();
           tempDrugGroup.Drug_Group_Name__c= 'Test';
           tempDrugGroup.Description__c = 'description';
           tempDrugGroup.Standard__c = true;
           tempDrugGroup.LastSent__c = system.now();
           tempDrugGroup.Effective_Date__c = system.today();
           tempDrugGroup.Termination_Date__c = system.today()+7;
      return tempDrugGroup ;
    }
        
    Public Drug_List__c createDrugList(){
       Drug_List__c tempDrugList = new  Drug_List__c();
           tempDrugList.Drug_List_Name__c = 'Test';
           tempDrugList.Description__c = 'description';
           tempDrugList.Special_Use__c = 'Save-A-Copay';
           tempDrugList.Standard__c = true;
           tempDrugList.LastSent__c = system.now();
           tempDrugList.Clinical_Edit_Code__c='1';
        return tempDrugList;
    }
    
    Public Drug_List_Description_Crosswalk__c  createDrugListDescCrosswalk(){
        Drug_List_Description_Crosswalk__c tempDrugListDCW = new  Drug_List_Description_Crosswalk__c();
        tempDrugListDCW.Description_Of_Drug_List__c='description';
        tempDrugListDCW.Drug_Code_Value__c='GPI';
        tempDrugListDCW.Drug_Type_Code__c='AHFS Therapeutic Class Code';
        return tempDrugListDCW;
    }
    
    Public Step_Therapy_PreRequisite_Drug__c preRequisite(){
        Step_Therapy_PreRequisite_Drug__c tempPreRequisite = new Step_Therapy_PreRequisite_Drug__c();
            tempPreRequisite.GPI__c = '12345678901234';
            tempPreRequisite.NDC__c = '12345678998';
            tempPreRequisite.Effective_Date__c= system.today();
            tempPreRequisite.Termination_Date__c = system.today()+7;
            tempPreRequisite.Minimum_Day_Supply__c = 7;
            tempPreRequisite.Lookback__c =5;
            tempPreRequisite.No_of_Distinct_Drugs__c = 5;
        return tempPreRequisite;
    }
    
    Public Option_Code__c newoptionCode(){
        Option_Code__c optionCode = new Option_Code__c();
            optionCode.Option_Code_Name__c='test';        
            optionCode.Option_Code_Description__c ='test';
            optionCode.Primary_Secondary_Indicator__c ='test';
            optionCode.Effective_Date__c = system.today();
            optionCode.Termination_Date__c = system.today() +7;
        return optionCode;      
    }
    
    Public Formulary__c newFormulary(){
         Formulary__c formulary = new Formulary__c();
             formulary.Formulary_Name__c = 'test';
             formulary.Formulary_Description__c ='test';
             formulary.Effective_Date__c = system.today();
             formulary.Termination_Date__c = system.today()+7;
             formulary.Standard__c=true;
             formulary.LastSent__c = system.now();
         return formulary ;
     }
     
     Public Formulary_List__c newFormularyList(Id optioncode){
         Formulary_List__c formularyList = new Formulary_List__c();
             formularyList.Formulary_List_Name__c ='test';
             formularyList.Formulary_List_Description__c ='description';
             formularyList.OptionCode__c = optionCode;
             formularyList.Effective_Date__c = system.today();
             formularyList.Termination_Date__c = system.today()+7;
             formularyList.LastSent__c = system.now();
         return formularyList;
     }
     
     Public Formulary_List_Entry__c newFormularyListEntry(Integer i,Id formularyList){
        Formulary_List_Entry__c formularyLitEntry = new Formulary_List_Entry__c();
            formularyLitEntry.Formulary_List__c = formularyList;
            formularyLitEntry.Effective_Date__c = system.today() - i;
            formularyLitEntry.Termination_Date__c = system.today() + i;
        return formularyLitEntry; 
    } 
     
    Public Formulary_List_Entry__c newFormularyListEntry(Integer i){
        Formulary_List_Entry__c formularyLitEntry = new Formulary_List_Entry__c();
            formularyLitEntry.Effective_Date__c = system.today() - i;
            formularyLitEntry.Termination_Date__c = system.today() + i;
        return formularyLitEntry; 
    }
    
    Public Drug_List_Criteria__c newDrugListcriteria(Id drugList,Integer i){
        Drug_List_Criteria__c testDrugList = new Drug_List_Criteria__c();
            testDrugList.Drug_List__c =drugList;
            testDrugList.Term__c=system.today()-i;
            testDrugList.Effective__c =system.today()+i;
        return testDrugList;
    }
    
    Public Drug__c createDrug(){
        Drug__c testDrug = new Drug__c();
            testDrug.Labeler_Code__c = '12';
            testDrug.NDC__c = '12345678901';
            testDrug.AHFS_Therapeutic_Class_Code__c = '12345';
            testDrug.Product_Name__c ='12345678901';
            testDrug.GPI__c ='12345678901234';
            testDrug.GPI_Generic_Name__c='test';
            testDrug.Manufacturer_Labeler_Name__c='test';
            testDrug.Package_Size__c ='12345678'; 
            testDrug.Package_Description__c='test';
            testDrug.Label_Name__c ='test';
        return testDrug;
    }
    Public Forms__c CriteriaForm(){
        Forms__c testform = new Forms__c(); 
            testform.Effective_Date__c = system.today();  
            testform.Termination_Date__c = system.today()+ 7;
            testform.LastSent__c = system.now();
        return testform;
    }
    Public M25VAL__c M25VAL(){
        M25VAL__c testM25VAL = new M25VAL__c();
            testM25VAL.Value_Description__c ='test';
        return testM25VAL;
    }
       Public TCRF_File__c TCRF(){
        TCRF_File__c testTCRF = new TCRF_File__c();
        return testTCRF;
    }
    Public Object_List__c createObjectList(){
        Object_List__c objectListId=new Object_List__c();
            objectListId.Object_List_Name__c='test';
            objectListId.Object_List_Description__c='test';
            objectListId.Effective_Date__c = system.today();
            objectListId.Termination_Date__c = system.today() +7;   
            objectListId.LastSent__c= system.now();
        return objectListId;
    }
    Public Object_List_Item__c createObjectListItem(Id parentId){
        Object_List_Item__c item = new Object_List_Item__c();
            item.Object_List__c = parentId;
        return item;
    }
    Public Generic_Code_Conversion__c createGenericCode() {
        Generic_Code_Conversion__c  gcc = new   Generic_Code_Conversion__c();
            gcc.Generic_Code_Conversion_Description__c = 'descroption';
            gcc.Generic_Code_Conversion_Name__c ='test';
            gcc.Effective_Date__c = system.today();
            gcc.Termination_Date__c = system.today() +7;    
            gcc.LastSent__c = system.now();
        return gcc;     
    }
    
    Public Generic_Code_Conversion_Entry__c createGenericCodeEntry(Id parentid) {
       Generic_Code_Conversion_Entry__c    gcce = new  Generic_Code_Conversion_Entry__c();
            gcce.Generic_Code_Conversion__c = parentid;
       return gcce;    
    } 
    //commented by Nitish request No 4882           
   /* Public  CRD_Pricing__c createCRDPricing (){
        CRD_Pricing__c pricing = new CRD_Pricing__c();
            pricing.Lastsent__c =system.now();
        return  pricing;
    }
    */
    
    Public Codes_List__c createCodeList(){
        Codes_List__c codeList = new Codes_List__c();
            codeList.LastSent__c=system.now();  
            codeList.Effective_Date__c = system.today();
            codeList.Termination_Date__c = system.today()+7;
            codeList.Code_List_Name__c ='test';
            codeList.Code_List_Description__c ='test description';
        return codeList;
    }
    
    Public Codes__c createCode(Id codeListId){
        Codes__c code = new Codes__c(); 
            code.Related_Code_List__c = codeListId;
        return code;
    }
    
    Public Max_Pay__c createMaxPay(){
        Max_Pay__c maxpay = new Max_Pay__c();
            maxpay.Begin_Date__c = system.today();
            maxpay.End_Date__c = system.today() +7; 
            maxpay.LastSent__c = system.now();
        return maxpay;
    }
    
    Public Exception__c createexception(Id maxpayId){
        Exception__c excep = new Exception__c();    
            excep.Max_Pay_c__c = maxpayId;
        return excep;
    }
    
    Public  Denial_Letter_Junction__c createdenialLetter(Id formId,Id druListCriteria){
        Denial_Letter_Junction__c  letter = new Denial_Letter_Junction__c();
            letter.Denial_Letter_ID__c= formId;
            letter.Drug_List_Criteria_ID__c = druListCriteria;
        return letter;
        
    }
    
    Public Clinical_Program_Criteria__c createProgrameCriteria(Id programeId){
        Clinical_Program_Criteria__c criteria = new Clinical_Program_Criteria__c();
            criteria.Clinical_Program__c = programeId;
            criteria.Effective_Date__c = system.today();
            criteria.Termination_Date__c=system.today() + 7;
        return criteria;
    }
    
    Public Drug_List_Junction__c createDrugListJunction(id groupId,Id listId){
         Drug_List_Junction__c junction = new Drug_List_Junction__c();
             junction.Parent_Drug_Group__c =groupId;
             junction.Drug_List__c = listId;
         return junction; 
     }
     
    Public Max_Pay_Limitation__c createmaxPayLimitation(Id parentid){
        Max_Pay_Limitation__c limitation = new Max_Pay_Limitation__c();
            Limitation.Max_Pay__c= parentid;
        return limitation; 
    }
    
    Public Conflict_Code_List__c createconflictCodeList(){
       Conflict_Code_List__c codelist = new Conflict_Code_List__c();
       return codelist;
    }
    
    Public Conflict_Codes__c createconflictCode(Id listId){
       Conflict_Codes__c conflictcode = new Conflict_Codes__c();
           conflictcode.Related_Conflict_Code_List__c = listId;
       return conflictcode;
    }
    
     Public Clinical_Program_Junction__c createClinicalprgmJunction(id prgmId,id groupId){
        Clinical_Program_Junction__c clinicalPrgmJunc = new Clinical_Program_Junction__c();
            clinicalPrgmJunc.Clinical_Program__c = prgmId;
            clinicalPrgmJunc.Clinical_Program_Group__c = groupId;
        return clinicalPrgmJunc;
    }
    
     Public Stepped_Over_Time__c createstepQuantityOverTym(Id listId){
        Stepped_Over_Time__c quantityOverTime = new Stepped_Over_Time__c();
            quantityOverTime.Related_Drug_List_Criteria__c = Listid;
            quantityOverTime.Step_Type__c = 'Quantity Limits';
            quantityOverTime.Percent_Minimum_Use__c = 12;
            quantityOverTime.Beginning_Range__c = 12345;
            quantityOverTime.End_Range__c = 12345;
            quantityOverTime.Time_Period__c = 'Year(s)';
            quantityOverTime.Time_Value__c = 12345;
        return quantityOverTime;
     } 
     
      Public Formulary_Junction__c createFormularyJunction(id listId,id formId){
        Formulary_Junction__c formularyJunc = new Formulary_Junction__c();
            formularyJunc.Formulary_List__c = listId;
            formularyJunc.Formulary__c = formId;
            formularyJunc.Priority__c = 12;
            formularyJunc.Termination_Date__c = system.today()+7;
            formularyJunc.Effective_Date__c = system.today();
        return formularyJunc;
    }
    
    Public Refill_Too_Soon__c createRefillTooSoon(){
        Refill_Too_Soon__c refillTooSoon = new Refill_Too_Soon__c();      
           refillToosoon.Refill_too_Soon_Name__c = 'Rashi';
           refillToosoon.Refill_too_Soon_Description__c = 'Rashi';
        return refillTooSoon;
    }
    
    Public Refill_Too_Soon_Criteria__c createRefillSoonCriteria(Id Parentid){
        Refill_Too_Soon_Criteria__c refillSoonCri = new Refill_Too_Soon_Criteria__c();
            refillSoonCri.Related_Refill_Too_Soon__c = Parentid;  
       return refillSoonCri;
    }

    Public Drug_Specific_Copay__c createDrugCopay(id crdId,Id groupId,Id listId,Id rtId){
        Drug_Specific_Copay__c drug=new Drug_Specific_Copay__c();
             drug.CRD_ID__c=crdId;
             drug.Drug_Group__c= groupId;
             drug.Drug_List__c= listId;
             drug.Stepped_Copay__c=true;
             drug.recordTypeId= rtId;   
         return drug;
    }
    
    Public Drug_Specific_Stepped_Copay__c createDrugSteppedCopay(Id drugId){
        Drug_Specific_Stepped_Copay__c drugsteppedcopay = new Drug_Specific_Stepped_Copay__c();
             drugsteppedcopay.Drug_Specific_Copay_ID__c =drugId;
             drugsteppedcopay.Dollar_Amount__c=100;
             drugsteppedcopay.Number_of_Steps__c='1';
             drugsteppedcopay.Beginning_Range__c=1;
             drugsteppedcopay.End_Range__c=2;
             drugsteppedcopay.Percent__c=100;
             drugsteppedcopay.Copay_Calculation__c='1. Lower of the Copay or precentage';
        return drugsteppedcopay;
    }
    Public Copay_Tier__c createCopayTier(Id crdId){
        Copay_Tier__c mailTier = new Copay_Tier__c();
              mailTier.CRD__c=crdId;  
              mailTier.Stepped_Copay__c=true;
        return  mailTier; 
    }
    //Bhaskar :Added to insert Related_Drug_List_Criteria__c record
    public Restricted_NDC_List__c createRestricted_NDC_List(id stpd,id dlc)
    {
        Restricted_NDC_List__c RNDC=new Restricted_NDC_List__c();
        RNDC.Related_Drug_List_Criteria__c=dlc;
             RNDC.Effective_Date__c=system.today();
             RNDC.Termination_Date__c=system.today()+1;
             RNDC.MS_Code_M__c=true;
             RNDC.MS_Code_N__c=true;
             RNDC.MS_Code_O__c=true;
             RNDC.MS_Code_Y__c=true;
             RNDC.OTC__c=true;
             RNDC.Rx__c=true;
             RNDC.Related_Step_Therapy_Pre_Requisite_Drug__c=stpd;
        return RNDC;
    }
    public Pers_Full_Report__c createPFR(integer PROV_NUM,integer LV_NO,Id CRD_Build_Order)
    {
        Pers_Full_Report__c PFR=new Pers_Full_Report__c();
        PFR.PERStimestamp__c = DateTime.newInstance(System.today(),Time.newInstance(0,0,0,0));
        PFR.WS_PSUID__c='83712271';
        PFR.WS_CNTRL_NO__c = 77;
        PFR.WS_PLSM_CD__c = 'JR';
        PFR.WS_NEW_INFRC_EFF_DT__c =System.today();
        PFR.WS_COB_CD__c = '02';
        PFR.WS_RISK_IND__c ='R';
        PFR.WS_PROV_NUM__c=PROV_NUM;
        PFR.WS_LV_NO__c=LV_NO;
        PFR.CRD_Build_Order__c=CRD_Build_Order;
        return PFR;
    }

}