/*Purpose: Apex Test Class for VFP_WaiverOfDeductible
========================================================================
 History                                                           
    -------                                                          
 VERSION     AUTHOR                 DATE                    DETAIL                                 
     1.0 -   Richa                 25/02/2015       Apex Test Class for VFP_WaiverOfDeductible
======================================================================== 
*/
@isTest (SeeAllData=true)
private class TEST_WaiverOfDeductible {
    
    public static id getDL(){
        id DLid;
        DLid = [Select id,Allowable_Actions__c from Drug_List__c where Allowable_Actions__c!=null LIMIT 1][0].id;
        return DLid;
    }
     
     public static id getDLwithoutAllowableAction(){
        id DLid;
        DLid = [Select id,Allowable_Actions__c  from Drug_List__c where Allowable_Actions__c= null LIMIT 1 ][0].id;
        return DLid;
    }
    
    public static id getDG(){
        id DGid;
        DGid = [Select id,Allowable_Actions__c from Drug_Group__c where Allowable_Actions__c!=null LIMIT 1 ][0].id;
        return DGid;
    }
    public static id getGMFGI(){
        id GMFGIid;
        GMFGIid = [Select id from GMF_Group_Identifier__c where Name='GGI-0002' LIMIT 1][0].id;
        return GMFGIid;
    }
    public static id getOption(){
        id Optionid;
        Option_Code__c oC=new Option_Code__c(Option_Code_Description__c='Health Exchange- Three Tier Closed Formulary', Effective_Date__c=system.today(), Termination_Date__c=system.today()+10, Primary_Secondary_Indicator__c='Primary', Option_Code_Name__c='SVL');
        insert oC;
        return oC.id;
    }
     
    public static id getformulary(){
        id Formularyid;
        Formulary__c oC=new Formulary__c(Option_Code__c=getOption(),formulary_name__c = 'Form1',GMF_Group_Identifier__c=getGMFGI(),Effective_Date__c = system.today(),Termination_Date__c = system.today() +1);
        insert oC;
        return oC.id;
    }
        
       
    static testmethod void myUnitTest2(){
    String dcMailRecordID;
    String dcRetailRecordID;
         for(RecordType RecType : [Select Id,Name,SobjectType From RecordType]){
         if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Mail'){
            dcMailRecordID =  RecType.ID;            
         }else if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Retail'){
            dcRetailRecordID = RecType.ID;
            }
        }
        Option_Code__c oc = new Option_Code__c();
        oc.Option_Code_Name__c = '3PRP';
        oc.Option_Code_Description__c = 'Open 3 tier Premier Plus';
        oc.Effective_Date__c = system.today();
        oc.Termination_Date__c = system.today() +1;
        insert oc;
        Formulary__c formulary = [select id,Formulary__c.GMF_Group_Identifier__r.Name,Formulary__c.Option_Code_Name__c,option_code__c,Option_Code__r.Name,formulary_name__c,GMF_Group_Identifier__c,Effective_Date__c,Termination_Date__c from Formulary__c where id=:getformulary()];  
        Waiver_Of_Deductible_Drug_Class__c woddc = new Waiver_Of_Deductible_Drug_Class__c();
        woddc.Drug_Class__c = '26 - FOR GENERIC DIABETIC DRUGS AND SUPPLIES AND FORMULARY BRAND DIABETIC DRUGS AND SUPPLIES.';
        insert woddc;

        Waiver_Of_Deductible_Drug_Class__c woddc2 = new Waiver_Of_Deductible_Drug_Class__c();
        woddc2.Drug_Class__c = '4 - FOR MAIL ORDER DRUGS';
        insert woddc2;
        
        CRD__c testCRD2 = new CRD__c();
        testCRD2.Insured_Type__c = 'Fully Insured';
        testCRD2.CRD_Automated__c = True;
        insert testCRD2;
        
        Drug_Coverage__c dCoverageMail = new Drug_Coverage__c();
        dCoverageMail.RecordTypeId = dcMailRecordID;
        dCoverageMail.CRD_ID__c = testCRD2.Id;
        dCoverageMail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageMail.Brand_Penalty_Type__c = Null;
        dCoverageMail.Brand_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Brand_Penalty_Percent__c = 13;
        dCoverageMail.Generic_Penalty_Type__c = Null;
        dCoverageMail.Generic_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Generic_Penalty_Percent__c = 13;
        dCoverageMail.Maintenance_Choice__c = 'Voluntary';
        dCoverageMail.No_of_fills_allowed_at_retail__c = 1;
        dCoverageMail.Mandatory_Mail_Order_Option__c = 'Not Applicable';
        insert dCoverageMail;
        
        Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
        dCoverageRetail.RecordTypeId = dcRetailRecordID;
        dCoverageRetail.CRD_ID__c = testCRD2.Id;
        dCoverageRetail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageRetail.Do_you_have_Specialty__c = 'No';
        dCoverageRetail.Aetna_Specialty_Care_Rx__c = Null;
        dCoverageRetail.Force_to_Specialty__c = 'No';
        dCoverageRetail.Secondary_Aetna_Specialty_Care_Rx__c ='Applies-Expanded List';
        dCoverageRetail.Secondary_of_Fills_before_Force_to_MOD__c = NULL;
        insert dCoverageRetail;
        
        Waiver_Of_Deductible__c wodSt = new Waiver_Of_Deductible__c();
        wodSt.crd_id__c = testCRD2.id;
        wodSt.Standard__c = true;
        wodSt.Drug_Class__c = '4 - FOR MAIL ORDER DRUGS';
        wodSt.Delivery_System__c = 'Retail';
        insert wodSt;
        
        Waiver_Of_Deductible__c wodSt2 = new Waiver_Of_Deductible__c();
        wodSt2.crd_id__c = testCRD2.id;
        wodSt2.Standard__c = true;
        wodSt2.Drug_Class__c = '4 - FOR MAIL ORDER DRUGS';
        wodSt2.Delivery_System__c = 'Retail';
        insert wodSt2;
        
        Waiver_Of_Deductible__c wod5 = new Waiver_Of_Deductible__c();
        wod5.crd_id__c = testCRD2.id;
        wod5.Standard__c = false;
        wod5.Delivery_System__c = 'Both';
        wod5.Drug_Group__c = getDG();
        wod5.Y__c = true;
        insert wod5;
        
       
        
        PageReference wodPage = Page.VF_WaiverOfDeductible;
        wodPage.getParameters().put('crdid',testCRD2.id);
        Test.setCurrentPage(wodPage);
        
        ApexPages.StandardController stCon2 = new ApexPages.standardController(testCRD2);
        VFP_WaiverOfDeductible wodController2 = new VFP_WaiverOfDeductible(stCon2);
        wodController2.nextbutton();
        wodController2.backbutton();
        wodController2.addStndrdDC();
        wodController2.addCustomDC();
        wodController2.deleteStndrdDC();
        wodController2.deleteCustomDC();
        wodController2.nextButton2();
        wodController2.backbutton2();
    }
    static testmethod void myUnitTest(){
    String dcMailRecordID;
    String dcRetailRecordID;
         for(RecordType RecType : [Select Id,Name,SobjectType From RecordType]){
         if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Mail'){
            dcMailRecordID =  RecType.ID;            
         }else if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Retail'){
            dcRetailRecordID = RecType.ID;
            }
        }
        Option_Code__c oc = new Option_Code__c();
        oc.Option_Code_Name__c = '3PRP';
        oc.Option_Code_Description__c = 'Open 3 tier Premier Plus';
        oc.Effective_Date__c = system.today();
        oc.Termination_Date__c = system.today() +1;
        insert oc;
        Formulary__c formulary = [select id,Formulary__c.GMF_Group_Identifier__r.Name,Formulary__c.Option_Code_Name__c,option_code__c,Option_Code__r.Name,formulary_name__c,GMF_Group_Identifier__c,Effective_Date__c,Termination_Date__c from Formulary__c where id=:getformulary()];  
        Waiver_Of_Deductible_Drug_Class__c woddc = new Waiver_Of_Deductible_Drug_Class__c();
        woddc.Drug_Class__c = '26 - FOR GENERIC DIABETIC DRUGS AND SUPPLIES AND FORMULARY BRAND DIABETIC DRUGS AND SUPPLIES.';
        woddc.Drug_List__c = getDL();
        woddc.Delivery_System__c = 'Retail';
        insert woddc;

        Waiver_Of_Deductible_Drug_Class__c woddc2 = new Waiver_Of_Deductible_Drug_Class__c();
        woddc2.Drug_Class__c = '25 - NONE FOR PHARMACY IN NETWORK AND GENERIC DRUGS FOR PHARMACY OUT OF NETWORK';
        woddc2.Drug_Group__c = getDG();
        woddc2.Delivery_System__c = 'Retail';
        insert woddc2;
        
        
        
        CRD__c testCRD2 = new CRD__c();
        testCRD2.Insured_Type__c = 'Fully Insured';
        testCRD2.CRD_Automated__c = True;
        insert testCRD2;
        
        Drug_Coverage__c dCoverageMail = new Drug_Coverage__c();
        dCoverageMail.RecordTypeId = dcMailRecordID;
        dCoverageMail.CRD_ID__c = testCRD2.Id;
        dCoverageMail.formulary__c = formulary.Id;
        dCoverageMail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageMail.Brand_Penalty_Type__c = Null;
        dCoverageMail.Brand_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Brand_Penalty_Percent__c = 13;
        dCoverageMail.Generic_Penalty_Type__c = Null;
        dCoverageMail.Generic_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Generic_Penalty_Percent__c = 13;
        dCoverageMail.Maintenance_Choice__c = 'Voluntary';
        dCoverageMail.No_of_fills_allowed_at_retail__c = 1;
        dCoverageMail.Mandatory_Mail_Order_Option__c = 'Not Applicable';
        dCoverageMail.Formulary__c=formulary.id;
        insert dCoverageMail;
        
        Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
        dCoverageRetail.RecordTypeId = dcRetailRecordID;
        dCoverageRetail.CRD_ID__c = testCRD2.Id;
        dCoverageMail.formulary__c = formulary.Id;
        dCoverageRetail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageRetail.Do_you_have_Specialty__c = 'No';
        dCoverageRetail.Aetna_Specialty_Care_Rx__c = Null;
        dCoverageRetail.Force_to_Specialty__c = 'No';
        dCoverageRetail.Secondary_Aetna_Specialty_Care_Rx__c ='Applies-Expanded List';
        dCoverageRetail.Secondary_of_Fills_before_Force_to_MOD__c = NULL;
        insert dCoverageRetail;
        
        Waiver_Of_Deductible__c wodSt = new Waiver_Of_Deductible__c();
        wodSt.crd_id__c = testCRD2.id;
        wodSt.Standard__c = true;
        wodSt.Drug_Class__c = '4 - FOR MAIL ORDER DRUGS';
        wodSt.Delivery_System__c = 'Retail';
        insert wodSt;
        
        Waiver_Of_Deductible__c wodSt2 = new Waiver_Of_Deductible__c();
        wodSt2.crd_id__c = testCRD2.id;
        wodSt2.Standard__c = true;
        wodSt2.Drug_Class__c = '4 - FOR MAIL ORDER DRUGS';
        wodSt2.Delivery_System__c = 'Retail';
        insert wodSt2;
        
        Waiver_Of_Deductible__c wod5 = new Waiver_Of_Deductible__c();
        wod5.crd_id__c = testCRD2.id;
        wod5.Standard__c = false;
        wod5.Delivery_System__c = 'Both';
        wod5.Drug_Group__c = getDG();
        wod5.Y__c = true;
        insert wod5;
        
        /*Waiver_Of_Deductible__c wod6 = new Waiver_Of_Deductible__c();
        wod6.crd_id__c = testCRD2.id;
        wod6.Standard__c = false;
        wod6.Delivery_System__c = 'Both';
        wod6.Drug_Group__c = getDG();
        wod6.Y__c = true;
        insert wod6;*/
        
        PageReference wodPage = Page.VF_WaiverOfDeductible;
        wodPage.getParameters().put('crdid',testCRD2.id);
        Test.setCurrentPage(wodPage);
        
        ApexPages.StandardController stCon2 = new ApexPages.standardController(testCRD2);
        VFP_WaiverOfDeductible wodController2 = new VFP_WaiverOfDeductible(stCon2);
        wodController2.nextbutton();
        wodController2.backbutton();
        wodController2.addStndrdDC();
        wodController2.addCustomDC();
        wodController2.deleteStndrdDC();
        wodController2.deleteCustomDC();
        wodController2.nextButton2();
        wodController2.backbutton2();
    }
    static testmethod void myUnitTest3(){
    String dcMailRecordID;
    String dcRetailRecordID;
         for(RecordType RecType : [Select Id,Name,SobjectType From RecordType]){
         if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Mail'){
            dcMailRecordID =  RecType.ID;            
         }else if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Retail'){
            dcRetailRecordID = RecType.ID;
            }
        }
        Option_Code__c oc = new Option_Code__c();
        oc.Option_Code_Name__c = '3PRP';
        oc.Option_Code_Description__c = 'Open 3 tier Premier Plus';
        oc.Effective_Date__c = system.today();
        oc.Termination_Date__c = system.today() +1;
        insert oc;
        Formulary__c formulary = [select id,Formulary__c.GMF_Group_Identifier__r.Name,Formulary__c.Option_Code_Name__c,option_code__c,Option_Code__r.Name,formulary_name__c,GMF_Group_Identifier__c,Effective_Date__c,Termination_Date__c from Formulary__c where id=:getformulary()];  
        Waiver_Of_Deductible_Drug_Class__c woddc = new Waiver_Of_Deductible_Drug_Class__c();
        woddc.Drug_Class__c = '26 - FOR GENERIC DIABETIC DRUGS AND SUPPLIES AND FORMULARY BRAND DIABETIC DRUGS AND SUPPLIES.';
        woddc.Drug_List__c = getDL();
        woddc.Delivery_System__c = 'Retail';
        insert woddc;

        Waiver_Of_Deductible_Drug_Class__c woddc2 = new Waiver_Of_Deductible_Drug_Class__c();
        woddc2.Drug_Class__c = '25 - NONE FOR PHARMACY IN NETWORK AND GENERIC DRUGS FOR PHARMACY OUT OF NETWORK';
        woddc2.Drug_Group__c = getDG();
        woddc2.Delivery_System__c = 'Retail';
        insert woddc2;
        
        
        
        CRD__c testCRD2 = new CRD__c();
        testCRD2.Insured_Type__c = 'Fully Insured';
        testCRD2.CRD_Automated__c = True;
        insert testCRD2;
        
        Drug_Coverage__c dCoverageMail = new Drug_Coverage__c();
        dCoverageMail.RecordTypeId = dcMailRecordID;
        dCoverageMail.CRD_ID__c = testCRD2.Id;
        dCoverageMail.formulary__c = formulary.Id;
        dCoverageMail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageMail.Brand_Penalty_Type__c = Null;
        dCoverageMail.Brand_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Brand_Penalty_Percent__c = 13;
        dCoverageMail.Generic_Penalty_Type__c = Null;
        dCoverageMail.Generic_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Generic_Penalty_Percent__c = 13;
        dCoverageMail.Maintenance_Choice__c = 'Voluntary';
        dCoverageMail.No_of_fills_allowed_at_retail__c = 1;
        dCoverageMail.Mandatory_Mail_Order_Option__c = 'Not Applicable';
        dCoverageMail.Formulary__c=formulary.id;
        insert dCoverageMail;
        
        Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
        dCoverageRetail.RecordTypeId = dcRetailRecordID;
        dCoverageRetail.CRD_ID__c = testCRD2.Id;
        dCoverageMail.formulary__c = formulary.Id;
        dCoverageRetail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageRetail.Do_you_have_Specialty__c = 'No';
        dCoverageRetail.Aetna_Specialty_Care_Rx__c = Null;
        dCoverageRetail.Force_to_Specialty__c = 'No';
        dCoverageRetail.Secondary_Aetna_Specialty_Care_Rx__c ='Applies-Expanded List';
        dCoverageRetail.Secondary_of_Fills_before_Force_to_MOD__c = NULL;
        insert dCoverageRetail;
        
        Waiver_Of_Deductible__c wodSt = new Waiver_Of_Deductible__c();
        wodSt.crd_id__c = testCRD2.id;
        wodSt.Standard__c = true;
        wodSt.Drug_Class__c = '4 - FOR MAIL ORDER DRUGS';
        wodSt.Delivery_System__c = 'Retail';
        insert wodSt;
        
        Waiver_Of_Deductible__c wodSt2 = new Waiver_Of_Deductible__c();
        wodSt2.crd_id__c = testCRD2.id;
        wodSt2.Standard__c = true;
        wodSt2.Drug_Class__c = '4 - FOR MAIL ORDER DRUGS';
        wodSt2.Delivery_System__c = 'Retail';
        insert wodSt2;
        
        Waiver_Of_Deductible__c wod5 = new Waiver_Of_Deductible__c();
        wod5.crd_id__c = testCRD2.id;
        wod5.Standard__c = false;
        wod5.Delivery_System__c = 'Both';
        wod5.Drug_Group__c = getDG();
        wod5.Y__c = true;
        insert wod5;
        
        /*Waiver_Of_Deductible__c wod6 = new Waiver_Of_Deductible__c();
        wod6.crd_id__c = testCRD2.id;
        wod6.Standard__c = false;
        wod6.Delivery_System__c = 'Both';
        wod6.Drug_Group__c = getDG();
        wod6.Y__c = true;
        insert wod6;*/
        
        PageReference wodPage = Page.VF_WaiverOfDeductible;
        wodPage.getParameters().put('crdid',testCRD2.id);
        Test.setCurrentPage(wodPage);
        
        ApexPages.StandardController stCon2 = new ApexPages.standardController(testCRD2);
        VFP_WaiverOfDeductible wodController2 = new VFP_WaiverOfDeductible(stCon2);
        wodController2.nextbutton();
        wodController2.backbutton();
        wodController2.addStndrdDC();
        wodController2.addCustomDC();
        wodController2.deleteStndrdDC();
        wodController2.deleteCustomDC();
        wodController2.nextButton2();
        wodController2.backbutton2();
    }
    static testmethod void myUnitTest4(){
    String dcMailRecordID;
    String dcRetailRecordID;
         for(RecordType RecType : [Select Id,Name,SobjectType From RecordType]){
         if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Mail'){
            dcMailRecordID =  RecType.ID;            
         }else if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Retail'){
            dcRetailRecordID = RecType.ID;
            }
        }
        Drug_Group__c dg = new Drug_Group__c();
        dg.RecordTypeId = Schema.SObjectType.Drug_Group__c.getRecordTypeInfosByName().get('Drug List').getRecordTypeId();
        dg.Drug_Group_Name__c = 'test';
        dg.Description__c = 'test data';
        dg.Effective_Date__c = system.today();
        dg.Termination_Date__c = system.today()+1;
        dg.Allowable_Actions__c = 'Allow Rule to be overridden';
        insert dg;
        
        Option_Code__c oc = new Option_Code__c();
        oc.Option_Code_Name__c = '3PRP';
        oc.Option_Code_Description__c = 'Open 3 tier Premier Plus';
        oc.Effective_Date__c = system.today();
        oc.Termination_Date__c = system.today() +1;
        insert oc;
        Waiver_Of_Deductible_Drug_Class__c woddc = new Waiver_Of_Deductible_Drug_Class__c();
        woddc.Drug_Class__c = '26 - FOR GENERIC DIABETIC DRUGS AND SUPPLIES AND FORMULARY BRAND DIABETIC DRUGS AND SUPPLIES.';
        woddc.Drug_List__c = getDLwithoutAllowableAction();
        woddc.Delivery_System__c = 'Retail';
        insert woddc;

        Waiver_Of_Deductible_Drug_Class__c woddc2 = new Waiver_Of_Deductible_Drug_Class__c();
        woddc2.Drug_Class__c = '25 - NONE FOR PHARMACY IN NETWORK AND GENERIC DRUGS FOR PHARMACY OUT OF NETWORK';
        woddc2.Drug_Group__c = dg.id;
        woddc2.Delivery_System__c = 'Retail';
        insert woddc2;
        
        
        
        CRD__c testCRD2 = new CRD__c();
        testCRD2.Insured_Type__c = 'Fully Insured';
        testCRD2.CRD_Automated__c = True;
        insert testCRD2;
        
        Drug_Coverage__c dCoverageMail = new Drug_Coverage__c();
        dCoverageMail.RecordTypeId = dcMailRecordID;
        dCoverageMail.CRD_ID__c = testCRD2.Id;
        dCoverageMail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageMail.Brand_Penalty_Type__c = Null;
        dCoverageMail.Brand_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Brand_Penalty_Percent__c = 13;
        dCoverageMail.Generic_Penalty_Type__c = Null;
        dCoverageMail.Generic_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Generic_Penalty_Percent__c = 13;
        dCoverageMail.Maintenance_Choice__c = 'Voluntary';
        dCoverageMail.No_of_fills_allowed_at_retail__c = 1;
        dCoverageMail.Mandatory_Mail_Order_Option__c = 'Not Applicable';
        insert dCoverageMail;
        
        Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
        dCoverageRetail.RecordTypeId = dcRetailRecordID;
        dCoverageRetail.CRD_ID__c = testCRD2.Id;
        dCoverageRetail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageRetail.Do_you_have_Specialty__c = 'No';
        dCoverageRetail.Aetna_Specialty_Care_Rx__c = Null;
        dCoverageRetail.Force_to_Specialty__c = 'No';
        dCoverageRetail.Secondary_Aetna_Specialty_Care_Rx__c ='Applies-Expanded List';
        dCoverageRetail.Secondary_of_Fills_before_Force_to_MOD__c = NULL;
        insert dCoverageRetail;
       
        
        Waiver_Of_Deductible__c wod5 = new Waiver_Of_Deductible__c();
        wod5.crd_id__c = testCRD2.id;
        wod5.Standard__c = true;
        wod5.Delivery_System__c = 'Both';
        wod5.Drug_Group__c = dg.id;
        wod5.Drug_Class__c = '25 - NONE FOR PHARMACY IN NETWORK AND GENERIC DRUGS FOR PHARMACY OUT OF NETWORK';
        wod5.Y__c = true;
        insert wod5;
        
        PageReference wodPage = Page.VF_WaiverOfDeductible;
        wodPage.getParameters().put('crdid',testCRD2.id);
        Test.setCurrentPage(wodPage);
        
        ApexPages.StandardController stCon2 = new ApexPages.standardController(testCRD2);
        VFP_WaiverOfDeductible wodController2 = new VFP_WaiverOfDeductible(stCon2);
        wodController2.nextbutton();
        wodController2.backbutton();
        wodController2.addStndrdDC();
        wodController2.addCustomDC();
        wodController2.deleteStndrdDC();
        wodController2.deleteCustomDC();
        wodController2.nextButton2();
        wodController2.backbutton2();
    }
    static testmethod void myUnitTest5(){
    String dcMailRecordID;
    String dcRetailRecordID;
         for(RecordType RecType : [Select Id,Name,SobjectType From RecordType]){
         if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Mail'){
            dcMailRecordID =  RecType.ID;            
         }else if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Retail'){
            dcRetailRecordID = RecType.ID;
            }
        }
        Drug_Group__c dg = new Drug_Group__c();
        dg.RecordTypeId = Schema.SObjectType.Drug_Group__c.getRecordTypeInfosByName().get('Drug List').getRecordTypeId();
        dg.Drug_Group_Name__c = 'test';
        dg.Description__c = 'test data';
        dg.Effective_Date__c = system.today();
        dg.Termination_Date__c = system.today()+1;
        dg.Allowable_Actions__c = 'Waiver of Deductible';
        insert dg;
        
        Option_Code__c oc = new Option_Code__c();
        oc.Option_Code_Name__c = '3PRP';
        oc.Option_Code_Description__c = 'Open 3 tier Premier Plus';
        oc.Effective_Date__c = system.today();
        oc.Termination_Date__c = system.today() +1;
        insert oc;
        Waiver_Of_Deductible_Drug_Class__c woddc = new Waiver_Of_Deductible_Drug_Class__c();
        woddc.Drug_Class__c = '26 - FOR GENERIC DIABETIC DRUGS AND SUPPLIES AND FORMULARY BRAND DIABETIC DRUGS AND SUPPLIES.';
        woddc.Drug_List__c = getDLwithoutAllowableAction();
        woddc.Delivery_System__c = 'Retail';
        insert woddc;

        Waiver_Of_Deductible_Drug_Class__c woddc2 = new Waiver_Of_Deductible_Drug_Class__c();
        woddc2.Drug_Class__c = '25 - NONE FOR PHARMACY IN NETWORK AND GENERIC DRUGS FOR PHARMACY OUT OF NETWORK';
        woddc2.Drug_Group__c = dg.id;
        woddc2.Delivery_System__c = 'Retail';
        insert woddc2;
        
        
        
        CRD__c testCRD2 = new CRD__c();
        testCRD2.Insured_Type__c = 'Fully Insured';
        testCRD2.CRD_Automated__c = True;
        insert testCRD2;
        
        Drug_Coverage__c dCoverageMail = new Drug_Coverage__c();
        dCoverageMail.RecordTypeId = dcMailRecordID;
        dCoverageMail.CRD_ID__c = testCRD2.Id;
        dCoverageMail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageMail.Brand_Penalty_Type__c = Null;
        dCoverageMail.Brand_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Brand_Penalty_Percent__c = 13;
        dCoverageMail.Generic_Penalty_Type__c = Null;
        dCoverageMail.Generic_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Generic_Penalty_Percent__c = 13;
        dCoverageMail.Maintenance_Choice__c = 'Voluntary';
        dCoverageMail.No_of_fills_allowed_at_retail__c = 1;
        dCoverageMail.Mandatory_Mail_Order_Option__c = 'Not Applicable';
        insert dCoverageMail;
        
        Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
        dCoverageRetail.RecordTypeId = dcRetailRecordID;
        dCoverageRetail.CRD_ID__c = testCRD2.Id;
        dCoverageRetail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageRetail.Do_you_have_Specialty__c = 'No';
        dCoverageRetail.Aetna_Specialty_Care_Rx__c = Null;
        dCoverageRetail.Force_to_Specialty__c = 'No';
        dCoverageRetail.Secondary_Aetna_Specialty_Care_Rx__c ='Applies-Expanded List';
        dCoverageRetail.Secondary_of_Fills_before_Force_to_MOD__c = NULL;
        insert dCoverageRetail;
       
        
        Waiver_Of_Deductible__c wod5 = new Waiver_Of_Deductible__c();
        wod5.crd_id__c = testCRD2.id;
        wod5.Standard__c = true;
        wod5.Delivery_System__c = 'Both';
        wod5.Drug_Group__c = dg.id;
        wod5.Drug_Class__c = '25 - NONE FOR PHARMACY IN NETWORK AND GENERIC DRUGS FOR PHARMACY OUT OF NETWORK';
        wod5.Y__c = true;
        insert wod5;
        Waiver_Of_Deductible__c wod6 = new Waiver_Of_Deductible__c();
        wod6.crd_id__c = testCRD2.id;
        wod6.Standard__c = true;
        wod6.Delivery_System__c = 'Both';
        system.debug('getDLwithoutAllowableAction++++ ' + getDLwithoutAllowableAction());
        wod6.Drug_List__c= getDLwithoutAllowableAction();
        wod6.Drug_Class__c = '25 - NONE FOR PHARMACY IN NETWORK AND GENERIC DRUGS FOR PHARMACY OUT OF NETWORK';
        wod6.Y__c = true;
        insert wod6;
        
        PageReference wodPage = Page.VF_WaiverOfDeductible;
        wodPage.getParameters().put('crdid',testCRD2.id);
        Test.setCurrentPage(wodPage);
        
        ApexPages.StandardController stCon2 = new ApexPages.standardController(testCRD2);
        VFP_WaiverOfDeductible wodController2 = new VFP_WaiverOfDeductible(stCon2);
        wodController2.nextbutton();
        wodController2.backbutton();
        wodController2.addStndrdDC();
        wodController2.addCustomDC();
        wodController2.deleteStndrdDC();
        wodController2.deleteCustomDC();
        wodController2.nextButton2();
        wodController2.backbutton2();
    }
    static testmethod void myUnitTest6(){
    String dcMailRecordID;
    String dcRetailRecordID;
         for(RecordType RecType : [Select Id,Name,SobjectType From RecordType]){
         if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Mail'){
            dcMailRecordID =  RecType.ID;            
         }else if(RecType.SobjectType =='Drug_Coverage__c' && RecType.Name =='Retail'){
            dcRetailRecordID = RecType.ID;
            }
        }
        Drug_List__c dl = new Drug_List__c();
        dl.RecordTypeId = Schema.SObjectType.Drug_List__c.getRecordTypeInfosByName().get('Drug List').getRecordTypeId();
        dl.Drug_List_Name__c= 'test';
        dl.Description__c = 'test data';
        dl.Effective_Date__c = system.today();
        dl.Termination_Date__c = system.today()+1;
        dl.Allowable_Actions__c = 'Waiver of Deductible';
        insert dl;
        
        Option_Code__c oc = new Option_Code__c();
        oc.Option_Code_Name__c = '3PRP';
        oc.Option_Code_Description__c = 'Open 3 tier Premier Plus';
        oc.Effective_Date__c = system.today();
        oc.Termination_Date__c = system.today() +1;
        insert oc;
        Waiver_Of_Deductible_Drug_Class__c woddc = new Waiver_Of_Deductible_Drug_Class__c();
        woddc.Drug_Class__c = '26 - FOR GENERIC DIABETIC DRUGS AND SUPPLIES AND FORMULARY BRAND DIABETIC DRUGS AND SUPPLIES.';
        woddc.Drug_List__c = getDLwithoutAllowableAction();
        woddc.Delivery_System__c = 'Retail';
        insert woddc;

        Waiver_Of_Deductible_Drug_Class__c woddc2 = new Waiver_Of_Deductible_Drug_Class__c();
        woddc2.Drug_Class__c = '25 - NONE FOR PHARMACY IN NETWORK AND GENERIC DRUGS FOR PHARMACY OUT OF NETWORK';
        woddc2.Drug_List__c= dl.id;
        woddc2.Delivery_System__c = 'Retail';
        insert woddc2;
        
        
        
        CRD__c testCRD2 = new CRD__c();
        testCRD2.Insured_Type__c = 'Fully Insured';
        testCRD2.CRD_Automated__c = True;
        insert testCRD2;
        
        Drug_Coverage__c dCoverageMail = new Drug_Coverage__c();
        dCoverageMail.RecordTypeId = dcMailRecordID;
        dCoverageMail.CRD_ID__c = testCRD2.Id;
        dCoverageMail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageMail.Brand_Penalty_Type__c = Null;
        dCoverageMail.Brand_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Brand_Penalty_Percent__c = 13;
        dCoverageMail.Generic_Penalty_Type__c = Null;
        dCoverageMail.Generic_Penalty_Dollar_Amount__c = 12;
        dCoverageMail.Generic_Penalty_Percent__c = 13;
        dCoverageMail.Maintenance_Choice__c = 'Voluntary';
        dCoverageMail.No_of_fills_allowed_at_retail__c = 1;
        dCoverageMail.Mandatory_Mail_Order_Option__c = 'Not Applicable';
        insert dCoverageMail;
        
        Drug_Coverage__c dCoverageRetail = new Drug_Coverage__c();
        dCoverageRetail.RecordTypeId = dcRetailRecordID;
        dCoverageRetail.CRD_ID__c = testCRD2.Id;
        dCoverageRetail.Do_you_have_Choose_Generic__c = 'No';
        dCoverageRetail.Do_you_have_Specialty__c = 'No';
        dCoverageRetail.Aetna_Specialty_Care_Rx__c = Null;
        dCoverageRetail.Force_to_Specialty__c = 'No';
        dCoverageRetail.Secondary_Aetna_Specialty_Care_Rx__c ='Applies-Expanded List';
        dCoverageRetail.Secondary_of_Fills_before_Force_to_MOD__c = NULL;
        insert dCoverageRetail;
       
     
        Waiver_Of_Deductible__c wod6 = new Waiver_Of_Deductible__c();
        wod6.crd_id__c = testCRD2.id;
        wod6.Standard__c = true;
        wod6.Delivery_System__c = 'Both';
        wod6.Drug_List__c= dl.id;
        wod6.Drug_Class__c = '25 - NONE FOR PHARMACY IN NETWORK AND GENERIC DRUGS FOR PHARMACY OUT OF NETWORK';
        wod6.Y__c = true;
        insert wod6;
        
        PageReference wodPage = Page.VF_WaiverOfDeductible;
        wodPage.getParameters().put('crdid',testCRD2.id);
        Test.setCurrentPage(wodPage);
        
        ApexPages.StandardController stCon2 = new ApexPages.standardController(testCRD2);
        VFP_WaiverOfDeductible wodController2 = new VFP_WaiverOfDeductible(stCon2);
        wodController2.nextbutton();
        wodController2.backbutton();
        wodController2.addStndrdDC();
        wodController2.addCustomDC();
        wodController2.deleteStndrdDC();
        wodController2.deleteCustomDC();
        wodController2.nextButton2();
        wodController2.backbutton2();
    }
}