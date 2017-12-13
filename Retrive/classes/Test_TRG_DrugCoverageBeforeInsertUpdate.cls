@isTest (SeeAllData=False)

private class Test_TRG_DrugCoverageBeforeInsertUpdate
{    
  static testMethod void testDrugCoverageBeforeInsertUpdate() 
    {     
        CRD__c newCRD = new CRD__c();
        Drug_Coverage__c drugCoverateItem=new Drug_Coverage__c();
        waiver_of_deductible__C wd=new waiver_of_deductible__C();
        list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where sobjecttype='Drug_Coverage__c' and developername='Retail']);
           
        newCRD.CRD_Automated__c = True; 
        newCRD.Are_you_creating_a_Package_Plan__c = 'No';
        newCRD.Plan_Platform__c = 'Traditional/PPO';
        newCRD.Control__c = '123455';
        newCRD.Plan__c = 'CB';
        newCRD.Sub_segment__c = 'ASB';
        newCRD.Platform_Information__c = 'T';
        newCRD.Predefined__c = True;
        newCRD.Retail_to_Mail__c =True; 
        newCRD.Do_you_want_to_do_Save_A_Copay__c='Yes';
        newCRD.SAC_Override_Option__c = 'Yes';
        newCRD.crd_automated__c = FALSE;
        insert newCRD;
               
        wd.Drug_Class__c='1 - FOR GENERIC DRUGS AND DIABETIC DRUGS AND SUPPLIES';
        wd.CRD_ID__c=newCRD.id;
        insert wd;

        Formulary__c formularyobj= new Formulary__c();
        formularyobj.Formulary_Name__c= 'New formulary';
        formularyobj.Formulary_Open_Closed__c='Open';
        insert formularyobj;
        
        drug_list__c dl = new drug_list__c();
        dl.recordtype = [Select Id From RecordType where name = 'Drug List' and sobjecttype = 'Drug_list__c' LIMIT 1];
        dl.inactive__c = false;
        dl.Special_Use__c = 'Specialty List';
        insert dl;
        
        drugCoverateItem.CRD_ID__c = newCRD.id;
        drugCoverateItem.RecordTypeId=rt.get(0).id;
        drugCoverateItem.Do_you_have_Choose_Generic__c ='Yes';
        drugCoverateItem.Choose_Generic_Copay_Diff_Exclusion__c='No';
        //drugCoverateItem.Secondary_of_Fills_before_Force_to_MOD__c= 12;
        drugCoverateItem.Aetna_Specialty_Care_Rx__c='Applies-Expanded List';
        drugCoverateItem.Secondary_Aetna_Specialty_Care_Rx__c ='Does not Apply (Insured/not state filed)';
        drugCoverateItem.formulary__c=formularyobj.id;
        drugCoverateItem.Do_you_have_Specialty__c = 'NO';
        drugCoverateItem.Formulary_Open_Closed__c='Open';
        drugCoverateItem.Force_to_Specialty__c= 'No';
        drugCoverateItem.Mandatory_Mail_Order_Option__c = 'Incentivized';
        drugCoverateItem.Incent_Mail_NonPref_Brand_Penalty_Type__c = 'Apply Penalty Only';
        drugCoverateItem.Incentivized_Mail_Brand_Penalty_Type__c = 'Apply Penalty Only';
        drugCoverateItem.Incentivized_Mail_Brand_Penalty_Amount__c = 25;
        drugCoverateItem.Incent_Mail_NonPref_Brand_Penalty_Amount__c = 25;
        drugcoverateitem.Incentivized_Mail_Generic_Penalty_Type__c = 'Apply Penalty Only'; 
        drugcoverateItem.Incentivized_Mail_Generic_Penalty_Amount__c = 25;
        drugcoverateItem.Secondary_Speciality_Drug_List__c = dl.id;
        insert drugCoverateItem;
        
        
        Formulary__c formularyobj1= new Formulary__c();
        formularyobj1.Formulary_Name__c= 'New formulary';
        formularyobj1.Formulary_Open_Closed__c='Closed';
        insert formularyobj1;
             
        drugCoverateItem.formulary__c=formularyobj1.id;
        drugCoverateItem.Formulary_Open_Closed__c='Closed';
        drugCoverateItem.Secondary_Aetna_Specialty_Care_Rx__c ='Custom';
        drugCoverateItem.Secondary_of_Fills_before_Force_to_MOD__c = NULL;
        drugCoverateItem.Secondary_Force_to_Specialty__c='No';
        update drugCoverateItem;
        
        Drug_Coverage__c drugCoverateItem2=new Drug_Coverage__c();
        drugCoverateItem2.CRD_ID__c = newCRD.id;
        drugCoverateItem2.RecordTypeId=rt.get(0).id;
        drugCoverateItem2.Do_you_have_Specialty__c = 'Yes';
        drugCoverateItem2.Force_to_Specialty__c= 'Yes';
        drugCoverateItem2.of_fills_before_force_to_specialty__c = 2;
        drugCoverateItem2.Secondary_Aetna_Specialty_Care_Rx__c ='Does not Apply (Insured/not state filed)';
        //drugCoverateItem2.Secondary_of_Fills_before_Force_to_MOD__c = 3;
        drugCoverateItem2.Aetna_Specialty_Care_Rx__c = 'Applies-Expanded List w/ Fertility';
        insert drugCoverateItem2;
        drugCoverateItem2.Aetna_Specialty_Care_Rx__c = 'Applies-Expanded List';
        update drugCoverateItem2;
        drugCoverateItem2.Aetna_Specialty_Care_Rx__c = 'Applies-Expanded List w/ Fertility';
        update drugCoverateItem2;
        drugCoverateItem2.Aetna_Specialty_Care_Rx__c = 'Applies -Self Injectables List Only';
        update drugCoverateItem2;
        drugCoverateItem2.Aetna_Specialty_Care_Rx__c = 'Applies -Self Injectables List Only w/Fertility';
        update drugCoverateItem2;
        drugCoverateItem2.Aetna_Specialty_Care_Rx__c = 'Applies-SG Value with Fertility';
        update drugCoverateItem2;
        drugCoverateItem2.Aetna_Specialty_Care_Rx__c = 'Applies-SG Value no Fertility';
        update drugCoverateItem2;
        drugCoverateItem2.Aetna_Specialty_Care_Rx__c = 'Applies-SG Value Plus with Fertility';
        update drugCoverateItem2;
    }
        
        static testMethod void testDrugCoverageBeforeInsertUpdateA() {
         
        CRD__c newCRD = new CRD__c();
        Drug_Coverage__c drugCoverateItem3=new Drug_Coverage__c();
        waiver_of_deductible__C wd=new waiver_of_deductible__C();
        list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where sobjecttype='Drug_Coverage__c' and developername='Retail']);
           
        newCRD.CRD_Automated__c = True; 
        newCRD.Are_you_creating_a_Package_Plan__c = 'No';
        newCRD.Plan_Platform__c = 'Traditional/PPO';
        newCRD.Control__c = '123455';
        newCRD.Plan__c = 'CB';
        newCRD.Sub_segment__c = 'ASB';
        newCRD.Platform_Information__c = 'T';
        newCRD.Predefined__c = True;
        newCRD.Retail_to_Mail__c =True; 
        newCRD.Do_you_want_to_do_Save_A_Copay__c='Yes';
        newCRD.SAC_Override_Option__c = 'Yes';
        newCRD.crd_automated__c = FALSE;
        insert newCRD;
               
        wd.Drug_Class__c='1 - FOR GENERIC DRUGS AND DIABETIC DRUGS AND SUPPLIES';
        wd.CRD_ID__c=newCRD.id;
        insert wd;

        Formulary__c formularyobj= new Formulary__c();
        formularyobj.Formulary_Name__c= 'New formulary';
        formularyobj.Formulary_Open_Closed__c='Open';
        insert formularyobj;
        
        drug_list__c dl1 = new drug_list__c();
        dl1.recordtype = [Select Id From RecordType where name = 'Drug List' and sobjecttype = 'Drug_list__c' LIMIT 1];
        dl1.inactive__c = false;
        dl1.Special_Use__c = 'Specialty List';
        insert dl1;
            
        drugCoverateItem3.CRD_ID__c = newCRD.id;
        drugCoverateItem3.RecordTypeId=rt.get(0).id;
        drugCoverateItem3.Do_you_have_Specialty__c = 'Yes';
        drugCoverateItem3.Force_to_Specialty__c= 'Yes';
        drugCoverateItem3.of_fills_before_force_to_specialty__c = 2;
        drugCoverateItem3.Secondary_Aetna_Specialty_Care_Rx__c ='Does not Apply (Insured/not state filed)';
        //drugCoverateItem3.Secondary_of_Fills_before_Force_to_MOD__c = 3;
        drugCoverateItem3.Aetna_Specialty_Care_Rx__c = 'Applies-SG Value Plus no Fertility';
        drugCoverateItem3.Secondary_Speciality_Drug_List__c = dl1.id;
        insert drugCoverateItem3;
        drugCoverateItem3.Aetna_Specialty_Care_Rx__c = 'Applies-LG Value with Fertility';
        update drugCoverateItem3;
        drugCoverateItem3.Aetna_Specialty_Care_Rx__c = 'Applies-LG Value no Fertility';
        update drugCoverateItem3;
        drugCoverateItem3.Aetna_Specialty_Care_Rx__c = 'Applies-LG Value Plus with Fertility';
        update drugCoverateItem3;
        drugCoverateItem3.Aetna_Specialty_Care_Rx__c = 'Applies-LG Value Plus no Fertility';
        update drugCoverateItem3;
        drugCoverateItem3.Aetna_Specialty_Care_Rx__c = 'Applies-LG Premier with Fertility';
        update drugCoverateItem3;
        drugCoverateItem3.Aetna_Specialty_Care_Rx__c = 'Applies-LG Premier Plus with Fertility';
        update drugCoverateItem3;
        drugCoverateItem3.Aetna_Specialty_Care_Rx__c = 'Applies-LG Premier Plus no Fertility';
        update drugCoverateItem3;
        drugCoverateItem3.Aetna_Specialty_Care_Rx__c = 'Applies-LG Premier no Fertility';
        update drugCoverateItem3;
        
    }
    
    static testMethod void testDrugCoverageBeforeInsertUpdateB() {
         
        CRD__c newCRD = new CRD__c();
        Drug_Coverage__c drugCoverateItem4=new Drug_Coverage__c();
        waiver_of_deductible__C wd=new waiver_of_deductible__C();
        list <RecordType> rt= new list<RecordType>([Select Id,Name from RecordType where sobjecttype='Drug_Coverage__c' and developername='Retail']);
           
        newCRD.CRD_Automated__c = True; 
        newCRD.Are_you_creating_a_Package_Plan__c = 'No';
        newCRD.Plan_Platform__c = 'Traditional/PPO';
        newCRD.Control__c = '123455';
        newCRD.Plan__c = 'CB';
        newCRD.Sub_segment__c = 'ASB';
        newCRD.Platform_Information__c = 'T';
        newCRD.Predefined__c = True;
        newCRD.Retail_to_Mail__c =True; 
        newCRD.Do_you_want_to_do_Save_A_Copay__c='Yes';
        newCRD.SAC_Override_Option__c = 'Yes';
        newCRD.crd_automated__c = FALSE;
        insert newCRD;
               
        wd.Drug_Class__c='1 - FOR GENERIC DRUGS AND DIABETIC DRUGS AND SUPPLIES';
        wd.CRD_ID__c=newCRD.id;
        insert wd;

        Formulary__c formularyobj= new Formulary__c();
        formularyobj.Formulary_Name__c= 'New formulary';
        formularyobj.Formulary_Open_Closed__c='Open';
        insert formularyobj;
        
        drug_list__c dl2 = new drug_list__c();
        dl2.recordtype = [Select Id From RecordType where name = 'Drug List' and sobjecttype = 'Drug_list__c' LIMIT 1];
        dl2.inactive__c = false;
        dl2.Special_Use__c = 'Specialty List';
        insert dl2;
            
        drugCoverateItem4.CRD_ID__c = newCRD.id;
        drugCoverateItem4.RecordTypeId=rt.get(0).id;
        drugCoverateItem4.Do_you_have_Specialty__c = 'Yes';
        drugCoverateItem4.Force_to_Specialty__c= 'Yes';
        drugCoverateItem4.of_fills_before_force_to_specialty__c = 2;
        drugCoverateItem4.Secondary_Aetna_Specialty_Care_Rx__c ='Does not Apply (Insured/not state filed)';
        //drugCoverateItem4.Secondary_of_Fills_before_Force_to_MOD__c = 3;
        drugCoverateItem4.Aetna_Specialty_Care_Rx__c = 'Applies-SG Value Plus no Fertility';
        drugCoverateItem4.Secondary_Speciality_Drug_List__c = dl2.id;
        insert drugCoverateItem4;
        drugCoverateItem4.Secondary_of_Fills_before_Force_to_MOD__c = Null;
        drugCoverateItem4.Secondary_Aetna_Specialty_Care_Rx__c = 'Applies-Expanded List';
        update drugCoverateItem4;
        drugCoverateItem4.Secondary_Aetna_Specialty_Care_Rx__c = 'Applies-Expanded List w/ Fertility';
        update drugCoverateItem4;
        drugCoverateItem4.Secondary_Aetna_Specialty_Care_Rx__c = 'Applies -Self Injectables List Only';
        update drugCoverateItem4;
        drugCoverateItem4.Secondary_Aetna_Specialty_Care_Rx__c = 'Applies -Self Injectables List Only w/Fertility';
        update drugCoverateItem4;
        
    }
    
   static testMethod void testDrugCoverageBeforeInsertUpdate1() 
   {
        
       
      Drug_Coverage__c d=new Drug_Coverage__c();
      list<drug_coverage__C> drugList=new list<drug_coverage__C>();
      
          d.Standard_Refill_too_Soon__c='No';  
          d.Aetna_Specialty_Care_Rx__c='Does not Apply (Insured/not state filed)';
           d.Aetna_Specialty_Care_Rx__c='Applies-Expanded List w/ Fertility';
          d.Aetna_Specialty_Care_Rx__c='Applies-Expanded List';
          d.Aetna_Specialty_Care_Rx__c='Applies -Self Injectables List Only w/Fertility';
            d.Aetna_Specialty_Care_Rx__c='Applies-SG Value with Fertility';
            d.Aetna_Specialty_Care_Rx__c='Applies-SG Value no Fertility';
            d.Aetna_Specialty_Care_Rx__c='Applies-SG Value Plus with Fertility';
            d.Aetna_Specialty_Care_Rx__c='Applies-SG Value Plus no Fertility';
            d.Aetna_Specialty_Care_Rx__c='Applies-LG Value with Fertility';
            d.Aetna_Specialty_Care_Rx__c='Applies-LG Value no Fertility';
            d.Aetna_Specialty_Care_Rx__c='Applies-LG Value Plus with Fertility';
            d.Aetna_Specialty_Care_Rx__c='Applies-LG Value Plus no Fertility';
            d.Aetna_Specialty_Care_Rx__c='Applies-LG Premier Plus with Fertility';
            d.Aetna_Specialty_Care_Rx__c='Applies-LG Premier Plus no Fertility';
           d.Do_you_have_Specialty__c='No';

          insert d;
         drug_coverage__C d1=[select formulary__c from drug_coverage__C where Standard_Refill_too_Soon__c='No' limit 1];
            d.formulary__c=d1.formulary__c;   
            
     
      } 
      
      
        static testMethod void testupdate2() 
   {
       RecordType rt1= [Select Id,Name from RecordType where sobjecttype='Clinical_Program_Group__c' and name='Save-A-Copay'];  
       Clinical_Program_Group__c cp=new Clinical_Program_Group__c();
       cp.Clinical_Program_Group_Name__c='Test';
       cp.RecordTypeId=rt1.id; 
       cp.Inactive__c=false;
       cp.Funding__c = 'Self Insured';
       cp.Clinical_Program_Group_Description__c='Test1';
       cp.Effective_Date__c=Date.today();
       cp.Termination_Date__c=Date.today();
       insert cp;    
     
      } 
      
        static testMethod void testupdate3() 
   {
         Waiver_Of_Deductible_Drug_Class__c drugClass=new Waiver_Of_Deductible_Drug_Class__c();
         drugClass.Delivery_System__c='Retail';
             insert drugClass; 
        
     
      } 
       
        static testMethod void testupdate4() 
   {
       drug_list__c dlist=new drug_list__c();
         dlist.Additional_Criteria__c='Yes';
             insert dlist;  
        
     
      } 
      
      
}