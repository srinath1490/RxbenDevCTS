/*Purpose: Apex Test Class to test BAC_CB_ArchivePFRs
========================================================================
History                                                            
-------                                                            
VERSION     AUTHOR          DATE            DETAIL                                 
   1.0      Richa         24th Feb 2015       Apex Test class to test BAC_CB_ArchivePFRs for Req 05555
======================================================================== */
@isTest
private class TEST_BAC_CB_ArchivePFRs{   
    static testMethod void TEST_BAC_CB_ArchivePFRs(){
        CRD__c crd = new crd__c();
        crd.Archived__c = true;
        insert crd;
        
        CRDBuildOrder__c cbonRecord = new CRDBuildOrder__c();
        cbonRecord.Build__c = true;
        cbonRecord.crd__c = crd.id;
        cbonRecord.Ready_to_Archive__c = false;
        cbonRecord.Ignored__c = true;
        cbonRecord.Description__c = '';
        insert cbonRecord;
        
        Pers_Full_Report__c pfr = new Pers_Full_Report__c();
        pfr.CRD__c = crd.id;
        pfr.CRD_Build_Order__c = cbonRecord.id;
        pfr.PERStimestamp__c = DateTime.newInstance(System.today(),Time.newInstance(0,0,0,0));
        pfr.WS_PROV_NUM__c = 12;
        pfr.WS_LV_NO__c = 6;
        pfr.WS_CNTRL_NO__c = 77;
        pfr.WS_PLSM_CD__c = 'JR';
        pfr.WS_NEW_INFRC_EFF_DT__c =System.today();
        insert pfr;
        
        CRD__c crd2 = new crd__c();
        crd2.Archived__c = true;
        insert crd2;
        
        CRDBuildOrder__c cbonRecord2 = new CRDBuildOrder__c();
        cbonRecord2.Build__c = true;
        cbonRecord2.crd__c = crd2.id;
        cbonRecord2.Ready_to_Archive__c = false;
        cbonRecord2.Ignored__c = true;
        cbonRecord2.Description__c = '';
        insert cbonRecord2;
        
        Attachment pfrAttachment2 = new Attachment();
        pfrAttachment2.Name = String.valueOf('-ArchivedPFRs.txt');
        pfrAttachment2.Body = Blob.valueOf('serializePFR');
        pfrAttachment2.Description = 'ArchivedPFRs';               
        pfrAttachment2.ParentId = cbonRecord2.ID;
        insert pfrAttachment2;
        
        CRD__c crd3 = new crd__c();
        crd3.Archived__c = true;
        insert crd3;
        
        CRDBuildOrder__c cbonRecord3 = new CRDBuildOrder__c();
        cbonRecord3.Build__c = true;
        cbonRecord3.crd__c = crd3.id;
        cbonRecord3.Ready_to_Archive__c = false;
        cbonRecord3.Ignored__c = true;
        cbonRecord3.Description__c = '';
        insert cbonRecord3;
        
        Attachment pfrAttachment = new Attachment();
        pfrAttachment.Name = String.valueOf('-ArchivedPFRs.txt');
        pfrAttachment.Body = Blob.valueOf('serializePFR');
        pfrAttachment.Description = 'ArchivedPFRs';               
        pfrAttachment.ParentId = cbonRecord3.ID;
        insert pfrAttachment;
        
        Pers_Full_Report__c pfr3 = new Pers_Full_Report__c();
        pfr3.CRD__c = crd.id;
        pfr3.CRD_Build_Order__c = cbonRecord3.id;
        pfr3.PERStimestamp__c = DateTime.newInstance(System.today(),Time.newInstance(0,0,0,0));
        pfr3.WS_PROV_NUM__c = 12;
        pfr3.WS_LV_NO__c = 6;
        pfr3.WS_CNTRL_NO__c = 77;
        pfr3.WS_PLSM_CD__c = 'JR';
        pfr3.WS_NEW_INFRC_EFF_DT__c =System.today();
        insert pfr3;
        
        CRD__c crd4 = new crd__c();
        crd4.Archived__c = true;
        insert crd4;
        
        CRDBuildOrder__c cbonRecord4 = new CRDBuildOrder__c();
        cbonRecord4.Build__c = true;
        cbonRecord4.crd__c = crd4.id;
        cbonRecord4.Ready_to_Archive__c = false;
        cbonRecord4.Ignored__c = true;
        cbonRecord4.Description__c = '';
        insert cbonRecord4;
        
        Database.executeBatch(new BAC_CB_archivePFRs(),200);
        /*System.assertEquals(true,cbonRecord.Ready_to_Archive__c);
        
        cbonRecord.Ready_to_Archive__c = false;
        update cbonRecord;
        
        Database.executeBatch(new BAC_CB_archivePFRs(),200);
        //System.assertEquals(false,cbonRecord.Ready_to_Archive__c);
        //System.assertEquals(' PFRs are already archived, they should be deleted',cbonRecord.Description__c);
        
        delete pfr;
        Database.executeBatch(new BAC_CB_archivePFRs(),200);
        //System.assertEquals(false,cbonRecord.Ready_to_Archive__c);
        //System.assertEquals(' PFRs are already archived, they should be deleted+PFRs are already archived',cbonRecord.Description__c);
        
        delete [Select id from Attachment where ParentId = :cbonRecord.id AND Description = 'ArchivedPFRs'];
        Database.executeBatch(new BAC_CB_archivePFRs(),200);
        //System.assertEquals(false,cbonRecord.Ready_to_Archive__c);
        //System.assertEquals(' PFRs are already archived, they should be deleted+PFRs are already archived+No PFRs/Attachment present',cbonRecord.Description__c);*/
        
    }
}