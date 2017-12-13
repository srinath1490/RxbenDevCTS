/*Purpose: Apex Test Class to test BAC_UpdateCIF
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Richa         10th Apr 2015       Apex Test class to test BAC_UpdateCIF
======================================================================== */
@isTest(seealldata = True)
private class TEST_BAC_UpdateCIF{   
    static testMethod void TEST_BAC_UpdateCIF(){
        
        Account TestAccount = new Account();
        TestAccount.name = 'Test';
        insert TestAccount;
        
        List<CRD__c> listCRD = new List<CRD__c>();
        CRD__c crd = new crd__c();
        crd.Archived__c = true;
        crd.Account__c = TestAccount.id;
        crd.CRD_Automated__c = True;
        crd.Plan_Type_Mail__c = true;
        crd.LastSent__c = system.today();
        crd.Insured_Type__c = 'Self Insured';
        crd.Do_you_want_to_do_Step_Therapy__c = 'Yes';
        crd.Does_the_client_want_to_do_COB__c = 'Yes';
        listCRD.add(crd);
        
        CRD__c crd2 = new crd__c();
        crd2.Archived__c = true;
        crd2.CRD_Automated__c = True;
        crd2.LastSent__c = system.today();
        crd2.Insured_Type__c = 'Fully Insured';
        listCRD.add(crd2);
        
        insert listCRD;
        
        Drug_Coverage__c dc = new Drug_Coverage__c();
        dc.crd_id__c = crd.id;
        insert dc;
        
        Drug_Coverage__c dc2 = new Drug_Coverage__c();
        dc2.crd_id__c = crd2.id;
        insert dc2;
        
        CRDBuildOrder__c cbon = new CRDBuildOrder__c ();
        cbon.CVS__c = true;
        cbon.crd__c = crd.id;
        insert cbon;
        
        CRDBuildOrder__c cbon2 = new CRDBuildOrder__c ();
        cbon2.CVS__c = true;
        cbon2.crd__c = crd2.id;
        insert cbon2;
        
        List<CIF__c> listCIF = new List<CIF__c>();
        CIF__c cif = new CIF__c();
        cif.Insured_Type__c = 'Self Insured';
        cif.Account__c = TestAccount.id;
        listCIF.add(cif);
        insert listCIF;
        
        CIF_Automation.CIFAutomation(listCRD);
        //Database.executeBatch(new BAC_UpdateCIF(),200);

    }
    /*static testMethod void TEST_BAC_UpdateCIF1(){
        
        Account TestAccount = new Account();
        TestAccount.name = 'Test';
        insert TestAccount;
        
        List<CRD__c> listCRD = new List<CRD__c>();
        CRD__c crd = new crd__c();
        crd.Archived__c = true;
        crd.Account__c = TestAccount.id;
        crd.Plan_Type_Mail__c = true;
        crd.LastSent__c = system.today();
        crd.Insured_Type__c = 'Self Insured';
        crd.CRD_Automated__c = True;
        crd.Do_you_want_to_do_Step_Therapy__c = 'Yes';
        crd.Does_the_client_want_to_do_COB__c = 'Yes';
        listCRD.add(crd);
        
        CRD__c crd2 = new crd__c();
        crd2.Archived__c = true;
        crd2.CRD_Automated__c = True;
        crd2.LastSent__c = system.today();
        crd2.Insured_Type__c = 'Fully Insured';
        listCRD.add(crd2);
        
        insert listCRD;
        Drug_Coverage__c dc = new Drug_Coverage__c();
        dc.crd_id__c = crd.id;
        insert dc;
        
        Drug_Coverage__c dc2 = new Drug_Coverage__c();
        dc2.crd_id__c = crd2.id;
        insert dc2;
        
        CRDBuildOrder__c cbon = new CRDBuildOrder__c ();
        cbon.CVS__c = true;
        cbon.crd__c = crd.id;
        insert cbon;
        
        CRDBuildOrder__c cbon2 = new CRDBuildOrder__c ();
        cbon2.CVS__c = true;
        cbon2.crd__c = crd2.id;
        insert cbon2;
        
        List<CIF__c> listCIF = new List<CIF__c>();
        CIF__c cif = new CIF__c();
        cif.Insured_Type__c = 'Self Insured';
        cif.Account__c = TestAccount.id;
        listCIF.add(cif);
        insert listCIF;    
        
        Database.executeBatch(new BAC_UpdateCIF(),200); 
        
     }*/

  }