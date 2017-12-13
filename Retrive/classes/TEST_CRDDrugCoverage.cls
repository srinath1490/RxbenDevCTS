/*Purpose: Apex Test Class for VFP_CRDDrugCoverage.
    ========================================================================
     History                                                           
        -------                                                          
     VERSION     AUTHOR                 DATE                    DETAIL                                 
         1.0 -   Abhay                 9/28/2011       Apex Test Class for VFP_CRDDrugCoverage.
    ======================================================================== 
    */
    @isTest 
    private class TEST_CRDDrugCoverage {

        static testMethod void myUnitTest() {
            list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where sobjecttype='Drug_Coverage__c']);
            CRD__c testCrd = new CRD__c();
            testCrd.Retail_to_Mail__c =True;
            testCrd.CRD_Automated__c = TRUE;
            insert testCrd;
           
            Drug_Coverage__c drugCoverateItem=new Drug_Coverage__c();
            drugCoverateItem.CRD_ID__c = testCrd.id;
            drugCoverateItem.RecordTypeId=rt.get(0).id;
            drugCoverateItem.Do_you_have_Choose_Generic__c ='Yes';
            drugCoverateItem.Choose_Generic_Copay_Diff_Exclusion__c='No';
            drugCoverateItem.Aetna_Specialty_Care_Rx__c = null;
            drugCoverateItem.Force_to_Specialty__c = null;              

            insert drugCoverateItem;
                   
            CRD__c testCrd2 = new CRD__c();
            testCrd2.Plan_Type_Mail__c = True;
            testCrd2.Standard_or_Custom_Plan__c = 'Creating a custom plan';
            testCrd2.CRD_Automated__c = TRUE;
            insert testCrd2;
            
            Drug_Specific_Copay__c drugSCopay=new Drug_Specific_Copay__c();
            drugSCopay.CRD_ID__c =  testCrd2.id;  
            insert drugSCopay; 
            
            Drug_Specific_Stepped_Copay__c drugSSteppedCopay = new Drug_Specific_Stepped_Copay__c();
            drugSSteppedCopay.Drug_Specific_Copay_ID__c =  drugSCopay.id;  
            drugSSteppedCopay.Dollar_Amount__c=10;
            insert drugSSteppedCopay;
            
            Copay_Tier__c copayTier = new Copay_Tier__c();       
            copayTier.CRD__c = testCrd2.id;
            copayTier.Percent__c=10;
            insert  copayTier;  
            
            SteppedCopay__c steppedCopay = new SteppedCopay__c();
            steppedCopay.Copay_Tier__c = copayTier.id;
            steppedCopay.Dollar_Amount__c=10;
            insert SteppedCopay;
            Formulary__c frm=new Formulary__c();
            frm.Formulary_Name__c='test';
            frm.Formulary_Description__c='test';
            frm.Effective_Date__c = system.today();
            frm.Formulary_Open_Closed__c = 'open';
            frm.Termination_Date__c =system.today() +7;
            insert frm;
            string dcfrm = frm.Formulary_Open_Closed__c;      
            Drug_Coverage__c drugCoverateItem1=new Drug_Coverage__c();
            drugCoverateItem1.Formulary__c=frm.id;
                  
            PageReference drugCoverage = Page.VF_CRDDrugCoverageStep2;
            drugCoverage.getParameters().put('crdid',testCrd.id);    
            drugCoverage.getParameters().put('dcId',drugCoverateItem.id);         
            Test.setCurrentPage(drugCoverage);         
            ApexPages.StandardController stCon = new ApexPages.standardController(drugCoverateItem);
            VFP_CRDDrugCoverageStep2  controller = new VFP_CRDDrugCoverageStep2 (stCon);      
            controller.selectedDrugId=drugCoverateItem.id;
            controller.isMandatoryGeneric = TRUE;
            controller.ismmoIncentive = TRUE;
            controller.isHavingSpeciality = TRUE;
            controller.drugCoverage.Mandatory_Mail_Order_Option__c='Incentivized';
            controller.drugCoverage.Co_Insurance_Percentage__c=null;
            controller.recordTypeValue=rt.get(1).id;
            controller.userSelectionRecordTypeName='Retail';
            controller.saveAndAdd();
            controller.drugCoverage.Mandatory_Mail_Order_Option__c='Incentivized1';
            controller.drugCoverage.Co_Insurance_Percentage__c=10;
            controller.drugCoverage.Maximum_days_supply__c=10;
            controller.drugCoverage.Maximum_quantity__c=10; 
            controller.drugCoverage.Rule_for_supply_quantity__c=null;
            controller.recordTypeValue=rt.get(1).id;
            controller.saveAndAdd();
            controller.redirectToPaperOptions();
            //controller.redirectToPaperOptions2();
            controller.drugCoverage.Maximum_days_supply__c=10;
            controller.drugCoverage.Rule_for_supply_quantity__c='10';         
            controller.recordTypeValue=rt.get(1).id;
            controller.userSelectionRecordTypeName='Mail';
            controller.drugCoverage.Brand_Penalty_Dollar_Amount__c=23;
            controller.drugCoverage.Brand_Penalty_Percent__c=22;
            controller.drugCoverage.Brand_Penalty_Type__c='Apply Penalty Only';
            controller.saveAndAdd();
            controller.redirectToPaperOptions();
            //controller.redirectToPaperOptions2();
             controller.userSelectionRecordTypeName='Retail';
            controller.redirectToPaperOptions();
            //controller.redirectToPaperOptions2();        
            //controller.showHiddenFields();
            //controller.showIndregentField();
            //controller.showNoOfFills();
            //controller.showMMOFields();
            controller.userSelectionRecordTypeName='Mail';
            //controller.addDrugClassRecords();
            controller.redirectToPaperOptions();
             controller.userSelectionRecordTypeName='Retail';
             //controller.addDrugClassRecords();
            controller.copyDrugCoverageValues(); 
            controller.recordTypeValue=rt.get(0).id;
            controller.copyDrugCoverageValues();                      
            controller.crd.Any_drug_specific_Specialty_copays__c=true;
            controller.redirectToCopay();
            //controller.redirectToCopay2();
            controller.crd.Any_drug_specific_Specialty_copays__c=false;         
            controller.redirectToCopay();
            //controller.redirectToCopay2();
            controller.lstDrugCoverageWrapper[0].isMarkedForDeletion=true;
            controller.deleteSelectedDrugCoverage();
            controller.AddNewDCDrugList();
            controller.deleteSelectedDCDrugList();
            
            controller.selectedDrugId=drugCoverateItem.id;
            controller.drugCoverage.Mandatory_Mail_Order_Option__c='Incentivized';
            controller.drugCoverage.Co_Insurance_Percentage__c=null;
            controller.recordTypeValue=rt.get(1).id;
            controller.userSelectionRecordTypeName='Mail';
            controller.drugCoverage.Brand_Penalty_Percent__c =23;
            controller.drugCoverage.Brand_Penalty_Type__c =null;
            controller.drugCoverage.Generic_Penalty_Percent__c=23;
            controller.drugCoverage.Generic_Penalty_Type__c =null;
            controller.redirectToPaperOptions();
            //controller.redirectToPaperOptions2();
            controller.saveAndAdd();         
             
            
            
            controller.crd.Standard_or_Custom_Plan__c = 'Creating a custom plan';
            try{
                //controller.addDrugClassRecords();
            }
            catch(exception ex){
            }
            Schema.DescribeSObjectResult d = Schema.SObjectType.Drug_Coverage__c;
            Map < string, Schema.RecordTypeInfo > rtMapById = d.getRecordTypeInfosByName();
            
            
            controller.recordTypeValue = rtMapById.get('Mail').getRecordTypeId();
            controller.drugCoverage.Maintenance_Choice__c = 'Mandatory' ;
            controller.crd.Plan_Type_Retail__c = false;
            controller.crd.Plan_Type_Mail__c = false;
            controller.drugCoverage.Maximum_days_supply__c = 2.1;
            try{
                controller.redirectToPaperOptions();
                //controller.redirectToPaperOptions2();
            }
            catch(exception ex){
            }   
            controller.drugCoverage.Formulary_Open_Closed__c = NULL;
            try{
                controller.redirectToPaperOptions();
                //controller.redirectToPaperOptions2();
            }
            catch(exception ex){
            }
            PageReference drugCoverage1 = Page.VF_CRDDrugCoverageStep2;
            drugCoverage1.getParameters().put('crdid',testCrd2.id);
            Test.setCurrentPage(drugCoverage1);         
            ApexPages.StandardController stCon1 = new ApexPages.standardController(drugCoverateItem1);
            VFP_CRDDrugCoverageStep2  controller1 = new VFP_CRDDrugCoverageStep2(stCon1);
            controller1.recordTypeValue=rt.get(0).id;
            controller1.userSelectionRecordTypeName='Mail';
            controller1.redirectToPaperOptions();
            controller1.crd.Integrate_with_Medical__c='No';
            controller1.redirectToPaperOptions();
            controller1.crd.Integrate_with_Medical__c='Yes';       
            controller1.redirectToPaperOptions();         
            controller1.recordTypeValue='none';
            controller1.saveAndAdd();
            controller1.redirectToPaperOptions();
            controller1.recordTypeValue=rt.get(1).id;
            controller1.saveAndAdd();
            controller1.crd.Any_drug_specific_Specialty_copays__c=false;         
            controller1.redirectToCopay();
            //controller.redirectToCopay2();
            controller1.drugCoverage.Mandatory_Mail_Order_Option__c='Incentivized';
            //controller1.showPercentField();
            controller1.drugCoverage.Mandatory_Mail_Order_Option__c='Incentivized12';
            //controller1.showPercentField();
            controller1.drugCoverage.Mandatory_Mail_Order_Option__c = 'Not Applicable';
            //controller1.showPercentField();
            controller1.drugCoverage.Do_you_have_Choose_Generic__c='Yes';
            //controller1.showDependentFields();
            controller1.drugCoverage.Do_you_have_Choose_Generic__c='No';
            //controller1.showDependentFields();
            controller1.recordTypeValue=controller1.getRecordType('Mail');
            controller1.showMailPanel();
            controller1.recordTypeValue=controller1.getRecordType('Retail');
            controller1.showMailPanel();
            controller1.showMailPanel();
            controller1.recordTypeValue=null;
            controller1.showMailPanel();
            //controller1.showCostAmount();
            controller1.drugCoverage.Standard_Refill_too_Soon__c='no';
            controller1.drugCoverage.Does_Dose_Limit_apply__c  ='Yes';
            controller1.showCustomRefillField();
            //controller1.showCostFields(); 
            controller1.drugcoverage.Aetna_Specialty_Care_Rx__c = null;
            controller1.drugcoverage.Force_to_Specialty__c = null;
            controller1.showSpecialityField();
            controller1.redirectToPaperOptions();
            controller1.drugcoverage.Aetna_Specialty_Care_Rx__c = 'RSO';
            controller1.showSpecialityField();           
            controller1.drugCoverage.Aetna_Specialty_Care_Rx__c='Applies-Expanded List';
            controller.drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c = 'Applies-Expanded List';
            controller1.showSpecialityField();
            
            controller1.drugCoverage.Maximum_days_supply__c = null;
            controller1.userSelectionRecordTypeName = 'Mail';
            controller1.crd.Plan_Type_Mail__c = true;
            controller1.redirectToPaperOptions();
            controller1.drugCoverage.Brand_Penalty_Dollar_Amount__c = 100;
            controller1.crd.Retail_to_Mail__c = false;
            controller1.redirectToPaperOptions();
            controller1.drugCoverage.Brand_Penalty_Type__c = 'abc';
            controller1.drugCoverage.Maintenance_Choice__c = 'Incentivized';
            controller1.drugCoverage.Generic_Penalty_Type__c = 'abc';
            controller1.redirectToPaperOptions();   
            controller1.drugCoverage.Brand_Penalty_Maximum_Dollar__c = 100;
            controller1.drugCoverage.Brand_Penalty_Minimum_Dollar__c = 100;
            controller1.redirectToPaperOptions();       
            controller1.drugCoverage.Generic_Penalty_Maximum_Dollar__c = 100;
            controller1.drugCoverage.Generic_Penalty_Minimum_Dollar__c = 100;
            controller1.redirectToPaperOptions();
            controller1.drugCoverage.Generic_Penalty_Dollar_Amount__c = 100;
            
            controller1.drugCoverage.Maintenance_Choice__c = null;
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();       
            boolean isMailDrugAvailable = true;
            boolean isRetailDrugAvailable = true;
            controller1.crd.Retail_to_Mail__c = false;
            controller1.drugCoverage.Generic_Penalty_Dollar_Amount__c = 20;
            controller1.drugCoverage.Mandatory_Mail_Order_Option__c = 'Not Applicable';
            controller1.drugCoverage.Exception_Drug_Group__c = null;
            controller1.drugCoverage.Exception_Drug_List__c = null;
            
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();       
            controller1.drugCoverage.Generic_Penalty_Percent__c = 20;       
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();       
            controller1.crd.Retail_to_Mail__c = true;
            controller1.redirectToPaperOptions();
            controller1.drugCoverage.Generic_Penalty_Type__c = null;
            controller1.redirectToPaperOptions();
            controller1.drugCoverage.Brand_Penalty_Type__c = null;
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();
            controller1.userSelectionRecordTypeName = 'Retail';
            controller1.redirectToPaperOptions();controller.saveAndAdd();
            controller1.drugCoverage.Aetna_Specialty_Care_Rx__c = 'RRA';
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();
            controller1.drugCoverage.Force_to_Specialty__c = 'RSO with Fertility';
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();
            controller1.drugCoverage.Aetna_Specialty_Care_Rx__c = 'RSO without Fertility';
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();
            controller1.drugCoverage.Force_to_Specialty__c = 'No' ;
            controller1.drugCoverage.of_fills_before_force_to_specialty__c = 10;
            controller1.redirectToPaperOptions();       
            controller1.saveAndAdd();
            controller1.drugCoverage.Force_to_Specialty__c = 'Yes' ;
            controller1.drugCoverage.of_fills_before_force_to_specialty__c = null;
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();
            controller1.drugCoverage.Aetna_Specialty_Care_Rx__c = 'RSO with Fertility' ;
            controller1.drugCoverage.Speciality_Drug_List__c =NULL;
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();
            controller1.drugCoverage.Do_you_have_Choose_Generic__c = null;
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();
            controller1.drugCoverage.Do_you_have_Choose_Generic__c = 'yes';
            controller1.drugCoverage.Maximum_days_supply__c = null;
            controller1.userSelectionRecordTypeName = 'Mail';
            controller1.drugCoverage.Maintenance_Choice__c = 'Mandatory';
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();
            controller1.drugCoverage.Maintenance_Choice__c = 'Mandatory';
            controller1.drugCoverage.Brand_Penalty_Dollar_Amount__c = null;
            controller1.drugCoverage.Brand_Penalty_Percent__c = null;
            controller1.drugCoverage.Generic_Penalty_Dollar_Amount__c = null;
            controller1.drugCoverage.Generic_Penalty_Percent__c = null; 
            controller1.crd.Retail_to_Mail__c = false;
            controller1.drugCoverage.Generic_Penalty_Dollar_Amount__c = 20;
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();
            controller1.recordTypeValue = 'none';
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd(); 
            
            controller1.showSecSpecialityField();
            controller1.allowTransitionFill();
            controller1.drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c = 'RRA';
            controller1.showSecSpecialityField();            
            controller1.allowTransitionFill();
            controller1.drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c = 'RSO';
            controller1.showSecSpecialityField();            
            controller1.allowTransitionFill();
           // controller1.allowTransitionFill();     
           controller1.drugCoverage.Aetna_Specialty_Care_Rx__c = NULL;
           controller1.drugCoverage.Force_to_Specialty__c = NULL ;
           controller1.saveandadd();           
        }
        static testMethod void myUnitTest1() {
            Drug_Group__c dg = new Drug_Group__c();
            dg.Drug_Group_Name__c = 'Acne- all- PR 36 y/o';
            dg.Effective_Date__c = system.today();
            dg.Description__c = 'Acne- all- PR 36 y/o';
            dg.Termination_Date__c = system.today()+7;
            insert dg;
            
            Drug_List__c dl = new Drug_List__c();
            dl.Description__c = 'Fluoride Dental Products (Covered- Rx only)';
            dl.Drug_List_Name__c = 'Fluoride Dental Products (Covered- Rx only)';
            dl.Effective_Date__c = system.today();
            dl.Termination_Date__c = system.today()+7;
            insert dl;
            
           
            
            DC_Drug_Class__c dcDrug = new DC_Drug_Class__c();
            dcDrug.Drug_Group__c = dg.Id;
           // dcDrug.Drug_List__c = dl.Id;
            dcDrug.Drug_Class__c = 'Commercial System List';
            dcDrug.Inclusion_Exclusion__c='Include';
            dcDrug.Apply_Limitations__c = 'Yes';
            dcDrug.Quantity_Over_Time_Quantity__c = 48.0;
            dcDrug.Quantity_Over_Time_Time_Period__c = 'Years';
            dcDrug.Quantity_Over_Time_Time_Value__c = 1.0;
            dcDrug.Start_Age__c = 36.0;
            dcDrug.Start_Age_Type__c = 'Years';
            dcDrug.Mandatory__c = 'Yes';
            dcDrug.For_Retail_Drug_Coverage__c = True;
            dcDrug.Bypass_M__c = 'Do Not Reduce MOOP OON';
            try{
                insert dcDrug;
            }catch(Exception e){
            }
            
            list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where sobjecttype='Drug_Coverage__c']);
            CRD__c testCrd = new CRD__c();
            testCrd.Retail_to_Mail__c =True; 
            testCrd.CRD_Automated__c = TRUE;
            insert testCrd;
           
            Drug_Coverage__c drugCoverateItem=new Drug_Coverage__c();
            drugCoverateItem.CRD_ID__c = testCrd.id;
            drugCoverateItem.RecordTypeId=rt.get(0).id;
            drugCoverateItem.Do_you_have_Choose_Generic__c ='Yes';
            drugCoverateItem.Choose_Generic_Copay_Diff_Exclusion__c='No';
            insert drugCoverateItem;
            
            CRD__c testCrd2 = new CRD__c();
            testCrd2.Standard_or_Custom_Plan__c = 'Creating a HIX plan';
            testCrd.CRD_Automated__c = TRUE;
            insert testCrd2;
            
            Drug_Specific_Copay__c drugSCopay=new Drug_Specific_Copay__c();
            drugSCopay.CRD_ID__c =  testCrd2.id;  
            insert drugSCopay; 
            
            Drug_Specific_Stepped_Copay__c drugSSteppedCopay = new Drug_Specific_Stepped_Copay__c();
            drugSSteppedCopay.Drug_Specific_Copay_ID__c =  drugSCopay.id;  
            drugSSteppedCopay.Dollar_Amount__c=10;
            insert drugSSteppedCopay;
            
            Copay_Tier__c copayTier = new Copay_Tier__c();       
            copayTier.CRD__c = testCrd2.id;
            copayTier.Percent__c=10;
            insert  copayTier; 
            
            SteppedCopay__c steppedCopay = new SteppedCopay__c();
            steppedCopay.Copay_Tier__c = copayTier.id;
            steppedCopay.Dollar_Amount__c=10;
            insert SteppedCopay;
            Formulary__c frm=new Formulary__c();
            frm.Formulary_Name__c='test';
            frm.Formulary_Description__c='test';
            frm.Effective_Date__c = system.today();
            frm.Formulary_Open_Closed__c = 'open';
            frm.Termination_Date__c =system.today() +7;
            insert frm; 
            string dcfrm2 = frm.Formulary_Open_Closed__c;
            Drug_Coverage__c drugCoverateItem1=new Drug_Coverage__c();
            drugCoverateItem1.Formulary__c=frm.id;
            drugCoverateItem1.CRD_ID__c = testCrd.id;
            drugCoverateItem1.RecordTypeId=rt.get(1).id;
            drugCoverateItem1.Do_you_have_Choose_Generic__c ='Yes';
            drugCoverateItem1.Choose_Generic_Copay_Diff_Exclusion__c='No';
            insert drugCoverateItem1;
            
            DC_Drug_List_Group__c dcRecord = new DC_Drug_List_Group__c();
            dcRecord.Related_Drug_Coverage__c = drugCoverateItem1.Id;
            dcRecord.Inclusion_Exclusion__c = 'Exclude';
            dcRecord.Apply_Limitations__c = 'Yes';
            insert dcRecord;
            
            PageReference drugCoverage1 = Page.VF_CRDDrugCoverageStep2;
            drugCoverage1.getParameters().put('crdid',testCrd2.id);
            Test.setCurrentPage(drugCoverage1);         
            ApexPages.StandardController stCon1 = new ApexPages.standardController(drugCoverateItem1);
            VFP_CRDDrugCoverageStep2  controller1 = new VFP_CRDDrugCoverageStep2(stCon1);
            controller1.recordTypeValue=rt.get(0).id;
            controller1.userSelectionRecordTypeName='Mail';
            //controller1.addDrugClassRecords();
            controller1.userSelectionRecordTypeName='Retail';
            controller1.drugcoverage.Formulary_Open_Closed__c = NULL;
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd(); 
            controller1.drugcoverage.Formulary_Open_Closed__c = 'Open';
            controller1.drugcoverage.Aetna_Specialty_Care_Rx__c= NULL;
            controller1.redirectToPaperOptions();controller1.saveAndAdd();
            controller1.drugcoverage.Formulary_Open_Closed__c = 'Open';
            controller1.drugcoverage.Aetna_Specialty_Care_Rx__c= 'Custom';
            controller1.drugcoverage.Force_to_Specialty__c= NULL;
            controller1.redirectToPaperOptions();controller1.saveAndAdd();
            controller1.drugcoverage.Formulary_Open_Closed__c = 'Open';
            controller1.drugcoverage.Aetna_Specialty_Care_Rx__c= 'Custom';
            controller1.drugcoverage.Force_to_Specialty__c= 'No';
            controller1.drugcoverage.Speciality_Drug_List__c= NULL;
            controller1.redirectToPaperOptions();controller1.saveAndAdd();
            controller1.drugcoverage.Formulary_Open_Closed__c = 'Open';
            controller1.drugcoverage.Aetna_Specialty_Care_Rx__c= 'abc';
            controller1.drugcoverage.Force_to_Specialty__c= 'Yes';
            controller1.drugcoverage.of_fills_before_force_to_specialty__c= NULL;
            controller1.redirectToPaperOptions();controller1.saveAndAdd();                                    
            controller1.drugcoverage.Formulary_Open_Closed__c = 'Open';
            controller1.drugcoverage.Aetna_Specialty_Care_Rx__c= 'RSO';
            controller1.drugcoverage.Force_to_Specialty__c= 'No';
            controller1.drugcoverage.of_fills_before_force_to_specialty__c= 10;
            controller1.drugcoverage.Mandatory_Mail_Order_Option__c = 'Not Applicable';
            controller1.redirectToPaperOptions();controller1.saveAndAdd();                                    
            controller1.drugcoverage.Formulary_Open_Closed__c = 'Open';
            controller1.drugcoverage.Aetna_Specialty_Care_Rx__c= 'RSO';
            controller1.drugcoverage.Force_to_Specialty__c= 'No';
            controller1.drugcoverage.of_fills_before_force_to_specialty__c= NULL;
            controller1.drugcoverage.Mandatory_Mail_Order_Option__c = 'xyz';
            controller1.redirectToPaperOptions();controller1.saveAndAdd();                                    
            
            //controller1.addDrugClassRecords();     
            controller1.userSelectionRecordTypeName='Specialty';
            //controller1.addDrugClassRecords(); 
            controller1.drugCoverage.Generic_Penalty_Maximum_Dollar__c = 100;
            controller1.drugCoverage.Generic_Penalty_Minimum_Dollar__c = 100;
            controller1.drugCoverage.Brand_Penalty_Maximum_Dollar__c = 100;
            controller1.drugCoverage.Brand_Penalty_Minimum_Dollar__c = 100;
            controller1.drugCoverage.Maintenance_Choice__c = 'Incentivized';
            controller1.drugCoverage.Generic_Penalty_Type__c = 'abc';
            controller1.drugCoverage.Generic_Penalty_Dollar_Amount__c = 0;
            controller1.drugCoverage.Generic_Penalty_Minimum_Dollar__c = 0;
            controller1.drugCoverage.Generic_Penalty_Percent__c = null;
            controller1.drugCoverage.Gen_Penalty_Based_Retail_Mail_AWP__c = null;
            controller1.drugCoverage.Brand_Penalty_Type__c = 'abc';
            controller1.drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c = 23;
            controller1.drugCoverage.Non_Pref_Brand_Penalty_Type__c = 'Yes';
            controller1.drugCoverage.Non_Pref_Brand_Penalty_Percent__c = 43;
             controller1.redirectToPaperOptions();
            controller1.saveAndAdd();
             controller1.recordTypeValue=controller1.getRecordType('Mail');
            controller1.drugCoverage.Mandatory_Mail_Order_Option__c = 'Mandatory';
            controller1.drugCoverage.Maintenance_Choice__c = 'Mandatory';
            controller1.drugCoverage.Brand_Penalty_Dollar_Amount__c = 23;
            controller1.drugCoverage.Brand_Penalty_Percent__c=22;
            controller1.drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c = 12;
            controller1.drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c = 30;
            controller1.drugCoverage.Non_Pref_Brand_Penalty_Type__c =null;
            controller1.recordTypeValue='Mail';
            controller1.redirectToPaperOptions();
            controller1.saveAndAdd();
            controller1.showSecSpecialityField();
            controller1.allowTransitionFill();
        }
        static testMethod void myUnitTest2() {
            list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where sobjecttype='Drug_Coverage__c']);
            CRD__c testCrd = new CRD__c();
            testCrd.Retail_to_Mail__c =True; 
            testCrd.CRD_Automated__c = TRUE;
            insert testCrd;
           
            Drug_Coverage__c drugCoverateItem=new Drug_Coverage__c();
            drugCoverateItem.CRD_ID__c = testCrd.id;
            drugCoverateItem.RecordTypeId=rt.get(1).id;
            drugCoverateItem.Do_you_have_Choose_Generic__c ='Yes';
            drugCoverateItem.Choose_Generic_Copay_Diff_Exclusion__c='No';
            drugCoverateItem.Force_to_Specialty__c = 'No';
            insert drugCoverateItem;
                   
            CRD__c testCrd2 = new CRD__c();
            testCrd2.Plan_Type_Mail__c = True;
            testCrd2.Standard_or_Custom_Plan__c = 'Creating a custom plan';
            testCrd2.CRD_Automated__c = TRUE;
            insert testCrd2;
            
            Drug_Specific_Copay__c drugSCopay=new Drug_Specific_Copay__c();
            drugSCopay.CRD_ID__c =  testCrd2.id;  
            insert drugSCopay; 
            
            Drug_Specific_Stepped_Copay__c drugSSteppedCopay = new Drug_Specific_Stepped_Copay__c();
            drugSSteppedCopay.Drug_Specific_Copay_ID__c =  drugSCopay.id;  
            drugSSteppedCopay.Dollar_Amount__c=10;
            insert drugSSteppedCopay;
            
            Copay_Tier__c copayTier = new Copay_Tier__c();       
            copayTier.CRD__c = testCrd2.id;
            copayTier.Percent__c=10;
            insert  copayTier;  
            
            SteppedCopay__c steppedCopay = new SteppedCopay__c();
            steppedCopay.Copay_Tier__c = copayTier.id;
            steppedCopay.Dollar_Amount__c=10;
            insert SteppedCopay;
            Formulary__c frm=new Formulary__c();
            frm.Formulary_Name__c='test';
            frm.Formulary_Description__c='test';
            frm.Effective_Date__c = system.today();
            frm.Termination_Date__c =system.today() +7;
            insert frm;       
            Drug_Coverage__c drugCoverateItem1=new Drug_Coverage__c();
            drugCoverateItem1.Formulary__c=frm.id;
                  
            PageReference drugCoverage = Page.VF_CRDDrugCoverageStep2;
            drugCoverage.getParameters().put('crdid',testCrd.id);    
            drugCoverage.getParameters().put('dcId',drugCoverateItem.id);         
            Test.setCurrentPage(drugCoverage);         
            ApexPages.StandardController stCon = new ApexPages.standardController(drugCoverateItem);
            VFP_CRDDrugCoverageStep2  controller = new VFP_CRDDrugCoverageStep2 (stCon);
            controller.crdid = testCrd.id;
            
            controller.recordTypeValue = rt.get(0).id;
            controller.crd.Plan_Type_Mail__c = true;
            
            controller.crd.Plan_Type_Retail__c  = true;
            controller.drugCoverage.Mandatory_Mail_Order_Option__c='Incentivized1';
            controller.drugCoverage.Co_Insurance_Percentage__c=10;
            controller.drugCoverage.Maximum_days_supply__c=10;
            controller.drugCoverage.Maximum_quantity__c=10;
            controller.drugCoverage.Rule_for_supply_quantity__c=null;
            //controller.recordTypeValue=rt.get(1).id;
            //controller.saveAndAdd();
            //controller.redirectToPaperOptions();controller.saveAndAdd();            
            controller.redirectToPaperOptions();controller.saveAndAdd();
            //controller.redirectToPaperOptions2();controller.saveAndAdd();
            controller.drugCoverage.Maximum_days_supply__c=10;
            controller.drugCoverage.Rule_for_supply_quantity__c='10';         
            controller.recordTypeValue=rt.get(1).id;
            controller.userSelectionRecordTypeName='Mail';
            controller.drugCoverage.Brand_Penalty_Dollar_Amount__c=23;
            controller.drugCoverage.Brand_Penalty_Percent__c=22;
            controller.drugCoverage.Brand_Penalty_Type__c='Apply Penalty Only';
            controller.saveAndAdd();
            controller.redirectToPaperOptions();controller.saveAndAdd();
            //controller.redirectToPaperOptions2();            
             controller.userSelectionRecordTypeName='Retail';
            controller.redirectToPaperOptions();controller.saveAndAdd();    
            //controller.redirectToPaperOptions2();
            
            controller.drugCoverage.Formulary_Open_Closed__c = 'abc';
            controller.redirectToPaperOptions();controller.saveAndAdd();            
            controller.drugCoverage.Aetna_Specialty_Care_Rx__c = 'abc';
            controller.redirectToPaperOptions();controller.saveAndAdd(); 
            //controller.redirectToPaperOptions2();          
            controller.drugCoverage.Force_to_Specialty__c = 'abc';
            controller.drugCoverage.Aetna_Specialty_Care_Rx__c = 'Custom';
            //controller.drugCoverage.Speciality_Drug_List__c = '01p50000000ToFI';                   
            controller.redirectToPaperOptions();controller.saveAndAdd();//controller.redirectToPaperOptions2();   
            controller.drugCoverage.Speciality_Drug_List__c = '01p50000000ToFI';                   
            controller.drugCoverage.Force_to_Specialty__c = 'Yes';                   
            controller.redirectToPaperOptions();controller.saveAndAdd();// controller.redirectToPaperOptions2(); 
            controller.drugCoverage.of_fills_before_force_to_specialty__c = 123; 
            controller.drugCoverage.Force_to_Specialty__c = 'No';                   
            controller.redirectToPaperOptions();controller.saveAndAdd();  //controller.redirectToPaperOptions2();    
            controller.drugCoverage.Force_to_Specialty__c = 'abc';
            controller.drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c = null;
            controller.drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c = 123; 
            controller.redirectToPaperOptions();controller.saveAndAdd();                                     
            controller.drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c = 'RRA';
            controller.drugCoverage.Secondary_of_Fills_before_Force_to_MOD__c = null; 
            controller.redirectToPaperOptions();controller.saveAndAdd(); //controller.redirectToPaperOptions2();             
            controller.drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c = 'RRA1';            
            controller.redirectToPaperOptions();controller.saveAndAdd();    
            controller.drugCoverage.Secondary_Force_to_Specialty__c = 'abc';
            controller.drugCoverage.Secondary_Speciality_Drug_List__c = null;
            controller.drugCoverage.Secondary_Aetna_Specialty_Care_Rx__c = 'Custom';           
            controller.redirectToPaperOptions();controller.saveAndAdd();                
            controller.drugCoverage.Secondary_Speciality_Drug_List__c = '01p50000000ToFI';
            controller.drugCoverage.Secondary_Force_to_Specialty__c = 'Yes';
            controller.drugCoverage.Secondary_of_fills_before_force_to_SPN__c = null;
            controller.redirectToPaperOptions();controller.saveAndAdd();  
            controller.drugCoverage.Secondary_Force_to_Specialty__c = 'No';
            controller.drugCoverage.Secondary_of_fills_before_force_to_SPN__c = 1232;
            controller.redirectToPaperOptions();controller.saveAndAdd();              
            controller.drugCoverage.Secondary_Force_to_Specialty__c = 'abc';            
            controller.redirectToPaperOptions();controller.saveAndAdd();                   
     
            controller.recordTypeValue=rt.get(0).id;
            controller.drugCoverage.Do_you_have_Choose_Generic__c = null;
            delete drugCoverateItem;
            drugCoverateItem.recordtypeid = rt.get(1).id;
            stCon = new ApexPages.standardController(drugCoverateItem);
            controller = new VFP_CRDDrugCoverageStep2 (stCon);
            controller.crdid = testCrd.id;            
            controller.crd.Plan_Type_Mail__c = true;
            
            controller.crd.Plan_Type_Retail__c  = true;
            controller.drugCoverage.Mandatory_Mail_Order_Option__c='Incentivized1';
            controller.drugCoverage.Co_Insurance_Percentage__c=10;
            controller.drugCoverage.Maximum_days_supply__c=10;
            controller.drugCoverage.Maximum_quantity__c=10;
            controller.drugCoverage.Rule_for_supply_quantity__c=null;
            //controller.recordTypeValue=rt.get(1).id;
            //controller.saveAndAdd();
            //controller.redirectToPaperOptions();controller.saveAndAdd();            
            controller.recordTypeValue=rt.get(0).id;
            controller.redirectToPaperOptions();controller.saveAndAdd();
            controller.drugCoverage.Do_you_have_Choose_Generic__c = 'abc';
            controller.drugCoverage.Maximum_days_supply__c = null;
            controller.crd.Retail_to_Mail__c = false;
            controller.drugCoverage.Brand_Penalty_Dollar_Amount__c = null;
            controller.drugCoverage.Mandatory_Mail_Order_Option__c = 'Mandatory';
            controller.crd.Insured_Type__c ='Self Insured';
            controller.redirectToPaperOptions();controller.saveAndAdd();
            controller.drugCoverage.Maintenance_Choice__c = 'Mandatory';
            controller.drugCoverage.Generic_Penalty_Type__c=null;
            controller.drugCoverage.Non_Pref_Brand_Penalty_Type__c=null;
            controller.drugCoverage.Generic_Penalty_Dollar_Amount__c=null;
            controller.drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c=null;
            controller.drugCoverage.Generic_Penalty_Percent__c=null;
            controller.drugCoverage.Non_Pref_Brand_Penalty_Percent__c=null;
            controller.drugCoverage.Gen_Penalty_Based_Retail_Mail_AWP__c=null;
            controller.drugCoverage.Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c=null;
            controller.drugCoverage.Generic_Penalty_Minimum_Dollar__c=null;
            controller.drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c=null;
            controller.drugCoverage.Generic_Penalty_Maximum_Dollar__c=null;
            controller.drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c=null;
            controller.drugCoverage.Brand_Penalty_Type__c=null;
            controller.drugCoverage.Brand_Penalty_Dollar_Amount__c=null;
            controller.drugCoverage.Brand_Penalty_Percent__c=null;
            controller.drugCoverage.Brand_Penalty_Based_Retail_Mail_AWP__c=null;
            controller.drugCoverage.Brand_Penalty_Minimum_Dollar__c=null;
            controller.drugCoverage.Brand_Penalty_Maximum_Dollar__c=null;            
            controller.redirectToPaperOptions();controller.saveAndAdd();            
            controller.drugCoverage.Maintenance_Choice__c = 'Mandatory1';
            controller.drugCoverage.Non_Pref_Brand_Penalty_Maximum_Dollar__c= 123;
            controller.drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c= 124;
            controller.redirectToPaperOptions();controller.saveAndAdd();                
            controller.drugCoverage.Maintenance_Choice__c = 'Incentivized';
            controller.drugCoverage.Generic_Penalty_Type__c = 'abc';
            controller.drugCoverage.Generic_Penalty_Dollar_Amount__c = 123;
            controller.drugCoverage.Brand_Penalty_Type__c= 'abc';
            controller.drugCoverage.Brand_Penalty_Dollar_Amount__c = 123;            
            controller.drugCoverage.Non_Pref_Brand_Penalty_Type__c = 'abc';
            controller.drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c = NULL; 
            controller.drugCoverage.Non_Pref_Brand_Penalty_Minimum_Dollar__c = NULL; 
            controller.drugCoverage.Non_Pref_Brand_Penalty_Percent__c = NULL ;
            controller.drugCoverage.Non_Pref_Brand_Penalty_Rtl_Mail_AWP__c = NULL;
            controller.redirectToPaperOptions();controller.saveAndAdd();     
            controller.drugCoverage.Non_Pref_Brand_Penalty_Type__c = null;
            controller.redirectToPaperOptions();controller.saveAndAdd();
            controller.drugCoverage.Non_Pref_Brand_Penalty_Percent__c = 123;
            controller.drugCoverage.Non_Pref_Brand_Penalty_Dollar_Amount__c = 123;
            controller.drugCoverage.Non_Pref_Brand_Penalty_Type__c = 'abc';
            controller.redirectToPaperOptions();controller.saveAndAdd();
            controller.drugCoverage.Non_Pref_Brand_Penalty_Type__c = null;
            controller.redirectToPaperOptions();controller.saveAndAdd();
            controller.drugCoverage.Brand_Penalty_Type__c = null;
            controller.redirectToPaperOptions();controller.saveAndAdd();
            
            controller.drugCoverage.Brand_Penalty_Type__c = 'abc';
            controller.redirectToPaperOptions();controller.saveAndAdd();
            controller.drugCoverage.Brand_Penalty_Dollar_Amount__c = NULL;
            controller.drugCoverage.Brand_Penalty_Minimum_Dollar__c = NULL;
            controller.drugCoverage.Brand_Penalty_Percent__c = NULL;
            controller.drugCoverage.Brand_Penalty_Based_Retail_Mail_AWP__c = NULL;            
            controller.redirectToPaperOptions();controller.saveAndAdd(); 
            controller.drugCoverage.Brand_Penalty_Type__c  = null;           
            controller.redirectToPaperOptions();controller.saveAndAdd(); 
            controller.drugCoverage.Generic_Penalty_Dollar_Amount__c = NULL ;
            controller.drugCoverage.Generic_Penalty_Minimum_Dollar__c = NULL ;
            controller.drugCoverage.Generic_Penalty_Percent__c = NULL ;
            controller.drugCoverage.Gen_Penalty_Based_Retail_Mail_AWP__c = NULL ;            
            controller.redirectToPaperOptions();controller.saveAndAdd(); 
            controller.drugCoverage.Generic_Penalty_Type__c             = null;
            controller.redirectToPaperOptions();controller.saveAndAdd(); 
            controller.drugCoverage.Brand_Penalty_Maximum_Dollar__c = 123;
            controller.drugCoverage.Brand_Penalty_Minimum_Dollar__c = 124;
            controller.redirectToPaperOptions();controller.saveAndAdd(); 
            controller.drugCoverage.Generic_Penalty_Maximum_Dollar__c= 123;
            controller.drugCoverage.Generic_Penalty_Minimum_Dollar__c= 124;
            controller.redirectToPaperOptions();controller.saveAndAdd(); 
            
            controller.drugCoverage.Generic_Penalty_Dollar_Amount__c= 123;
            controller.drugCoverage.Generic_Penalty_Percent__c= 124;
            controller.redirectToPaperOptions();controller.saveAndAdd();
            controller.drugCoverage.Generic_Penalty_Dollar_Amount__c= null;
            controller.drugCoverage.Generic_Penalty_Percent__c= null;
            controller.drugCoverage.Brand_Penalty_Dollar_Amount__c= null;
            controller.drugCoverage.Brand_Penalty_Percent__c= null;            
            controller.crd.Retail_to_Mail__c = true;
            controller.redirectToPaperOptions();controller.saveAndAdd();       
            controller.drugCoverage.Formulary_Open_Closed__c = null;     
            controller.redirectToPaperOptions();controller.saveAndAdd();       
            controller.drugCoverage.Maintenance_Choice__c = 'Mandatory';

            controller.redirectToPaperOptions();controller.saveAndAdd();
            controller.crd.Standard_or_Custom_Plan__c = 'Creating a HIX plan';       
            controller.userSelectionRecordTypeName = 'Retail';
            try{
                //controller.addDrugClassRecords();
            }
            catch(exception ex){
            }
            controller.drugcoverage.Generic_Penalty_Dollar_Amount__c = 10;
            controller.drugcoverage.Generic_Penalty_Percent__c = 10;
            controller.drugcoverage.Brand_Penalty_Dollar_Amount__c = 10;
            controller.drugcoverage.Brand_Penalty_Percent__c = 10;
            controller.redirectToPaperOptions();controller.saveAndAdd();
            
            controller.crd.Retail_to_Mail__c = true;            
            controller.userSelectionRecordTypeName = 'Mail';
            controller.drugcoverage.Generic_Penalty_Dollar_Amount__c = 10;
            controller.drugcoverage.Generic_Penalty_Percent__c = 10;
            controller.drugcoverage.Brand_Penalty_Dollar_Amount__c = 10;
            controller.drugcoverage.Brand_Penalty_Percent__c = 10;
            controller.redirectToPaperOptions();controller.saveAndAdd();
            }        
     static testMethod void myUnitTest3() {   
         CRD__c testCrd2 = new CRD__c();
            testCrd2.Standard_or_Custom_Plan__c = 'Creating a HIX plan';
            testCrd2.CRD_Automated__c = TRUE;
            testCrd2.Any_DAW_specific_Mail_copays__c = True;
            testCrd2.Plan_Type_Mail__c = True;
            insert testCrd2;
            DAW_Specific_Copay__c ds = new DAW_Specific_Copay__c();
            ds.CRD_ID__c = testCrd2.id;
            ds.Copay_Calculation__c = 'Greatest of All';
            ds.DAW_Code__c = '1';
            ds.Dollar_Amount__c = 10;
            ds.Minimum_Dollar__c = 9;
            ds.Stepped__C = True;
            insert ds;
            Copay_Tier__c copayTier = new Copay_Tier__c();       
            copayTier.CRD__c = testCrd2.id;
            copayTier.Percent__c=10;
            copayTier.Stepped_Copay__c = True;
            insert  copayTier;  
            
            SteppedCopay__c steppedCopay = new SteppedCopay__c();
            steppedCopay.Copay_Tier__c = copayTier.id;
            steppedCopay.Dollar_Amount__c=10;
            insert SteppedCopay;
            update testCrd2;
            System.debug('YYYY ' + testCrd2.Daw_Specific_Stepped_Copay_Count__c + ' ' + testCrd2.SteppedCopayCount__c);
            Formulary__c frm=new Formulary__c();
            frm.Formulary_Name__c='test';
            frm.Formulary_Description__c='test';
            frm.Effective_Date__c = system.today();
            frm.Termination_Date__c =system.today() +7;
            insert frm; 
                  
            Drug_Coverage__c drugCoverateItem1=new Drug_Coverage__c();
            drugCoverateItem1.Formulary__c=frm.id;
                  
            PageReference drugCoverage = Page.VF_CRDDrugCoverageStep2;
            drugCoverage.getParameters().put('crdid',testCrd2.id);    
            drugCoverage.getParameters().put('dcId',drugCoverateItem1.id);         
            Test.setCurrentPage(drugCoverage);         
            ApexPages.StandardController stCon = new ApexPages.standardController(drugCoverateItem1);
            VFP_CRDDrugCoverageStep2  controller = new VFP_CRDDrugCoverageStep2 (stCon);
            controller.redirectToPaperOptions2();
            controller.redirectToCopay2();
         }
    
      static testMethod void myUnitTest4() { 
        Id devRecordTypeId = Schema.SObjectType.Drug_Coverage__c.getRecordTypeInfosByName().get('Retail').getRecordTypeId(); 
        Id devRecordTypeId2 = Schema.SObjectType.Drug_Coverage__c.getRecordTypeInfosByName().get('Mail').getRecordTypeId();   
        CRD__c testCrd = new CRD__c();
            testCrd.Retail_to_Mail__c =True;
            testCrd.CRD_Automated__c = TRUE;
            testCrd.Plan_Type_Retail__c = TRUE;
            insert testCrd;
        
          Formulary__c frm=new Formulary__c();
            frm.Formulary_Name__c='test';
            frm.Formulary_Description__c='test';
            frm.Effective_Date__c = system.today();
            frm.Formulary_Open_Closed__c = 'open';
            frm.Termination_Date__c =system.today() +7;
            insert frm;
            string dcfrm = frm.Formulary_Open_Closed__c;      
            Drug_Coverage__c drugCoverateItem=new Drug_Coverage__c();
            drugCoverateItem.Formulary__c=frm.id;
            drugCoverateItem.CRD_ID__c = testCrd.id;
            system.debug('%%%%% ' + devRecordTypeId );
            drugCoverateItem.RecordTypeId=devRecordTypeId2;
            drugCoverateItem.Do_you_have_Choose_Generic__c ='Yes';
            drugCoverateItem.Choose_Generic_Copay_Diff_Exclusion__c='No';
            drugCoverateItem.Aetna_Specialty_Care_Rx__c = null;
            drugCoverateItem.Force_to_Specialty__c = null; 
            drugCoverateItem.Formulary_Open_Closed__c = 'open';
            insert drugCoverateItem;
            PageReference drugCoverage = Page.VF_CRDDrugCoverageStep2;
            drugCoverage.getParameters().put('crdid',testCrd.id);    
            drugCoverage.getParameters().put('dcId',drugCoverateItem.id);         
            Test.setCurrentPage(drugCoverage);         
            ApexPages.StandardController stCon = new ApexPages.standardController(drugCoverateItem);
            VFP_CRDDrugCoverageStep2  controller = new VFP_CRDDrugCoverageStep2 (stCon);  
            controller.recordTypeValue = devRecordTypeId;
            controller.redirectToPaperOptions();
        }
             
    }