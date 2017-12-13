//Purpose: Apex Test Class to test CMMNotificationService webservice class

@isTest   
 
private class Test_CMMNotificationService
{
    //Function to test null value scenario
    static testMethod void testCMMNull()
    {
        date mydate = date.parse('01/01/2015');
        CMMNotificationService.getBenefitDetails('', 0899023, mydate, 'Sample');
    }
    
    //Function to test CMM complete functionality with Retail DC
    static testMethod void testCMM()
    {
        date mydate = date.parse('01/01/2015');
        Id dcId = Schema.SObjectType.Drug_Coverage__c.RecordTypeInfosByName.get('Retail').RecordTypeId;
        
        Account acc= new Account();
        acc.Name = 'IVL Public Exchange';
        insert acc;
        
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '0899023';
        pcg.CSAP_Plan_ID__c = 'AB';
        insert pcg;
        
        CRD__c crd = new CRD__c();
        crd.Effective_Start_Date__c = mydate ;
        crd.Archived__c = False;
        crd.Account__c = acc.id;
        crd.National__c = 'Individual';
        crd.Plan_Type_Retail__c = True;
        insert crd ;
        
        crd.Status__c = 'XML & Case Generated. CRD Complete.';
        update crd;
        
        CRD__c crd1 = new CRD__c();
        crd1.Effective_Start_Date__c = mydate ;
        crd1.Archived__c = False;
        insert crd1 ;
        
        crd1.Status__c = 'XML & Case Generated. CRD Complete.';
        update crd1;
        
        
        CSAP_CGLP_Junction__c csap = new CSAP_CGLP_Junction__c();
        csap.Partial_Control_Group__c = pcg.id;
        csap.CRD__c = crd.id;
        insert csap;
        
        Drug_Coverage__c dc = new Drug_Coverage__c();
        dc.CRD_ID__c = crd.id;
        dc.RecordTypeId = dcId;
        dc.Aetna_Specialty_Care_Rx__c = 'Test';
        dc.Force_to_Specialty__c = 'Yes';
        dc.of_fills_before_force_to_specialty__c = 2;
        dc.Do_you_have_Specialty__c = 'Yes';
        insert dc;
        
        DC_Drug_List_Group__c dcdl = new DC_Drug_List_Group__c();
        dcdl.Related_Drug_Coverage__c = dc.id;
        dcdl.Drug_List__c = System.Label.Drug_List_Fertility_Inj ;
        dcdl.Inclusion_Exclusion__c = 'Exclude';
        insert dcdl;
        
        DC_Drug_List_Group__c dcdl1 = new DC_Drug_List_Group__c();
        dcdl1.Related_Drug_Coverage__c = dc.id;
        dcdl1.Drug_List__c = System.Label.Drug_List_Fertility_oral ;
        dcdl1.Inclusion_Exclusion__c = 'Exclude';
        insert dcdl1;
        
        CMMNotificationService.getBenefitDetails('AB', 0899023, mydate, 'Sample');
    }
    
    //Function to test pkg with no CRD scenario
    static testMethod void testCMM1()
    {
        date mydate = date.parse('01/01/2015');
        
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '0899023';
        pcg.CSAP_Plan_ID__c = 'AB';
        insert pcg;
        
        CRD__c crd = new CRD__c();
        crd.Effective_Start_Date__c = mydate ;
        crd.Status__c = 'In Progress';
        crd.Archived__c = False;
        insert crd ;
        
        
        CSAP_CGLP_Junction__c csap = new CSAP_CGLP_Junction__c();
        csap.Partial_Control_Group__c = pcg.id;
        csap.CRD__c = crd.id;
        insert csap;
        
        CMMNotificationService.getBenefitDetails('AB', 0899023, mydate, 'Sample');
    }
    
    //Function to test CMM with CRD and Do_you_have_Specialty__c = No and Account != IVL Public Exchange
    static testMethod void testCMM2()
    {
        date mydate = date.parse('01/01/2015');
        Id dcId = Schema.SObjectType.Drug_Coverage__c.RecordTypeInfosByName.get('Retail').RecordTypeId;
        Id dcId1 = Schema.SObjectType.Drug_Coverage__c.RecordTypeInfosByName.get('Mail').RecordTypeId;
            
        Account acc= new Account();
        acc.Name = 'Test';
        insert acc;
        
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '0899023';
        pcg.CSAP_Plan_ID__c = 'AB';
        insert pcg;
        
        CRD__c crd = new CRD__c();
        crd.Effective_Start_Date__c = mydate ;
        crd.Archived__c = False;
        crd.Account__c = acc.id;
        crd.National__c = 'Individual';
        crd.Plan_Type_Retail__c = True;
        insert crd ;
        
        crd.Status__c = 'XML & Case Generated. CRD Complete.';
        update crd;
        
        
        CSAP_CGLP_Junction__c csap = new CSAP_CGLP_Junction__c();
        csap.Partial_Control_Group__c = pcg.id;
        csap.CRD__c = crd.id;
        insert csap;
        
        Drug_Coverage__c dc = new Drug_Coverage__c();
        dc.CRD_ID__c = crd.id;
        dc.RecordTypeId = dcId;
        dc.Aetna_Specialty_Care_Rx__c = 'Test';
        dc.Force_to_Specialty__c = 'No';
        dc.Do_you_have_Specialty__c = 'No';
        insert dc;
        
        CMMNotificationService.getBenefitDetails('AB', 0899023, mydate, 'Sample');
    }
    
    //Function to test CMM with CRD and National != Individual
    static testMethod void testCMM3()
    {
        date mydate = date.parse('01/01/2015');
        Id dcId = Schema.SObjectType.Drug_Coverage__c.RecordTypeInfosByName.get('Retail').RecordTypeId;
        Id dcId1 = Schema.SObjectType.Drug_Coverage__c.RecordTypeInfosByName.get('Mail').RecordTypeId;
            
                
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '0899023';
        pcg.CSAP_Plan_ID__c = 'AB';
        insert pcg;
        
        CRD__c crd = new CRD__c();
        crd.Effective_Start_Date__c = mydate ;
        crd.Archived__c = False;
        crd.National__c = 'Test';
        crd.Plan_Type_Retail__c = True;
        insert crd ;
        
        crd.Status__c = 'XML & Case Generated. CRD Complete.';
        update crd;
        
        
        CSAP_CGLP_Junction__c csap = new CSAP_CGLP_Junction__c();
        csap.Partial_Control_Group__c = pcg.id;
        csap.CRD__c = crd.id;
        insert csap;
        
        Drug_Coverage__c dc = new Drug_Coverage__c();
        dc.CRD_ID__c = crd.id;
        dc.RecordTypeId = dcId;
        dc.Aetna_Specialty_Care_Rx__c = 'Test';
        dc.Force_to_Specialty__c = 'No';
        dc.Do_you_have_Specialty__c = 'No';
        insert dc;
        
        CMMNotificationService.getBenefitDetails('AB', 0899023, mydate, 'Sample');
    }
    
    //Function to test CMM complete functionality with Mail DC
    static testMethod void testCMM4()
    {
        date mydate = date.parse('01/01/2015');
        Id dcId1 = Schema.SObjectType.Drug_Coverage__c.RecordTypeInfosByName.get('Mail').RecordTypeId;
        
        Account acc= new Account();
        acc.Name = 'IVL Public Exchange';
        insert acc;
        
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '0899023';
        pcg.CSAP_Plan_ID__c = 'AB';
        insert pcg;
        
        CRD__c crd = new CRD__c();
        crd.Effective_Start_Date__c = mydate ;
        crd.Archived__c = False;
        crd.Account__c = acc.id;
        crd.National__c = 'Individual';
        crd.Plan_Type_Retail__c = True;
        insert crd ;
        
        crd.Status__c = 'XML & Case Generated. CRD Complete.';
        update crd;
        
        
        CSAP_CGLP_Junction__c csap = new CSAP_CGLP_Junction__c();
        csap.Partial_Control_Group__c = pcg.id;
        csap.CRD__c = crd.id;
        insert csap;
        
        Drug_Coverage__c dc = new Drug_Coverage__c();
        dc.CRD_ID__c = crd.id;
        dc.RecordTypeId = dcId1;
        dc.Aetna_Specialty_Care_Rx__c = 'Test';
        dc.Force_to_Specialty__c = 'Yes';
        dc.of_fills_before_force_to_specialty__c = 2;
        dc.Do_you_have_Specialty__c = 'Yes';
        insert dc;
        
        DC_Drug_List_Group__c dcdl = new DC_Drug_List_Group__c();
        dcdl.Related_Drug_Coverage__c = dc.id;
        dcdl.Drug_List__c = System.Label.Drug_List_Fertility_Inj ;
        dcdl.Inclusion_Exclusion__c = 'Exclude';
        insert dcdl;
        
        DC_Drug_List_Group__c dcdl1 = new DC_Drug_List_Group__c();
        dcdl1.Related_Drug_Coverage__c = dc.id;
        dcdl1.Drug_List__c = System.Label.Drug_List_Fertility_oral ;
        dcdl1.Inclusion_Exclusion__c = 'Exclude';
        insert dcdl1;
        
        CMMNotificationService.getBenefitDetails('AB', 0899023, mydate, 'Sample');
    }
    
    //Function to test CMM complete functionality with Retail DC and DCDL - Inclusion_Exclusion = 'Include'
    static testMethod void testCMM5()
    {
        date mydate = date.parse('01/01/2015');
        Id dcId = Schema.SObjectType.Drug_Coverage__c.RecordTypeInfosByName.get('Retail').RecordTypeId;
        
        Account acc= new Account();
        acc.Name = 'IVL Public Exchange';
        insert acc;
        
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '0899023';
        pcg.CSAP_Plan_ID__c = 'AB';
        insert pcg;
        
        CRD__c crd = new CRD__c();
        crd.Effective_Start_Date__c = mydate ;
        crd.Archived__c = False;
        crd.Account__c = acc.id;
        crd.National__c = 'Individual';
        crd.Plan_Type_Retail__c = True;
        insert crd ;
        
        crd.Status__c = 'XML & Case Generated. CRD Complete.';
        update crd;
        
        CRD__c crd1 = new CRD__c();
        crd1.Effective_Start_Date__c = mydate ;
        crd1.Archived__c = False;
        insert crd1 ;
        
        crd1.Status__c = 'XML & Case Generated. CRD Complete.';
        update crd1;
        
        
        CSAP_CGLP_Junction__c csap = new CSAP_CGLP_Junction__c();
        csap.Partial_Control_Group__c = pcg.id;
        csap.CRD__c = crd.id;
        insert csap;
        
        Drug_Coverage__c dc = new Drug_Coverage__c();
        dc.CRD_ID__c = crd.id;
        dc.RecordTypeId = dcId;
        dc.Aetna_Specialty_Care_Rx__c = 'Test';
        dc.Force_to_Specialty__c = 'Yes';
        dc.of_fills_before_force_to_specialty__c = 2;
        dc.Do_you_have_Specialty__c = 'Yes';
        insert dc;
        
        DC_Drug_List_Group__c dcdl = new DC_Drug_List_Group__c();
        dcdl.Related_Drug_Coverage__c = dc.id;
        dcdl.Drug_List__c = System.Label.Drug_List_Fertility_Inj ;
        dcdl.Inclusion_Exclusion__c = 'Include';
        insert dcdl;
        
        DC_Drug_List_Group__c dcdl1 = new DC_Drug_List_Group__c();
        dcdl1.Related_Drug_Coverage__c = dc.id;
        dcdl1.Drug_List__c = System.Label.Drug_List_Fertility_oral ;
        dcdl1.Inclusion_Exclusion__c = 'Include';
        insert dcdl1;
        
        CMMNotificationService.getBenefitDetails('AB', 0899023, mydate, 'Sample');
    }
    
    
    //Function to test Trad pkg scenario without CRD
    static testMethod void testCMMtrad()
    {
        date mydate = date.parse('01/01/2015');
        
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '999023';
        pcg.CSAP_Plan_ID__c = 'A';
        insert pcg;
        
        ControlPlanRxPlan__c cp = new ControlPlanRxPlan__c();
        cp.Control__c =  '899023';
        cp.Plan__c = 'AB';
        cp.Key__c = 'testtrad';
        insert cp;
        
        ControlPlanRxPlan__c cp1 = new ControlPlanRxPlan__c();
        cp1.Control__c =  '899023';
        cp1.Plan__c = 'AB';
        cp1.Key__c = 'testtrad1';
        insert cp1;


        
        CMMNotificationService.getBenefitDetails('AB', 899023, mydate, 'Sample');
    }
    
    //Function to test Trad pkg scenario without CRD
    static testMethod void testCMMtrad1()
    {
        date mydate = date.parse('01/01/2015');
        
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '999023';
        pcg.CSAP_Plan_ID__c = 'A';
        insert pcg;
        
        ControlPlanRxPlan__c cp = new ControlPlanRxPlan__c();
        cp.Control__c =  '899023';
        cp.Plan__c = 'AB';
        cp.Key__c = 'testtrad';
        insert cp;
        
        CRD__c crd = new CRD__c();
        crd.Effective_Start_Date__c = mydate ;
        crd.Status__c = 'XML & Case Generated. CRD Complete.';
        crd.Archived__c = False;
        insert crd ;
        
        ControlPlanRxPlan__c cp1 = new ControlPlanRxPlan__c();
        cp1.Control__c =  '899023';
        cp1.Plan__c = 'AB';
        cp1.Key__c = 'testtrad1';
        cp1.CRD__c = crd.id;
        insert cp1;
        
        
        CMMNotificationService.getBenefitDetails('AB', 899023, mydate, 'Sample');
    }
    
    //Function to test Trad pkg scenario with CRD
    static testMethod void testCMMtrad2()
    {
        date mydate = date.parse('01/01/2015');
        
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '999023';
        pcg.CSAP_Plan_ID__c = 'A';
        insert pcg;
        
        ControlPlanRxPlan__c cp = new ControlPlanRxPlan__c();
        cp.Control__c =  '899023';
        cp.Plan__c = 'AB';
        cp.Key__c = 'testtrad';
        insert cp;
        
        CRD__c crd = new CRD__c();
        crd.Effective_Start_Date__c = mydate ;
        crd.Archived__c = False;
        insert crd ;
        
        crd.Status__c = 'XML & Case Generated. CRD Complete.';
        update crd;
        
        ControlPlanRxPlan__c cp1 = new ControlPlanRxPlan__c();
        cp1.Control__c =  '899023';
        cp1.Plan__c = 'AB';
        cp1.Key__c = 'testtrad1';
        cp1.CRD__c = crd.id;
        insert cp1;
        
        
        CMMNotificationService.getBenefitDetails('AB', 899023, mydate, 'Sample');
    }
    
    //Function to test Trad pkg scenario without ControlPlanRxPlan
    static testMethod void testCMMtrad3()
    {
        date mydate = date.parse('01/01/2015');
        
        Partial_Control_Group__c pcg = new Partial_Control_Group__c();
        pcg.CSAP_Control_ID__c = '999023';
        pcg.CSAP_Plan_ID__c = 'A';
        insert pcg;
        
        ControlPlanRxPlan__c cp = new ControlPlanRxPlan__c();
        cp.Control__c =  '999023';
        cp.Plan__c = 'AB';
        cp.Key__c = 'testtrad';
        insert cp;
        
        

        
        CMMNotificationService.getBenefitDetails('AB', 899023, mydate, 'Sample');
    }



}