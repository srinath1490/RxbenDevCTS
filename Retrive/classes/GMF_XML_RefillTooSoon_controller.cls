/*Purpose: initial draft of XML 
========
History                                                            
-------                                                            
VERSION     AUTHOR                 DATE                             DETAIL                                 
    1.0 -   Allen, Becca            05/30/2012                      Created the file    
    1.1 -   Allen, Becca            12/10/2012                      updated with last modified dates and last sent, etc.
======================================================================== */
public with sharing class GMF_XML_RefillTooSoon_controller {

    Refill_Too_Soon__c record;
    Map<String,String> rmap = new Map<String,String>();
    Map<String,String> rtscmap_2 = new Map<String,String>();
    List<Map<String,String>> rtscmap = new List<Map<String,String>>();
  
    Id parentId;
  
    public GMF_XML_RefillTooSoon_controller (ApexPages.StandardController controller) {
        
        //Hix field added as per Request 01100, By Rahul Nasa
        parentId=controller.getId();
        record=[Select 
                    r.Standard__c, r.Search_Indication__c, r.LastModifiedDate, r.LastSent__c, r.Refill_too_Soon_Name__c, r.Refill_too_Soon_Description__c, r.RecordType.Name, 
                    r.Name, r.Message_returned_to_the_Provider__c, r.Inactive__c, r.Id, r.Exclusion_Drug_List__r.Name, r.Exclusion_Drug_List__r.LastModifiedDate, r.Exclusion_Drug_List__r.LastSent__c,r.Early_Refill_Option__c, 
                    r.Cumulative_Search_Indication__c, r.Cumulative_Rx_Max_Days_Supply__c, r.Cumulative_Minimum_Percent__c, r.Funding_Type__c,
                    r.Cumulative_History_Days__c, r.Bypass_History_Days_Supply__c, r.Begin_Refill_Logic_after_Fills__c, r.Account__c, r.Carrier__c,
                    r.Effective_Date__c, r.Termination_Date__c,r.Hix__c,
                    (Select 
                        Id, Name, Rx_Min_Days_Supply__c, Rx_Max_Days_Supply__c, LastModifiedDate, Minimum_Percent__c 
                    From Refill_Too_Soon_Criteria__r WHERE isDeleted = false ) 
                From Refill_Too_Soon__c r
                WHERE Id = :parentId];
        
        //Build MAPs
        rmap.put('RefillTooSoonID',String.valueOf(record.Name));
        rmap.put('RefillTooSoonName',String.valueOf(record.Refill_too_Soon_Name__c));
        rmap.put('RefillTooSoonDescription',String.valueOf(record.Refill_too_Soon_Description__c));
        rmap.put('RecordType',String.valueOf(record.RecordType.Name));
        rmap.put('Inactive',String.valueOf(record.Inactive__c));
        rmap.put('EffectiveDate',String.valueOf(record.Effective_Date__c));
        rmap.put('TerminationDate',String.valueOf(record.Termination_Date__c));
        
        //Hix field added as per Request 01100, By Rahul Nasa
        rmap.put('HIX',String.valueOf(record.Hix__c));        
        //Hix field added as per Request 01100, By Rahul Nasa       
        rmap.put('LastModifiedDate',String.valueOf(record.LastModifiedDate));
        rmap.put('LastSent',String.valueOf(record.LastSent__c));
        rmap.put('TimeStamp',String.valueOf(system.now()));
        
        rmap.put('EarlyRefillOption',String.valueOf(record.Early_Refill_Option__c));
        rmap.put('SearchIndication',String.valueOf(record.Search_Indication__c));
        rmap.put('BypassHistoryDaysSupply',String.valueOf(record.Bypass_History_Days_Supply__c));
        
        rmap.put('FundingType',String.valueOf(record.Funding_Type__c));
        rmap.put('Carrier',String.valueOf(record.Carrier__c));
        rmap.put('CumulativeRxMaxDaysSupply',String.valueOf(record.Cumulative_Rx_Max_Days_Supply__c));
        rmap.put('CumulativeMinimumPercent',String.valueOf(record.Cumulative_Minimum_Percent__c));
        rmap.put('BeginRefillLogicAfterNumberFills',String.valueOf(record.Begin_Refill_Logic_after_Fills__c));
        rmap.put('CumulativeSearchIndication',String.valueOf(record.Cumulative_Search_Indication__c));
        rmap.put('CumulativeHistoryDays',String.valueOf(record.Cumulative_History_Days__c));
        rmap.put('ExclusionDrugList',String.valueOf(record.Exclusion_Drug_List__r.Name));
        rmap.put('ExclusionDrugListLastModified',String.valueOf(record.Exclusion_Drug_List__r.LastModifiedDate));
        rmap.put('ExclusionDrugListLastSent',String.valueOf(record.Exclusion_Drug_List__r.LastSent__c));
        rmap.put('MessageReturnedToTheProvider',String.valueOf(record.Message_returned_to_the_Provider__c));
        
        for(Refill_Too_Soon_Criteria__c rchild : record.Refill_Too_Soon_Criteria__r){
            rtscmap_2 = new Map<String,String>();
            rtscmap_2.put('RefillTooSoonCriteriaID',String.valueOf(rchild.Name));
            rtscmap_2.put('RxMinDaysSupply',String.valueOf(rchild.Rx_Min_Days_Supply__c));   
            rtscmap_2.put('RxMaxDaysSupply',String.valueOf(rchild.Rx_Max_Days_Supply__c));  
            rtscmap_2.put('MinimumPercent',String.valueOf(rchild.Minimum_Percent__c));
            rtscmap_2.put('RTSCriteriaLastModified',String.valueOf(rchild.LastModifiedDate));
            rtscmap.add(rtscmap_2);
        }
        
    }
    
    public PageReference generateXML(){
        GMFXmlWriter_ValueOnly gmfwriter=new GMFXmlWriter_ValueOnly();
         String CurrentVersion='1.1';
        String s=gmfwriter.getparentXml(CurrentVersion,'RefillTooSoon','RefillTooSoonCriteria',rmap,rtscmap);
        record.LastSent__c=system.now();
        update record;
        Case c=new Case();
        c.Aetna_Case_Type__c='GMF Case';
        c.RecordTypeId=[Select c.Id From RecordType c where isActive = true and DeveloperName = 'External_CRD_GMF'].id;
        c.Effective_Date__c=record.Effective_Date__c;
        c.Subject=String.valueOf(record.Name)+' '+'-'+' '+String.valueOf(record.Refill_Too_Soon_Name__c);
        insert c;
        
        Blob xmlblob=Blob.valueof(s);
        Attachment xmlAttach=new Attachment();
            xmlAttach.body=xmlblob;
            xmlAttach.Name=record.Name+' '+system.now()+'.xml';
            xmlAttach.parentId=c.Id;
            xmlAttach.contentType='XML';
        insert xmlAttach;
        
        String urlStr = '/'+String.valueOf(c.Id);
        PageReference MyObjectPR = new 
        PageReference(urlStr);
    
        return MyObjectPR;
    }
    
    /** 
    * =====================================================================
    *                          TEST CASE(S)
    * =====================================================================
    **/
    static testMethod void testXMLGeneration(){
        RecordType rt = [SELECT id from RecordType WHERE SobjectType = 'Refill_Too_Soon__c' AND DeveloperName like '%Retail%' LIMIT 1];
        Refill_Too_Soon__c r = new Refill_Too_Soon__c();
        r.RecordTypeId = rt.Id;
        r.Refill_too_Soon_Name__c = 'test';
        r.Refill_too_Soon_Description__c = 'test';
        insert r;
        
        Refill_Too_Soon_Criteria__c r2 = new Refill_Too_Soon_Criteria__c();
        r2.Related_Refill_Too_Soon__c = r.Id;
        insert r2;
        
        ApexPages.StandardController rsc = new ApexPages.StandardController(r);
        GMF_XML_RefillTooSoon_controller rc = new GMF_XML_RefillTooSoon_controller(rsc);
        rc.generateXML();
    }
    
}