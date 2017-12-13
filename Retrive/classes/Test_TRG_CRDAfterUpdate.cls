@isTest
public class Test_TRG_CRDAfterUpdate {
    static testmethod void TestVFPCRDSearchController() {
        PageReference PageRef = Page.VF_CRDSearch;
        test.setCurrentPage(PageRef);
        
            
        Account TestAccount = new Account();
        TestAccount.name = 'Test';
        insert TestAccount;
        
        CRD__c TestCRD = new CRD__c();
        TestCRD.Account__c = TestAccount.ID;
        TestCRD.Are_you_creating_a_Package_Plan__c = 'No';
        TestCRD.Plan_Type_Mail__c = true;
        TestCRD.LastSent__c = Date.today() - 7;
        
        insert TestCRD;
       
        test.starttest();
        TestCRD.Plan_Type_Paper_Out_of_Network__c = true;
        testcrd.rxplanid__c = 'cde';
        testCrd.Contract_State__c = 'abc';
        update TestCRD;
        test.stoptest();
        
        CRD__c TestCRD1 = new CRD__c();
        TestCRD1 .Account__c = TestAccount.ID;
        TestCRD1 .Are_you_creating_a_Package_Plan__c = 'No';
        TestCRD1 .Plan_Type_Mail__c = true;
        TestCRD1 .rxplanid__c = 'abc';
        TestCRD1 .LastSent__c = Date.today() - 7;
        TestCRD1 .Plan_Type_Mail__c = true;
        TestCRD1 .Plan_Type_Paper__c = true;
        TestCRD1 .Plan_Type_Retail__c = true;
        TestCRD1 .Plan_Type_Specialty__c = true;
        TestCRD1 .Plan_Type_Paper_Out_of_Network__c = true;
        TestCRD1 .Plan_Type_Specialty_OON__c = true;
        
        TestCRD1 .Any_drug_specific_Mail_copays__c = true;
        TestCRD1 .Any_drug_specific_Paper_copays__c = true;
        TestCRD1 .Any_drug_specific_Paper_Out_of_Network__c = true;
        TestCRD1 .Any_drug_specific_Retail_copays__c  = true;
        TestCRD1 .Any_drug_specific_Specialty_copays__c = true;
        TestCRD1 .Any_drug_specific_Specialty_OON_copays__c = true;
        TestCRD1 .Any_DAW_specific_Mail_copays__c = true;
        TestCRD1 .Any_DAW_specific_Paper_copays__c = true;
        TestCRD1 .Any_DAW_specific_Retail_copays__c = true;
        TestCRD1 .Any_DAW_specific_Specialty_copays__c = true;
        TestCRD1 .Any_DAW_specific_Paper_OON_copays__c = true;
        TestCRD1 .Any_DAW_specific_Specialty_OON_copays__c = true;
        insert TestCRD1 ;
        
        CRD_Step_Therapy_Junction__c testcrdstepthrpy = new CRD_Step_Therapy_Junction__c();
        testcrdstepthrpy.isAutopopulated__c = true;
        testcrdstepthrpy.CRD_ID__c = TestCRD1.id;
        
        insert testcrdstepthrpy;
        
        CRD_PriorAuth_Junction__c precertJunction = new CRD_PriorAuth_Junction__c();
        precertJunction.isAutopopulated__c = true;
        precertJunction.CRD_ID__c = TestCRD1.id;
        insert precertJunction;
        
        CRD_Quantity_Limit_Junction__c qlJunction = new CRD_Quantity_Limit_Junction__c();
        qlJunction.isAutopopulated__c = true;
        qlJunction.CRD_ID__c = TestCRD1.id;
        
        insert qlJunction;
        
        ST_PA_QL_Auto_Populate__c stpaqllist = new ST_PA_QL_Auto_Populate__c();
        stpaqllist.name = 'test';
        stpaqllist.Record_Type__c='Step Therapy';
        stpaqllist.Contract_State__c = 'abc';
        stpaqllist.What_is_the_Funding_Type__c = 'abc';
        insert stpaqllist;

        ST_PA_QL_Auto_Populate__c stpaqllist1 = new ST_PA_QL_Auto_Populate__c();
        stpaqllist1.name = 'test';
        stpaqllist1.Record_Type__c='Precert';
        stpaqllist1.Contract_State__c = 'abc';
        stpaqllist1.What_is_the_Funding_Type__c = 'abc';
        insert stpaqllist1;
        
        ST_PA_QL_Auto_Populate__c stpaqllist2 = new ST_PA_QL_Auto_Populate__c();
        stpaqllist2.name = 'test';
        stpaqllist2.Record_Type__c='Quantity Limit';
        stpaqllist2.Contract_State__c = 'abc';
        stpaqllist2.What_is_the_Funding_Type__c = 'abc';
        insert stpaqllist2;     
        
        Copay_Tier__c testcopay = new Copay_Tier__c();  
        RecordType mailRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Retail'];
        testcopay.recordtypeid = mailRt.id;
        //testcopay.name = 'testname';
        testcopay.crd__c = testcrd1.id;
        insert testcopay;
        Copay_Tier__c testcopay1 = new Copay_Tier__c(); 
        mailRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Paper'];
        testcopay1.recordtypeid = mailRt.id;
        //testcopay.name = 'testname';
        testcopay1.crd__c = testcrd1.id;
        insert testcopay1;
        Copay_Tier__c testcopay2 = new Copay_Tier__c(); 
        mailRt=[Select Id,Name from RecordType where sobjecttype='Copay_Tier__c' and name ='Paper Out of Network'];
        testcopay2.recordtypeid = mailRt.id;
        //testcopay.name = 'testname';
        testcopay2.crd__c = testcrd1.id;
        insert testcopay2;
        Copay_Tier__c testcopay3 = new Copay_Tier__c(); 
    
        
        TestCRD.Plan_Type_Paper_Out_of_Network__c = true;
        TestCRD1 .rxplanid__c = 'cde';
        TestCRD1.ISDummyCRD__c = true;
        TestCRD1 .Contract_State__c = 'abc';
        TestCRD1.Standard_Program_or_Select_Classes__c = 'ST Drug List(s)';
        TestCRD1.Standard_Precert_List_or_Select_Classes__c = 'PA Drug List(s)';
        TestCRD1.Standard_QL_List_or_Select_Classes__c = 'QL Drug List(s)';
        TestCRD1.Insured_Type__c = 'abc';
        TestCRD1 .Plan_Type_Mail__c = true;
        TestCRD1 .Plan_Type_Paper__c = false;
        TestCRD1 .Plan_Type_Retail__c = false;
        TestCRD1 .Plan_Type_Specialty__c = false;
        TestCRD1 .Plan_Type_Paper_Out_of_Network__c = false;
        TestCRD1 .Plan_Type_Specialty_OON__c = false;
        
        TestCRD1 .Any_drug_specific_Mail_copays__c = false;
        TestCRD1 .Any_drug_specific_Paper_copays__c = false;
        TestCRD1 .Any_drug_specific_Paper_Out_of_Network__c = false;
        TestCRD1 .Any_drug_specific_Retail_copays__c  = false;
        TestCRD1 .Any_drug_specific_Specialty_copays__c = false;
        TestCRD1 .Any_drug_specific_Specialty_OON_copays__c = false;
        TestCRD1 .Any_DAW_specific_Mail_copays__c = false;
        TestCRD1 .Any_DAW_specific_Paper_copays__c = false;
        TestCRD1 .Any_DAW_specific_Retail_copays__c = false;
        TestCRD1 .Any_DAW_specific_Specialty_copays__c = false;
        TestCRD1 .Any_DAW_specific_Paper_OON_copays__c = false;
        TestCRD1 .Any_DAW_specific_Specialty_OON_copays__c = false;     
        update TestCRD1 ;
        

    }
}