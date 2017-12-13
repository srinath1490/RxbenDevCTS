@isTest
private class Test_GMFBuilderUtil {
    
    @testSetup static void methodName() { 
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        case c = new case(subject ='TestData');
        c.status = 'Ready to Send';insert c;
        //Test Data Utility Class
        GC_UtilityClassTestData testdata = new GC_UtilityClassTestData();
        // Drug List Creation   Drug List
        Drug_List__c DL=testdata.createDrugList();
        DL.Description__c = 'Test_GMFBuilderUtilDL1';
        DL.Drug_List_Name__c= 'Test_GMFBuilderUtilDL1';
        DL.recordtypeID = Schema.SObjectType.Drug_List__c.getRecordTypeInfosByName().get('Drug List').getRecordTypeId();
		insert DL;
        
        // Drug List Creation   Step Therapy
        Drug_List__c DL_ST=testdata.createDrugList();
        DL_ST.Description__c = 'Test_GMFBuilderUtilDL_ST1';
        DL_ST.Drug_List_Name__c= 'Test_GMFBuilderUtilDL_ST1';
        DL_ST.Inactive__c=false;
        DL_ST.recordtypeID = Schema.SObjectType.Drug_List__c.getRecordTypeInfosByName().get('Step Therapy').getRecordTypeId();
		insert DL_ST;
        
        // Drug Group Creation
        Drug_Group__c DG=testdata.createDrugGroup();
        DG.Drug_Group_Name__c= 'Test_GMFBuilderUtilDG1';
        DG.Description__c = 'Test_GMFBuilderUtilDG1'; insert DG;
        //Drug List Junction
        Drug_List_Junction__c DLJ=testdata.createDrugListJunction(DG.id,DL.id); insert DLJ;
        // Formulary 
        Formulary__c F=testdata.newFormulary();
        F.Formulary_Name__c = 'Test_GMFBuilderUtilF1';
        F.Formulary_Description__c ='Test_GMFBuilderUtilF1';insert F;
        //Option Code Option_Code__c newoptionCode()
        Option_Code__c OC=testdata.newoptionCode();
        OC.Option_Code_Name__c='TOC1';        
        OC.Option_Code_Description__c ='Test_GMFBuilderUtilOC1'; insert OC;
        //Formulary List    
        Formulary_List__c FL=testdata.newFormularyList(OC.id);
        FL.Formulary_List_Name__c ='Test_GMFBuilderUtilFL1';
        FL.Formulary_List_Description__c ='Test_GMFBuilderUtilFL1'; insert FL;
        //Formulary Junction 
        Formulary_Junction__c FJ=testdata.createFormularyJunction(FL.id,F.id); insert FJ;
        //Formulary List Entry
        Formulary_List_Entry__c FLE=testdata.newFormularyListEntry(1);
        FLE.Formulary_List__c=FL.id;
        FLE.GPI__c='519900032067*';
        insert FLE;
        //Clinical Program Save_A_Copay
        Clinical_Program__c CP_SAC=testdata.createClinicalPrograme('Save-A-Copay');
        CP_SAC.RecordTypeId = Schema.SObjectType.Clinical_Program__c.getRecordTypeInfosByName().get('Save-A-Copay').getRecordTypeId();
		CP_SAC.Standard__c =true;
        CP_SAC.Description__c = 'Test_GMFBuilderUtilCP_SAC1';
        CP_SAC.Clinical_Programs_Name__c = 'Test_GMFBuilderUtilCP_SAC1'; insert CP_SAC;
        //Clinical Program Prescription_Savings_Program
        Clinical_Program__c CP_PSP=testdata.createClinicalPrograme('Prescription Savings Program');
        CP_PSP.RecordTypeId = Schema.SObjectType.Clinical_Program__c.getRecordTypeInfosByName().get('Prescription Savings Program').getRecordTypeId();
		CP_PSP.Standard__c =true;
        CP_PSP.Description__c = 'Test_GMFBuilderUtilCP_PSP1';
        CP_PSP.Clinical_Programs_Name__c = 'Test_GMFBuilderUtilCP_PSP1'; insert CP_PSP;
        //Clinical Program Group Save-A-Copay
        Clinical_Program_Group__c CPG_SAC=testdata.creteProgrameGroup('Save-A-Copay','Any');
        CPG_SAC.RecordTypeId = Schema.SObjectType.Clinical_Program_Group__c.getRecordTypeInfosByName().get('Save-A-Copay').getRecordTypeId();
		CPG_SAC.Clinical_Program_Group_Description__c = 'Test_GMFBuilderUtilCPG_SAC1';
        CPG_SAC.Clinical_Program_Group_Name__c = 'Test_GMFBuilderUtilCPG_SAC1';
        insert CPG_SAC;
        //Clinical Program Group Prescription Savings Program
        Clinical_Program_Group__c CPG_PSP=testdata.creteProgrameGroup('Prescription Savings Program','Any');
        CPG_PSP.RecordTypeId = Schema.SObjectType.Clinical_Program_Group__c.getRecordTypeInfosByName().get('Prescription Savings Program').getRecordTypeId();
		insert CPG_PSP;
        //Clinical Program Junction
        Clinical_Program_Junction__c CPJ=testdata.createClinicalprgmJunction(CP_SAC.id,CPG_SAC.id); insert CPJ;
        //Clinical Program Criteria   
        Clinical_Program_Criteria__c CPC=testdata.createProgrameCriteria(CP_SAC.id); insert CPC;
        //Generic Code Conversion 
        Generic_Code_Conversion__c GCC = testdata.createGenericCode();
        GCC.Generic_Code_Conversion_Description__c = 'Test_GMFBuilderUtilGCC1';
        GCC.Generic_Code_Conversion_Name__c ='Test_GMFBuilderUtilGCC1'; insert GCC;
        //Generic Code Conversion Entry
        Generic_Code_Conversion_Entry__c GCCE =testdata.createGenericCodeEntry(GCC.id); insert GCCE;
        //Object List
        Object_List__c OL =testdata.createObjectList();
        OL.Object_List_Name__c='Test_GMFBuilderUtilOL1';
        OL.Object_List_Description__c='Test_GMFBuilderUtilOL1';
        insert OL;
        
        /**************************GMFCR*********************GMFCR**********************************/
        //List GMF CR
        LIst<GMF_Change_Request__c> listGMFCR=new LIst<GMF_Change_Request__c>();
        // GMF CR Creation for Drug List
        GMF_Change_Request__c GMFDL = new GMF_Change_Request__c();
        GMFDL.RecordTypeId = Schema.SObjectType.GMF_Change_Request__c.getRecordTypeInfosByName().get('Drug List').getRecordTypeId();
		GMFDL.Drug_list__c = DL.id;
        GMFDL.Case__c = c.id;
        GMFDL.ReadyToSendDate__c = System.today() + 5;
        listGMFCR.add(GMFDL);
        // GMF CR Creation for Drug List ST
        GMF_Change_Request__c GMFDL_ST = new GMF_Change_Request__c();
        GMFDL_ST.RecordTypeId = Schema.SObjectType.GMF_Change_Request__c.getRecordTypeInfosByName().get('Step Therapy').getRecordTypeId();
		GMFDL_ST.Drug_list__c = DL_ST.id;
        GMFDL_ST.Case__c = c.id;
        GMFDL_ST.ReadyToSendDate__c = System.today() + 6;
        //listGMFCR.add(GMFDL_ST);
        // GMF CR Creation for Drug Group
        GMF_Change_Request__c GMFDG = new GMF_Change_Request__c();
        GMFDG.RecordTypeId = Schema.SObjectType.GMF_Change_Request__c.getRecordTypeInfosByName().get('Drug Group').getRecordTypeId();
		GMFDG.Drug_Group__c = DG.id;
        GMFDG.Case__c = c.id;
        GMFDG.ReadyToSendDate__c = System.today() + 5;
        listGMFCR.add(GMFDG);
        // GMF CR Creation for Formulary
        GMF_Change_Request__c GMFF = new GMF_Change_Request__c();
        GMFF.RecordTypeId = Schema.SObjectType.GMF_Change_Request__c.getRecordTypeInfosByName().get('Formulary').getRecordTypeId();
		GMFF.Formulary__c = F.id;
        GMFF.Case__c = c.id;
        GMFF.ReadyToSendDate__c = System.today() + 5;
        listGMFCR.add(GMFF);
        // GMF CR Creation for Option Code
        GMF_Change_Request__c GMFOC = new GMF_Change_Request__c();
        GMFOC.RecordTypeId = Schema.SObjectType.GMF_Change_Request__c.getRecordTypeInfosByName().get('Option Codes').getRecordTypeId();
		GMFOC.Option_Code__c = OC.id;
        GMFOC.Case__c = c.id;
        GMFOC.ReadyToSendDate__c = System.today() + 5;
        listGMFCR.add(GMFOC);
        // GMF CR Creation for Formulary List
        GMF_Change_Request__c GMFFL = new GMF_Change_Request__c();
        GMFFL.RecordTypeId = Schema.SObjectType.GMF_Change_Request__c.getRecordTypeInfosByName().get('Formulary List').getRecordTypeId();
		GMFFL.Formulary_List__c = FL.id;
        GMFFL.Case__c = c.id;
        GMFFL.ReadyToSendDate__c = System.today() + 5;
        listGMFCR.add(GMFFL);
        // GMF CR Creation for Clinical Program Save_A_Copay
        GMF_Change_Request__c GMCP_SAC = new GMF_Change_Request__c();
        GMCP_SAC.RecordTypeId = Schema.SObjectType.GMF_Change_Request__c.getRecordTypeInfosByName().get('Clinical Programs').getRecordTypeId();
		GMCP_SAC.Clinical_Program__c = CP_SAC.id;
        GMCP_SAC.Case__c = c.id;
        GMCP_SAC.ReadyToSendDate__c = System.today() + 5;
        listGMFCR.add(GMCP_SAC);
        // GMF CR Creation for Clinical Program Prescription_Savings_Program
        GMF_Change_Request__c GMCP_PSP = new GMF_Change_Request__c();
        GMCP_PSP.RecordTypeId = Schema.SObjectType.GMF_Change_Request__c.getRecordTypeInfosByName().get('Clinical Programs').getRecordTypeId();
		GMCP_PSP.Clinical_Program__c = GMCP_PSP.id;
        GMCP_PSP.Case__c = c.id;
        GMCP_PSP.ReadyToSendDate__c = System.today() + 5;
        listGMFCR.add(GMCP_PSP);
        // GMF CR Creation for Clinical Program Group Save_A_Copay
        GMF_Change_Request__c GMCPG_SAC = new GMF_Change_Request__c();
        GMCPG_SAC.RecordTypeId = Schema.SObjectType.GMF_Change_Request__c.getRecordTypeInfosByName().get('Clinical Program Group').getRecordTypeId();
        GMCPG_SAC.Clinical_Program_Group__c = CPG_SAC.id;
        GMCPG_SAC.Case__c = c.id;
        GMCPG_SAC.ReadyToSendDate__c = System.today() + 5;
        listGMFCR.add(GMCPG_SAC);
        // GMF CR Creation for Clinical Program Group Prescription_Savings_Program
        GMF_Change_Request__c GMCPG_PSP = new GMF_Change_Request__c();
        GMCPG_PSP.RecordTypeId = Schema.SObjectType.GMF_Change_Request__c.getRecordTypeInfosByName().get('Clinical Program Group').getRecordTypeId();
        GMCPG_PSP.Clinical_Program_Group__c = CPG_PSP.id;
        GMCPG_PSP.Case__c = c.id;
        GMCPG_PSP.ReadyToSendDate__c = System.today() + 5;
        listGMFCR.add(GMCPG_PSP);
        // GMF CR Creation for Generic Code Conversion 
        GMF_Change_Request__c GMGCC = new GMF_Change_Request__c();
        GMGCC.RecordTypeId = Schema.SObjectType.GMF_Change_Request__c.getRecordTypeInfosByName().get('Generic Code Conversion').getRecordTypeId();
        GMGCC.Generic_Code_Conversion__c = GCC.id;
        GMGCC.Case__c = c.id;
        GMGCC.ReadyToSendDate__c = System.today() + 5;
        listGMFCR.add(GMGCC);
        // GMF CR Creation for Object List
        GMF_Change_Request__c GMOL = new GMF_Change_Request__c();
        GMOL.RecordTypeId = Schema.SObjectType.GMF_Change_Request__c.getRecordTypeInfosByName().get('Object Lists').getRecordTypeId();
		GMOL.Object_List__c = OL.id;
        GMOL.Case__c = c.id;
        GMOL.ReadyToSendDate__c = System.today() + 5;
        listGMFCR.add(GMOL);
        //GMFCR List Insert
        Insert listGMFCR;
        
        //Drug List Criteria
        Drug_List_Criteria__c DLC=testdata.newDrugListcriteria(DL.id,1); 
        DLC.Drug_Type_Code__c='GPI';
        DLC.Drug_Code_Value__c='519900032067*';
        insert DLC;
        
        
        //Drug_List_Description_Crosswalk__c
        Drug_List_Description_Crosswalk__c  DLDCW=testdata.createDrugListDescCrosswalk();
        DLDCW.Description_Of_Drug_List__c='description';
        DLDCW.Drug_Code_Value__c='GPI';
        DLDCW.Drug_Type_Code__c='OTC Equivalent';
        insert  DLDCW;
        
        //Drug List Criteria
        Drug_List_Criteria__c DLC_ST=testdata.newDrugListcriteria(DL_ST.id,2); 
        DLC_ST.recordtypeID = Schema.SObjectType.Drug_List_Criteria__c.getRecordTypeInfosByName().get('Step Therapy').getRecordTypeId();
		DLC_ST.Drug_Type_Code__c='GPI';
        DLC_ST.Drug_Code_Value__c='519900032067*';
        insert DLC_ST;
        
        
        //Object List Item
        Object_List_Item__c OLI=testdata.createObjectListItem(OL.id); insert OLI;  
        //Step Therapy PreRequisite Drug
        Step_Therapy_PreRequisite_Drug__c STPD = testdata.preRequisite();
        STPD.Related_Drug_List_Criteria__c=DLC_ST.id;
        insert STPD;
        //Restricted_NDC_List__c
        List<Restricted_NDC_List__c>RNDCL=new List<Restricted_NDC_List__c>();
        Restricted_NDC_List__c RNL=testdata.createRestricted_NDC_List(STPD.id,DLC.id);
        RNDCL.add(RNL);  
        //Restricted_NDC_List__c
        Restricted_NDC_List__c RNDC=new Restricted_NDC_List__c();
        RNDC.Related_Formulary_List_Entry__c=FLE.id;
        RNDC.Related_Drug_List_Criteria__c=DLC.id;
             RNDC.Effective_Date__c=system.today();
             RNDC.Termination_Date__c=system.today()+5;
             RNDC.MS_Code_M__c=true;
             RNDC.MS_Code_N__c=true;
             RNDC.MS_Code_O__c=true;
             RNDC.MS_Code_Y__c=true;
             RNDC.OTC__c=true;
             RNDC.Rx__c=true;
        	RNDC.Restrict_NDC__c='123456789*';
        	RNDCL.add(RNDC);
        insert RNDCL;
        //Form_Junction__c
        Form_Junction__c FJI=new Form_Junction__c(Formulary_List_Entry_ID__c=FLE.id); insert FJI;
        //Stepped_Over_Time__c 
        Stepped_Over_Time__c SOT=testdata.createstepQuantityOverTym(DLC.id); insert SOT;
    }
    Private Static testMethod void Test_GMFBuilderUtil1(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        //Drug List 
        Drug_List__c DL = [select id,Description__c  from Drug_List__c where 	Description__c = 'Test_GMFBuilderUtilDL1' limit 1]; update DL;        
        //Drug List Criteria 
        Drug_List_Criteria__c DLC = [select id from Drug_List_Criteria__c where Drug_List__c=:DL.id ]; update DLC;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil2(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        //Drug List ST
        Drug_List__c DL_ST = [select id,Description__c  from Drug_List__c where 	Description__c = 'Test_GMFBuilderUtilDL_ST1' limit 1]; update DL_ST;        
        //Drug List Criteria  ST
        Drug_List_Criteria__c DLC_ST = [select id from Drug_List_Criteria__c where Drug_List__c=:DL_ST.id ]; update DLC_ST;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil3(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        //Drug Group
        Drug_Group__c DG = [select id from Drug_Group__c where Description__c = 'Test_GMFBuilderUtilDG1' limit 1]; update DG; 
        //Drug List Junction
        Drug_List__c DL = [select id,Description__c  from Drug_List__c where 	Description__c = 'Test_GMFBuilderUtilDL1' limit 1];
        Drug_List_Junction__c DLJ = [select id from Drug_List_Junction__c where Parent_Drug_Group__c=:DG.id and Drug_List__c=:DL.id limit 1]; update DLJ;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil4(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        //Formulary__c
        Formulary__c F = [select id from Formulary__c where Formulary_Name__c = 'Test_GMFBuilderUtilF1' and Formulary_Description__c ='Test_GMFBuilderUtilF1'  limit 1]; update F;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil5(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        //Option Code
        Option_Code__c OC = [select id from Option_Code__c where Option_Code_Name__c='TOC1' and Option_Code_Description__c ='Test_GMFBuilderUtilOC1'  limit 1]; update OC;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil6(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        //Formulary List
        Formulary_List__c FL = [select id from Formulary_List__c where Formulary_List_Name__c ='Test_GMFBuilderUtilFL1' and Formulary_List_Description__c ='Test_GMFBuilderUtilFL1'  limit 1]; update FL;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil7(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        //Formulary Junction
        Formulary__c F = [select id from Formulary__c where Formulary_Name__c = 'Test_GMFBuilderUtilF1' and Formulary_Description__c ='Test_GMFBuilderUtilF1'  limit 1]; 
        Formulary_List__c FL = [select id from Formulary_List__c where Formulary_List_Name__c ='Test_GMFBuilderUtilFL1' and Formulary_List_Description__c ='Test_GMFBuilderUtilFL1'  limit 1];
        Formulary_Junction__c FJ = [select id from Formulary_Junction__c where Formulary_List__c =:FL.id and Formulary__c =:F.id  limit 1]; update FJ;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil8(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        //Formulary List Entry
        Formulary_List__c FL = [select id from Formulary_List__c where Formulary_List_Name__c ='Test_GMFBuilderUtilFL1' and Formulary_List_Description__c ='Test_GMFBuilderUtilFL1'  limit 1];
        Formulary_List_Entry__c FLE = [select id from Formulary_List_Entry__c where Formulary_List__c =:FL.id limit 1]; update FLE;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil9(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        //Clinical Program Save_A_Copay
        Clinical_Program__c CP_SAC = [select id from Clinical_Program__c where Description__c ='Test_GMFBuilderUtilCP_SAC1' and Clinical_Programs_Name__c ='Test_GMFBuilderUtilCP_SAC1' limit 1]; update CP_SAC; 
        //Clinical Program Group Save-A-Copay
        Clinical_Program_Group__c CPG_SAC = [select id from Clinical_Program_Group__c where Clinical_Program_Group_Description__c ='Test_GMFBuilderUtilCPG_SAC1' and Clinical_Program_Group_Name__c ='Test_GMFBuilderUtilCPG_SAC1' limit 1]; update CPG_SAC; 
        //Clinical Program Junction
        Clinical_Program_Junction__c CPJ = [select id from Clinical_Program_Junction__c where Clinical_Program__c=:CP_SAC.id and Clinical_Program_Group__c=:CPG_SAC.id limit 1 ]; update CPJ;
        //Clinical Program Criteria
        Clinical_Program_Criteria__c CPC = [select id from Clinical_Program_Criteria__c where Clinical_Program__c=:CP_SAC.id limit 1]; update CPC;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil10(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        //Generic Code Conversion 
        Generic_Code_Conversion__c GCC = [select id from Generic_Code_Conversion__c where Generic_Code_Conversion_Description__c = 'Test_GMFBuilderUtilGCC1' and Generic_Code_Conversion_Name__c ='Test_GMFBuilderUtilGCC1' limit 1]; update GCC;
        //Generic_Code_Conversion_Entry__c
        Generic_Code_Conversion_Entry__c GCCE = [select id from Generic_Code_Conversion_Entry__c where 	Generic_Code_Conversion__c=: GCC.id limit 1]; update GCCE;
        Test.stopTest();
    } 
    Private Static testMethod void Test_GMFBuilderUtil11(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        //Object List
        Object_List__c OL = [select id from Object_List__c where Object_List_Name__c='Test_GMFBuilderUtilOL1' and Object_List_Description__c='Test_GMFBuilderUtilOL1' limit 1]; update OL;
        // Object List Item
        Object_List_Item__c OLI = [select id from  Object_List_Item__c where Object_List__c=:OL.id limit 1]; update OLI;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil12(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        Drug_List__c DL_ST = [select id,Description__c  from Drug_List__c where 	Description__c = 'Test_GMFBuilderUtilDL_ST1' limit 1]; 
        //Drug List Criteria  ST
        Drug_List_Criteria__c DLC_ST = [select id from Drug_List_Criteria__c where Drug_List__c=:DL_ST.id ]; 
        //Step Therapy PreRequisite Drug
        Step_Therapy_PreRequisite_Drug__c STPD = [select id from  Step_Therapy_PreRequisite_Drug__c where Related_Drug_List_Criteria__c=:DLC_ST.id limit 1]; update STPD;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil13(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        Drug_List__c DL = [select id,Description__c  from Drug_List__c where 	Description__c = 'Test_GMFBuilderUtilDL1' limit 1]; 
        //Drug List Criteria  ST
        Drug_List_Criteria__c DLC = [select id from Drug_List_Criteria__c where Drug_List__c=:DL.id ]; 
        //Restricted_NDC_List__c
        Restricted_NDC_List__c RNL = [select id from  Restricted_NDC_List__c where Related_Drug_List_Criteria__c=:DLC.id limit 1]; update RNL;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil14(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        Formulary_List__c FL = [select id from Formulary_List__c where Formulary_List_Name__c ='Test_GMFBuilderUtilFL1' and Formulary_List_Description__c ='Test_GMFBuilderUtilFL1'  limit 1];
        Formulary_List_Entry__c FLE = [select id from Formulary_List_Entry__c where Formulary_List__c =:FL.id limit 1]; 
        //Restricted_NDC_List__c
        Restricted_NDC_List__c RNL = [select id from  Restricted_NDC_List__c where Related_Formulary_List_Entry__c=:FLE.id limit 1]; update RNL;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil15(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        Formulary_List__c FL = [select id from Formulary_List__c where Formulary_List_Name__c ='Test_GMFBuilderUtilFL1' and Formulary_List_Description__c ='Test_GMFBuilderUtilFL1'  limit 1];
        Formulary_List_Entry__c FLE = [select id from Formulary_List_Entry__c where Formulary_List__c =:FL.id limit 1]; 
        //Form_Junction__c
        Form_Junction__c FJI = [select id from  Form_Junction__c where Formulary_List_Entry_ID__c=:FLE.id limit 1]; update FJI;
        Test.stopTest();
    }
    Private Static testMethod void Test_GMFBuilderUtil16(){
        Test.startTest();
        // Custom Setting Inserted
        insert new Org_Trigger_Configurations__c(TRG_LockGMF__c =True,Name='Trigger Configurations');
        Drug_List__c DL = [select id,Description__c  from Drug_List__c where 	Description__c = 'Test_GMFBuilderUtilDL1' limit 1];         
        //Drug List Criteria 
        Drug_List_Criteria__c DLC = [select id from Drug_List_Criteria__c where Drug_List__c=:DL.id ]; 
		//Form_Junction__c
        Stepped_Over_Time__c SOT = [select id from  Stepped_Over_Time__c where Related_Drug_List_Criteria__c=:DLC.id limit 1]; update SOT;
        Test.stopTest();
    }
    
}